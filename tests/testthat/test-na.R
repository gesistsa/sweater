all_s<- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
"photographer", "geologist", "shoemaker", "athlete", "cashier", 
"dancer", "housekeeper", "accountant", "physicist", "gardener", 
"dentist", "weaver", "blacksmith", "psychologist", "supervisor", 
"mathematician", "surveyor", "tailor", "designer", "economist", 
"mechanic", "laborer", "postmaster", "broker", "chemist", "librarian", 
"attendant", "clerical", "musician", "porter", "scientist", "carpenter", 
"sailor", "instructor", "sheriff", "pilot", "inspector", "mason", 
"baker", "administrator", "architect", "collector", "operator", 
"surgeon", "driver", "painter", "conductor", "nurse", "cook", 
"engineer", "retired", "sales", "lawyer", "clergy", "physician", 
"farmer", "clerk", "manager", "guard", "artist", "smith", "official", 
"police", "doctor", "professor", "student", "judge", "teacher", 
"author", "secretary", "soldier")
all_a<- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
all_b<- c("she", "daughter", "hers", "her", "mother", "woman", "girl", 
"herself", "female", "sister", "daughters", "mothers", "women", 
"girls", "females", "sisters", "aunt", "aunts", "niece", "nieces"
)

S1 <- sample(all_s, sample(2:10, size = 1))
T1 <- sample(all_s, sample(2:10, size = 1))
A1 <- sample(all_a, sample(2:10, size = 1))
B1 <- sample(all_b, sample(2:10, size = 1))
garbage <- "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ"

test_that("mac add na", {
    expect_length(mac(googlenews, append(S1, garbage), A1)$P, length(S1))
    expect_output(mac(googlenews, append(S1, garbage), A1, verbose = TRUE))
    expect_length(mac(googlenews, append(S1, garbage), A1)$S_words, length(S1))
    expect_length(mac(googlenews, S1, append(A1, garbage))$P, length(S1))
    expect_length(mac(googlenews, S1, append(A1, garbage))$A_words, length(A1))
    expect_output(mac(googlenews, S1, append(A1, garbage), verbose = TRUE))    
})

test_that("rnd add na", {
    expect_length(rnd(googlenews, append(S1, garbage), A1, B1)$P, length(S1))
    expect_output(rnd(googlenews, append(S1, garbage), A1, B1, verbose = TRUE))
    expect_length(rnd(googlenews, append(S1, garbage), A1, B1)$S_words, length(S1))
    expect_length(rnd(googlenews, S1, append(A1, garbage), B1)$P, length(S1))
    expect_length(rnd(googlenews, S1, append(A1, garbage), B1)$A_words, length(A1))
    expect_output(rnd(googlenews, S1, append(A1, garbage), B1, verbose = TRUE))
    expect_length(rnd(googlenews, S1, A1, append(B1, garbage))$P, length(S1))
    expect_length(rnd(googlenews, S1, A1, append(B1, garbage))$B_words, length(B1))
    expect_output(rnd(googlenews, S1, A1, append(B1, garbage), verbose = TRUE))
})

test_that("semaxis add na", {
    expect_length(semaxis(googlenews, append(S1, garbage), A1, B1)$P, length(S1))
    expect_output(semaxis(googlenews, append(S1, garbage), A1, B1, verbose = TRUE))
    expect_length(semaxis(googlenews, append(S1, garbage), A1, B1)$S_words, length(S1))
    expect_length(semaxis(googlenews, S1, append(A1, garbage), B1)$P, length(S1))
    expect_length(semaxis(googlenews, S1, append(A1, garbage), B1)$A_words, length(A1))
    expect_output(semaxis(googlenews, S1, append(A1, garbage), B1, verbose = TRUE))
    expect_length(semaxis(googlenews, S1, A1, append(B1, garbage))$P, length(S1))
    expect_length(semaxis(googlenews, S1, A1, append(B1, garbage))$B_words, length(B1))
    expect_output(semaxis(googlenews, S1, A1, append(B1, garbage), verbose = TRUE))
})

test_that("nas add na", {
    expect_length(nas(googlenews, append(S1, garbage), A1, B1)$P, length(S1))
    expect_output(nas(googlenews, append(S1, garbage), A1, B1, verbose = TRUE))
    expect_length(nas(googlenews, append(S1, garbage), A1, B1)$S_words, length(S1))
    expect_length(nas(googlenews, S1, append(A1, garbage), B1)$P, length(S1))
    expect_length(nas(googlenews, S1, append(A1, garbage), B1)$A_words, length(A1))
    expect_output(nas(googlenews, S1, append(A1, garbage), B1, verbose = TRUE))
    expect_length(nas(googlenews, S1, A1, append(B1, garbage))$P, length(S1))
    expect_length(nas(googlenews, S1, A1, append(B1, garbage))$B_words, length(B1))
    expect_output(nas(googlenews, S1, A1, append(B1, garbage), verbose = TRUE))
})

test_that("ect add na", {
    expect_length(ect(googlenews, append(S1, garbage), A1, B1)$u_a, length(S1))
    expect_output(ect(googlenews, append(S1, garbage), A1, B1, verbose = TRUE))
    expect_length(ect(googlenews, append(S1, garbage), A1, B1)$S_words, length(S1))
    expect_length(ect(googlenews, S1, append(A1, garbage), B1)$u_a, length(S1))
    expect_length(ect(googlenews, S1, append(A1, garbage), B1)$A_words, length(A1))
    expect_output(ect(googlenews, S1, append(A1, garbage), B1, verbose = TRUE))
    expect_length(ect(googlenews, S1, A1, append(B1, garbage))$u_a, length(S1))
    expect_length(ect(googlenews, S1, A1, append(B1, garbage))$B_words, length(B1))
    expect_output(ect(googlenews, S1, A1, append(B1, garbage), verbose = TRUE))
})

test_that("weat add na", {
    expect_output(weat(googlenews, append(S1, garbage), T1, A1, B1, verbose = TRUE))
    expect_output(weat(googlenews, S1, append(T1, garbage), A1, B1, verbose = TRUE))
    expect_output(weat(googlenews, S1, T1, append(A1, garbage), B1, verbose = TRUE))
    expect_output(weat(googlenews, S1, T1, A1, append(B1, garbage), verbose = TRUE))
    ### res <- list(S_diff = S_diff, T_diff = T_diff, S = S, T = T, A = A, B = B)
    gS <- weat(googlenews, append(S1, garbage), T1, A1, B1, verbose = FALSE)
    expect_length(gS$S_diff, length(S1))
    expect_length(gS$T_diff, length(T1))
    expect_length(gS$S_words, length(S1))
    expect_length(gS$T_words, length(T1))
    expect_length(gS$A_words, length(A1))
    expect_length(gS$B_words, length(B1))
    gT <- weat(googlenews, S1, append(T1, garbage), A1, B1, verbose = FALSE)
    expect_length(gT$S_diff, length(S1))
    expect_length(gT$T_diff, length(T1))
    expect_length(gT$S_words, length(S1))
    expect_length(gT$T_words, length(T1))
    expect_length(gT$A_words, length(A1))
    expect_length(gT$B_words, length(B1))
    gA <- weat(googlenews, S1, T1, append(A1, garbage), B1, verbose = FALSE)
    expect_length(gT$S_diff, length(S1))
    expect_length(gT$T_diff, length(T1))
    expect_length(gT$S_words, length(S1))
    expect_length(gT$T_words, length(T1))
    expect_length(gT$A_words, length(A1))
    expect_length(gT$B_words, length(B1))
    gB <- weat(googlenews, S1, T1, A1, append(B1, garbage), verbose = FALSE)
    expect_length(gT$S_diff, length(S1))
    expect_length(gT$T_diff, length(T1))
    expect_length(gT$S_words, length(S1))
    expect_length(gT$T_words, length(T1))
    expect_length(gT$A_words, length(A1))
    expect_length(gT$B_words, length(B1))
})
