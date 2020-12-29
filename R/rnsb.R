## require(ggplot2)

## load("glove_sweeney.rda")
## load("bing_pos.rda")
## load("bing_neg.rda")

## w <- glove_sweeney
## A <- bing_pos
## B <- bing_neg

#' Relative Negative Sentiment Bias
#'
#' This function estimate the Relative Negative Sentiment Bias (RNSB) of word embeddings.
#' @param w
#' @param S
#' @param A
#' @param B
#' @export
rnsb <- function(w, S, A, B) {
    feature_matrix <- w[rownames(w) %in% c(A, B),]
    colnames(feature_matrix) <- paste("f", seq_len(ncol(feature_matrix)), sep = "")
    label <- as.numeric(rownames(feature_matrix) %in% B)
    features <- as.data.frame(cbind(label, feature_matrix))
    classifier <- glm(label~., data = features, family = "binomial")
    newdata <- w[S, ]
    colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")
    f_star <- predict(classifier, as.data.frame(newdata), type = "response")
    P <- f_star / sum(f_star)
    res <- list(classifier = classifier, A = A, B = B, features = features, S = S, P = P)
    class(res) <- append(class(res), "rnsb")
    return(res)
}

#' @export
rnsb_es <- function(rnsb) {
    PP <- rnsb$P
    PQ <- 1 / length(PP)
    kl <- sum(PP * log(PP/PQ))
    return(kl)
}

## table(label, predict(classifer) > 0.5)


## group_names <- c("swedish", "irish", "mexican", "chinese", "filipino", "german", "english", "french", "norwegian", "american", "indian", "dutch", "russian", "scottish", "italian")

## newdata <- w[group_names, ]
## colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")


## f_star <- predict(classifer, as.data.frame(newdata), type = "response")
## options("scipen"=-100, "digits"=4)
## P <- f_star / sum(f_star)

## ## Not the same as in Figure 3!
## P

## ggplot(data.frame(group_name = names(P), P = P), aes(x = group_name, y = P)) + geom_point()
