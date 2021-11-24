## 3 repro cases

test_that("WEAT ES calc", {
    S1 <- c("math", "algebra", "geometry", "calculus", "equations", "computation", "numbers", "addition")
    T1 <- c("poetry", "art", "dance", "literature", "novel", "symphony", "drama", "sculpture")
    A1 <- c("male", "man", "boy", "brother", "he", "him", "his", "son")
    B1 <- c("female", "woman", "girl", "sister", "she", "her", "hers", "daughter")
    sw <- weat(glove_math, S1, T1, A1, B1)
    expect_true("sweater" %in% class(sw))
    expect_true("weat" %in% class(sw))
    tolerance <- 0.001
    expect_true(abs(weat_es(sw) - 1.055) < tolerance)
    expect_true(abs(weat_es(sw, standardize = FALSE) - 0.0248) < tolerance)
    expect_true(abs(weat_es(sw, r = TRUE) - 0.491) < tolerance)
})

test_that("RND ES calc, garg", {
    S2 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
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
    A2 <- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
    B2 <- c("she", "daughter", "hers", "her", "mother", "woman", "girl", 
"herself", "female", "sister", "daughters", "mothers", "women", 
"girls", "females", "sisters", "aunt", "aunts", "niece", "nieces"
)
    garg_f1 <- rnd(googlenews, S2, A2, B2)
    expect_true("sweater" %in% class(garg_f1))
    expect_true("rnd" %in% class(garg_f1))
    tolerance <- 0.001
    expect_true(abs(rnd_es(garg_f1) - (-6.3415)) < tolerance)
})

test_that("RNSB ES Calc", {
    skip_on_cran()
    skip_if_not(file.exists("../testdata/glove_sweeney.rda"))
    load("../testdata/glove_sweeney.rda")
    load("../testdata/bing_pos.rda")
    load("../testdata/bing_neg.rda")
    S3 <- c("swedish", "irish", "mexican", "chinese", "filipino",
       "german", "english", "french", "norwegian", "american",
       "indian", "dutch", "russian", "scottish", "italian")
    sn <- rnsb(glove_sweeney, S3, bing_pos, bing_neg)
    expect_true("sweater" %in% class(sn))
    expect_true("rnsb" %in% class(sn))
    tolerance <- 0.001
    expect_true(abs(rnsb_es(sn) - (0.6225)) < tolerance)
})


## Non-repo

test_that("Mac ES calc", {
    S4 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
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
    A4 <- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
    res <- mac(googlenews, S4, A4)
    expect_true("sweater" %in% class(res))
    expect_true("mac" %in% class(res))
    tolerance <- 0.001
    expect_true(abs(mac_es(res) - (0.13758)) < tolerance)
})

## Reject cases

test_that("reject *_es", {
    S5 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer", 
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
    A5 <- c("he", "son", "his", "him", "father", "man", "boy", "himself", 
"male", "brother", "sons", "fathers", "men", "boys", "males", 
"brothers", "uncle", "uncles", "nephew", "nephews")
    mac_res <- mac(googlenews, S5, A5)
    expect_error(mac_es())
    expect_error(mac_es(garg_f1))
    expect_error(rnd_es())
    expect_error(rnd_es(mac_res))
    expect_error(rnsb_es(mac_res))
    expect_error(weat_es(mac_res))
    expect_error(ect_es(mac_res))
})
