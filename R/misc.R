#' @importFrom stats dist predict sd var
#' @importFrom utils glob2rx head
#' @importFrom graphics dotchart abline text
NULL

#' A subset of the pretrained word2vec word vectors
#'
#' This is a subset of the original pretrained word2vec word vectors trained on Google News. The same word vectors were used in Garg et al. (2018) to study biases.
#' @references
#' Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644. \doi{10.1073/pnas.1720347115}
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
#' For `ect`, this function calls [plot_ect()]. For other tests (except `weat`), this function plots the bias of words in `S` as a Cleveland Dot Plot. Plotting the result of `weat` is not supported.
#' @param x an S3 object returned from mac, rnd, semaxis, nas or rnsb
#' @return a plot
#' @author Chung-hong Chan
#' @export
plot_bias <- function(x) {
    if ("ect" %in% class(x)) {
        plot_ect(x)
    } else if (is.null(x$P)) {
        stop("Plotting the result of this test type (", .purify_class(x),  ") is not supported.", call. = FALSE)
    } else {
        sortedx <- sort(x$P)
        graphics::dotchart(sortedx, labels = names(sortedx))
    }
}

.purify_class <- function(x) {
    setdiff(class(x), c("list", "sweater"))[1]
}

#' Calculate the effect size of a query
#'
#' This function calculates the effect of a query.
#' @param x an S3 object returned from a query, either by the function [query()] or underlying functions such as [mac()]
#' @param ... additional parameters for the effect size functions
#' \describe{
#' \item{\code{r}}{for `weat`: a boolean to denote whether convert the effect size to biserial correlation coefficient.}
#' \item{\code{standardize}}{for `weat`: a boolean to denote whether to correct the difference by the standard division. The standardized version can be interpreted the same way as Cohen's d. }
#' }
#' @return effect size
#' @author Chung-hong Chan
#' @details
#' The following methods are supported.
#' \describe{
#' \item{\code{mac}}{mean cosine distance value. The value makes sense only for comparison (e.g. before and after debiasing). But a lower value indicates greater association between the target words and the attribute words.}
#' \item{\code{rnd}}{sum of all relative norm distances. It equals to zero when there is no bias.}
#' \item{\code{rnsb}}{Kullback-Leibler divergence of the predicted negative probabilities, P, from the uniform distribution. A lower value indicates less bias.}
#' \item{\code{ect}}{Spearman Coefficient of an Embedding Coherence Test. The value ranges from -1 to +1 and a larger value indicates less bias.}
#' \item{\code{weat}}{The standardized effect size (default) can be interpreted the same way as Cohen's D.}
#' }
#' @seealso [weat_es()], [mac_es()], [rnd_es()], [rnsb_es()], [ect_es()]
#' @references
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186. \doi{10.1126/science.aal4230}
#' Dev, S., & Phillips, J. (2019, April). [Attenuating bias in word vectors.](https://proceedings.mlr.press/v89/dev19a.html) In The 22nd International Conference on Artificial Intelligence and Statistics (pp. 879-887). PMLR.
#' Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644. \doi{10.1073/pnas.1720347115}
#' Manzini, T., Lim, Y. C., Tsvetkov, Y., & Black, A. W. (2019). [Black is to criminal as caucasian is to police: Detecting and removing multiclass bias in word embeddings.](https://arxiv.org/abs/1904.04047) arXiv preprint arXiv:1904.04047.
#' Sweeney, C., & Najafian, M. (2019, July). [A transparent framework for evaluating unintended demographic bias in word embeddings.](https://aclanthology.org/P19-1162/) In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
#' @export
calculate_es <- function(x, ...) {
    if (!"sweater" %in% class(x)) {
        stop("The input object x must be a sweater S3 object.", call. = FALSE)
    }
    class_x <- .purify_class(x)
    switch(class_x,
           "weat" = weat_es(x, ...),
           "mac" = mac_es(x),
           "rnd" = rnd_es(x),
           "rnsb" = rnsb_es(x),
           "ect" = ect_es(x),
           stop("No effect size can be calculated for this query.", call. = FALSE))
}
