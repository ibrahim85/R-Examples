#' @docType data
#' @name NIRsoil
#' @aliases NIRsoil
#' @title NIRSoil
#' @format A data frame of 825 observations and 5 variables
#' @usage
#' data(NIRsoil)
#' @description
#' Soil spectral library of the \sQuote{Chimiometrie 2006} challenge. 
#' The database contains absorbance spectra of dried and sieved soil samples measured between 1100 nm 
#' and 2498 nm at 2 nm interval. The soil samples come from agricultural fields collected from all over
#' the Walloon region in Belgium. Three parameters are associated with the spectral library: Nt 
#' (Total Nitrogen in g/Kg of dry soil), CEC (Cation Exchange Capacity in meq/100 g of dry soil) 
#' and Ciso (Carbon in g/100 g of dry soil). Carbon content has been measured following the ISO14235 method.
#' @details
#' The dataset includes 618 training and 207 test samples with 5 variables: Nt (Total Nitrogen), Ciso (Carbon), 
#' CEC (Cation Exchange Capacity), train (\code{vector} of {0,1} indicating training (1) and validation (0) samples)
#' and spc (a \code{matrix} with absorbance NIR data and band positions as \code{colnames}).
#' Nt, Ciso and CEC have respectively 22 \%, 11 \% and 46 \% of the observations with missing values.
#' @source Pierre Dardenne from Walloon Agricultural Research Centre, Belgium.
#' @references 
#' Fernandez Pierna, J.A., and Dardenne, P., 2008. Soil parameter quantification by NIRS as a Chemometric challenge at 'Chimiometrie 2006'. Chemometrics and Intelligent Laboratory Systems 91, 94-98.
#' 
#' Minasny, B., and McBratney, A.B., 2008. Regression rules as a tool for predicting soil properties from infrared reflectance spectroscopy. Chemometrics and Intelligent Laboratory Systems 94, 72-79.
#' @keywords datasets
NULL 
