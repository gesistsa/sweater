test_that("read_word2vec", {
    expect_error(x1 <- read_word2vec("../testdata/word2vec_small.txt"), NA)
    expect_error(x2 <- read_word2vec("../testdata/word2vec_notest.txt"), NA)
    expect_true(nrow(x1) == 10)
    expect_true(ncol(x1) == 3)
    expect_true(nrow(x2) == 10)
    expect_true(ncol(x2) == 3)    
    expect_error(read_word2vec("../testdata/word2vec_wrong.txt"))
    expect_error(read_word2vec("../testdata/word2vec_wrong2.txt"))
})

test_that("weird cases", {
    expect_error(read_word2vec())
    expect_error(read_word2vec("../testdata/word2vec_weird.txt"))    
})
