#' Speedy Word Embedding Association Test
#'
#' This functions test the potential bias in a set of word embeddings using the method by Caliskan et al (2017).
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of the first set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists...
#' @param T a character vector of the second set of target words. In an example of studying gender stereotype, it can include occupations such as nurse, teacher, librarian...
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @param B a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.
#' @return a sweater object
#' @examples
#' # Reproduce the number in Caliskan et al. (2017) - Table 1, "Math vs. Arts"
#' data(glove_math)
#' S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
#' T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
#' A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
#' B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
#' sw <- sweater(glove_math, S, T, A, B)
#' sweater_es(sw)
#' @author Chung-hong Chan
#' @references
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186.
#' @export 
weat <- function(w, S, T, A, B) {
    S_diff <- cpp_bweat(S, A, B, w)
    T_diff <- cpp_bweat(T, A, B, w)
    res <- list(S_diff = S_diff, T_diff = T_diff, S = S, T = T, A = A, B = B)
    class(res) <- "sweater"
    return(res)
}

#' Calculation of effect size
#'
#' This function calculates the effect size from a sweater object. The original implementation in Caliskan et al. (2017) assumes the numbers of words in S and in T must be equal. The current implementation eases this assumption by adjusting the variance with the difference in sample sizes. It is also possible to convert the Cohen's d to Pearson's correlation coefficient (r).
#' @param standardize a boolean to denote whether to correct the difference by the standard division. The standardized version can be interpreted the same way as Cohen's d.
#' @param r a boolean to denote whether convert the effect size to Pearson's correlation coefficient.
#' @export
weat_es <- function(sweater_obj, standardize = TRUE, r = FALSE) {
    S_diff <- sweater_obj$S_diff
    T_diff <- sweater_obj$T_diff
    n1 <- length(S_diff)
    n2 <- length(T_diff)
    total <- n1 + n2
    if (!standardize) {
        return(mean(S_diff) - mean(T_diff))
    }
    if (n1 == n2) {
        pooled_sd <- sd(c(S_diff, T_diff))
    } else {
        S_var <- var(S_diff)
        T_var <- var(T_diff)
        pooled_sd <- sqrt(((n1 -1) * S_var) + ((n2 - 1) * T_var)/(n1 + n2 + 2))
    }
    es <- ((mean(S_diff) - mean(T_diff)) / pooled_sd)
    if (r) {
        es <- es / sqrt(es^2 + ((total^2 - 2 * total)/ (n1 * n2)))
    }
    return(es)
}

#' @export
weat_exact <- function(sweater_obj) {
    S_diff <- sweater_obj$S_diff
    T_diff <- sweater_obj$T_diff
    if (length(c(S_diff, T_diff)) > 10) {
        warning("Exact test would take a long time. Use sweater_resampling or sweater_boot (to be implemented) instead.")
    }
    p_value <- .exact_test(S_diff, T_diff)
    return(p_value)
}

#' @export
weat_resampling <- function(sweater_obj, n_resampling = 9999) {
    S_diff <- sweater_obj$S_diff
    T_diff <- sweater_obj$T_diff
    union_diff <- c(S_diff, T_diff)
    labels <- c(rep(TRUE, length(S_diff)), rep(FALSE, length(T_diff)))
    st_diff <- rep(NA, n_resampling)
    test_stat <- (mean(S_diff) - mean(T_diff))
    attr(test_stat, "names") <- "bias"
    for (i in seq_len(n_resampling)) {
        z <- sample(labels)
        st_diff[i] <- (mean(union_diff[z]) - mean(union_diff[!z]))
    }
    n_alter <- sum(st_diff > test_stat)
    p <- n_alter / n_resampling
    null_value <- mean(st_diff)
    attr(null_value, "names") <- "bias"
    para <- null_value
    attr(null_value, "names") <- "bias"
    res <- list(null.value = null_value, alternative = "greater", method = "Resampling approximation of the exact test in Caliskan et al. (2017)", estimate = test_stat, data.name = deparse(substitute(sweater_obj)), statistic = test_stat, p.value = p)
    class(res) <- "htest"
    return(res)
}

#' A subset of the pretrained GLoVE word vectors
#'
#' This is a subset of the original pretrained GLoVE word vectors provided by Pennington et al (2017). The same word vectors were used in Caliskan et al. (2017) to study biases.
#' @references
#' Pennington, J., Socher, R., & Manning, C. D. (2014, October). Glove: Global vectors for word representation. In Proceedings of the 2014 conference on empirical methods in natural language processing (EMNLP) (pp. 1532-1543).
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186.
"glove_math"
