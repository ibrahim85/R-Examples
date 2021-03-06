library(ctsem)
library(testthat)

context("knownFits")



#anomauth
test_that("time calc", {

  data(AnomAuth)
  AnomAuthmodel<-ctModel(LAMBDA=matrix(c(1, 0, 0, 1), nrow=2, ncol=2),  
    n.latent=2,n.manifest=2, 
    MANIFESTVAR=diag(0,2),
    Tpoints=5)

  AnomAuthfit<-ctFit(AnomAuth, AnomAuthmodel)
  
  
  expect_equal(23415.929,AnomAuthfit$mxobj$output$Minus2LogLikelihood)
  

})

#anomauth with trait asymptotic vs standard param comparisons
test_that("time calc", {
  
  data(AnomAuth)
  AnomAuthmodel<-ctModel(LAMBDA=matrix(c(1, 0, 0, 1), nrow=2, ncol=2),  
    n.latent=2,n.manifest=2, 
    MANIFESTVAR=diag(0,2),
    TRAITVAR='auto',
    Tpoints=5)
  
  AnomAuthfit1<-ctFit(AnomAuth, AnomAuthmodel,asymptotes=FALSE,carefulFit=F,objective='mxFIML')
  AnomAuthfit2<-ctFit(AnomAuth, AnomAuthmodel,asymptotes=TRUE)
  
  
  expect_equal(AnomAuthfit2$mxobj$output$Minus2LogLikelihood,AnomAuthfit1$mxobj$output$Minus2LogLikelihood)
  
  summ1<-summary(AnomAuthfit1,verbose=TRUE)
  summ2<-summary(AnomAuthfit2,verbose=TRUE)
  
  expect_equal(summ1$ctparameters[,1:2],summ2$ctparameters[,1:2],tolerance = .001)
  
})


test_that("time calc", {
data("Oscillating")

inits <- c(-38, -.5, 1, 1, .1, 1, 0, .9)
names(inits) <- c("crosseffect","autoeffect", "diffusion",
  "T0var11", "T0var21", "T0var22","m1", "m2")

oscillatingm <- ctModel(n.latent = 2, n.manifest = 1, Tpoints = 11, 
  MANIFESTVAR = matrix(c(0), nrow = 1, ncol = 1), 
  LAMBDA = matrix(c(1, 0), nrow = 1, ncol = 2),
  T0MEANS = matrix(c('m1', 'm2'), nrow = 2, ncol = 1), 
  T0VAR = matrix(c("T0var11", "T0var21", 0, "T0var22"), nrow = 2, ncol = 2),
  DRIFT = matrix(c(0, "crosseffect", 1, "autoeffect"), nrow = 2, ncol = 2), 
  CINT = matrix(0, ncol = 1, nrow = 2),
  DIFFUSION = matrix(c(0, 0, 0, "diffusion"), nrow = 2, ncol = 2),
  startValues = inits)

oscillatingf <- ctFit(Oscillating, oscillatingm, objective='mxFIML',carefulFit = FALSE)

expect_equal(-3461.936,oscillatingf$mxobj$output$Minus2LogLikelihood,tolerance=.001)


})