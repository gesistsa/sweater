test_that("print method, except rnsb", {
    S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- weat(glove_math, S1, T1, A1, B1)
    expect_snapshot(sw)
    expect_snapshot(query(glove_math, S_words = S1, A_words= A1, method = "mac"))
    for (test_types in c("rnd", "semaxis", "nas", "ect")) {
        expect_snapshot(query(glove_math, S_words = S1, A_words= A1, B_words = B1, method = test_types))
    }
})

test_that("print method, rnsb", {
    ## the numerical precision of LiblineaR has changed since version 2.50-1
    skip_on_cran()
    skip_if(compareVersion(as.character(packageVersion("LiblineaR")), "2.50-1") != -1)
    S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    expect_snapshot(query(glove_math, S_words = S1, A_words= A1, B_words = B1, method = "rnsb"))
})
