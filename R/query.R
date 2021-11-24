.guess <- function(w, S_words, T_words, A_words, B_words, method = "guess", verbose = FALSE) {
    if (missing(w)) {
        stop("w must be provided.")
    }
    if (missing(S_words) | missing(A_words)) {
        stop("S_words and A_words must be provided.")
    }
    if (!method %in% c("guess", "weat", "mac", "nas", "semaxis", "rnsb", "rnd", "ect")) {
        stop("Unkonwn method. Available methods are: guess, weat, mac, nas, semaxis, rnsb, rnd, ect.")
    }
    if (method == "guess") {
        if (missing(T_words) & missing(B_words)) {
            method <- "mac"
        } else if (missing(T_words)) {
            if (verbose) {
                cat("Multiple guesses available, default to rnd.\n")
            }
            method <- "rnd"
        } else {
            method <- "weat"
        }
    }
    return(method)
}

#' A common interface for making query
#'
#' This function makes a query based on the supplied parameters.
#' @param ... additional parameters for the underlying function
#' @param method string, the method to be used to make the query. Available options are: `weat`, `mac`, `nas`, `semaxis`, `rnsb`, `rnd`, `nas`, `ect` and `guess`. If `guess`, the function selects the best option for you. 
#' @inheritParams weat
#' @return a sweater S3 object
#' @seealso [weat()], [mac()], [nas()], [semaxis()], [rnsb()], [rnd()], [nas()], [ect()]
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
#' garg_f1 <- query(googlenews, S_words = S1, A_words = A1, B_words = B1)
#' plot_bias(garg_f1)
#' @export
query <- function(w, S_words, T_words, A_words, B_words, method = "guess", verbose = FALSE, ...) {
    method <- .guess(w = w, S_words= S_words, T_words= T_words,
                     A_words = A_words, B_words= B_words, method = method,
                     verbose = verbose)
    switch(method,
           "weat" = weat(w = w, S_words= S_words, T_words = T_words, A_words = A_words, B_words = B_words, verbose = verbose),
           "mac" = mac(w = w, S_words = S_words, A_words = A_words, verbose = verbose),
           "nas" = nas(w = w, S_words = S_words, A_words = A_words, B_words = B_words, verbose = verbose),
           "semaxis" = semaxis(w = w, S_words = S_words, A_words = A_words, B_words = B_words, verbose = verbose, ...),
           "rnsb" = rnsb(w = w, S_words = S_words, A_words = A_words, B_words = B_words, verbose = verbose, ...),
           "rnd" = rnd(w = w, S_words = S_words, A_words = A_words, B_words = B_words, verbose = verbose),
           "ect" = ect(w = w, S_words = S_words, A_words = A_words, B_words = B_words, verbose = verbose)
           )
}
