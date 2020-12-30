
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sweater <img src="man/figures/sweater_logo.svg" align="right" height="200" />

<!-- badges: start -->

<!-- badges: end -->

The goal of sweater (**S**peedy **W**ord **E**mbedding **A**ssociation
**T**est & **E**xtras using **R**) is to test for biases in word
embeddings.

The package provides functions that are speedy. They are either
implemented in C++, or are speedy but accurate approximation of the
original implementation proposed by Caliskan et al (2017).

If your goal is to reproduce the analysis in Caliskan et al (2017),
please consider using the [original Java
program](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DX4VWP&version=2.0)
or the R package [cbn](https://github.com/conjugateprior/cbn) by Lowe.
This package provides extras (e.g. RNSB).

## Installation

You can install the Github version of sweater with:

``` r
devtools::install_github("chainsawriot/sweater")
```

## Notation of a query

All tests in this package use the concept of queries (see Badilla et
al., 2020) to study the biases in the input word embeddings `w`. This
package uses the “STAB” notation \[1\] from Brunet et al (2019).

All tests depend on two types of words. The first type, namely, `S` and
`T`, is *target words* (or *neutral words* in Garg et al). These are
words that **should** have no bias. For instance, the words such as
“nurse” and “professor” can be used as target words to study the
gender bias in word embeddings. One can also seperate these words into
two sets, `S` and `T`, to group words by their perceived bias. For
example, Caliskan et al. (2017) grouped target words into two groups:
mathematics (“math”, “algebra”, “geometry”, “calculus”, “equations”,
“computation”, “numbers”, “addition”) and arts (“poetry”, “art”,
“dance”, “literature”, “novel”, “symphony”, “drama”, “sculpture”).
Please note that also `T` is not always required.

The second type, namely `A` and `B`, is *attribute words* (or *group
words* in Garg et al). These are words with known properties in relation
to the bias that one is studying. For example, Caliskan et al. (2017)
used gender-related words such as “male”, “man”, “boy”, “brother”, “he”,
“him”, “his”, “son” to study gender bias. These words qualify as
attribute words because we know they are related to a certain gender.
`A` and `B` are always required.

All functions follow the same template: `test(w, S, T, A, B)`. One can
then extract the effect size of the test using `test_es`.

## Example: Word Embedding Association Test

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
sw <- weat(glove_math, S, T, A, B)

# extraction of effect size
weat_es(sw)
#> [1] 1.055015
```

## A note about the effect size

By default, the effect size from the function `weat_es` is adjusted by
the pooled standard deviaion (see Page 2 of Caliskan et al. 2007). The
standardized effect size can be interpreted the way as Cohen’s d (Cohen,
1988).

One can also get the unstandardized version (aka. test statistic in the
original paper):

``` r
weat_es(sw, standardize = FALSE)
#> [1] 0.02486533
```

The original implementation assumes equal size of S and T. This
assumption can be relaxed by pooling the standard deviaion with sample
size adjustment. The function `weat_es` does it when S and T are of
different length.

Also, the effect size can be converted to point-biserial correlation
(mathematically equivalent to the Pearson’s product moment correlation).

``` r
weat_es(sw, r = TRUE)
#> [1] 0.4912066
```

## Exact test

The exact test described in Caliskan et al. (2017) is also available.
But it takes a long time to calculate.

``` r
## Don't do it. It takes a long time and is almost always significant.
weat_exact(sw)
```

Instead, please use the resampling approximaton of the exact test. The
p-value is very close to the reported 0.018.

``` r
weat_resampling(sw)
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

## Example: Relative Negative Sentiment Bias

This analysis attempts to reproduce the analysis in Sweeney & Najafian
(2019). Please note that `T` is not required.

``` r
S <- c("swedish", "irish", "mexican", "chinese", "filipino",
       "german", "english", "french", "norwegian", "american",
       "indian", "dutch", "russian", "scottish", "italian")
sn <- rnsb(glove_sweeney, S, bing_pos, bing_neg)
```

The analysis shows that `mexican`, `american`, `chinese` and `irish` are
more likely to be associated with negative sentiment. (Please note that
the numbers are different from the original paper; pending confirmation
with the original authors)

``` r
sort(sn$P)
#>      swedish        dutch      english       indian     scottish      russian 
#> 4.386836e-05 1.359952e-03 2.321847e-03 4.896528e-03 4.911510e-03 1.088144e-02 
#>      italian    norwegian       german     filipino       french     american 
#> 1.569090e-02 1.644982e-02 1.724904e-02 1.984069e-02 2.043743e-02 1.334806e-01 
#>        irish      chinese      mexican 
#> 1.533780e-01 2.017766e-01 3.972818e-01
```

The effect size from the analysis is the Kullback–Leibler divergence of
P from the uniform distribution. (It is also substantially larger than
the number reported in the original paper; pending confirmation with the
original authors)

``` r
rnsb_es(sn)
#> [1] 0.9770686
```

## References

1.  Badilla, P., Bravo-Marquez, F., & Pérez, J. (2020). WEFE: The word
    embeddings fairness evaluation framework. In Proceedings of the 29
    th Intern. Joint Conf. Artificial Intelligence.
2.  Brunet, M. E., Alkalay-Houlihan, C., Anderson, A., & Zemel, R.
    (2019, May). Understanding the origins of bias in word embeddings.
    In International Conference on Machine Learning (pp. 803-811). PMLR.
3.  Caliskan, Aylin, Joanna J. Bryson, and Arvind Narayanan. “Semantics
    derived automatically from language corpora contain human-like
    biases.” Science 356.6334 (2017): 183-186.
4.  Cohen, J. (1988), Statistical Power Analysis for the Behavioral
    Sciences, 2nd Edition. Hillsdale: Lawrence Erlbaum.
5.  McGrath, R. E., & Meyer, G. J. (2006). When effect sizes disagree:
    the case of r and d. Psychological methods, 11(4), 386.
6.  Rosenthal, R. (1991), Meta-Analytic Procedures for Social Research.
    Newbury Park: Sage
7.  Sweeney, C., & Najafian, M. (2019, July). A transparent framework
    for evaluating unintended demographic bias in word embeddings. In
    Proceedings of the 57th Annual Meeting of the Association for
    Computational Linguistics (pp. 1662-1667).

<!-- end list -->

1.  because STAB is easy to remember.
