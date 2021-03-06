#' Perform bootstrap sampling and calculate test statistics for each bootstrap sample
#'
#' Create a bootstrap sample, perform multivariate QTL scan, and calculate LRT statistic
#'
#' Performs a parametric bootstrap method to calibrate test statistic values in the test of
#' pleiotropy vs. separate QTL. It begins by inferring parameter values at
#' the `pleio_peak_index` index value in the object `probs`. It then uses
#' these inferred parameter values in sampling from a multivariate normal
#' distribution. For each of the `nboot_per_job` sampled phenotype vectors, a two-dimensional QTL
#' scan, starting at the marker indexed by `start_snp` within the object
#' `probs` and extending for a total of `n_snp` consecutive markers. The
#' two-dimensional scan is performed via the function `scan_pvl`. For each
#' two-dimensional scan, a likelihood ratio test statistic is calculated. The
#' outputted object is a vector of `nboot_per_job` likelihood ratio test
#' statistics from `nboot_per_job` distinct bootstrap samples.
#'
#' @param probs founder allele probabilities three-dimensional array for one chromosome only (not a list)
#' @param pheno n by d matrix of phenotypes
#' @param addcovar n by c matrix of additive numeric covariates
#' @param kinship a kinship matrix, not a list
#' @param start_snp positive integer indicating index within probs for start of scan
#' @param n_snp number of (consecutive) markers to use in scan
#' @param pleio_peak_index positive integer index indicating genotype matrix for bootstrap sampling. Typically acquired by using `find_pleio_peak_tib`.
#' @param nboot_per_job number of bootstrap samples to acquire per function invocation
#' @param max_iter maximum number of iterations for EM algorithm
#' @param max_prec stepwise precision for EM algorithm. EM stops once incremental difference in log likelihood is less than max_prec
#' @param n_cores number of cores to use when calling `scan_pvl`
#' @export
#' @importFrom stats var
#' @references Knott SA, Haley CS (2000) Multitrait
#' least squares for quantitative trait loci detection.
#' Genetics 156: 899–911.
#'
#' Walling GA, Visscher PM, Haley CS (1998) A comparison of
#' bootstrap methods to construct confidence intervals in QTL mapping.
#' Genet. Res. 71: 171–180.
#' @examples
#'
## define probs
#'probs_pre <- rbinom(n = 100 * 10, size = 1, prob = 1 / 2)
#'probs <- array(data = probs_pre, dim = c(100, 1, 10))
#'s_id <- paste0('s', 1:100)
#'rownames(probs) <- s_id
#'colnames(probs) <- 'A'
#'dimnames(probs)[[3]] <- paste0('Marker', 1:10)
#'# define Y
#'set.seed(2018-12-29)
#'Y_pre <- runif(200)
#'Y <- matrix(data = Y_pre, nrow = 100)
#'rownames(Y) <- s_id
#'colnames(Y) <- paste0('t', 1:2)
#'addcovar <- matrix(c(runif(99), NA), nrow = 100, ncol = 1)
#'rownames(addcovar) <- s_id
#'colnames(addcovar) <- 'c1'
#'kin <- diag(100)
#'rownames(kin) <- s_id
#'colnames(kin) <- s_id
#'Y2 <- Y
#'Y2[1, 2] <- NA
#'boot_pvl(probs = probs, pheno = Y, kinship = kin,
#'         start_snp = 1, n_snp = 10, pleio_peak_index = 10, nboot_per_job = 1)
#'boot_pvl(probs = probs, pheno = Y2, kinship = kin,
#'         start_snp = 1, n_snp = 10, pleio_peak_index = 10, nboot_per_job = 2)
#'
#'
#' @return numeric vector of (log) likelihood ratio test statistics from `nboot_per_job` bootstrap samples
#'
boot_pvl <- function(probs,
                     pheno,
                     addcovar = NULL,
                     kinship = NULL,
                     start_snp = 1,
                     n_snp,
                     pleio_peak_index,
                     nboot_per_job = 1,
                     max_iter = 1e+04,
                     max_prec = 1 / 1e+08,
                     n_cores = 1
                     )
    {
    if (is.null(probs)) stop("probs is NULL")
    if (is.null(pheno)) stop("pheno is NULL")
    stopifnot(!is.null(rownames(probs)),
              !is.null(colnames(probs)),
              !is.null(dimnames(probs)[[3]]),
              !is.null(rownames(pheno)),
              n_snp > 0,
              start_snp > 0,
              start_snp + n_snp - 1 <= dim(probs)[3]
    )
    # check additional conditions when addcovar is not NULL
    if (!is.null(addcovar)) {
        stopifnot(!is.null(rownames(addcovar)),
                  !is.null(colnames(addcovar))
        )
    }
    d_size <- ncol(pheno)  # d_size is the number of univariate phenotypes
    # force things to be matrices
    if(!is.matrix(pheno)) {
        pheno <- as.matrix(pheno)
        if(!is.numeric(pheno)) stop("pheno is not numeric")
    }
    if(is.null(colnames(pheno))) # force column names
        colnames(pheno) <- paste0("pheno", seq_len(ncol(pheno)))
    if(!is.null(addcovar)) {
        if(!is.matrix(addcovar)) addcovar <- as.matrix(addcovar)
        if(!is.numeric(addcovar)) stop("addcovar is not numeric")
    }

    # find individuals in common across all arguments
    # and drop individuals with missing covariates or missing *one or more* phenotypes
    # need to consider presence or absence of different inputs: kinship, addcovar
    id2keep <- make_id2keep(probs = probs,
                            pheno = pheno,
                            addcovar = addcovar,
                            kinship = kinship
    )
    # remove - from id2keep vector - subjects with a missing phenotype or covariate
    pheno <- subset_input(input = pheno, id2keep = id2keep)
    subjects_phe <- check_missingness(pheno)
    id2keep <- intersect(id2keep, subjects_phe)
    if (!is.null(addcovar)) {
        addcovar <- subset_input(input = addcovar, id2keep = id2keep)
        subjects_cov <- check_missingness(addcovar)
        id2keep <- intersect(id2keep, subjects_cov)
    }
    # Send messages if there are two or fewer subjects
    if (length(id2keep) == 0){stop("no individuals common to all inputs")}
    if (length(id2keep) <= 2){
        stop(paste0("only ", length(id2keep),
                    " common individual(s): ",
                    paste(id2keep, collapse = ": ")))
    }
    # subset inputs to get all without missingness
    probs <- subset_input(input = probs, id2keep = id2keep)
    pheno <- subset_input(input = pheno, id2keep = id2keep)
    if (!is.null(kinship)) {
        kinship <- subset_kinship(kinship = kinship, id2keep = id2keep)
    }
## define X1 - a single marker's allele probabilities
    X1 <- probs[ , , pleio_peak_index]
    if (!is.null(addcovar)) {
        Xpre <- cbind(X1, addcovar)
    } else {
        Xpre <- X1
    }
    X <- gemma2::stagger_mats(Xpre, Xpre)
    if (!is.null(kinship)){
        # covariance matrix estimation
        # first, run gemma2::MphEM(), by way of calc_covs(), to get Vg and Ve
        cc_out <- calc_covs(pheno, kinship, max_iter = max_iter, max_prec = max_prec, covariates = addcovar)
        Vg <- cc_out$Vg
        Ve <- cc_out$Ve
        # define Sigma
        Sigma <- calc_Sigma(Vg, Ve, kinship)
    }
    if (is.null(kinship)){
        # get Sigma for Haley Knott regression without random effect
        Ve <- var(pheno) # get d by d covar matrix
        Sigma <- calc_Sigma(Vg = NULL, Ve = Ve)
    }
    Sigma_inv <- solve(Sigma)
    # calc Bhat
    B <- rcpp_calc_Bhat2(X = X,
                         Sigma_inv = Sigma_inv,
                         Y = as.vector(as.matrix(pheno))
    )
    # Start loop
    lrt <- numeric()
    for (i in 1:nboot_per_job) {
        foo <- sim1(X = X, B = B, Vg = Vg, Ve = Ve, kinship = kinship)
        Ysim <- matrix(foo, ncol = 2, byrow = FALSE)
        rownames(Ysim) <- rownames(pheno)
        colnames(Ysim) <- c("t1", "t2")
        loglik <- scan_pvl(probs = probs,
                           pheno = Ysim,
                           addcovar = addcovar,
                           kinship = kinship,
                           start_snp = start_snp,
                           n_snp = n_snp,
                           max_iter = max_iter,
                           max_prec = max_prec,
                           n_cores = n_cores
                           )
        lrt[i] <- calc_lrt_tib(loglik)
    }
    return(lrt)
}
