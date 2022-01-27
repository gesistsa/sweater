.p <- function(y) {
    if (length(y) >= 1) {
        return(TRUE)
    }
    if (is.null(y)) {
        return(FALSE)
    }
    if (identical(y, character(0))) {
        return(FALSE)
    }
    if (is.na(y)) {
        return(FALSE)
    }
    return(TRUE)
}

.d <- function(x, y) {
    if (.p(y)) {
        cat(cli::style_bold(x), y, "\n")
    }
}


#' @rdname query
#' @export
print.sweater <- function(x, ...) {
    test_type <- .purify_class(x)
    cli::cli_h1("sweater object")
    .d("Test type: ", test_type)
    if (!test_type %in% c("semaxis", "nas")) {
        .d("Effect size: ", calculate_es(x))
    }
    cli::cli_h1("Functions")
    cli::cli_ul()
    if (!test_type %in% c("semaxis", "nas")) {
        cli::cli_li("{.fun calculate_es}: Calculate effect size")
    }
    if (test_type != "weat") {
        cli::cli_li("{.fun plot}: Plot the bias of each individual word")
    } else {
        cli::cli_li("{.fun weat_resampling}: Conduct statistical test")        
    }
}

#' @rdname plot_bias
#' @param ... other parameters
#' @export
plot.sweater <- function(x, ...) {
    plot_bias(x)
}
