## relative norm distance

.get_dist <- function(word, vec, w) {
    dist(rbind(w[word,], vec), method = "euclidean")[1]
}

#' Relative Norm Distance
#'
#' This function calculate the relative norm distance (RND) of word embeddings.
#' 
#' @inheritParams weat
#' @return A list with class \code{"rnd"} containing the following components:
#' \describe{
#' \item{\code{$norm_diff}}{a vector of relative norm distances for every word in S}
#' \item{\code{$S}}{the input S}
#' \item{\code{$A}}{the input A}
#' \item{\code{$B}}{the input B}
#' }
#' \code{\link{rnd_es}} can be used to obtain the effect size of the test.
#' @examples
#' data(googlenews)
#' S <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", "photographer", "geologist", "shoemaker", "athlete", "cashier", "dancer", "housekeeper", "accountant", "physicist", "gardener", "dentist", "weaver", "blacksmith", "psychologist", "supervisor", "mathematician", "surveyor", "tailor", "designer", "economist", "mechanic", "laborer", "postmaster", "broker", "chemist", "librarian", "attendant", "clerical", "musician", "porter", "scientist", "carpenter", "sailor", "instructor", "sheriff", "pilot", "inspector", "mason", "baker", "administrator", "architect", "collector", "operator", "surgeon", "driver", "painter", "conductor", "nurse", "cook", "engineer", "retired", "sales", "lawyer", "clergy", "physician", "farmer", "clerk", "manager", "guard", "artist", "smith", "official", "police", "doctor", "professor", "student", "judge", "teacher", "author", "secretary", "soldier")
#' A <- c("he", "son", "his", "him", "father", "man", "boy", "himself", "male", "brother", "sons", "fathers", "men", "boys", "males", "brothers", "uncle", "uncles", "nephew", "nephews")
#' B <- c("she", "daughter", "hers", "her", "mother", "woman", "girl",  "herself", "female", "sister", "daughters", "mothers", "women", "girls", "females", "sisters", "aunt", "aunts", "niece", "nieces")
#' garg_f1 <- rnd(googlenews, S, A, B)
#' sort(garg_f1$P)
#' @export
rnd <- function(w, S, A, B, verbose = FALSE) {
    ## Cleaning
    w_lab <- rownames(w)
    A <- .clean(A, w_lab, verbose = verbose)
    B <- .clean(B, w_lab, verbose = verbose)
    S <- .clean(S, w_lab, verbose = verbose)
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
#' @param x an object from the function \link{rnd}
#' @return Sum of all relative norm distances
#' @export
rnd_es <- function(x) {
    if (!"rnd" %in% class(x)) {
        stop("x is not created with rnd().", call. = FALSE)
    }
    return(sum(x$P))
}
