#' @importFrom stats dist predict sd var
#' @importFrom utils glob2rx head
#' @importFrom graphics dotchart abline text
NULL

#' A subset of the pretrained word2vec word vectors
#'
#' This is a subset of the original pretrained word2vec word vectors trained on Google News. The same word vectors were used in Garg et al. (2018) to study biases.
#' @references
#' Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644.
"googlenews"

#' A helper function for reading word2vec format
#'
#' This function reads word2vec text format and return a dense matrix that can be used by this package.
#' The file can have or have not the "verification line", i.e. the first line contains the dimensionality of the matrix. If the verification line exists, the function will check the returned matrix for correctness.
#' @param x path to your text file
#' @return a dense matrix
#' @author Chung-hong Chan
#' @export
read_word2vec <- function(x) {
    init_lines <- strsplit(readLines(x, n = 2), " ")
    first_line <- init_lines[[1]]
    second_line <- init_lines[[2]]
    if (length(second_line) == 2) {
        stop("Input file x has only two columns. It is probably not suitable for analysis.")
    }
    if (length(first_line) == 2) {
        ## it has the dimensionality written
        skip_line <- 1
        x_nrow <- as.numeric(first_line[1])
        x_ncol <- as.numeric(first_line[2])
    } else {
        skip_line <- 0
        x_nrow <- NA
        x_ncol <- NA
    }
    raw <- data.table::fread(x, header = FALSE, quote = "", skip = skip_line)
    raw_mat <- as.matrix(raw[,-1])
    colnames(raw_mat) <- NULL
    rownames(raw_mat) <- raw$V1
    if (!is.na(x_nrow) & !is.na(x_ncol)) {
        if (nrow(raw_mat) != x_nrow | ncol(raw_mat) != x_ncol) {
            stop("The returned matrix does not match the dimensionality specified in the input file x.", call. = FALSE)
        }
    }
    return(raw_mat)
}

.clean <- function(x, w_lab, verbose = FALSE) {
    new_x <- intersect(x, w_lab)
    if (length(new_x) < length(x) & verbose) {
        print("Some word(s) are not available in w.")
    }
    return(new_x)
}

#' Visualize the bias of words in S
#'
#' For `ect`, this function calls [plot_ect()]. For `mac`, `rnd`, and `semaxis`, this function plots the bias of words in `S` as a Cleveland Dot Plot.
#' @param x an S3 object returned from mac, rnd, semaxis, nas or rnsb
#' @return a plot
#' @author Chung-hong Chan
#' @export
plot_bias <- function(x) {
    if ("ect" %in% class(x)) {
        plot_ect(x)
    }
    if (is.null(x$P)) {
        stop("No P slot in the input object x.")
    }
    sortedx <- sort(x$P)
    graphics::dotchart(sortedx, labels = names(sortedx))
}

.purify_class <- function(x) {
    setdiff(class(x), c("list", "sweater"))[1]
}

#' Calculate the effect size of a query
#'
#' This function calculates the effect of a query.
#' @param x an S3 object return from a query, either by the function [query()] or underlying functions such as [mac()]
#' @param ... additional parameters for the effect size functions
#' @return the effect size
#' @author Chung-hong Chan
#' @seealso [weat_es()], [mac_es()], [rnd_es()], [rnsb_es()], [ect_es()]
#' @export
calculate_es <- function(x, ...) {
    if (!"sweater" %in% class(x)) {
        stop("The input object x must be a sweater S3 object.")
    }
    class_x <- .purify_class(x)
    switch(class_x,
           "weat" = weat_es(x, ...),
           "mac" = mac_es(x),
           "rnd" = rnd_es(x),
           "rnsb" = rnsb_es(x),
           "ect" = ect_es(x),
           stop("No effect size can be calculated for this query."))
}
