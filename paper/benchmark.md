
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

### versus WEFE

The hidden gem of this package is the function `read_word2vec`. It is so
flexible and yet speedy. In the following example, we are going to
compare the typical task of the bias detection pipeline:

1.  read a pretrained word embedding file (In this case GloVE, 5.3 GB)
2.  do WEAT

`read_word2vec` is based on the C++ based function `data.table::fread`
and it can read almost all formats (word2vec, glove, fastText, etc). The
entire workflow can be finished in less than a minute.

``` bash
time Rscript bench.R
```

    ## Loading required package: sweater
    ## 
    ## ── sweater object ──────────────────────────────────────────────────────────────
    ## Test type:  weat 
    ## Effect size:  1.055015 
    ## 
    ## ── Functions ───────────────────────────────────────────────────────────────────
    ## • <calculate_es()>: Calculate effect size
    ## • <weat_resampling()>: Conduct statistical test
    ## 
    ## real 0m25.089s
    ## user 1m0.162s
    ## sys  0m6.879s

The Python workflow, however, needs to use `gensim` to read the
pretained word embedding file and it can’t read GLoVE format directly
and the file needs to first convert to word2vec \[1\]. The
`KeyedVectors.load_word2vec_format` is not written in a low-level
language and thus is many times slower than `read_word2vec`. And the
result reported is not the same as the numbers reported in Caliskan et
al.

``` bash
time python3 bench.py
```

    ## {'query_name': 'S and T wrt A and B', 'result': 0.19892264262307435, 'weat': 0.19892264262307435, 'effect_size': 1.0896144272748516, 'p_value': nan}
    ## 
    ## real 12m37.665s
    ## user 12m18.620s
    ## sys  0m19.261s

## Testing environment

``` r
sessionInfo()
```

    ## R version 4.1.2 (2021-11-01)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 20.04.3 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/atlas/libblas.so.3.10.3
    ## LAPACK: /usr/lib/x86_64-linux-gnu/atlas/liblapack.so.3.10.3
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] compiler  stats     graphics  grDevices utils     datasets  methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ## [1] bench_1.1.2     sweater_0.1.4   lsa_0.73.2      SnowballC_0.7.0
    ## [5] purrr_0.3.4    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.8       knitr_1.37       magrittr_2.0.2   tidyselect_1.1.1
    ##  [5] R6_2.5.1         rlang_1.0.0      fastmap_1.1.0    fansi_1.0.2     
    ##  [9] dplyr_1.0.7      stringr_1.4.0    tools_4.1.2      xfun_0.29       
    ## [13] utf8_1.2.2       DBI_1.1.2        cli_3.1.1        htmltools_0.5.2 
    ## [17] ellipsis_0.3.2   assertthat_0.2.1 yaml_2.2.2       digest_0.6.29   
    ## [21] tibble_3.1.6     lifecycle_1.0.1  crayon_1.4.2     vctrs_0.3.8     
    ## [25] glue_1.6.1       evaluate_0.14    rmarkdown_2.11   stringi_1.7.6   
    ## [29] pillar_1.6.5     generics_0.1.1   profmem_0.6.0    pkgconfig_2.0.3

``` bash
neofetch --stdout
```

    ## chainsawriot@mzes153 
    ## -------------------- 
    ## OS: Ubuntu 20.04.3 LTS x86_64 
    ## Host: LIFEBOOK U749 10601736746 
    ## Kernel: 5.13.0-27-generic 
    ## Uptime: 1 day, 56 mins 
    ## Packages: 2850 (dpkg), 23 (snap) 
    ## Shell: zsh 5.8 
    ## Resolution: , 1920x1080 
    ## WM: stumpwm 
    ## Theme: Yaru-dark [GTK3] 
    ## Icons: Yaru [GTK3] 
    ## Terminal: R 
    ## CPU: Intel i5-8365U (8) @ 4.100GHz 
    ## GPU: Intel UHD Graphics 620 
    ## Memory: 7806MiB / 31780MiB

-----

1.  Actually the only difference between the two format is the GLoVE
    format doesn’t record the dimensionality of the matrix in the first
    line.
