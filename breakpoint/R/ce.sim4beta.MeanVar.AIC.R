ce.sim4beta.MeanVar.AIC <-
function(N, data, h, L0, L, M, Melite, eps, a){
    
    if (N == 0){
#       seql <- c(1, L)
#       LL.full <- loglikMeanVarNormal(seql, data, h)
#       AIC.value <- -2*LL.full + 4*(N + 1)
      #       #AIC.val <- -2*LL.full + 4* (N + 1)
      #       return(list(locis = c(1, (L + 1)), AIC.Val = AIC.val, LogLike = LL.full))
      #       rm(LL.full, AIC.val)
      
      #mAIC.full <- mAIC(seql, data, 0, L, h)    
#       return(list(loci = c(1, (L + 1)), AIC.Val = AIC.value, LogLike = LL.full))
#       rm(AIC.value, LL.full, seql)
      LL.full <- loglik.MeanVarNormal(1, (L + 1), data, h)[[1]]
      AIC.full <- AIC.MeanVarNormal(LL.full, 0, L)
      return(list(loci = c(1, (L + 1)), AIC.Val = AIC.full, LogLike = LL.full))
      
    } else {
      
      ########################Parameter initialization######################################################  
      new.para <- array(1, dim = c(2, N))
      ######################################################################################################  
#      llVal <- c()
#      aic <- c()
      k <- 0
      repeat
      {
        k <- k + 1
        ch <- array(0, dim =c (M, (N + 2)))       
        ch[, 1] <- c(1)                    
        ch[, (N + 2)] <- c(L + 1)    
        ch[, (2 : (N + 1))] <- apply(new.para, 2, betarand, L0, L, M)   
        ch <- t(apply(ch, 1, sort))     
        
#         LL.full <- apply(ch, 1, loglikMeanVarNormal, data, h)
#         AIC.val <- -2*LL.full + 4*(N + 1)
        LL.full <- apply(ch, 1, llhood.MeanVarNormal, data, h)
        AIC.val <- apply(as.data.frame(LL.full), 1, AIC.MeanVarNormal, N, L) 
        
        ch <- cbind(ch, LL.full, AIC.val)
        ch <- ch[order(ch[, (N + 4)], decreasing = FALSE), ]  
        
        melitesmpl <- ch[1 : Melite, ]                     
        # llVal[k] <- melitesmpl[1, (N + 3)] 
#        llVal <- melitesmpl[1, (N + 3)] 
#        aic[k] <- melitesmpl[1, (N + 4)] 
#        aic <- melitesmpl[1, (N + 4)] 
        
        newpar.n <- array(0, dim = c(2, N))
        newpar.n[1, ] <- apply(as.matrix(melitesmpl[, (2 :(N + 1))]), 2, mean)
        newpar.n[2, ] <- apply(as.matrix(melitesmpl[, (2 :(N + 1))]), 2, var)   
        
        newpar.new <- array(0, dim = c(2, N))
        newpar.new[1, ] <- apply(newpar.n, 2, fun.alpha, L0, L)
        newpar.new[2, ] <- apply(newpar.n, 2, fun.beta, L0, L)
        new.para <- a * newpar.new + (1 - a) * new.para
        
        mad <- apply(as.matrix(melitesmpl[, (2 : (N + 1))]), 2, mad)
        
        if(max(mad) <= eps){break}
      }
#      return(list(loci = ch[1, (1 : (N + 2))], AIC.Val = aic[k], LogLike = llVal[k]))
      return(list(loci = ch[1, (1 : (N + 2))], AIC.Val = melitesmpl[1, (N + 4)][[1]], LogLike = melitesmpl[1, (N + 3)][[1]]))
    }
  }
