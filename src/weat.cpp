#include <Rcpp.h>
#include <algorithm>
using namespace Rcpp;

// [[Rcpp::export]]
double raw_cosine(const NumericVector& x1, const NumericVector& x2) {
    unsigned int v_len = x1.size();
    double dot = 0.0, deno_a = 0.0, deno_b = 0.0;
    for(unsigned int i = 0; i < v_len; i++) {
        dot += x1[i] * x2[i];
        deno_a += x1[i] * x1[i];
        deno_b += x2[i] * x2[i];
    }
    return dot / (sqrt(deno_a) * sqrt(deno_b));
}

NumericVector cpp_take(NumericMatrix& glove_mat, const String& word, CharacterVector& rn) {
    int cur_index = 0;
    for (CharacterVector::iterator i = rn.begin(); i != rn.end(); ++i) {
        if (word == *i) {
            return glove_mat(cur_index, _);
        }
        cur_index += 1;
    }
    return NumericVector::create(NA_REAL);
}

double cosine(const String& word, NumericVector& v1, NumericMatrix& glove_mat, CharacterVector& rn) {
    return raw_cosine(cpp_take(glove_mat, word, rn), v1);
}

double cos_diff(const String& c, CharacterVector& A, NumericMatrix& glove_mat,  CharacterVector& rn) {
    NumericVector v1 = cpp_take(glove_mat, c, rn);
    double total_cosine = 0.0;
    for (CharacterVector::iterator i = A.begin(); i != A.end(); ++i) {
        total_cosine += cosine(*i, v1, glove_mat, rn);
    }
    return total_cosine / A.size();
}

// [[Rcpp::export]]
double cpp_g(const String& c, CharacterVector& A, CharacterVector& B, NumericMatrix& glove_mat) {
    CharacterVector rn = rownames(glove_mat);
    return cos_diff(c, A, glove_mat, rn) - cos_diff(c, B, glove_mat, rn);
}

// [[Rcpp::export]]
NumericVector cpp_bweat(CharacterVector& C, CharacterVector& A, CharacterVector& B, NumericMatrix& glove_mat) {
    int n_C = C.size();
    NumericVector res(n_C);
    for (int i = 0; i < n_C; ++i) {
        if((i % 10000) == 0){
            Rcpp::checkUserInterrupt();
        }
        res[i] = cpp_g(C[i], A, B, glove_mat);
    }
    return res;
}

// [[Rcpp::export]]
NumericVector cpp_mac(CharacterVector& C, CharacterVector& A, NumericMatrix& glove_mat) {
    int n_C = C.size();
    NumericVector res(n_C);
    CharacterVector rn = rownames(glove_mat);
    for (int i = 0; i < n_C; ++i) {
        if((i % 10000) == 0){
            Rcpp::checkUserInterrupt();
        }
        res[i] = cos_diff(C[i], A, glove_mat, rn);
    }
    return res;
}

// [[Rcpp::export]]
NumericVector cpp_nas(String& c, CharacterVector& A, NumericMatrix& glove_mat) {
    CharacterVector rn = rownames(glove_mat);
    int n_A = A.size();
    NumericVector res(n_A);
    NumericVector vc = cpp_take(glove_mat, c, rn);
    for (int i = 0; i < n_A; ++i) {
        if((i % 10000) == 0){
            Rcpp::checkUserInterrupt();
        }
        NumericVector va = cpp_take(glove_mat, A[i], rn);
        res[i] = raw_cosine(vc, va);
    }
    return res;
}

// Statistical test

// double cpp_exact(NumericVector union_diff, double test_stat, int s_length) {
//     long long int iter = 0;
//     long long int pos = 0;
//     int union_length = union_diff.size();
//     NumericVector union_here = clone(union_diff);
//     std::sort(union_here.begin(), union_here.end());
//     double a = 0.0;
//     double b = 0.0;
//     double c = 0.0;
//     do {
// 	Rcpp::checkUserInterrupt();
// 	iter += 1;
// 	for (int j = 0; j < s_length; j ++) {
// 	    a += union_here[j];
// 	}
// 	for (int k = s_length; k < union_length; k++) {
// 	    b += union_here[k];
// 	}
// 	c = (a / s_length) - (b / (union_length - s_length));
// 	if (c > test_stat) {
// 	    pos += 1;
// 	}
//     } while (std::next_permutation(union_here.begin(), union_here.end()));
//     double ans = pos / (iter * 1.0);
//     return ans;
// }
