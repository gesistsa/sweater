## relative norm distance

.get_dist <- function(word, vec, w) {
    dist(rbind(w[word,], vec), method = "euclidean")[1]
}

#' @export
rnd <- function(w, S, A, B) {
    v1 <- purrr::map_dbl(purrr::array_branch(w[A,], 2), mean)
    v2 <- purrr::map_dbl(purrr::array_branch(w[B,], 2), mean)
    norm_a <- purrr::map_dbl(S, .get_dist, v1, w)
    norm_b <- purrr::map_dbl(S, .get_dist, v2, w)
    norm_diff <- norm_a - norm_b
    names(norm_diff) <- S
    res <- list(P = norm_diff, S = S, A = A, B = B)
    class(res) <- append(class(res), "rnd")
    return(res)
}

#' @export
rnd_es <- function(rnd) {
    return(sum(rnd$P))
}
