.guess <- function(w, S, T, A, B, method = "guess", verbose = FALSE) {
    if (missing(w)) {
        stop("w must be provided.")
    }
    if (missing(S) | missing(A)) {
        stop("S and A must be provided.")
    }
    if (!method %in% c("guess", "weat", "mac", "nas", "semaxis", "rnsb", "rnd")) {
        stop("Unkonwn method. Available methods are: guess, weat, mac, nas, semaxis, rnsb, rnd.")
    }
    if (method == "guess") {
        if (missing(T) & missing(B)) {
            method <- "mac"
        } else if (missing(T)) {
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
#' @param method string, the method to be used to make the query. Available options are: `weat`, `mac`, `nas`, `semaxis`, `rnsb`, `rnd`, `nas` and `guess`. If `guess`, the function selects the best option for you. 
#' @inheritParams weat
#' @return a sweater S3 object
#' @seealso [weat()], [mac()], [nas()], [semaxis()], [rnsb()], [rnd()], [nas()]
#' @author Chung-hong Chan
#' @examples
#' data(googlenews)
#' S <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer",
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
#' A <- c("he", "son", "his", "him", "father", "man", "boy", "himself",
#' "male", "brother", "sons", "fathers", "men", "boys", "males", "brothers",
#' "uncle", "uncles", "nephew", "nephews")
#' B <- c("she", "daughter", "hers", "her", "mother", "woman", "girl",
#' "herself", "female", "sister", "daughters", "mothers", "women", "girls",
#' "females", "sisters", "aunt", "aunts", "niece", "nieces")
#' garg_f1 <- query(googlenews, S = S, A = A, B = B)
#' plot_bias(garg_f1)
#' @export
query <- function(w, S, T, A, B, method = "guess", verbose = FALSE, ...) {
    method <- .guess(w = w, S = S, T = T,
                     A = A, B = B, method = method,
                     verbose = verbose)
    switch(method,
           "weat" = weat(w = w, S = S, T = T, A = A, B = B, verbose = verbose),
           "mac" = mac(w = w, S = S, A = A, verbose = verbose),
           "nas" = nas(w = w, S = S, A = A, B = B, verbose = verbose),
           "semaxis" = semaxis(w = w, S = S, A = A, B = B, verbose = verbose, ...),
           "rnsb" = rnsb(w = w, S = S, A = A, B = B, verbose = verbose, ...),
           "rnd" = rnd(w = w, S = S, A = A, B = B, verbose = verbose)
           )
}
