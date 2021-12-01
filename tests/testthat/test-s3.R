test_that("print method", {
    S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- weat(glove_math, S1, T1, A1, B1)
    expect_snapshot(sw)
    expect_snapshot(query(glove_math, S_words = S1, A_words= A1, method = "mac"))
    for (test_types in c("rnd", "semaxis", "nas", "rnsb", "ect")) {
        expect_snapshot(query(glove_math, S_words = S1, A_words= A1, B_words = B1, method = test_types))
    }    
})
