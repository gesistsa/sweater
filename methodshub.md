# sweater - Speedy Word Embedding Association Test and Extras Using R


## Description

<!-- - Provide a brief and clear description of the method, its purpose, and what it aims to achieve. Add a link to a related paper from social science domain and show how your method can be applied to solve that research question.   -->

Conduct various tests for evaluating implicit biases in word embeddings:
Word Embedding Association Test (Caliskan et al., 2017),
[\<doi:10.1126/science.aal4230\>](https://doi.org/10.1126/science.aal4230),
Relative Norm Distance (Garg et al., 2018),
[\<doi:10.1073/pnas.1720347115\>](https://doi.org/10.1073/pnas.1720347115),
Mean Average Cosine Similarity (Mazini et al., 2019)
\<arXiv:1904.04047\>, SemAxis (An et al., 2018) \<arXiv:1806.05521\>,
Relative Negative Sentiment Bias (Sweeney & Najafian, 2019)
[\<doi:10.18653/v1/P19-1162\>](https://doi.org/10.18653/v1/P19-1162),
and Embedding Coherence Test (Dev & Phillips, 2019)
\<arXiv:1901.07656\>.

## Keywords

<!-- EDITME -->

- Word Embedding
- Implicit Association
- Bias

## Science Usecase(s)

<!-- - Include usecases from social sciences that would make this method applicable in a certain scenario.  -->
<!-- The use cases or research questions mentioned should arise from the latest social science literature cited in the description. -->

This package was used in the literature to quantify the (unwanted)
implicit associations in word embeddings trained on large text corpora,
e.g. [Urman et al. (2022)](https://doi.org/10.1177/14614448221099536)
and [Müller et
al. (2024)](https://doi.org/10.1080/10584609.2023.2193146).

While not using this package, the methods were used in various social
science publications, e.g. [Caliskan et
al. (2017)](https://doi.org/10.1126/science.aal4230).

## Repository structure

This repository follows [the standard structure of an R
package](https://cran.r-project.org/doc/FAQ/R-exts.html#Package-structure).

## Environment Setup

With R installed:

``` r
install.packages("sweater")
```

<!-- ## Hardware Requirements (Optional) -->
<!-- - The hardware requirements may be needed in specific cases when a method is known to require more memory/compute power.  -->
<!-- - The method need to be executed on a specific architecture (GPUs, Hadoop cluster etc.) -->

## Input Data

<!-- - The input data has to be a Digital Behavioral Data (DBD) Dataset -->
<!-- - You can provide link to a public DBD dataset. GESIS DBD datasets (https://www.gesis.org/en/institute/digital-behavioral-data) -->

`sweater` accepts pretrained or newly trained word embeddings. In the
package, subsets of GLoVE and Google News Word2Vec embeddings are
included. Existing pretrained word embeddings can be read using the
provided function `sweater::read_word2vec()`. The word embeddings
trained using R packages such as
[`text2vec`](https://CRAN.R-project.org/package=text2vec) and
[rsparse](https://cran.r-project.org/package=rsparse) are directly
supported.

## Sample Input and Output Data

<!-- - Show how the input data looks like through few sample instances -->
<!-- - Providing a sample output on the sample input to help cross check  -->

The word embeddings should be in the form of standard dense R matrix,
which each row represents the word vector of a word. For example, the
GLoVE (only first five rows and 10 dimensions) looks like this:

``` r
library(sweater)
glove_math[1:5, 1:10]
```

             [,1]     [,2]      [,3]      [,4]      [,5]      [,6]     [,7]
    he   0.085181 0.508920 -0.088280 -0.397850  0.252510  0.057932 -0.15804
    his  0.019097 0.231190 -0.168100  0.129900  0.342980  0.054346 -0.19300
    her  0.142030 0.095083 -0.268100  0.647990  0.100300 -0.103720 -0.18631
    she  0.236480 0.390910 -0.095802  0.053600 -0.039457  0.094117 -0.12456
    him -0.223060 0.154560 -0.321320  0.052292  0.284170 -0.296610 -0.32371
            [,8]     [,9]  [,10]
    he  -0.40127 -0.13023 3.9609
    his -0.39108 -0.11816 3.6969
    her -0.39495 -0.27631 3.5805
    she -0.50161 -0.14399 3.7937
    him -0.36878 -0.25365 3.7652

The output from `sweater` is an S3 Object, which can be used to do
statistical analysis or data visualization.

## How to Use

<!-- - Providing HowTos on the method for different types of usages -->
<!-- - Describe how the method should be used, including installation, configuration, and any specific instructions for users. -->

Please refer to the [overview of this
package](https://github.com/gesistsa/sweater/blob/v0.1/README.md) for a
comprehensive introduction of the package.

`sweater` provides the main function `query()` for conducting several
tests. All tests depend on two types of words. The first type, namely,
`S_words` and `T_words`, is *target words* . In the case of studying
biases, these are words that **should** have no bias. For instance, the
words such as “nurse” and “professor” can be used as target words to
study the gender bias in word embeddings.

One can also separate these words into two sets, `S_words` and
`T_words`, to group words by their perceived bias. For example, Caliskan
et al. (2017) grouped target words into two groups: mathematics (“math”,
“algebra”, “geometry”, “calculus”, “equations”, “computation”,
“numbers”, “addition”) and arts (“poetry”, “art”, “dance”, “literature”,
“novel”, “symphony”, “drama”, “sculpture”). Please note that `T_words`
is not always required.

The second type, namely `A_words` and `B_words`, is *attribute words*
(or *group words* in Garg et al). These are words with known properties
in relation to the bias that one is studying. For example, Caliskan et
al. (2017) used gender-related words such as “male”, “man”, “boy”,
“brother”, “he”, “him”, “his”, “son” to study gender bias. These words
qualify as attribute words because we know they are related to a certain
gender.

This example reproduces the detection of “Math. vs Arts” gender bias in
Caliskan et al (2017).

``` r
data(glove_math) # a subset of the original GLoVE word vectors

S4 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T4 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A4 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B4 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

# extraction of effect size
query(w = glove_math, S_words = S4, T_words = T4, A_words = A4, B_words = B4)
```

    ── sweater object ──────────────────────────────────────────────────────────────

    Test type:  weat 
    Effect size:  1.055015 

    ── Functions ───────────────────────────────────────────────────────────────────

    • `calculate_es()`: Calculate effect size

    • `weat_resampling()`: Conduct statistical test

## Contact Details

Maintainer: Chung-hong Chan <chainsawtiney@gmail.com>

Issue Tracker: <https://github.com/gesistsa/sweater/issues>

## Publication

1.  Chan, C., (2022). sweater: Speedy Word Embedding Association Test
    and Extras Using R. Journal of Open Source Software, 7(72), 4036,
    https://doi.org/10.21105/joss.04036

<!-- ## Acknowledgements -->
<!-- - Acknowledgements if any -->
<!-- ## Disclaimer -->
<!-- - Add any disclaimers, legal notices, or usage restrictions for the method, if necessary. -->
