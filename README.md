
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sweater <img src="man/figures/sweater_logo.svg" align="right" height="200" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/chainsawriot/sweater/workflows/R-CMD-check/badge.svg)](https://github.com/chainsawriot/sweater/actions)
[![Codecov test
coverage](https://codecov.io/gh/chainsawriot/sweater/branch/master/graph/badge.svg)](https://codecov.io/gh/chainsawriot/sweater?branch=master)
<!-- badges: end -->

The goal of sweater (**S**peedy **W**ord **E**mbedding **A**ssociation
**T**est & **E**xtras using **R**) is to test for biases in word
embeddings.

The package provides functions that are speedy. They are either
implemented in C++, or are speedy but accurate approximation of the
original implementation proposed by Caliskan et al (2017).

This package provides extra methods such as Relative Norm Distance,
SemAxis and Relative Negative Sentiment Bias.

If your goal is to reproduce the analysis in Caliskan et al (2017),
please consider using the [original Java
program](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DX4VWP&version=2.0)
or the R package [cbn](https://github.com/conjugateprior/cbn) by Lowe.
To reproduce the analysis in Garg et al (2018), please consider using
the [original Python
program](https://github.com/nikhgarg/EmbeddingDynamicStereotypes). To
reproduce the analysis in Mazini et al (2019), please consider using the
[original Python
program](https://github.com/TManzini/DebiasMulticlassWordEmbedding/).

## Installation

You can install the Github version of sweater with:

``` r
devtools::install_github("chainsawriot/sweater")
```

## Notation of a query

All tests in this package use the concept of queries (see Badilla et
al., 2020) to study the biases in the input word embeddings `w`. This
package uses the “STAB” notation from Brunet et al (2019).

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

It is recommended to use the function `query()` to make a query and
`calculate_es()` to calculate the effect size. You can also use the
inidividual functions below.

## Available methods

| Target words | Attribution words | Method                                                      | functions                                             |
| ------------ | ----------------- | ----------------------------------------------------------- | ----------------------------------------------------- |
| S            | A                 | Mean Average Cosine Similarity (Mazini et al. 2019)         | mac(), mac\_es()                                      |
| S            | A, B              | Relative Norm Distance (Garg et al. 2018)                   | rnd(), rnd\_es()                                      |
| S            | A, B              | Relative Negative Sentiment Bias (Sweeney & Najafian. 2019) | rnsb(), rnsb\_es()                                    |
| S            | A, B              | SemAxis (An et al. 2018)                                    | semaxis()                                             |
| S            | A, B              | Normalized Association Score (Caliskan et al. 2017)         | nas()                                                 |
| S, T         | A, B              | Word Embedding Association Test (Caliskan et al. 2017)      | weat(), weat\_es(), weat\_resampling(), weat\_exact() |
| S, T         | A, B              | Word Embeddings Fairness Evaluation (Badilla et al. 2020)   | To be implemented                                     |

## Example: Mean Average Cosine Similarity

The simplest form of bias detection is Mean Average Cosine Similarity
(Mazini et al. 2019). The same method is used also in Kroon et
al. (2020).

``` r
require(sweater)
#> Loading required package: sweater
#> 
#> Attaching package: 'sweater'
#> The following object is masked _by_ '.GlobalEnv':
#> 
#>     googlenews

S <- c("swedish", "irish", "mexican", "chinese", "filipino",
       "german", "english", "french", "norwegian", "american",
       "indian", "dutch", "russian", "scottish", "italian")
## The same
## mac_neg <- mac(glove_sweeney, S, A = bing_neg)
mac_neg <- query(glove_sweeney, S = S, A = bing_neg)
sort(mac_neg$P)
#>    scottish   norwegian       dutch     swedish       irish      indian 
#> -0.05503365 -0.04837842 -0.04686386 -0.04520747 -0.04347593 -0.04325103 
#>     english     italian    american      german      french    filipino 
#> -0.04187256 -0.04145709 -0.04112830 -0.04045438 -0.03885260 -0.03559971 
#>     mexican     chinese     russian 
#> -0.03193020 -0.02910324 -0.02581414
```

## Example: Relative Norm Distance

This analysis reproduces the analysis in Garg et al (2018), namely
Figure 1. Please note that `T` is not required.

``` r
S <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
"photographer", "geologist", "shoemaker", "athlete", "cashier", 
"dancer", "housekeeper", "accountant", "physicist", "gardener", 
"dentist", "weaver", "blacksmith", "psychologist", "supervisor", 
"mathematician", "surveyor", "tailor", "designer", "economist", 
"mechanic", "laborer", "postmaster", "broker", "chemist", "librarian", 
"attendant", "clerical", "musician", "porter", "scientist", "carpenter", 
"sailor", "instructor", "sheriff", "pilot", "inspector", "mason", 
"baker", "administrator", "architect", "collector", "operator", 
"surgeon", "driver", "painter", "conductor", "nurse", "cook", 
"engineer", "retired", "sales", "lawyer", "clergy", "physician", 
"farmer", "clerk", "manager", "guard", "artist", "smith", "official", 
"police", "doctor", "professor", "student", "judge", "teacher", 
"author", "secretary", "soldier")
A <- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
B <- c("she", "daughter", "hers", "her", "mother", "woman", "girl", 
"herself", "female", "sister", "daughters", "mothers", "women", 
"girls", "females", "sisters", "aunt", "aunts", "niece", "nieces"
)

## The same
## garg_f1 <- rnd(googlenews, S, A, B)
garg_f1 <- query(googlenews, S = S, A = A, B = B)
```

The function `plot_bias` can be used to plot the bias of each word in S.
Words such as “nurse”, “midwife” and “librarian” are more associated
with female, as indicated by the positive relative norm distance.

``` r
plot_bias(garg_f1)
```

<img src="man/figures/README-rndplot-1.png" width="100%" />

The effect size is simply the sum of all relative norm distance values
(Equation 3 in Garg et al. 2018). The more positive value indicates that
words in S are more associated with `B`. As the effect size is negative,
it indicates that the concept of occupation is more associated with `A`,
i.e. male.

``` r
calculate_es(garg_f1)
#> [1] -6.341598
```

## Example: SemAxis

This analysis attempts to reproduce the analysis in An et al. (2018).
Please note that `T` is not required.

You may obtain the word2vec word vectors trained with Trump supporters
Reddit from [here](https://github.com/ghdi6758/SemAxis).

``` r
S <- c("mexicans", "asians", "whites", "blacks", "latinos")
A <- c("respect")
B <- c("disrespect")
res <- query(reddit, S = S, A = A, B = B, method = "semaxis", l = 1)
res$P
#>    mexicans      asians      whites      blacks     latinos 
#> -0.16402445 -0.10867685 -0.10599096 -0.07974000 -0.04583781
```

## Example: Relative Negative Sentiment Bias

This analysis attempts to reproduce the analysis in Sweeney & Najafian
(2019). Please note that `T` is not required.

``` r
S <- c("swedish", "irish", "mexican", "chinese", "filipino",
       "german", "english", "french", "norwegian", "american",
       "indian", "dutch", "russian", "scottish", "italian")
sn <- query(glove_sweeney, S = S, A = bing_pos, B = bing_neg, method = "rnsb")
```

The analysis shows that `indian`, `mexican`, and `russian` are more
likely to be associated with negative sentiment.

``` r
plot_bias(sn)
```

<img src="man/figures/README-rnsbplot-1.png" width="100%" />

The effect size from the analysis is the Kullback–Leibler divergence of
P from the uniform distribution. It is extremely close to the value
reported in the original paper (0.6225).

``` r
rnsb_es(sn)
#> [1] 0.6228853
```

## Support for Quanteda Dictionary

`rnsb` supports quanteda dictionary as `S`. `rnd` and `weat` will
support it later.

For example, `newsmap_europe` is an abridged dictionary from the package
newsmap (Watanabe, 2018). The dictionary contains keywords of European
countries and has two levels: regional level (e.g. Eastern Europe) and
country level (e.g. Germany).

``` r
require(quanteda)
#> Loading required package: quanteda
#> Package version: 3.1.0
#> Unicode version: 13.0
#> ICU version: 66.1
#> Parallel computing: 8 of 8 threads used.
#> See https://quanteda.io for tutorials and examples.
newsmap_europe
#> Dictionary object with 4 primary key entries and 2 nested levels.
#> - [EAST]:
#>   - [BG]:
#>     - bulgaria, bulgarian*, sofia
#>   - [BY]:
#>     - belarus, belarusian*, minsk
#>   - [CZ]:
#>     - czech republic, czech*, prague
#>   - [HU]:
#>     - hungary, hungarian*, budapest
#>   - [MD]:
#>     - moldova, moldovan*, chisinau
#>   - [PL]:
#>     - poland, polish, pole*, warsaw
#>   [ reached max_nkey ... 4 more keys ]
#> - [NORTH]:
#>   - [AX]:
#>     - aland islands, aland island*, alandish, mariehamn
#>   - [DK]:
#>     - denmark, danish, dane*, copenhagen
#>   - [EE]:
#>     - estonia, estonian*, tallinn
#>   - [FI]:
#>     - finland, finnish, finn*, helsinki
#>   - [FO]:
#>     - faeroe islands, faeroe island*, faroese*, torshavn
#>   - [GB]:
#>     - uk, united kingdom, britain, british, briton*, brit*, london
#>   [ reached max_nkey ... 10 more keys ]
#> - [SOUTH]:
#>   - [AD]:
#>     - andorra, andorran*
#>   - [AL]:
#>     - albania, albanian*, tirana
#>   - [BA]:
#>     - bosnia, bosnian*, bosnia and herzegovina, herzegovina, sarajevo
#>   - [ES]:
#>     - spain, spanish, spaniard*, madrid, barcelona
#>   - [GI]:
#>     - gibraltar, gibraltarian*, llanitos
#>   - [GR]:
#>     - greece, greek*, athens
#>   [ reached max_nkey ... 11 more keys ]
#> - [WEST]:
#>   - [AT]:
#>     - austria, austrian*, vienna
#>   - [BE]:
#>     - belgium, belgian*, brussels
#>   - [CH]:
#>     - switzerland, swiss*, zurich, bern
#>   - [DE]:
#>     - germany, german*, berlin, frankfurt
#>   - [FR]:
#>     - france, french*, paris
#>   - [LI]:
#>     - liechtenstein, liechtenstein*, vaduz
#>   [ reached max_nkey ... 3 more keys ]
```

Country-level analysis

``` r
country_level <- rnsb(googlenews, newsmap_europe, bing_pos, bing_neg, levels = 2)
plot_bias(country_level)
```

<img src="man/figures/README-rnsb2-1.png" width="100%" />

Region-level analysis

``` r
region_level <- rnsb(googlenews, newsmap_europe, bing_pos, bing_neg, levels = 1)
plot_bias(region_level)
```

<img src="man/figures/README-rnsb3-1.png" width="100%" />

Comparison of the two effect sizes. Please note the much smaller effect
size from region-level analysis. It reflects the evener distribution of
P acorss regions than across countries.

``` r
calculate_es(country_level)
#> [1] 0.0796689
calculate_es(region_level)
#> [1] 0.00329434
```

## Example: Normalized Association Score

Normalized Association Score (Caliskan et al., 2017) is similar to
Relative Norm Distance above. Please note that `T` is not required.

``` r
S <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
"photographer", "geologist", "shoemaker", "athlete", "cashier", 
"dancer", "housekeeper", "accountant", "physicist", "gardener", 
"dentist", "weaver", "blacksmith", "psychologist", "supervisor", 
"mathematician", "surveyor", "tailor", "designer", "economist", 
"mechanic", "laborer", "postmaster", "broker", "chemist", "librarian", 
"attendant", "clerical", "musician", "porter", "scientist", "carpenter", 
"sailor", "instructor", "sheriff", "pilot", "inspector", "mason", 
"baker", "administrator", "architect", "collector", "operator", 
"surgeon", "driver", "painter", "conductor", "nurse", "cook", 
"engineer", "retired", "sales", "lawyer", "clergy", "physician", 
"farmer", "clerk", "manager", "guard", "artist", "smith", "official", 
"police", "doctor", "professor", "student", "judge", "teacher", 
"author", "secretary", "soldier")
A <- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
B <- c("she", "daughter", "hers", "her", "mother", "woman", "girl", 
"herself", "female", "sister", "daughters", "mothers", "women", 
"girls", "females", "sisters", "aunt", "aunts", "niece", "nieces"
)

nas_f1 <- query(googlenews, S = S, A = A, B = B, method = "nas")
plot_bias(nas_f1)
```

<img src="man/figures/README-nasplot-1.png" width="100%" />

There is a very strong correlation between NAS and RND.

``` r
cor.test(nas_f1$P, garg_f1$P)
#> 
#>  Pearson's product-moment correlation
#> 
#> data:  nas_f1$P and garg_f1$P
#> t = -24.93, df = 74, p-value < 2.2e-16
#> alternative hypothesis: true correlation is not equal to 0
#> 95 percent confidence interval:
#>  -0.9650781 -0.9148179
#> sample estimates:
#>        cor 
#> -0.9453038
```

## Example: Word Embedding Association Test

This example reproduces the detection of “Math. vs Arts” gender bias in
Caliskan et al (2017).

``` r
data(glove_math) # a subset of the original GLoVE word vectors

S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
sw <- query(glove_math, S, T, A, B)

# extraction of effect size
calculate_es(sw)
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
## weat_es
calculate_es(sw, standardize = FALSE)
#> [1] 0.02486533
```

The original implementation assumes equal size of `S` and `T`. This
assumption can be relaxed by pooling the standard deviaion with sample
size adjustment. The function `weat_es` does it when `S` and `T` are of
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
#> data:  sweater_obj
#> bias = 0.024865, p-value = 0.0171
#> alternative hypothesis: true bias is greater than 7.245425e-05
#> sample estimates:
#>       bias 
#> 0.02486533
```

## References

1.  An, J., Kwak, H., & Ahn, Y. Y. (2018). SemAxis: A lightweight
    framework to characterize domain-specific word semantics beyond
    sentiment. arXiv preprint arXiv:1806.05521.
2.  Badilla, P., Bravo-Marquez, F., & Pérez, J. (2020). WEFE: The word
    embeddings fairness evaluation framework. In Proceedings of the 29
    th Intern. Joint Conf. Artificial Intelligence.
3.  Brunet, M. E., Alkalay-Houlihan, C., Anderson, A., & Zemel, R.
    (2019, May). Understanding the origins of bias in word embeddings.
    In International Conference on Machine Learning (pp. 803-811). PMLR.
4.  Caliskan, Aylin, Joanna J. Bryson, and Arvind Narayanan. “Semantics
    derived automatically from language corpora contain human-like
    biases.” Science 356.6334 (2017): 183-186.
5.  Cohen, J. (1988), Statistical Power Analysis for the Behavioral
    Sciences, 2nd Edition. Hillsdale: Lawrence Erlbaum.
6.  Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word
    embeddings quantify 100 years of gender and ethnic stereotypes.
    Proceedings of the National Academy of Sciences, 115(16),
    E3635-E3644.
7.  Manzini, T., Lim, Y. C., Tsvetkov, Y., & Black, A. W. (2019). Black
    is to criminal as caucasian is to police: Detecting and removing
    multiclass bias in word embeddings. arXiv preprint arXiv:1904.04047.
8.  McGrath, R. E., & Meyer, G. J. (2006). When effect sizes disagree:
    the case of r and d. Psychological methods, 11(4), 386.
9.  Rosenthal, R. (1991), Meta-Analytic Procedures for Social Research.
    Newbury Park: Sage
10. Sweeney, C., & Najafian, M. (2019, July). A transparent framework
    for evaluating unintended demographic bias in word embeddings. In
    Proceedings of the 57th Annual Meeting of the Association for
    Computational Linguistics (pp. 1662-1667).
11. Watanabe, K. (2018). Newsmap: A semi-supervised approach to
    geographical news classification. Digital Journalism, 6(3), 294-309.
