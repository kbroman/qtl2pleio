% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy_scan_pvl.R
\name{transform_loglik_mat}
\alias{transform_loglik_mat}
\title{Assemble tibble from matrix of log-likelihood values}
\usage{
transform_loglik_mat(loglik_mat)
}
\arguments{
\item{loglik_mat}{a square matrix of log-likelihood values with rownames and colnames matching}
}
\value{
tibble with 3 columns: marker1, marker2 and log-likelihood
}
\description{
Assemble tibble from matrix of log-likelihood values
}
\examples{
llmat <- matrix(nrow = 3, ncol = 3, data = rgamma(9, 5))
rownames(llmat) <- paste0('m', 1:3)
colnames(llmat) <- paste0('m', 1:3)
transform_loglik_mat(llmat)
}
\seealso{
Other profile log-likelihood tibble functions: \code{\link{add_intercepts}},
  \code{\link{add_pmap}},
  \code{\link{assemble_profile_tib}},
  \code{\link{tidy_scan_pvl}}
}
\concept{profile log-likelihood tibble functions}
