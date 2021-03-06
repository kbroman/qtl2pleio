#' Simulate many bivariate phenotype files and write them to a new directory
#'
#' @param run_num run number, an integer
#' @param index1 marker index for locus 1, an integer
#' @param index2 marker index for locus 2, an integer
#' @param probs genotype probabilities array for a single chromosome
#' @param Vg genetic covariance matrix
#' @param Ve error covariance matrix
#' @param B vectorized allele effect matrix, ie, vec(Bmatrix)
#' @param kinship a LOCO kinship matrix
#' @param DIR directory where trait files will be written
#' @param nsim number of trait files to create
#' @importFrom utils write.table
#' @return a n by 2 matrix containing two distinct phenotypes

sim400 <- function(run_num, index1, index2, probs, Vg = matrix(data = c(1, 0, 0, 1), nrow = 2), Ve = Vg,
    B = rep(c(-3, -3, -3, -3, 3, 3, 3, 3), times = 2), kinship, DIR = paste0("sim_data/run", run_num,
        "-400sims"), nsim = 400) {
    X1 <- probs[, , index1]  #index is from command line args
    X2 <- probs[, , index2]
    X <- gemma2::stagger_mats(X1, X2)
    for (i in 0:(nsim - 1)) {
        foo <- sim1(X = X, B = B, Vg = Vg, Ve = Ve, kinship = kinship)
        Ysim <- matrix(foo, ncol = 2, byrow = FALSE)
        rownames(Ysim) <- rownames(probs)
        fn <- paste0("Ysim-run", run_num, "_", i, ".txt")
        write.table(x = Ysim, file = file.path(DIR, fn))
    }
}
