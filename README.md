
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sweater <img src="man/figures/sweater_logo.svg" align="right" height="200" />

<!-- badges: start -->

<!-- badges: end -->

The goal of sweater (Speedy Word Embedding Association TEst using R) is
to test for biases in word embeddings.

The package provides functions that are speedy. They are either
implemented in C++, or are speedy but accurate approximation of the
original implementation proposed by Caliskan et al (2017).

## Installation

You can install the Github version of sweater with:

``` r
devtools::install_github("chainsawriot/sweater")
```

## Example

This example reproduces the detection of “Math. vs Arts” gender bias in
Caliskan et al (2017).

``` r
require(sweater)
#> Loading required package: sweater
data(glove_math) # a subset of the original GLoVE word vectors

S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
sw <- sweater(glove_math, S, T, A, B)
sweater_es(sw)
#> [1] 1.055015
```

The exact test described in Caliskan et al. (2017) is also available.
But it takes a long time to calculate.

``` r
## Don't do it. It takes a long time and is almost always significant.
sweater_exact(sw)
```

Instead, please use the resampling approximaton of the exact test. The
p-value is very close to the reported 0.018.

``` r
sweater_resampling(sw)
#> 
#>  Resampling approximation of the exact test in Caliskan et al. (2017)
#> 
#> data:  sw
#> bias = 0.024865, p-value = 0.0171
#> alternative hypothesis: true bias is greater than 7.245425e-05
#> sample estimates:
#>       bias 
#> 0.02486533
```

## References

1.  Caliskan, Aylin, Joanna J. Bryson, and Arvind Narayanan. “Semantics
    derived automatically from language corpora contain human-like
    biases.” Science 356.6334 (2017): 183-186.
