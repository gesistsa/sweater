.cal_diffvec <- function(a, b, w) {
    veca <- w[a, , drop = TRUE]
    vecb <- w[b, , drop = TRUE]
    diff <- veca - vecb
    diff
}

.cal_beta <- function(A_words, B_words, w) {
    diff_mat <- simplify2array(purrr::map2(A_words, B_words, .cal_diffvec, w = w))
    pca_model <- stats::prcomp(diff_mat, center = FALSE)
    beta <- predict(pca_model)[,1]
}

.cal_dot <- function(x, y) {
    sum(x * y)
}

#' @export
ripa <- function(w, S_words, A_words, B_words, verbose = FALSE) {
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    B_cleaned <- .clean(B_words, w_lab, verbose = verbose)
    S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
    beta <- .cal_beta(A_cleaned, B_cleaned, w)
    score <- purrr::map_dbl(S_cleaned, ~.cal_dot(beta, w[.,, drop = TRUE]))
    names(score) <- S_cleaned
    res <- list(P = score, S_words = S_cleaned, A_words = A_cleaned, B_words = B_cleaned)
    class(res) <- append(class(res), c("ripa", "sweater"))
    return(res)
}

