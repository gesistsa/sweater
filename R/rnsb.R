#' Relative Negative Sentiment Bias
#'
#' This function estimate the Relative Negative Sentiment Bias (RNSB) of word embeddings.
#' @param w a numeric matrix representing the word vectors.
#' @param S either a vector or a dictionary of target words
#' @param A a vector of attribute words
#' @param B a vector of attribute words
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

#' Calculation the 
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


## table(label, predict(classifer) > 0.5)

## w <- glove_sweeney

## S <- c("swedish", "irish", "mexican", "chinese", "filipino", "german", "english", "french", "norwegian", "american", "indian", "dutch", "russian", "scottish", "italian")

## A <- bing_pos
## B <- bing_neg
## feature_matrix <- w[rownames(w) %in% c(A, B),,drop = FALSE]
## colnames(feature_matrix) <- paste("f", seq_len(ncol(feature_matrix)), sep = "")
## label <- as.numeric(rownames(feature_matrix) %in% B)

## require(LiblineaR)
## classifier <- LiblineaR::LiblineaR(data = feature_matrix, target = label, type = 0, epsilon = 1e-4)

## newdata <- w[S,,drop = FALSE]
## colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")

## prob <- predict(classifier, newdata, proba = TRUE)$probabilities[,2]
## PP <- prob / sum(prob)
## PQ <- 1 / length(PP)
## kl <- sum(PP * log(PP/PQ))
## kl

## newdata <- w[group_names, ]
## colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")


## f_star <- predict(classifer, as.data.frame(newdata), type = "response")
## options("scipen"=-100, "digits"=4)
## P <- f_star / sum(f_star)

## ## Not the same as in Figure 3!
## P

## ggplot(data.frame(group_name = names(P), P = P), aes(x = group_name, y = P)) + geom_point()
