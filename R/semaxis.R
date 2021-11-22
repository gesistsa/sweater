.soften <- function(word, w, l = 3, return_k = FALSE) {
    if (l == 0) {
        return(w[word, , drop = TRUE])
    } 
    sim_res <- proxy::simil(y = w[word, , drop = FALSE], x = w, method = "cosine")
    goodk <- head(sort(sim_res[,1], decreasing = TRUE), l + 1)
    if (return_k) {
        return(goodk)
    }
    apply(w[names(goodk), ], 2, mean, na.rm = TRUE)
}

#' Characterise word semantics using the SemAxis framework
#'
#' This function calculates the axis and the score using the SemAxis framework proposed in An et al (2018).
#'
#' @inheritParams weat
#' @param l an integer indicates the number of words to augment each word in A and B based on cosine , see An et al (2018). Default to 0 (no augmentation).
#' @return A list with class \code{"semaxis"} containing the following components:
#' \describe{
#' \item{\code{$P}}{for each of words in S, the score according to SemAxis}
#' \item{\code{$V}}{the semantic axis vector}
#' \item{\code{$S_words}}{the input S_words}
#' \item{\code{$A_words}}{the input A_words}
#' \item{\code{$B_words}}{the input B_words}
#' }
#' @examples
#' data(glove_math)
#' S1 <- c("math", "algebra", "geometry", "calculus", "equations",
#' "computation", "numbers", "addition")
#' A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
#' B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
#' semaxis(glove_math, S1, A1, B1, l = 0)$P
#' @author Chung-hong Chan
#' @references
#' An, J., Kwak, H., & Ahn, Y. Y. (2018). SemAxis: A lightweight framework to characterize domain-specific word semantics beyond sentiment. arXiv preprint arXiv:1806.05521.
#' @export
semaxis <- function(w, S_words, A_words, B_words, l = 0, verbose = FALSE) {
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    B_cleaned <- .clean(B_words, w_lab, verbose = verbose)
    S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
    w_dim <- ncol(w)
    V_a <- vapply(A_cleaned, function(x) .soften(x, w, l), numeric(w_dim))
    V_b <- vapply(B_cleaned, function(x) .soften(x, w, l), numeric(w_dim))
    axis <- apply(V_a, 1, mean, na.rm = TRUE) - apply(V_b, 1, mean, na.rm = TRUE)
    score <- purrr::map_dbl(S_cleaned, ~ raw_cosine(w[.,,drop = FALSE], axis))
    names(score) <- S_cleaned
    res <- list(P = score, S_words = S_cleaned, A_words = A_cleaned, B_words = B_cleaned, V = axis)
    class(res) <- append(class(res), c("semaxis", "sweater"))
    return(res)
}


#' A subset of the pretrained word2vec word vectors on Reddit
#'
#' This is a subset of the pretrained word2vec word vectors on Reddit provided by An et al. (2018). With this dataset, you can try with the "l" parameter of [semaxis()] up to 10.
#' 
#' @references
#' An, J., Kwak, H., & Ahn, Y. Y. (2018). SemAxis: A lightweight framework to characterize domain-specific word semantics beyond sentiment. arXiv preprint arXiv:1806.05521.
"small_reddit"
