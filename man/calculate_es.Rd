% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{calculate_es}
\alias{calculate_es}
\title{Calculate the effect size of a query}
\usage{
calculate_es(x, ...)
}
\arguments{
\item{x}{an S3 object returned from a query, either by the function \code{\link[=query]{query()}} or underlying functions such as \code{\link[=mac]{mac()}}}

\item{...}{additional parameters for the effect size functions
\itemize{
\item \code{r} for \code{weat}: a boolean to denote whether convert the effect size to biserial correlation coefficient.
\item \code{standardize} for \code{weat}: a boolean to denote whether to correct the difference by the standard division. The standardized version can be interpreted the same way as Cohen's d.
}}
}
\value{
effect size
}
\description{
This function calculates the effect of a query.
}
\details{
The following methods are supported.
\itemize{
\item \code{mac} mean cosine distance value. The value makes sense only for comparison (e.g. before and after debiasing). But a lower value indicates greater association between the target words and the attribute words.
\item \code{rnd} sum of all relative norm distances. It equals to zero when there is no bias.
\item \code{rnsb} Kullback-Leibler divergence of the predicted negative probabilities, P, from the uniform distribution. A lower value indicates less bias.
\item \code{ect} Spearman Coefficient of an Embedding Coherence Test. The value ranges from -1 to +1 and a larger value indicates less bias.
\item \code{weat} The standardized effect size (default) can be interpreted the same way as Cohen's D.
}
}
\references{
Caliskan, A., Bryson, J. J., & Narayanan, A. (2017). Semantics derived automatically from language corpora contain human-like biases. Science, 356(6334), 183-186. \doi{10.1126/science.aal4230}

Dev, S., & Phillips, J. (2019, April). \href{https://proceedings.mlr.press/v89/dev19a.html}{Attenuating bias in word vectors.} In The 22nd International Conference on Artificial Intelligence and Statistics (pp. 879-887). PMLR.

Garg, N., Schiebinger, L., Jurafsky, D., & Zou, J. (2018). Word embeddings quantify 100 years of gender and ethnic stereotypes. Proceedings of the National Academy of Sciences, 115(16), E3635-E3644. \doi{10.1073/pnas.1720347115}

Manzini, T., Lim, Y. C., Tsvetkov, Y., & Black, A. W. (2019). \href{https://arxiv.org/abs/1904.04047}{Black is to criminal as caucasian is to police: Detecting and removing multiclass bias in word embeddings.} arXiv preprint arXiv:1904.04047.

Sweeney, C., & Najafian, M. (2019, July). \href{https://aclanthology.org/P19-1162/}{A transparent framework for evaluating unintended demographic bias in word embeddings.} In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 1662-1667).
}
\seealso{
\code{\link[=weat_es]{weat_es()}}, \code{\link[=mac_es]{mac_es()}}, \code{\link[=rnd_es]{rnd_es()}}, \code{\link[=rnsb_es]{rnsb_es()}}, \code{\link[=ect_es]{ect_es()}}
}
