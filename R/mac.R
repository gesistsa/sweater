#' Mean average cosine similarity
#'
#' This function calculates the mean average cosine similarity (MAC) score proposed in Manzini et al (2019).
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of a set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists.
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @return A list with class \code{"rnd"} containing the following components:
#' \describe{
#' \item{\code{$P}}{a vector of cosine similarity values for every word in S}
#' \item{\code{$S}}{the input S}
#' \item{\code{$A}}{the input A}
#' }
#' \code{\link{mac_es}} can be used to obtain the effect size of the test.
#' @examples
#' data(googlenews)
#' S <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", "photographer", "geologist", "shoemaker", "athlete", "cashier", "dancer", "housekeeper", "accountant", "physicist", "gardener", "dentist", "weaver", "blacksmith", "psychologist", "supervisor", "mathematician", "surveyor", "tailor", "designer", "economist", "mechanic", "laborer", "postmaster", "broker", "chemist", "librarian", "attendant", "clerical", "musician", "porter", "scientist", "carpenter", "sailor", "instructor", "sheriff", "pilot", "inspector", "mason", "baker", "administrator", "architect", "collector", "operator", "surgeon", "driver", "painter", "conductor", "nurse", "cook", "engineer", "retired", "sales", "lawyer", "clergy", "physician", "farmer", "clerk", "manager", "guard", "artist", "smith", "official", "police", "doctor", "professor", "student", "judge", "teacher", "author", "secretary", "soldier")
#' A <- c("he", "son", "his", "him", "father", "man", "boy", "himself", "male", "brother", "sons", "fathers", "men", "boys", "males", "brothers", "uncle", "uncles", "nephew", "nephews")
#' x <- mac(googlenews, S, A)
#' x$P
#' @export
mac <- function(w, S, A) {
    available_terms <- rownames(w)
    S <- intersect(S, available_terms)
    A <- intersect(A, available_terms)
    mac_dist <- cpp_mac(S, A, w)
    names(mac_dist) <- S
    res <- list(P = mac_dist, S = S, A = A)
    class(res) <- "mac"
    return(res)
}

#' Calculation of MAC
#'
#' This function calculates the mean of cosine distance values
#' 
#' @param x an object from the function \link{mac}
#' @return Mean of all cosine similarity values
#' @export
#' @export
mac_es <- function(x) {
    if (!"mac" %in% class(x)) {
        stop("x is not created with mac().", call. = FALSE)
    }
    return(mean(x$P))
}
