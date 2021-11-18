test_that(".soften", {
    x <- .soften("respect", small_reddit, l = 0)
    expect_length(x, 300)
    x <- .soften("respect", small_reddit, l = 1)
    expect_length(x, 300)
    x <- .soften("respect", small_reddit, l = 1, return_k = TRUE)
    expect_length(x, 2)
    expect_true("respecting" %in% names(x))
    x <- .soften("respect", small_reddit, l = 3, return_k = TRUE)
    expect_length(x, 3 + 1)
    expect_true("compassion" %in% names(x))
    x <- .soften("respect", small_reddit, l = 3, return_k = FALSE)
    expect_length(x, 300)    
})

## integration
test_that("integration", {
    S1 <- c("mexicans", "asians", "whites", "blacks", "latinos")
    A1 <- c("respect")
    B1 <- c("disrespect")
    x1 <- query(small_reddit, S_words = S1, A_words = A1, B_words = B1, method = "semaxis", l = 0)
    x2 <- query(small_reddit, S_words = S1, A_words = A1, B_words = B1, method = "semaxis", l = 1)
    expect_true(all(x1$P != x2$P))
    tol <- 0.0001
    mex_p <- x2$P["mexicans"]
    lati_p <- x2$P["latinos"]
    expect_true(abs(mex_p - -0.16402445) < tol)
    expect_true(abs(lati_p - -0.04583781) < tol)
})
