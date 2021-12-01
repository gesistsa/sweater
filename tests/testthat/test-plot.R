
save_png <- function(code, width = 400, height = 400) {
    path <- tempfile(fileext = ".png")
    png(path, width = width, height = height)
    on.exit(dev.off())
    code
    path
}

test_that("weat is not plottable", {
    S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- weat(glove_math, S1, T1, A1, B1)
    expect_error(plot_bias(sw))
    expect_error(plot_ect(sw))
    expect_error(save_png(plot_bias(query(glove_math, S_words = S1, A_words= A1, method = "mac"))), NA)
    for (test_types in c("rnd", "semaxis", "nas", "rnsb", "ect")) {
        expect_error(save_png(plot_bias(query(glove_math, S_words = S1, A_words = A1, B_words = B1, method = test_types))), NA)
    }
})

test_that("S3 plot method", {
    expect_error(plot(sw))
    expect_error(save_png(plot(query(glove_math, S_words = S1, A_words= A1, method = "mac"))), NA)
    for (test_types in c("rnd", "semaxis", "nas", "rnsb", "ect")) {
        expect_error(save_png(plot(query(glove_math, S_words = S1, A_words = A1, B_words = B1, method = test_types))), NA)
    }
})
