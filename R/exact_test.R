.exact_test <- function(S_diff, T_diff) {
    s_length <- length(S_diff)
    union_diff <- c(S_diff, T_diff)
    test_stat <- (mean(S_diff) - mean(T_diff))
    return(cpp_exact(union_diff, test_stat, s_length))
}
