## Issue 36

test_that("single", {
    expect_error(query(googlenews, S_words = c("janitor", "midwife"), A_words = c("he"), method = "mac"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), A_words = c("he"), B_words = c("she"), method = "rnd"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), A_words = c("he"), B_words = c("she"), method = "rnsb"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), A_words = c("he"), B_words = c("she"), method = "ect"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), A_words = c("he"), B_words = c("she"), method = "semaxis"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), A_words = c("he"), B_words = c("she"), method = "nas"), NA)
    expect_error(query(googlenews, S_words = c("janitor"), T_words = c("nurse"), A_words = c("he"), B_words = c("she"), method = "weat"), NA)
})
