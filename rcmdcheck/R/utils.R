
is.named <- function(x) {
  !is.null(names(x)) && all(names(x) != "")
}

set_envvar <- function(envs) {
  if (length(envs) == 0) return()

  stopifnot(is.named(envs))

  old <- Sys.getenv(names(envs), names = TRUE, unset = NA)
  set <- !is.na(envs)

  both_set <- set & !is.na(old)

  if (any(set))  do.call("Sys.setenv", as.list(envs[set]))
  if (any(!set)) Sys.unsetenv(names(envs)[!set])

  invisible(old)
}

with_envvar <- function(new, code) {
  old <- set_envvar(new)
  on.exit(set_envvar(old))
  force(code)
}

read_char <- function(path, ...) {
  readChar(path, nchars = file.info(path)$size, ...)
}

win2unix <- function(str) {
  gsub("\r\n", "\n", str, fixed = TRUE)
}
