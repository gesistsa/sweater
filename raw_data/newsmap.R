require(quanteda)

newsmap <- dictionary(file = "newsmap_english.yml")
str(newsmap)

newsmap_europe <- newsmap$EUROPE

usethis::use_data(newsmap_europe)
