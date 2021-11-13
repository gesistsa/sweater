## test for the .soften

x <- readRDS("raw_data/reddit.RDS")

.soften("respect", x, l = 20)
.soften("disrespect", x, l = 20)

k1 <- readRDS("raw_data/goodk1.RDS")
k2 <- readRDS("raw_data/goodk2.RDS")

S <- c("mexicans", "asians", "whites", "blacks", "latinos")
A <- c("respect")
B <- c("disrespect")

## and some random rows
set.seed(10102102)
random_rows <- sample(rownames(x), 70) %>% purrr::keep(~stringr::str_detect(., "^[a-z0-9]+$"))


all_words <- unique(c(k1, k2, S, A, B, random_rows))

small_reddit <- x[all_words, ]

usethis::use_data(small_reddit, overwrite = TRUE)

