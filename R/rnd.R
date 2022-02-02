## relative norm distance

.get_dist <- function(word, vec, w) {
    dist(rbind(w[word,], vec), method = "euclidean")[1]
}

#' Relative Norm Distance
#'
#' This function calculate the relative norm distance (RND) of word embeddings. If possible, please use [query()] instead.
#' 
#' @inheritParams weat
#' @return A list with class \code{"rnd"} containing the following components:
#' \describe{
#' \item{\code{$norm_diff}}{a vector of relative norm distances for every word in S_words}
#' \item{\code{$S_words}}{the input S_words}
#' \item{\code{$A_words}}{the input A_words}
#' \item{\code{$B_words}}{the input B_words}
#' }
#' \code{\link{rnd_es}} can be used to obtain the effect size of the test.
#' @author Chung-hong Chan
#' @examples
#' data(googlenews)
#' S1 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer",
#' "photographer", "geologist", "shoemaker", "athlete", "cashier", "dancer",
#' "housekeeper", "accountant", "physicist", "gardener", "dentist", "weaver",
#' "blacksmith", "psychologist", "supervisor", "mathematician", "surveyor",
#' "tailor", "designer", "economist", "mechanic", "laborer", "postmaster",
#' "broker", "chemist", "librarian", "attendant", "clerical", "musician",
#' "porter", "scientist", "carpenter", "sailor", "instructor", "sheriff",
#' "pilot", "inspector", "mason", "baker", "administrator", "architect",
#' "collector", "operator", "surgeon", "driver", "painter", "conductor",
#' "nurse", "cook", "engineer", "retired", "sales", "lawyer", "clergy",
#' "physician", "farmer", "clerk", "manager", "guard", "artist", "smith",
#' "official", "police", "doctor", "professor", "student", "judge",
#' "teacher", "author", "secretary", "soldier")
#' A1 <- c("he", "son", "his", "him", "father", "man", "boy", "himself",
#' "male", "brother", "sons", "fathers", "men", "boys", "males", "brothers",
#' "uncle", "uncles", "nephew", "nephews")
#' B1 <- c("she", "daughter", "hers", "her", "mother", "woman", "girl",
#' "herself", "female", "sister", "daughters", "mothers", "women", "girls",
#' "females", "sisters", "aunt", "aunts", "niece", "nieces")
#' garg_f1 <- rnd(googlenews, S1, A1, B1)
#' plot_bias(garg_f1)
#' @export
#' @references
#' Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644. \doi{10.1073/pnas.1720347115}
rnd <- function(w, S_words, A_words, B_words, verbose = FALSE) {
    ## Cleaning
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    B_cleaned <- .clean(B_words, w_lab, verbose = verbose)
    S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
    v1 <- purrr::map_dbl(purrr::array_branch(w[A_cleaned,], 2), mean)
    v2 <- purrr::map_dbl(purrr::array_branch(w[B_cleaned,], 2), mean)
    norm_a <- purrr::map_dbl(S_cleaned, .get_dist, v1, w)
    norm_b <- purrr::map_dbl(S_cleaned, .get_dist, v2, w)
    norm_diff <- norm_a - norm_b
    names(norm_diff) <- S_cleaned
    res <- list(P = norm_diff, S_words = S_cleaned, A_words = A_cleaned, B_words = B_cleaned)
    class(res) <- append(c("sweater", "rnd"), class(res))
    return(res)
}

#' Calculation of sum of all relative norm distances
#'
#' This function calculates the sum of all relative norm distances from the relative norm distance test. If possible, please use [calculate_es()] instead.
#' @param x an object from the function \link{rnd}
#' @return Sum of all relative norm distances
#' @author Chung-hong Chan
#' @export
#' @references
#' Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644. \doi{10.1073/pnas.1720347115}
rnd_es <- function(x) {
    if (!"rnd" %in% class(x)) {
        stop("x is not created with rnd().", call. = FALSE)
    }
    return(sum(x$P))
}
