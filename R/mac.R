#' Mean average cosine similarity
#'
#' This function calculates the mean average cosine similarity (MAC) score proposed in Manzini et al (2019). If possible, please use [query()] instead.
#'
#' @inheritParams weat
#' @return A list with class \code{"mac"} containing the following components:
#' \describe{
#' \item{\code{$P}}{a vector of cosine similarity values for every word in S_words}
#' \item{\code{$S_words}}{the input S_words}
#' \item{\code{$A_words}}{the input A_words}
#' }
#' \code{\link{mac_es}} can be used to obtain the effect size of the test.
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
#' "official", "police", "doctor", "professor", "student", "judge", "teacher",
#' "author", "secretary", "soldier")
#' A1 <- c("he", "son", "his", "him", "father", "man", "boy", "himself",
#' "male", "brother", "sons", "fathers", "men", "boys", "males", "brothers",
#' "uncle", "uncles", "nephew", "nephews")
#' x <- mac(googlenews, S1, A1)
#' x$P
#' @export
#' @references
#' Manzini, T., Lim, Y. C., Tsvetkov, Y., & Black, A. W. (2019). [Black is to criminal as caucasian is to police: Detecting and removing multiclass bias in word embeddings.](https://arxiv.org/abs/1904.04047) arXiv preprint arXiv:1904.04047.
mac <- function(w, S_words, A_words, verbose = FALSE) {
    ## Cleaning
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
    mac_dist <- cpp_mac(S_cleaned, A_cleaned, w)
    names(mac_dist) <- S_cleaned
    res <- list(P = mac_dist, S_words = S_cleaned, A_words = A_cleaned)
    class(res) <- append(c("sweater", "mac"), class(res))
    return(res)
}

#' Calculation of MAC Effect Size
#'
#' This function calculates the mean of cosine distance values. If possible, please use [calculate_es()] instead.
#' 
#' @param x an object from the function \link{mac}
#' @return Mean of all cosine similarity values
#' @author Chung-hong Chan
#' @export
#' @references
#' Manzini, T., Lim, Y. C., Tsvetkov, Y., & Black, A. W. (2019). [Black is to criminal as caucasian is to police: Detecting and removing multiclass bias in word embeddings.](https://arxiv.org/abs/1904.04047) arXiv preprint arXiv:1904.04047.
mac_es <- function(x) {
    if (!"mac" %in% class(x)) {
        stop("x is not created with mac().", call. = FALSE)
    }
    return(mean(x$P))
}
