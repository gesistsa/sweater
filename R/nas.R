.cal_nas <- function(s, w, A, B) {
    nas_dist_A <- cpp_nas(s, A, w)
    nas_dist_B <- cpp_nas(s, B, w)
    names(nas_dist_A) <- A
    names(nas_dist_B) <- B
    res <- list(s = s, nas_dist_A = nas_dist_A, nas_dist_B = nas_dist_B)
    return(res)
}

.cal_nas_p <- function(x) {
    p <- (mean(x$nas_dist_A) - mean(x$nas_dist_B)) / sd(c(x$nas_dist_A, x$nas_dist_B))
    return(p)
}

#' Calculate Normalized Association Score
#'
#' This functions quantifies the bias in a set of word embeddings by Caliskan et al (2017). In comparison to WEAT introduced in the same paper, this method is more suitable for continuous ground truth data. See Figure 1 and Figure 2 of the original paper.
#' @inheritParams weat
#' @author Chung-hong Chan
#' @return A list with class \code{"nas"} containing the following components:
#' \describe{
#' \item{\code{$P}}{a vector of normalized association score for every word in S}
#' \item{\code{$raw}}{a list of raw results used for calculating normalized association scores}
#' \item{\code{$S_words}}{the input S_words}
#' \item{\code{$A_words}}{the input A_words}
#' \item{\code{$B_words}}{the input B_words}
#' }
#' @export
#' @references
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186. \doi{10.1126/science.aal4230}
nas <- function(w, S_words, A_words, B_words, verbose = FALSE) {
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    B_cleaned <- .clean(B_words, w_lab, verbose = verbose)
    S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
    res <- purrr::map(S_cleaned, .cal_nas, w = w, A = A_cleaned, B = B_cleaned)
    P <- purrr::map_dbl(res, .cal_nas_p)
    names(P) <- S_cleaned
    res <- list(P = P, raw = res, S_words = S_cleaned, A_words = A_cleaned, B_words = B_cleaned)
    class(res) <- append(c("sweater", "nas"), class(res))
    return(res)
}
