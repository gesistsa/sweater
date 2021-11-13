##library(quanteda)

test_that("RNSB Dict demo", {
    skip_on_cran()
    load("../testdata/newsmap_europe.rda")
    load("../testdata/dictionary_demo.rda")
    load("../testdata/bing_pos.rda")
    load("../testdata/bing_neg.rda")
    expect_error(country_level <- rnsb(dictionary_demo, newsmap_europe, bing_pos, bing_neg, levels = 2), NA)
    expect_error(region_level <- rnsb(dictionary_demo, newsmap_europe, bing_pos, bing_neg, levels = 1), NA)
    tolerance <- 0.001
    expect_true(abs(rnsb_es(country_level) - (0.0796689)) < tolerance)
    expect_true(abs(rnsb_es(region_level) - (0.00329434)) < tolerance)
})
