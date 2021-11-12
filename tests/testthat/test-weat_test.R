set.seed(11111)
S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

sw <- weat(glove_math, S, T, A, B)

test_that("resampling", {
    expect_error(weat_resampling(S))
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
S <- c("math", "algebra", "geometry")
T <- c("poetry", "art", "dance")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

sw2 <- weat(glove_math, S, T, A, B)

test_that("exact", {
    expect_snapshot(weat_exact(sw2))
})
