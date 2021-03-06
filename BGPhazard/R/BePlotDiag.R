BePlotDiag <-
function(M, variable = "Pi", pos = 1) {
  if (variable != "Pi" && variable != "u" && variable != "c" && variable 
      != "epsilon") {
    stop ("Error: 'variable' must be either 'Pi', 'u', 'c' or 'epsilon'.")
  }
  MAT <- M$summary
  K <- M$K
  tol = .Machine$double.eps ^ 0.5
  if (pos < 0 || pos > K || abs(pos - round(pos)) > tol ) {
    stop ("Invalid position.")
  }
  if ((variable == "c" || variable == "u") && pos > K - 1) {
    stop ("Invalid position.")
  }
  if (length(M$summary[, 1]) == (3 * K - 2) && variable == "epsilon"){
    stop("Plots for 'epsilon' are not available.")
  }
  if (variable == "epsilon" && pos != 1) {
    warning("'epsilon' has only one entry (1). Graphics shown for epsilon_1.")
    pos <- 1
  }
  if (variable  ==  "Pi") {
    a <- 0
  }
  if (variable  ==  "u") {
    a <- K
    if (mean(MAT[pos + a, ]) == 0) {
      stop("Plots for 'u' are not available.")
    }
  }
  if (variable == "c") {
    a <- 2 * K - 1
    if (mean(MAT[pos + a, ]) == 0) {
      stop ("Plots for 'c' are not available.")
    }
  }
  if (variable == "epsilon") {
    a <- 3 * K - 2
  }
  if (var(MAT[pos + a, ]) == 0) {
    stop ("Plots are not available.")
  }  
  par(mfrow=c(2, 2))
  ## Trace
  plot(MAT[pos + a, ], type = "l", xlab = "Iteration", ylab = "", 
       col = "slateblue4")
  mtext("Trace", line = 1, ps = 2, cex = 1, font = 1)
  ## Ergodic Mean
  p.erg <- cumsum(MAT[pos + a, ]) / 1:length(MAT[1, ])
  plot(p.erg, type = "l", xlab = "Iteration", ylab = "", col = "slateblue4")
  mtext("Ergodic mean", line = 1, ps = 2, cex = 1, font = 1)
  ## Autocorrelation function
  acf(MAT[pos + a, ], main = "", ylab = "", lwd = 2)
  mtext("Autocorrelation function", line = 1, ps = 2, cex = 1, font = 1)
  ## Histogram
  hist(MAT[pos + a, ], main = "", xlab = "", col = "lightblue", freq = FALSE)
  mtext("Histogram", line = 1, ps = 2, cex = 1, font = 1)
  par(mfrow = c(1, 1))
  mtext(paste(variable, pos), line = 2.5, ps = 2, cex = 1.25, font = 2)
}
