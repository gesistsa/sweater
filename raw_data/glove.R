glove_raw <- data.table::fread("glove.6B.300d.txt", header = FALSE, quote = "")

bing_pos <- scan("positive-words.txt", comment.char = ";", what = "character", quiet = TRUE)

bing_neg <- scan("negative-words.txt", comment.char = ";", what = "character", quiet = TRUE)

usethis::use_data(bing_pos)
usethis::use_data(bing_neg)

group_names <- c("swedish", "irish", "mexican", "chinese", "filipino", "german", "english", "french", "norwegian", "american", "indian", "dutch", "russian", "scottish", "italian")

glove_mat <- as.matrix(glove_raw[,2:301])
colnames(glove_mat) <- NULL
rownames(glove_mat) <- glove_raw$V1

##saveRDS(glove_mat, "glove_mat.RDS")
glove_sweeney <- glove_mat[rownames(glove_mat) %in% c(bing_pos, bing_neg, group_names),]

usethis::use_data(glove_sweeney, overwrite = TRUE)
