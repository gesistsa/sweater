set.seed(11111)
S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

sw <- weat(glove_math, S1, T1, A1, B1)

test_that("named vector for T_diff and S_diff, #27", {
    expect_false(is.null(names(sw$S_diff)))
    expect_false(is.null(names(sw$T_diff)))
})

test_that("resampling", {
    expect_error(weat_resampling(S1))
    expect_error(weat_resampling(sw), NA)
    res <- weat_resampling(sw)
    expect_equal(class(res), "htest")
    tol <- 0.01
    exp <- 0.018 #from Caliskan paper
    expect_true(abs(res$p.value - exp) < tol)
})

test_that("Display mistake", {
    expect_snapshot(weat_resampling(sw))
    whatever <- sw
    expect_snapshot(weat_resampling(whatever))
})


set.seed(11111)
S2 <- c("math", "algebra", "geometry")
T2 <- c("poetry", "art", "dance")
A2 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B2 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

sw2 <- weat(glove_math, S2, T2, A2, B2)

test_that("exact", {
    expect_snapshot(weat_exact(sw2))
})

test_that("exact., reverse", {
    sw3 <- weat(glove_math, T2, S2, A2, B2)
    expect_snapshot(weat_exact(sw3))
})

