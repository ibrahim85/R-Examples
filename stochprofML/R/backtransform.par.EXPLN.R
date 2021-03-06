backtransform.par.EXPLN <-
function(this.par,m,fix.mu,fixed.mu) {
# Transforms the parameter from all real numbers back to its original scale, i.e.
#
# INPUT:
#    this.par=(w1,w2,...w_(T-1),mu,log(sigma),log(lambda))
# with 
#    w_i = logit((p_1+...+p_i)/(p_1+...+p_(i+1))) for i=1,...,T-1
# and
#    lambda = (lambda_1,lambda_2,...,lambda_m)
# where mu and lambda are typically vectors.   
#
#
# OUTPUT:
#    this.theta=(p1,p2,...,p_(T-1),mu,sigma,lambda)
#
#
# - this.par is the parameter in the unrestricted space
# - m is the number of genes analyzed
# - fix.mu is a Boolean indicating whether the parameter mu is kept fixed
# - if fix.mu==T, mu is fixed to fixed.mu. In that case, this.par is lower-dimensional,
#   i.e. it does not contain mu. The output is full-dimensional 
     
     
   # determine number of types of cells
   if (length(this.par)==m) {
      TY <- 1
   }
   else if (!fix.mu) {
      TY <- length(this.par)/(m+1)
   }
   else {
      TY <- length(this.par)-m
   }
   
   #######
   ## p ##
   #######
   
   if (TY>1) {
      this.w <- this.par[1:(TY-1)]
      ## vector with sums of the probabilities
      p.sums <- rep(NA,TY-1)
      p.sums[length(p.sums)] <- stochprof.expit(this.w[length(this.w)])
      if (TY>2) {
         for (i in (length(p.sums)-1):1) {
            p.sums[i] <- stochprof.expit(this.w[i]) * p.sums[i+1]
         }
      }
      ## vector with probabilities
      if (TY>2) {
         p.sums.shifted <- c(0,p.sums[1:(length(p.sums)-1)])
         this.p <- p.sums - p.sums.shifted
      }
      else {
         this.p <- p.sums
      }
   }
   else {
      this.p <- NULL
   }
               
   ######
   # mu #
   ######
   if (TY==1) {
      this.mu <- NULL
   }
   else if (!fix.mu) {
      this.mu <- this.par[TY:((m+1)*(TY-1))]
   }
   else {
      this.mu <- fixed.mu
   }
   
   #########
   # sigma #
   #########
   if (TY==1) {
      this.sigma <- NULL
   }
   else if (!fix.mu) {
      this.sigma <- exp(this.par[(m+1)*(TY-1)+1])
   }
   else {
      this.sigma <- exp(this.par[TY])
   }
   
   ##########
   # lambda #
   ##########
   if (TY==1) {
      this.lambda <- exp(this.par[1:length(this.par)])
   }
   else {
      this.lambda <- exp(this.par[length(this.par)-m+(1:m)])
   }
   
   # put together
   this.theta <- c(this.p,this.mu,this.sigma,this.lambda)
   
   return(this.theta)
}
