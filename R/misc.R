#' @importFrom stats dist predict sd var
#' @importFrom utils glob2rx head
#' @importFrom graphics dotchart
NULL

#' A helper function for reading word2vec format
#'
#' This function reads word2vec text format and return a dense matrix that can be used by this package.
#' The file can have or have not the "verification line", i.e. the first line contains the dimensionality of the matrix. If the verification line exists, the function will check the returned matrix for correctness.
#' @param x path to your text file
#' @return a dense matrix
#' @export
read_word2vec <- function(x) {
    first_line <- strsplit(readLines(x, n = 1), " ")[[1]]
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
#' This function plots the bias of words in `S` as a Cleveland Dot Plot.
#' @param x an S3 object returned from mac, rnd, semaxis, nas or rnsb
#' @return a plot
#' @export
plot_bias <- function(x) {
    if (is.null(x$P)) {
        stop("No P slot in the input object x.")
    }
    sortedx <- sort(x$P)
    graphics::dotchart(sortedx, labels = names(sortedx))
}
