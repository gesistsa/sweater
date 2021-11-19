## Resubmission (18-Nov-2021)

    Please write TRUE and FALSE instead of T and F. (Please don't use 'T' or
    'F' as vector names.), e.g.:
    man/query.Rd:
     query(w, S, T, A, B, method = "guess", verbose = FALSE, ...)
    man/weat.Rd:
     weat(w, S, T, A, B, verbose = FALSE)

It has been fixed by changing all S, T, A, B to S_words, T_words, A_words and B_words respectively.


    Please add \value to .Rd files regarding exported methods and explain
    the functions results in the documentation. Please write about the
    structure of the output (class) and also what the output means. (If a
    function does not return a value, please document that too, e.g.
    \value{No return value, called for side effects} or similar)
    Missing Rd-tags:
	weat_es.Rd: \value

The missing \value for weat_es.Rd has been added.


