#' Relative Negative Sentiment Bias
#'
#' This function estimate the Relative Negative Sentiment Bias (RNSB) of word embeddings (Sweeney & Najafian, 2019).
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of a set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists.
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @param B a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.
#' @param levels an integer vector: if S is a quanteda dictionary, this value indicates the levels of analysis.
#' @return A list with class \code{"rnsb"} containing the following components:
#' \describe{
#' \item{\code{$classifer}}{ a logistic regression model with L2 regularization trained with LiblineaR}
#' \item{\code{$A}}{the input A}
#' \item{\code{$B}}{the input B}
#' \item{\code{$S}}{the input S}
#' \item{\code{$P}}{the predicted negative sentiment probabilities}
#' }
#' \code{\link{rnsb_es}} can be used to obtain the effect size of the test.
#' @examples
#' S <- c("swedish", "irish", "mexican", "chinese", "filipino", "german", "english", "french", "norwegian", "american", "indian", "dutch", "russian", "scottish", "italian")
#' sn <- rnsb(w = glove_sweeney, S = S, A = bing_pos, B = bing_neg)
#' sort(sn$P)
#' @references
#' Sweeney, C., & Najafian, M. (2019, July). A transparent framework for evaluating unintended demographic bias in word embeddings. In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
#' @export
rnsb <- function(w, S, A, B, levels = 1) {
    feature_matrix <- w[rownames(w) %in% c(A, B),,drop = FALSE]
    colnames(feature_matrix) <- paste("f", seq_len(ncol(feature_matrix)), sep = "")
    label <- as.numeric(rownames(feature_matrix) %in% B)
    classifier <- LiblineaR::LiblineaR(data = feature_matrix, target = label, type = 0, epsilon = 1e-4)
    if ("dictionary2" %in% class(S)) {
        flist <- quanteda::as.list(S, levels = levels, flatten = TRUE)
        flist_regex <- purrr::map_chr(flist, .convert_globs)
        flist_words <- purrr::map(flist_regex, .find_words, input_words = rownames(w))
        flist_probs <- purrr::map(flist_words, .words_pred, w = w, classifier = classifier)
        f_star <- purrr::map_dbl(flist_probs, mean)
    } else {
        newdata <- w[S,,drop = FALSE]
        colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")
        f_star <- predict(classifier, newdata, proba = TRUE)$probabilities[,2]
        names(f_star) <- S
    }
    P <- f_star / sum(f_star, na.rm = TRUE)
    res <- list(classifier = classifier, A = A, B = B, S = S, P = P)
    class(res) <- append(class(res), "rnsb")
    return(res)
}

#' Calculation the Kullback-Leibler divergence
#'
#' This function calculates the Kullback-Leibler divergence of the predicted negative probabilities, P, from the uniform distribution.
#' @param rnsb an rnsb object from the \link{rnsb} function.
#' @return the Kullback-Leibler divergence.
#' @references
#' Sweeney, C., & Najafian, M. (2019, July). A transparent framework for evaluating unintended demographic bias in word embeddings. In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
#' @export
rnsb_es <- function(rnsb) {
    PP <- stats::na.omit(rnsb$P)
    PQ <- 1 / length(PP)
    kl <- sum(PP * log(PP/PQ))
    return(kl)
}

plot_rnsbs <- function(rnsb1, rnsb2, rnsb1_label = "rnsb1", rnsb2_label = "rnsb2") {
    groupnames <- c(names(rnsb1$P), names(rnsb2$P)) 
    values <- c(rnsb1$P, rnsb2$P)
    labels <- c(rep(rnsb1_label, length(rnsb1$P)), rep(rnsb2_label, length(rnsb2$P)))
    diff <- values - c(rnsb1$P, rnsb1$P)
    equality <- 1.0 / length(stats::na.omit(rnsb1$P))
    data_to_plot <- data.frame(labels, groupnames, values, diff)
    data_to_plot <- data_to_plot[!is.na(data_to_plot$values)]
    ggplot2::ggplot(data_to_plot, ggplot2::aes(x = forcats::fct_reorder(groupnames, diff), y = values, fill = labels)) + ggplot2::geom_bar(stat = "identity", position=ggplot2::position_dodge()) + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1)) + ggplot2::xlab("S") + ggplot2::ylab("P") + ggplot2::geom_hline(yintercept = equality, lty = 2, color = "darkgray") + ggplot2::coord_flip()
}

