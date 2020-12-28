test_that("ES calc", {
    S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- sweater(glove_math, S, T, A, B)
    tolerance <- 0.001
    expect_true(abs(sweater_es(sw) - 1.055) < tolerance)
    expect_true(abs(sweater_es(sw, standardize = FALSE) - 0.0248) < tolerance)
    expect_true(abs(sweater_es(sw, r = TRUE) - 0.491) < tolerance)
})
