program <- rio::import("72nd Annual ICA Conference_27MAY2022.csv")
require(quanteda)
require(text2vec)


window_size <- 10
rank <- 200
x_max <- 100
learning_rate <- 0.05
    
abstracts <- corpus(program$`Submission Body`) %>% tokens(remove_punct = TRUE, remove_url = TRUE, remove_symbols = TRUE) %>% tokens_tolower()

pub_fcm <- fcm(abstracts, context = "window", window = window_size, count = "weighted", weights = 1 / seq_len(window_size), tri = TRUE)

glove <- GlobalVectors$new(rank = rank, x_max = x_max, learning_rate = learning_rate)
wv_main <- glove$fit_transform(pub_fcm, n_iter = 100, convergence_tol = 0.01, n_threads = 8)
wv_context <- glove$components
wM <- wv_main + t(wv_context)
saveRDS(wM, "ica_program_wm.RDS")


require(sweater)
ica_program_wm <- readRDS("ica_program_wm.RDS")
S_words <- c("analysis", "analytic", "computation", "computational", "analyses", "research", "computer", "computers")
A_words <- c("r", "cran")
B_words <- c("python", "pip")

x <- query(wM, S_words = S_words, A_words = A_words, B_words = B_words, method = "ect")
plot(x, main = "ECT, below the line - pro R", cex = 2)
