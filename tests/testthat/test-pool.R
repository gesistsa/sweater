test_that("Pooled SD", {
    ## Taken from easystats/effectsize
    ##https://github.com/easystats/effectsize/blob/main/tests/testthat/test-pooled.R
    expect_equal(.cal_pooled_sd(1:4, 1:3 * 5), 3.316625, tolerance = 0.001)
    expect_equal(.cal_pooled_sd(c(1:3, 40), 1:3 * 5), 15.06652, tolerance = 0.001)
    x <- 1:5
    y <- 1:5
    expect_equal(.cal_pooled_sd(x, y, force = TRUE), sd(c(x, y)) * sqrt(9 / 8))
    ## Taken from https://www.statology.org/pooled-standard-deviation-in-r/
    data1 <- c(6, 6, 7, 8, 8, 10, 11, 13, 15, 15, 16, 17, 19, 19, 21)
    data2 <- c(10, 11, 13, 13, 15, 17, 17, 19, 20, 22, 24, 25, 27, 29, 29)
    expect_equal(.cal_pooled_sd(data1, data2), 6.6224974, tolerance = 0.001)
    expect_equal(.cal_pooled_sd(data1, data2, force = TRUE), 5.789564, tolerance = 0.001)
})
