require(quanteda)

load("newsmap_europe.rda")

levels <- 2
flist <- as.list(newsmap_europe, levels = levels, flatten = TRUE)

.convert_globs <- function(globs) {
    paste(glob2rx(globs), collapse = "|")
}

flist_regex <- purrr::map_chr(flist, .convert_globs)
googlenews <- data.table::fread("googlenews.txt", header = FALSE, skip = 1, quote = "")

flist_regex

monster_reg <- paste(flist_regex, collapse = "|")

gnews_selector <- grepl(monster_reg, googlenews$V1)

bing_pos <- scan("positive-words.txt", comment.char = ";", what = "character", quiet = TRUE)

bing_neg <- scan("negative-words.txt", comment.char = ";", what = "character", quiet = TRUE)

A <- readLines("female_pairs.txt", warn = FALSE)
B <- readLines("male_pairs.txt", warn = FALSE)
S <- readLines("occupations1950.txt", warn = FALSE)


sentiment_select <- googlenews$V1 %in% c(bing_pos, bing_neg, A, B, S)

gdict <- googlenews[sentiment_select | gnews_selector, ]

gdict_mat <- as.matrix(gdict[,2:301])

colnames(gdict_mat) <- NULL
rownames(gdict_mat) <- gdict$V1

googlenews <- gdict_mat

usethis::use_data(googlenews)
