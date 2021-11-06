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

S <- sample(all_s, sample(2:10))
T <- sample(all_s, sample(2:10))
A <- sample(all_a, sample(2:10))
B <- sample(all_b, sample(2:10))
garbage <- "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ"

test_that("mac add na", {
    expect_length(mac(googlenews, append(S, garbage), A)$P, length(S))
    expect_output(mac(googlenews, append(S, garbage), A, verbose = TRUE))
    expect_length(mac(googlenews, append(S, garbage), A)$S, length(S))
    expect_length(mac(googlenews, S, append(A, garbage))$P, length(S))
    expect_length(mac(googlenews, S, append(A, garbage))$A, length(A))
    expect_output(mac(googlenews, S, append(A, garbage), verbose = TRUE))    
})

test_that("rnd add na", {
    expect_length(rnd(googlenews, append(S, garbage), A, B)$P, length(S))
    expect_output(rnd(googlenews, append(S, garbage), A, B, verbose = TRUE))
    expect_length(rnd(googlenews, append(S, garbage), A, B)$S, length(S))
    expect_length(rnd(googlenews, S, append(A, garbage), B)$P, length(S))
    expect_length(rnd(googlenews, S, append(A, garbage), B)$A, length(A))
    expect_output(rnd(googlenews, S, append(A, garbage), B, verbose = TRUE))
    expect_length(rnd(googlenews, S, A, append(B, garbage))$P, length(S))
    expect_length(rnd(googlenews, S, A, append(B, garbage))$B, length(B))
    expect_output(rnd(googlenews, S, A, append(B, garbage), verbose = TRUE))
})

test_that("semaxis add na", {
    expect_length(semaxis(googlenews, append(S, garbage), A, B)$P, length(S))
    expect_output(semaxis(googlenews, append(S, garbage), A, B, verbose = TRUE))
    expect_length(semaxis(googlenews, append(S, garbage), A, B)$S, length(S))
    expect_length(semaxis(googlenews, S, append(A, garbage), B)$P, length(S))
    expect_length(semaxis(googlenews, S, append(A, garbage), B)$A, length(A))
    expect_output(semaxis(googlenews, S, append(A, garbage), B, verbose = TRUE))
    expect_length(semaxis(googlenews, S, A, append(B, garbage))$P, length(S))
    expect_length(semaxis(googlenews, S, A, append(B, garbage))$B, length(B))
    expect_output(semaxis(googlenews, S, A, append(B, garbage), verbose = TRUE))
})

test_that("nas add na", {
    expect_length(nas(googlenews, append(S, garbage), A, B)$P, length(S))
    expect_output(nas(googlenews, append(S, garbage), A, B, verbose = TRUE))
    expect_length(nas(googlenews, append(S, garbage), A, B)$S, length(S))
    expect_length(nas(googlenews, S, append(A, garbage), B)$P, length(S))
    expect_length(nas(googlenews, S, append(A, garbage), B)$A, length(A))
    expect_output(nas(googlenews, S, append(A, garbage), B, verbose = TRUE))
    expect_length(nas(googlenews, S, A, append(B, garbage))$P, length(S))
    expect_length(nas(googlenews, S, A, append(B, garbage))$B, length(B))
    expect_output(nas(googlenews, S, A, append(B, garbage), verbose = TRUE))
})

test_that("weat add na", {
    expect_output(weat(googlenews, append(S, garbage), T, A, B, verbose = TRUE))
    expect_output(weat(googlenews, S, append(T, garbage), A, B, verbose = TRUE))
    expect_output(weat(googlenews, S, T, append(A, garbage), B, verbose = TRUE))
    expect_output(weat(googlenews, S, T, A, append(B, garbage), verbose = TRUE))
    ### res <- list(S_diff = S_diff, T_diff = T_diff, S = S, T = T, A = A, B = B)
    gS <- weat(googlenews, append(S, garbage), T, A, B, verbose = FALSE)
    expect_length(gS$S_diff, length(S))
    expect_length(gS$T_diff, length(T))
    expect_length(gS$S, length(S))
    expect_length(gS$T, length(T))
    expect_length(gS$A, length(A))
    expect_length(gS$B, length(B))
    gT <- weat(googlenews, S, append(T, garbage), A, B, verbose = FALSE)
    expect_length(gT$S_diff, length(S))
    expect_length(gT$T_diff, length(T))
    expect_length(gT$S, length(S))
    expect_length(gT$T, length(T))
    expect_length(gT$A, length(A))
    expect_length(gT$B, length(B))
    gA <- weat(googlenews, S, T, append(A, garbage), B, verbose = FALSE)
    expect_length(gA$S_diff, length(S))
    expect_length(gA$T_diff, length(T))
    expect_length(gA$S, length(S))
    expect_length(gA$T, length(T))
    expect_length(gA$A, length(A))
    expect_length(gA$B, length(B))
    gB <- weat(googlenews, S, T, A, append(B, garbage), verbose = FALSE)
    expect_length(gB$S_diff, length(S))
    expect_length(gB$T_diff, length(T))
    expect_length(gB$S, length(S))
    expect_length(gB$T, length(T))
    expect_length(gB$A, length(A))
    expect_length(gB$B, length(B))
})
