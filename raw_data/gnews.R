googlenews <- data.table::fread("googlenews.txt", header = FALSE, skip = 1, quote = "")

A <- readLines("female_pairs.txt", warn = FALSE)
B <- readLines("male_pairs.txt", warn = FALSE)
S <- readLines("occupations1950.txt", warn = FALSE)

googlenews_subset <- googlenews[googlenews$V1 %in% c(A, B, S),]

googlenews_garg <- as.matrix(googlenews_subset[,2:301])
colnames(googlenews_garg) <- NULL
rownames(googlenews_garg) <- googlenews_subset$V1

usethis::use_data(googlenews_garg)
