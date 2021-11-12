
save_png <- function(code, width = 400, height = 400) {
    path <- tempfile(fileext = ".png")
    png(path, width = width, height = height)
    on.exit(dev.off())
    code
    path
}

test_that("weat is not plottable", {
    S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- weat(glove_math, S, T, A, B)
    expect_error(plot_bias(sw))
    expect_error(save_png(plot_bias(query(glove_math, S = S, A = A, method = "mac"))), NA)
    expect_error(save_png(plot_bias(query(glove_math, S = S, A = A, B = B, method = "rnd"))), NA)
    expect_error(save_png(plot_bias(query(glove_math, S = S, A = A, B = B, method = "semaxis"))), NA)
    expect_error(save_png(plot_bias(query(glove_math, S = S, A = A, B = B, method = "nas"))), NA)
    expect_error(save_png(plot_bias(query(glove_math, S = S, A = A, B = B, method = "rnsb"))), NA)
})
