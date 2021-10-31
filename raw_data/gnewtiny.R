require(sweater)

gnews <- read_word2vec("raw_data/googlenews.txt")

A <- readLines("raw_data/female_pairs.txt", warn = FALSE)
B <- readLines("raw_data/male_pairs.txt", warn = FALSE)
S <- readLines("raw_data/occupations1950.txt", warn = FALSE)

googlenews <- gnews[c(A, B, S),]

usethis::use_data(googlenews)
