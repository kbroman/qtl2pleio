#include <Rcpp.h>
#include <RcppEigen.h>
using namespace Rcpp;
using namespace Eigen;


// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
Eigen::MatrixXd rcpp_ols(const Eigen::Map<Eigen::MatrixXd> & X, const Eigen::Map<Eigen::MatrixXd> & Y) {
  return (X.transpose() * X).ldlt().solve(X.transpose() * Y);
}


// [[Rcpp::export]]
Eigen::MatrixXd rcpp_gls(const Eigen::Map<Eigen::MatrixXd> & X, const Eigen::Map<Eigen::MatrixXd> & Y, const Eigen::Map<Eigen::MatrixXd> & Sigma_inv) {
  Eigen::MatrixXd pre = X.transpose() * Sigma_inv * X;
  return (pre.inverse() * X.transpose() * Sigma_inv * Y);
}






// All test files should include the <testthat.h>
// header file.
#include <testthat.h>

// Normally this would be a function from your package's
// compiled library -- you might instead just include a header
// file providing the definition, and let R CMD INSTALL
// handle building and linking.

