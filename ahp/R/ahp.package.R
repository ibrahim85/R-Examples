#' ahp AHP (Analytic Hierarchy Process) Modeling for R
#' 
#' AHP (Analytic Hierarchy Process) is a decision making framework developed by Thomas Saaty.
#' This package lets you model and analyse complex decision making problems according to the AHP framework.  
#' 
#' The basic workflow with this package is:
#' 1. specify your ahp problem in an ahp file. See \code{vignette("file-format", package = "ahp")} for details
#' 2. load ahp file, using \code{\link{Load}}
#' 3. calculate model, using \code{\link{Calculate}}
#' 4. visualize the ahp model using \code{\link{Visualize}}
#' 5. output model analysis, either using \code{\link{Analyze}} or using \code{\link{AnalyzeTable}}
#' 
#' For more information, see the package vignette using \code{vignette("examples", package = "ahp")}. To learn
#' the details about the ahp file format, type \code{vignette("file-format", package = "ahp")}
#' 
#' @examples
#' library(ahp)
#' #list example files provided by the package
#' list.files(system.file("extdata", package="ahp"))
#' #load a specific example
#' ahpFile <- system.file("extdata", "car.ahp", package="ahp")
#' carAhp <- Load(ahpFile)
#' Calculate(carAhp)
#' Analyze(carAhp)
#' AnalyzeTable(carAhp)
#' 
#' #the vacation.ahp file provides an example with multiple decision makers
#' ahpFile <- system.file("extdata", "vacation.ahp", package="ahp")
#' vacationAhp <- Load(ahpFile)
#' Calculate(vacationAhp)
#' Visualize(vacationAhp)
#' Analyze(vacationAhp, decisionMaker = "Dad")
#' AnalyzeTable(vacationAhp, decisionMaker = "Mom")
#' AnalyzeTable(vacationAhp, 
#'              decisionMaker = "Kid",
#'              variable = "priority", 
#'              sort = "orig", 
#'              pruneFun = function(node, dm) PruneByCutoff(node, dm, minWeight = 0.1))
#'
#' @docType package
#' @name ahp
NULL