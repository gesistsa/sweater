% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ect.R
\name{ect}
\alias{ect}
\title{Embedding Coherence Test}
\usage{
ect(w, S_words, A_words, B_words, verbose = FALSE)
}
\arguments{
\item{w}{a numeric matrix of word embeddings, e.g. from \code{\link[=read_word2vec]{read_word2vec()}}}

\item{S_words}{a character vector of the first set of target words. In an example of studying gender stereotype, it can include occupations such as programmer, engineer, scientists...}

\item{A_words}{a character vector of the first set of attribute words. In an example of studying gender stereotype, it can include words such as man, male, he, his.}

\item{B_words}{a character vector of the second set of attribute words. In an example of studying gender stereotype, it can include words such as woman, female, she, her.}

\item{verbose}{logical, whether to display information}
}
\value{
A list with class \code{"ect"} containing the following components:
\itemize{
\item \verb{$A_words} the input A_words
\item \verb{$B_words} the input B_words
\item \verb{$S_words} the input S_words
\item \verb{$u_a} Cosine similarity between each word vector of S_words and average vector of A_words
\item \verb{$u_b} Cosine similarity between each word vector of S_words and average vector of B_words
}
}
\description{
This function estimate the Embedding Coherence Test (ECT) of word embeddings (Dev & Philips, 2019). If possible, please use \code{\link[=query]{query()}} instead.
}
\examples{
data(googlenews)
S1 <- c("janitor", "statistician", "midwife", "bailiff", "auctioneer",
"photographer", "geologist", "shoemaker", "athlete", "cashier", "dancer",
"housekeeper", "accountant", "physicist", "gardener", "dentist", "weaver",
"blacksmith", "psychologist", "supervisor", "mathematician", "surveyor",
"tailor", "designer", "economist", "mechanic", "laborer", "postmaster",
"broker", "chemist", "librarian", "attendant", "clerical", "musician",
"porter", "scientist", "carpenter", "sailor", "instructor", "sheriff",
"pilot", "inspector", "mason", "baker", "administrator", "architect",
"collector", "operator", "surgeon", "driver", "painter", "conductor",
"nurse", "cook", "engineer", "retired", "sales", "lawyer", "clergy",
"physician", "farmer", "clerk", "manager", "guard", "artist", "smith",
"official", "police", "doctor", "professor", "student", "judge",
"teacher", "author", "secretary", "soldier")
A1 <- c("he", "son", "his", "him", "father", "man", "boy", "himself",
"male", "brother", "sons", "fathers", "men", "boys", "males", "brothers",
"uncle", "uncles", "nephew", "nephews")
B1 <- c("she", "daughter", "hers", "her", "mother", "woman", "girl",
"herself", "female", "sister", "daughters", "mothers", "women", "girls",
"females", "sisters", "aunt", "aunts", "niece", "nieces")
garg_f1 <- ect(googlenews, S1, A1, B1)
plot_ect(garg_f1)
}
\references{
Dev, S., & Phillips, J. (2019, April). \href{https://proceedings.mlr.press/v89/dev19a.html}{Attenuating bias in word vectors.} In The 22nd International Conference on Artificial Intelligence and Statistics (pp. 879-887). PMLR.
}
\seealso{
\code{\link[=ect_es]{ect_es()}} can be used to obtain the effect size of the test.
\code{\link[=plot_ect]{plot_ect()}} can be used to visualize the result.
}
