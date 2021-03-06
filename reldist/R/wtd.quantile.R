#################################################################################
# The <wtd.quantile> function determines and returns the weighted quantile of a
# vector x
#
# --PARAMETERS--
#   x     : a numeric vector
#   na.rm : whether missing values should be removed (T or F); default=FALSE
#   weight: a vector of weights for each value in x
#
# --RETURNED--
#   NA                     if x has missing values and 'na.rm'=FALSE
#   the weighted quantile    otherwise  
#
################################################################################

wtd.quantile <- function(x, q=0.5, na.rm = FALSE, weight=FALSE) {
 	if(mode(x) != "numeric")
 		stop("need numeric data")
 	x <- as.vector(x)
 	wnas <- is.na(x)
 	if(sum(wnas)>0) {
 		if(na.rm)
 		 x <- x[!wnas]
 	  	 if(!missing(weight)){weight <- weight[!wnas]}
 		else return(NA)
 	}
 	n <- length(x)
 	half <- (n + 1)/2
 	if(n %% 2 == 1) {
 	  if(!missing(weight)){
 		weight <- weight/sum(weight)
 		sx <- sort.list(x)
 		sweight <- cumsum(weight[sx])
 		min(x[sx][sweight >= q])
 	  }else{
 		x[order(x)[half]]
 	  }
 	}
 	else {
 	  if(!missing(weight)){
 		weight <- weight/sum(weight)
 		sx <- sort.list(x)
 		sweight <- cumsum(weight[sx])
 		min(x[sx][sweight >= q])
 	  }else{
 		half <- floor(half) + 0:1
 		sum(x[order(x)[half]])/2
 	  }
 	}
 }

wtd.iqr <- function(x, na.rm = FALSE, weight=FALSE) {
  wtd.quantile(x, q=0.75, na.rm = na.rm, weight=weight)
- wtd.quantile(x, q=0.25, na.rm = na.rm, weight=weight)
}
iqr <- function(x, na.rm = FALSE) {
  wtd.quantile(x, q=0.75, na.rm = na.rm, weight=FALSE)
- wtd.quantile(x, q=0.25, na.rm = na.rm, weight=FALSE)
}
