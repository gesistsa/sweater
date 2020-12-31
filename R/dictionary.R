
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
    colnames(newdata) <- paste("f", seq_len(ncol(newdata)), sep = "")
    f_star <- predict(classifier, as.data.frame(newdata), type = "response")
    return(f_star)
}
