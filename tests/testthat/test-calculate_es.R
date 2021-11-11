S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")

test_that(".purify", {
    expect_equal(.purify_class(weat(glove_math, S, T, A, B)), "weat")
    expect_equal(.purify_class(mac(glove_math, S, A)), "mac")
    expect_equal(.purify_class(rnsb(glove_math, S, A, B)), "rnsb")
    expect_equal(.purify_class(rnd(glove_math, S, A, B)), "rnd")
    expect_equal(.purify_class(semaxis(glove_math, S, A, B)), "semaxis")
    expect_equal(.purify_class(nas(glove_math, S, A, B)), "nas")    
})

test_that("error cases", {
    expect_error(calculate_es())
    expect_error(calculate_es(x = 1))
    expect_error(calculate_es(semaxis(glove_math, S, A, B)))
    expect_error(calculate_es(nas(glove_math, S, A, B)))
})

test_that("calculate effect size", {
    sw <- weat(glove_math, S, T, A, B)
    expect_equal(weat_es(sw), calculate_es(sw))
    expect_equal(weat_es(sw, standardize = FALSE), calculate_es(sw, standardize = FALSE))
    expect_equal(weat_es(sw, r = TRUE), calculate_es(sw, r = TRUE))
    mac_res <- mac(glove_math, S, A)
    expect_equal(mac_es(mac_res), calculate_es(mac_res))
    rnd_res <- rnd(glove_math, S, A, B)
    expect_equal(rnd_es(rnd_res), calculate_es(rnd_res))
    rnsb_res <- rnsb(glove_math, S, A, B)
    expect_equal(rnsb_es(rnsb_res), calculate_es(rnsb_res))    
})
