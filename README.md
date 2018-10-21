
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qtl2pleio

## Badges

[![Travis-CI Build
Status](https://travis-ci.org/fboehm/qtl2pleio.svg?branch=master)](https://travis-ci.org/fboehm/qtl2pleio)
[![Coverage
Status](https://img.shields.io/codecov/c/github/fboehm/qtl2pleio/master.svg)](https://codecov.io/github/fboehm/qtl2pleio?branch=master)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

## Goals

The goal of qtl2pleio is to perform a likelihood ratio test that
distinguishes between competing hypotheses of presence of two separate
QTL (alternative hypothesis) and pleiotropy (null hypothesis) in QTL
studies in multiparental populations, such as the Diversity Outbred
mouse population. `qtl2pleio` data structures are those used in the
`rqtl/qtl2` package.

## Installation

``` r
install.packages("devtools")
devtools::install_github("fboehm/qtl2pleio")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.

## Citation information

``` r
citation("qtl2pleio")
#> Warning: 'DESCRIPTION' file has an 'Encoding' field and re-encoding is not
#> possible
#> Warning in citation("qtl2pleio"): no date field in DESCRIPTION file of
#> package 'qtl2pleio'
#> Warning in citation("qtl2pleio"): could not determine year for 'qtl2pleio'
#> from package DESCRIPTION file
#> 
#> To cite package 'qtl2pleio' in publications use:
#> 
#>   Frederick Boehm (NA). qtl2pleio: Hypothesis test of close
#>   linkage vs pleiotropy in multiparental populations. R package
#>   version 0.1.2.9000. https://github.com/fboehm/qtl2pleio
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {qtl2pleio: Hypothesis test of close linkage vs pleiotropy in multiparental populations},
#>     author = {Frederick Boehm},
#>     note = {R package version 0.1.2.9000},
#>     url = {https://github.com/fboehm/qtl2pleio},
#>   }
```
