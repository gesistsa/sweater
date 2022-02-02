---
title: 'sweater: Speedy Word Embedding Association Test and Extras Using R'
tags:
  - R
  - word embedding
  - implicit bias
  - media bias
  - algorithmic accountability
authors:
  - name: Chung-hong Chan
    orcid: 0000-0002-6232-7530
    affiliation: 1
affiliations:
 - name: Mannheimer Zentrum für Europäische Sozialforschung, Universität Mannheim
   index: 1
citation_author: Chan.
date: 28 January 2022
year: 2022
bibliography: paper.bib
output: rticles::joss_article
csl: apa.csl
journal: JOSS
---



# Statement of need

The goal of this R package is to detect (implicit) biases in word embeddings. Word embeddings can capture how similar or different two words are in terms of implicit and explicit meanings. Using the example in @collobert2011natural, the word vector for "XBox" is close to that of "PlayStation", as measured by a distance measure such as cosine distance. The same technique can also be used to detect biases. In the situation of racial bias detection, for example, @kroon2020guilty measure how close the word vectors for various ethnic group names (e.g. "Dutch", "Belgian" , and "Syrian") to that of various nouns related to threats (e.g. "terrorist", "murderer", and "gangster"). These biases in word embedding can be understood through the implicit social cognition model of media priming [@arendt:2013:DDM]. In this model, implicit stereotypes are defined as the "strength of the automatic association between a group concept (e.g., minority group) and an attribute (e.g., criminal)." [@arendt:2013:DDM, p. 832] All of these bias detection methods are based on the strength of association between a concept (or a target) and an attribute in embedding spaces.

The importance of detecting biases in word embeddings is twofold. First, pretrained, biased word embeddings deployed in real-life machine learning systems can pose fairness concerns [@packer2018text;@boyarskaya2020overcoming]. Second, biases in word embeddings reflect the biases in the original training material. Social scientists, communication researchers included, have exploited these methods to quantify (implicit) media biases by extracting biases from word embeddings locally trained on large text corpora [e.g. @kroon2020guilty;@knoche2019identifying;@sales2019media].

Previously, the software of these methods is only scatteredly available as the addendum of the original papers and was implemented in different languages (Java, Python, etc.). `sweater` provides several of these bias detection methods in one unified package with a consistent R interface [@rcore]. Also, some provided methods are implemented in C++ for speed and interfaced to R using the `Rcpp` package [@eddelbuettel:2013:SRC] [^BENCH].

[^BENCH]: Compared with a pure R implementation, the C++ implementation of Word Embedding Association Test in `sweater` is at least 7 times faster. See the benchmark [here](https://github.com/chainsawriot/sweater/blob/master/paper/benchmark.md).

# Related work

The R package `cbn` (https://github.com/conjugateprior/cbn) by Will Lowe provides tools for replicating the study by @caliskan:2017:S. The Python package `wefe` [@badilla2020wefe] provides several methods for bias evaluation in a unified (Python) interface.

# Usage

In this section, I demonstrate how the package can be used to detect biases and reproduce some published findings.

## Word Embeddings

The input word embedding $w$ is a dense $m\times n$ matrix, where $m$ is the total size of the vocabulary in the training corpus and $n$ is the vector dimension size.

`sweater` supports input word embeddings, $w$, in several formats. For locally trained word embeddings, output from the R packages `word2vec` [@wijffelsword2vec], `rsparse` [@rsparse] and `text2vec` [@selivanov2020tex2vec] can be used directly with the packages primary functions, such as `query` [^TRAIN]. Pretrained word embeddings in the so-called "word2vec" file format, such as those obtained online [^SOURCE], can be converted to the dense numeric matrix format required with the `read_word2vec` function.

The package also provides three trimmed word embeddings for experimentation: `googlenews` [@mikolov2013distributed], `glove_math` [@pennington:2014:G] , and `small_reddit` [@an2018semaxis].

[^TRAIN]: The vignette of `text2vec` provides a guide on how to locally train word embeddings using the GLoVE algorithm [@pennington:2014:G]. https://cran.r-project.org/web/packages/text2vec/vignettes/glove.html

[^SOURCE]: For example, the [pretrained GLoVE word embeddings](https://nlp.stanford.edu/projects/glove/), [pretrained word2vec word embeddings](https://wikipedia2vec.github.io/wikipedia2vec/pretrained/)  and pretrained [fastText word embeddings](https://fasttext.cc/docs/en/english-vectors.html).

## Query

`sweater` uses the concept of a *query* [@badilla2020wefe] to study the biases in $w$ and the $\mathcal{S}\mathcal{T}\mathcal{A}\mathcal{B}$ notation from @brunet2019understanding to form a query. A query contains two or more sets of seed words (wordsets selected by people administering the test, sometimes called "seed lexicons" or "dictionaries"). Among these seed wordsets, there should be at least one set of *target words* and one set of *attribute words*.

Target words are words that **should** have no bias and usually represent the concept one would like to probe for biases. For instance, @garg:2018:W investigated the "women bias" of occupation-related words and their target words contain "nurse", "mathematician", and "blacksmith". These words can be used as target words because in an ideal world with no "women bias" associated with occupations, these occupation-related words should have no gender association.

Target words are denoted as wordsets $\mathcal{S}$ and $\mathcal{T}$. All methods require $\mathcal{S}$ while $\mathcal{T}$ is only required for WEAT. For instance, the study of gender stereotypes in academic pursuits by @caliskan:2017:S used $\mathcal{S} = \{math, algebra, geometry, calculus, equations, ...\}$ and $\mathcal{T}= \{poetry, art, dance, literature, novel, ...\}$.

Attribute words are words that have known properties in relation to the bias. They are denoted as wordsets $\mathcal{A}$ and $\mathcal{B}$. All methods require both wordsets except Mean Average Cosine Similarity [@manzini2019black]. For instance, the study of gender stereotypes by @caliskan:2017:S used $\mathcal{A} = \{he, son, his, him, ...\}$ and $\mathcal{B} = \{she, daughter, hers, her, ...\}$. In some applications, popular off-the-shelf sentiment dictionaries can also be used as $\mathcal{A}$ and $\mathcal{B}$ [e.g. @sweeney2020reducing]. That being said, it is up to the researchers to select and derive these seed words in a query. However, the selection of seed words has been shown to be the most consequential part of the entire analysis [@antoniak2021bad;@du2021assessing]. Please read @antoniak2021bad for recommendations.

## Supported methods

Table 1 lists all methods supported by sweater. The function `query` is used to conduct a query. The function `calculate_es` can be used for some methods to calculate the effect size representing the overall bias of $w$ from the query.

Table: All methods supported by sweater

| Method                                                  | Target words                 | Attribute words              |
|---------------------------------------------------------|------------------------------|------------------------------|
| Mean Average Cosine Similarity [@manzini2019black]      | $\mathcal{S}$                | $\mathcal{A}$                |
| Relative Norm Distance [@garg:2018:W]                   | $\mathcal{S}$                | $\mathcal{A}$, $\mathcal{B}$ |
| Relative Negative Sentiment Bias [@sweeney2020reducing] | $\mathcal{S}$                | $\mathcal{A}$, $\mathcal{B}$ |
| SemAxis [@an2018semaxis]                                | $\mathcal{S}$                | $\mathcal{A}$, $\mathcal{B}$ |
| Normalized Association Score [@caliskan:2017:S]         | $\mathcal{S}$                | $\mathcal{A}$, $\mathcal{B}$ |
| Embedding Coherence Test [@dev2019attenuating]          | $\mathcal{S}$                | $\mathcal{A}$, $\mathcal{B}$ |
| Word Embedding Association Test [@caliskan:2017:S]      | $\mathcal{S}$, $\mathcal{T}$ | $\mathcal{A}$, $\mathcal{B}$ |

## Example 1

Relative Norm Distance (RND) [@garg:2018:W] is calculated with two sets of attribute words. The following analysis reproduces the calculation of "women bias" values in @garg:2018:W. The publicly available word2vec word embeddings trained on the Google News corpus is used [@mikolov2013distributed]. Words such as "nurse", "midwife" and "librarian" are more associated with female, as indicated by the positive relative norm distance (Figure 1).


```r
library(sweater)
data(googlenews)
S1 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer",
       "photographer", "geologist", "shoemaker", "athlete", "cashier",
       "dancer", "housekeeper", "accountant", "physicist", "gardener",
       "dentist", "weaver", "blacksmith", "psychologist", "supervisor",
       "mathematician", "surveyor", "tailor", "designer", "economist",
       "mechanic", "laborer", "postmaster", "broker", "chemist",
       "librarian", "attendant", "clerical", "musician", "porter",
       "scientist", "carpenter", "sailor", "instructor", "sheriff",
       "pilot", "inspector", "mason", "baker", "administrator",
       "architect", "collector", "operator", "surgeon", "driver",
       "painter", "conductor", "nurse", "cook", "engineer", "retired",
       "sales", "lawyer", "clergy", "physician", "farmer", "clerk",
       "manager", "guard", "artist", "smith", "official", "police",
       "doctor", "professor", "student", "judge", "teacher", "author",
       "secretary", "soldier")
A1 <- c("he", "son", "his", "him", "father", "man", "boy", "himself",
        "male", "brother", "sons", "fathers", "men", "boys", "males",
        "brothers", "uncle", "uncles", "nephew", "nephews")
B1 <- c("she", "daughter", "hers", "her", "mother", "woman", "girl",
       "herself", "female", "sister", "daughters", "mothers", "women",
       "girls", "females", "sisters", "aunt", "aunts", "niece", "nieces")
res_rnd_male <- query(w = googlenews, S_words = S1,
                      A_words = A1, B_words= B1,
                      method = "rnd")
plot(res_rnd_male)
```

![Bias of words in the target wordset according to relative norm distance](paper_files/figure-latex/rnd-1.pdf) 

## Example 2

Word Embedding Association Test (WEAT) [@caliskan:2017:S] requires all four wordsets of $\mathcal{S}$, $\mathcal{T}$, $\mathcal{A}$, and $\mathcal{B}$. The method is modeled after the Implicit Association Test (IAT) [@nosek:2005:UUI] and it measures the relative strength of $\mathcal{S}$'s association with $\mathcal{A}$ to $\mathcal{B}$ against the same of $\mathcal{T}$. The effect sizes calculated from a large corpus, as shown by @caliskan:2017:S, are comparable to the published IAT effect sizes obtained from volunteers.

In this example, the publicly available GLoVE embeddings made available by the original Stanford Team [@pennington:2014:G] were used. In the following example, the calculation of "Math. vs Arts" gender bias in @caliskan:2017:S is reproduced. In this example, the positive effect size indicates the words in the wordset $\mathcal{S}$ are more associated with males than $\mathcal{T}$ associated with males.


```r
data(glove_math) # a subset of the original GLoVE word vectors
S2 <- c("math", "algebra", "geometry", "calculus", "equations",
        "computation", "numbers", "addition")
T2 <- c("poetry", "art", "dance", "literature", "novel", "symphony",
        "drama", "sculpture")
A2 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B2 <- c("female", "woman", "girl", "sister", "she", "her", "hers",
        "daughter")
sw <- query(w = glove_math,
            S_words = S2, T_words = T2,
            A_words = A2, B_words = B2)
sw
```

```
## 
```

```
## -- sweater object --------------------------------------------------------------
```

```
## Test type:  weat 
## Effect size:  1.055015
```

```
## 
```

```
## -- Functions -------------------------------------------------------------------
```

```
## * `calculate_es()`: Calculate effect size
```

```
## * `weat_resampling()`: Conduct statistical test
```

The statistical significance of the effect size can be evaluated using the function `weat_resampling`.


```r
weat_resampling(sw)
```

```
## 
## 	Resampling approximation of the exact test in Caliskan et al. (2017)
## 
## data:  sw
## bias = 0.024865, p-value = 0.0171
## alternative hypothesis: true bias is greater than 7.245425e-05
## sample estimates:
##       bias 
## 0.02486533
```

# Acknowledgements

The development of this package was supported by the Federal Ministry for Family Affairs, Senior Citizens, Women and Youth (*Bundesministerium für Familie, Senioren, Frauen und Jugend*), the Federal Republic of Germany -- Research project: "*Erfahrungen von Alltagsrassismus und medienvermittelter Rassismus in der (politischen) Öffentlichkeit*".

# References
