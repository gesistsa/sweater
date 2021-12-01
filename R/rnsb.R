#' Relative Negative Sentiment Bias
#'
#' This function estimate the Relative Negative Sentiment Bias (RNSB) of word embeddings (Sweeney & Najafian, 2019).
#'
#' @inheritParams weat
#' @param levels levels of entries in a hierarchical dictionary that will be applied (see quanteda::dfm_lookup)
#' @return A list with class \code{"rnsb"} containing the following components:
#' \describe{
#' \item{\code{$classifer}}{ a logistic regression model with L2 regularization trained with LiblineaR}
#' \item{\code{$A_words}}{the input A_words}
#' \item{\code{$B_words}}{the input B_words}
#' \item{\code{$S_words}}{the input S_words}
#' \item{\code{$P}}{the predicted negative sentiment probabilities}
#' }
#' \code{\link{rnsb_es}} can be used to obtain the effect size of the test.
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
#' garg_f1 <- rnsb(googlenews, S1, A1, B1)
#' plot_bias(garg_f1)
#' @author Chung-hong Chan
#' @references
#' Sweeney, C., & Najafian, M. (2019, July). A transparent framework for evaluating unintended demographic bias in word embeddings. In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
#' @export
rnsb <- function(w, S_words, A_words, B_words, levels = 1, verbose = FALSE) {
    ## Cleaning
    w_lab <- rownames(w)
    A_cleaned <- .clean(A_words, w_lab, verbose = verbose)
    B_cleaned <- .clean(B_words, w_lab, verbose = verbose)
    feature_matrix <- w[w_lab %in% c(A_cleaned, B_cleaned),,drop = FALSE]
    colnames(feature_matrix) <- paste("f", seq_len(ncol(feature_matrix)), sep = "")
    label <- as.numeric(rownames(feature_matrix) %in% B_cleaned)
    classifier <- LiblineaR::LiblineaR(data = feature_matrix, target = label, type = 0, epsilon = 1e-4)
    if ("dictionary2" %in% class(S_words)) {
        flist <- quanteda::as.list(S_words, levels = levels, flatten = TRUE)
        flist_regex <- purrr::map_chr(flist, .convert_globs)
        flist_words <- purrr::map(flist_regex, .find_words, input_words = rownames(w))
        flist_probs <- purrr::map(flist_words, .words_pred, w = w, classifier = classifier)
        f_star <- purrr::map_dbl(flist_probs, mean)
        S_cleaned <- S_words
    } else {
        ## Cleaning
        S_cleaned <- .clean(S_words, w_lab, verbose = verbose)
        newdata <- w[S_cleaned,,drop = FALSE]
        colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")
        f_star <- predict(classifier, newdata, proba = TRUE)$probabilities[,2]
        names(f_star) <- S_cleaned
    }
    P <- f_star / sum(f_star, na.rm = TRUE)
    res <- list(classifier = classifier, A_words = A_cleaned, B = B_cleaned, S = S_cleaned, P = P)
    class(res) <- append(c("sweater", "rnsb"), class(res))
    return(res)
}

#' Calculation the Kullback-Leibler divergence
#'
#' This function calculates the Kullback-Leibler divergence of the predicted negative probabilities, P, from the uniform distribution.
#' @param x an rnsb object from the \link{rnsb} function.
#' @return the Kullback-Leibler divergence.
#' @author Chung-hong Chan
#' @references
#' Sweeney, C., & Najafian, M. (2019, July). A transparent framework for evaluating unintended demographic bias in word embeddings. In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
#' @export
rnsb_es <- function(x) {
    if (!"rnsb" %in% class(x)) {
        stop("x is not created with rnsb().", call. = FALSE)
    }
    PP <- stats::na.omit(x$P)
    PQ <- 1 / length(PP)
    kl <- sum(PP * log(PP/PQ))
    return(kl)
}

## plot_rnsbs <- function(rnsb1, rnsb2, rnsb1_label = "rnsb1", rnsb2_label = "rnsb2") {
##     groupnames <- c(names(rnsb1$P), names(rnsb2$P)) 
##     values <- c(rnsb1$P, rnsb2$P)
##     labels <- c(rep(rnsb1_label, length(rnsb1$P)), rep(rnsb2_label, length(rnsb2$P)))
##     diff <- values - c(rnsb1$P, rnsb1$P)
##     equality <- 1.0 / length(stats::na.omit(rnsb1$P))
##     data_to_plot <- data.frame(labels, groupnames, values, diff)
##     data_to_plot <- data_to_plot[!is.na(data_to_plot$values)]
##     ggplot2::ggplot(data_to_plot, ggplot2::aes(x = forcats::fct_reorder(groupnames, diff), y = values, fill = labels)) + ggplot2::geom_bar(stat = "identity", position=ggplot2::position_dodge()) + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1)) + ggplot2::xlab("S") + ggplot2::ylab("P") + ggplot2::geom_hline(yintercept = equality, lty = 2, color = "darkgray") + ggplot2::coord_flip()
## }

