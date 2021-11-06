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
#' @return A list with class \code{"nas"} containing the following components:
#' \describe{
#' \item{\code{$P}}{a vector of normalized association score for every word in S}
#' \item{\code{$raw}}{a list of raw results used for calculating normalized association scores}
#' \item{\code{$S}}{the input S}
#' \item{\code{$A}}{the input A}
#' \item{\code{$B}}{the input B}
#' }
#' @export
nas <- function(w, S, A, B, verbose = FALSE) {
    w_lab <- rownames(w)
    A <- .clean(A, w_lab, verbose = verbose)
    B <- .clean(B, w_lab, verbose = verbose)
    S <- .clean(S, w_lab, verbose = verbose)
    res <- purrr::map(S, .cal_nas, w = w, A = A, B = B)
    P <- purrr::map_dbl(res, .cal_nas_p)
    names(P) <- S
    res <- list(P = P, raw = res, S = S, A = A, B = B)
    class(res) <- append(class(res), c("sweater", "nas"))
    return(res)
}
