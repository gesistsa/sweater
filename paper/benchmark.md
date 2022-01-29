
## Benchmark

This is a version of WEAT written entirely in R.

``` r
require(purrr)
```

    ## Loading required package: purrr

``` r
require(lsa)
```

    ## Loading required package: lsa

    ## Loading required package: SnowballC

``` r
take <- function(word, w) {
    return(as.vector(w[word, , drop = FALSE]))
}

get_x <- function(w, words) {
    purrr::map(words, take, w = w)
}

g <- function(c, A, B, w) {
    A_emb <- get_x(w, A)
    B_emb <- get_x(w, B)
    c_emb <- get_x(w, c)[[1]]
    a_cos_diff <- mean(purrr::map_dbl(A_emb, ~cosine(., c_emb)))
    b_cos_diff <- mean(purrr::map_dbl(B_emb, ~cosine(., c_emb)))
    return(a_cos_diff - b_cos_diff)
}

.clean <- function(x, w_lab, verbose = FALSE) {
    new_x <- intersect(x, w_lab)
    if (length(new_x) < length(x) & verbose) {
        print("Some word(s) are not available in w.")
    }
    return(new_x)
}


r_weat <- function(w, S, T, A, B, verbose = FALSE) {
    w_lab <- rownames(w)
    A <- .clean(A, w_lab, verbose = verbose)
    B <- .clean(B, w_lab, verbose = verbose)
    S <- .clean(S, w_lab, verbose = verbose)
    T <- .clean(T, w_lab, verbose = verbose)
    S_diff <- purrr::map_dbl(S, g, A, B, w)
    T_diff <- purrr::map_dbl(T, g, A, B, w)
    ## union_diff <- purrr::map_dbl(union(S, T), g, A, B, w)
    return((mean(S_diff) - mean(T_diff)) / sd(c(S_diff, T_diff)))
}
require(compiler)
```

    ## Loading required package: compiler

``` r
r_weat_c <- cmpfun(r_weat)
```

## The Calikskan et al. example.

``` r
require(sweater)
```

    ## Loading required package: sweater

    ## 
    ## Attaching package: 'sweater'

    ## The following object is masked from 'package:lsa':
    ## 
    ##     query

``` r
S2 <- c("math", "algebra", "geometry", "calculus", "equations",
        "computation", "numbers", "addition")
T2 <- c("poetry", "art", "dance", "literature", "novel", "symphony",
        "drama", "sculpture")
A2 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B2 <- c("female", "woman", "girl", "sister", "she", "her", "hers",
        "daughter")
r_weat(glove_math, S2, T2, A2, B2)
```

    ## [1] 1.055015

``` r
r_weat_c(glove_math, S2, T2, A2, B2)
```

    ## [1] 1.055015

The same implementation in C++ from `sweater`

``` r
calculate_es(query(glove_math, S2, T2, A2, B2))
```

    ## [1] 1.055015

``` r
cpp_weat <- function(w, S, T, A, B) {
    calculate_es(query(w, S, T, A, B))
}
```

The C++ implementation in `sweater` is \>10x faster. Byte-code
compilation (`r_weat_c`) can bring about almost no little improvement.

``` r
require(bench)
```

    ## Loading required package: bench

``` r
benchmark_res <- bench::mark(
                            r_weat(glove_math, S2, T2, A2, B2),
                            r_weat_c(glove_math, S2, T2, A2, B2),
                            cpp_weat(glove_math, S2, T2, A2, B2),
                            relative = TRUE)
benchmark_res
```

    ## # A tibble: 3 × 6
    ##   expression                             min median `itr/sec` mem_alloc `gc/sec`
    ##   <bch:expr>                           <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
    ## 1 r_weat(glove_math, S2, T2, A2, B2)    12.0   11.4      1.04      2.35     1   
    ## 2 r_weat_c(glove_math, S2, T2, A2, B2)  12.2   11.7      1         2.35     1.02
    ## 3 cpp_weat(glove_math, S2, T2, A2, B2)   1      1       10.6       1        1.89

### Random benchmark

In this benchmark, we test how the lengths of S/T/A/B affect the
performance. `sweater` is at least 7x faster.

``` r
set.seed(12121)
stab_length <- seq(10, 100, 10)
r_bench <- function(stab_n) {
    w_lab <- rownames(googlenews)
    S <- sample(w_lab, stab_n)
    T <- sample(w_lab, stab_n)
    A <- sample(w_lab, stab_n)
    B <- sample(w_lab, stab_n)
    bench::mark(r_weat(googlenews, S, T, A, B),
                r_weat_c(googlenews, S, T, A, B),
                cpp_weat(googlenews, S, T, A, B),
                relative = TRUE)
}

res <- map(stab_length, r_bench)
```

    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.
    
    ## Warning: Some expressions had a GC in every iteration; so filtering is disabled.

``` r
res %>% map_dfr(~.[1,3]) %>% dplyr::mutate(stab_length = stab_length)
```

    ## # A tibble: 10 × 2
    ##    median stab_length
    ##     <dbl>       <dbl>
    ##  1  10.7           10
    ##  2  10.7           20
    ##  3  10.0           30
    ##  4  12.9           40
    ##  5  10.6           50
    ##  6   8.77          60
    ##  7   8.89          70
    ##  8   9.03          80
    ##  9   9.21          90
    ## 10   8.64         100
