.soften <- function(word, w, l = 3) {
    if (l == 0) {
        return(w[word, , drop = TRUE])
    } 
    sim_res <- text2vec::sim2(x = w, y = w[word, , drop = FALSE], method = "cosine", norm = "l2")
    goodk <- head(sort(sim_res[,1], decreasing = TRUE), l + 1)
    apply(w[names(goodk), ], 2, mean, na.rm = TRUE)
}

#' Characterise word semantics using the SemAxis framework
#'
#' This function calculates the axis and the score using the SemAxis framework proposed in An et al (2018).
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of a set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists.
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @param B a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.
#' @param l an integer indicates the number of words to augment each word in A and B based on cosine , see An et al (2018). Default to 0 (no augmentation).
#' @return A list with class \code{"semaxis"} containing the following components:
#' \describe{
#' \item{\code{$P}}{for each of words in S, the score according to SemAxis}
#' \item{\code{$V}}{the semantic axis vector}
#' \item{\code{$S}}{the input S}
#' \item{\code{$A}}{the input A}
#' \item{\code{$B}}{the input B}
#' }
#' @examples
#' data(glove_math)
#' S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
#' A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
#' B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
#' semaxis(glove_math, S, A, B, l = 0)$P
#' @author Chung-hong Chan
#' @references
#' An, J., Kwak, H., & Ahn, Y. Y. (2018). SemAxis: A lightweight framework to characterize domain-specific word semantics beyond sentiment. arXiv preprint arXiv:1806.05521.
#' @export
semaxis <- function(w, S, A, B, l = 0) {
    V_a <- sapply(A, function(x) .soften(x, w, l))
    V_b <- sapply(B, function(x) .soften(x, w, l))
    axis <- apply(V_a, 1, mean, na.rm = TRUE) - apply(V_b, 1, mean, na.rm = TRUE)
    score <- purrr::map_dbl(S, ~ raw_cosine(w[.,,drop = FALSE], axis))
    names(score) <- S
    res <- list(P = score, S = S, A = A, B = B, V = axis)
    class(res) <- "semaxis"
    return(res)
}
