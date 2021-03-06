#' @export
#' @title Rolling Mean with Alignment
#' @param x an \R numeric vector
#' @param n integer window size
#' @param increment integer shift to use when sliding the window to the next location
#' @param align window alignment, one of \code{"left"|"center"|"right"}
#' @description Fast rolling means with aligment using C++/Rcpp.
#' Additional performance gains can be achieved by skipping \code{increment} values between calculations.
#' @details The window size \code{n} is interpreted as the full window length.
#'   
#' Setting \code{increment} to a value greater than one will result in \code{NA}s for all skipped-over indices.
#' 
#' The \code{align} parameter determines the alignment of the current index within the window. Thus:
#'     
#' \itemize{
#'   \item{\code{align="left" [*------]} will cause the returned vector to have n-1 \code{NA} values at the right end.}
#'   \item{\code{align="center" [---*---]} will cause the returned vector to have (n-1)/2 \code{NA} values at either end.}
#'   \item{\code{align="right" [------*]} will cause the returned vector to have n-1 \code{NA} values at the left end.}
#' }
#' @note For \code{align="center"}, the window size is increased by one if necessary to guarantee an odd window size.
#' @return A vector of rolling mean values of the same length as \code{x}.
#' @examples
#' x <- rep(1:5,each=10)
#' plot(x,cex=0.8,pch=17,main="Test of roll_mean alignment with a 5-point window")
#' points(roll_mean(x,5,1,'left'),cex=1.5,col='blue',type='b')
#' points(roll_mean(x,5,1,'center'),cex=1.5,col='forestgreen',type='b')
#' points(roll_mean(x,5,1,'right'),cex=1.5,col='red',type='b')
#' legend("topleft",
#'        legend=c('data','align=left','align=center','align=right'),
#'        col=c('black','blue','forestgreen','red'),
#'        pch=c(17,1,1,1))

roll_mean <- function( x, n=7, increment=1, align="center" ) {
  
  if ( !is.vector(x) ) {
    
    stop("the x supplied is not a vector")
    
  } else {
    
    if ( n > length(x) ) {
      stop("n cannot be greater than length(x).")
    }
    
    # It is easier to pass a float to C code than a character vector
    if ( align == "left" ) {
      alignCode <- -1
    } else if ( align == "center" ) {
      alignCode <- 0
      if (n%%2 == 0) { # Guarantee that n is odd
        n <- n + 1
      }
    } else if ( align == "right" ) {
      alignCode <- 1
    } else {
      stop("align must be one of left|center|right.")
    }
    
    # Avoid infinite loop
    if ( increment < 1 ) {
      stop("increment must be >= 1.")
    }
    
    result <- .Call("seismicRoll_roll_mean_numeric_vector", 
                    x, as.integer(n), as.integer(increment), as.integer(alignCode),
                    PACKAGE="seismicRoll")
    
    return (as.numeric(result))
    
  }
  
}

