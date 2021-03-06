library("matrixStats")

allocMatrix_R <- function(nrow, ncol, value=NA) {
  matrix(data=value, nrow=nrow, ncol=ncol)
} # allocMatrix_R()

values <- list(
  -1L, 0L, +1L, NA_integer_, .Machine$integer.max,
  -1, 0, +1, NA_real_, NaN, -Inf, +Inf, .Machine$double.xmin, .Machine$double.xmax, .Machine$double.eps, .Machine$double.neg.eps,
  FALSE, TRUE, NA
)

nrow <- 5L
ncol <- 10L
for (value in values) {
  X0 <- allocMatrix_R(nrow, ncol, value=value)
  X <- allocMatrix(nrow, ncol, value=value)
  str(list(nrow=nrow, ncol=ncol, value=value, X=X, X0=X0))
  stopifnot(identical(X,X0))
}

