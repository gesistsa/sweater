#' Simple Word Embedding Association Test
#'
#' This functions test the potential bias in a set of word embeddings using the method by Caliskan et al (2017).
#' @param w a numeric matrix of word embeddings (e.g. from rsparse::GloVe)
#' @param S a character vector of the first set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists...
#' @param T a character vector of the second set of target words. In an example of studying gender stereotype, it can include occupations such as nurse, teacher, librarian...
#' @param A a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.
#' @param B a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.
#' @param standardize a boolean to denote division of the difference by the standard division. The standardized version can be interpreted the same way as Cohen's d.
#' @return WEAT results
#' @examples
#' # Reproduce the number in Caliskan et al. (2017) - Table 1, "Math vs. Arts"
#' data(glove_math)
#' S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
#' T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
#' A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
#' B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
#' sweater(glove_math, S, T, A, B)
#' @author Chung-hong Chan
#' @references
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186.
#' @export 
sweater <- function(w, S, T, A, B, standardize = TRUE) {
    S_diff <- cpp_bweat(S, A, B, w)
    T_diff <- cpp_bweat(T, A, B, w)
    if (standardize) {
        union_diff <- c(S_diff, T_diff)
        weat_base <- sd(union_diff)
    } else {
        weat_base <- 1
    }
    return((mean(S_diff) - mean(T_diff)) / weat_base)
}


#' A subset of the pretrained GLoVE word vectors
#'
#' This is a subset of the original pretrained GLoVE word vectors provided by Pennington et al (2017). The same word vectors were used in Caliskan et al. (2017) to study biases.
#' @references
#' Pennington, J., Socher, R., & Manning, C. D. (2014, October). Glove: Global vectors for word representation. In Proceedings of the 2014 conference on empirical methods in natural language processing (EMNLP) (pp. 1532-1543).
#' Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186.
"glove_math"
