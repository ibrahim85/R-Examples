# This file was generated by Rcpp::compileAttributes
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

generate_ngrams_batch <- function(documents_list, ngram_min, ngram_max, stopwords = character(), ngram_delim = " ") {
    .Call('tokenizers_generate_ngrams_batch', PACKAGE = 'tokenizers', documents_list, ngram_min, ngram_max, stopwords, ngram_delim)
}

skip_ngrams <- function(words, n, k) {
    .Call('tokenizers_skip_ngrams', PACKAGE = 'tokenizers', words, n, k)
}

