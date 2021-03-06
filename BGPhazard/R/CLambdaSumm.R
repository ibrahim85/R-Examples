CLambdaSumm <-
function(M, confidence = 0.95) {
  if (confidence <= 0 || confidence >= 1) {
    stop ("Invalid parameter: confidence must be between 0 and 1.")
  }
  K <- M$K
  tao <- M$tao
  iterations <- M$iterations
  S <- M$S
  H <- M$H
  SUM.h <- matrix(0, ncol = 5, nrow = K)
  SUM.S <- matrix(0, ncol = 5, nrow = 101)
  SUM.H <- matrix(0, ncol = 5, nrow = 101)
  pr <- (1 - confidence) / 2
  for(k in 1:K) {
    SUM.h[k, 1] <- k
    SUM.h[k, 2] <- mean(M$summary[k, ])
    SUM.h[k, 3] <- quantile(M$summary[k, ], probs = pr)
    SUM.h[k, 4] <- quantile(M$summary[k, ], probs = 0.5)
    SUM.h[k, 5] <- quantile(M$summary[k, ], probs = 1 - pr)
  }
  colnames(SUM.h) <- c("k", "mean(lambda)",  pr, 0.50, 1 - pr)
  for(i in 1:101) {
    SUM.S[i, 1] <- S[i, 1]
    SUM.S[i, 2] <- mean(S[i, 2:iterations])
    SUM.S[i, 3] <- quantile(S[i, 2:iterations], probs = pr)
    SUM.S[i, 4] <- quantile(S[i, 2:iterations], probs = 0.5)
    SUM.S[i, 5] <- quantile(S[i, 2:iterations], probs = 1 - pr)
  }
  colnames(SUM.S) <- c("t", "S^(t)",  pr, 0.50, 1 - pr)
  for(i in 1:101) {
    SUM.H[i, 1] <- H[i, 1]
    SUM.H[i, 2] <- mean(H[i, 2:iterations])
    SUM.H[i, 3] <- quantile(H[i, 2:iterations], probs = pr)
    SUM.H[i, 4] <- quantile(H[i, 2:iterations], probs = 0.5)
    SUM.H[i, 5] <- quantile(H[i, 2:iterations], probs = 1 - pr)
  }
  colnames(SUM.S) <- c("t", "H^(t)",  pr, 0.50, 1 - pr)
  out <- list(SUM.h = SUM.h, SUM.S = SUM.S, SUM.H = SUM.H)
}
