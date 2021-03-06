#' @export
#' @title Convert an rpqueue to a data.frame
#' 
#' @description Converts the elements of an rpqueue into rows of a data.frame, if this is reasonable.
#' 
#' @details This function runs in \eqn{O(N)} time in the size of the rpqueue, and will only work if all 
#' elements of the queue have the same \code{length()} (e.g., same number of columns), and if any of the 
#' elements have names, then those names do not conflict (e.g., same column names where used). 
#' This is accomplished by a call to
#' \code{do.call("rbind", as.list.rpqueue(x))}, where \code{\link{as.list.rpqueue}} converts the rpqueue to a list
#' where the front element becomes the first element of the list.
#' @param x rpqueue to convert.
#' @param row.names passed on to \code{as.data.frame} before final conversion.
#' @param optional passed onto \code{as.data.frame} before final conversion.
#' @param ... passed onto \code{as.data.frame} before final conversion.
#' @return a data.frame with the first row the previous front of the queue and last row the previous back.
#' @seealso \code{\link{as.list.rpqueue}} for conversion to a list and the generic \code{\link{as.data.frame}}.
#' @examples 
#' q <- rpqueue()
#' q <- insert_back(q, data.frame(names = c("Bob", "Joe"), ages = c(25, 18)))
#' q <- insert_back(q, data.frame(names = c("Mary", "Kate", "Ashley"), ages = c(27, 26, 21)))
#' print(q)
#' 
#' qq <- as.data.frame(q)
#' print(qq)
#' 
#' ## Elements may be similarly-named lists as well, representing individual rows:
#' q <- rpqueue()
#' q <- insert_back(q, list(name = "Bob", age = 25))
#' q <- insert_back(q, list(name = "Mary", age = 24))
#' print(q)
#' 
#' qq <- as.data.frame(q)
#' print(qq)
#' 
#' ## Building a deque in a loop, converting to a dataframe after the fact:
#' q <- rpqueue()
#' for(i in 1:1000) {
#'  if(runif(1,0,1) < 0.5) {
#'    q <- insert_back(q, data.frame(i = i, type = "sqrt", val = sqrt(i)))
#'  } else {
#'    q <- insert_back(q, data.frame(i = i, type = "log", val = log(i)))
#'  }
#'  if(i %% 100 == 0) {
#'    print(i/1000)
#'  }
#' }
#' print(head(as.data.frame(q)))
as.data.frame.rpqueue <- function(x, row.names = NULL, optional = FALSE, ...) {
  dlist <- lapply(as.list(x), as.data.frame, optional = optional, ...)
  uniquelens <- unique(lapply(dlist, length))
  if(length(uniquelens) > 1) {
    stop("cannot convert an rpqueue to a data.frame unless all elements have the same length()")
  }
  uniquenamesets <- unique(lapply(dlist, names))
  if(length(uniquenamesets) > 1) {
    stop("cannot convert an rpqueue to a data.frame when elements have contradictory names()")
  }
  return(as.data.frame(do.call(rbind, dlist), row.names, optional, ...))
}