
.convert_globs <- function(globs) {
    paste(glob2rx(globs), collapse = "|")
}

.find_words <- function(regex, input_words) {
    grep(regex, input_words, value = TRUE)
}

.words_pred <- function(words, w, classifier) {
    if (length(words) == 0) {
        return(NA)
    }
    newdata <- w[words, ,drop = FALSE]
    f_star <- predict(classifier, newdata, proba = TRUE)$probabilities[,2]
    names(f_star) <- words
    return(f_star)
}
