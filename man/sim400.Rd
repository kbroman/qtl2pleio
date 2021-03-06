% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sim400.R
\name{sim400}
\alias{sim400}
\title{Simulate many bivariate phenotype files and write them to a new directory}
\usage{
sim400(run_num, index1, index2, probs, Vg = matrix(data = c(1, 0, 0, 1),
  nrow = 2), Ve = Vg, B = rep(c(-3, -3, -3, -3, 3, 3, 3, 3), times =
  2), kinship, DIR = paste0("sim_data/run", run_num, "-400sims"),
  nsim = 400)
}
\arguments{
\item{run_num}{run number, an integer}

\item{index1}{marker index for locus 1, an integer}

\item{index2}{marker index for locus 2, an integer}

\item{probs}{genotype probabilities array for a single chromosome}

\item{Vg}{genetic covariance matrix}

\item{Ve}{error covariance matrix}

\item{B}{vectorized allele effect matrix, ie, vec(Bmatrix)}

\item{kinship}{a LOCO kinship matrix}

\item{DIR}{directory where trait files will be written}

\item{nsim}{number of trait files to create}
}
\value{
a n by 2 matrix containing two distinct phenotypes
}
\description{
Simulate many bivariate phenotype files and write them to a new directory
}
