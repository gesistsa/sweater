S <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
T <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
A <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
B <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
sw <- weat(glove_math, S, T, A, B)

test_that(".purify", {
    expect_equal(.purify_class(weat(glove_math, S, T, A, B)), "weat")
    expect_equal(.purify_class(mac(glove_math, S, A)), "mac")
    expect_equal(.purify_class(rnsb(glove_math, S, A, B)), "rnsb")
    expect_equal(.purify_class(rnd(glove_math, S, A, B)), "rnd")
    expect_equal(.purify_class(semaxis(glove_math, S, A, B)), "semaxis")
    expect_equal(.purify_class(nas(glove_math, S, A, B)), "nas")
})
