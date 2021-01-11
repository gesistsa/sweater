## relative norm distance

.get_dist <- function(word, vec, w) {
    dist(rbind(w[word,], vec), method = "euclidean")[1]
}

#' Relative Norm Distance
#'
#' This function calculate the relative norm distance (RND) of word embeddings.
#' 
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of a set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists.
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @param B a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.
#' @return A list with class \code{"rnd"} containing the following components:
#' \describe{
#' \item{\code{$norm_diff}}{a vector of relative norm distances for every word in S}
#' \item{\code{$S}}{the input S}
#' \item{\code{$A}}{the input A}
#' \item{\code{$B}}{the input B}
#' }
#' \code{\link{rnd_es}} can be used to obtain the effect size of the test.
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

#' Calculation of sum of all relative norm distances
#'
#' This function calculates the sum of all relative norm distances from the relative norm distance test.
#' @param rnd an object from the function \link{rnd}
#' @return Sum of all relative norm distances
#' @export
rnd_es <- function(rnd) {
    return(sum(rnd$P))
}
