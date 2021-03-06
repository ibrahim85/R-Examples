
#' @title Simulate Dynamic Network at Time 1
#'
#' @description This function simulates a dynamic network over one or multiple
#'              time steps, to be used in \code{\link{netsim}} models.
#'
#' @param x An \code{EpiModel} object of class \code{\link{netest}}.
#' @param nw A \code{networkDynamic} object.
#' @param nsteps Number of time steps to simulate the network over.
#' @param nsims Number of independent network simulations.
#' @param control An \code{EpiModel} object of class \code{\link{control.net}}.
#'
#' @export
#' @keywords netUtils internal
#'
sim_nets <- function(x, nw, nsteps, control) {

  suppressWarnings(
    sim <- simulate(nw,
                    formation = x$formation,
                    dissolution = x$coef.diss$dissolution,
                    coef.form = x$coef.form,
                    coef.diss = x$coef.diss$coef.crude,
                    time.slices = nsteps,
                    time.start = 1,
                    time.offset = 0,
                    constraints = x$constraints,
                    monitor = control$nwstats.formula,
                    nsim = 1,
                    control = control$set.control.stergm))

  return(sim)
}


#' @title Resimulate Dynamic Network at Time 2+
#'
#' @description This function resimulates the dynamic network in stochastic
#'              network models simulated in \code{\link{netsim}} with dependence
#'              between the epidemic and demographic processes and the network
#'              structure.
#'
#' @param x A master object passed through \code{\link{netsim}}.
#' @param at Current time step.
#'
#' @export
#' @keywords netUtils internal
#'
resim_nets <- function(dat, at) {

  idsActive <- which(dat$attr$active == 1)
  anyActive <- ifelse(length(idsActive) > 0, TRUE, FALSE)
  if (dat$param$modes == 2) {
    nActiveM1 <- length(intersect(modeids(dat$nw, mode = 1), idsActive))
    nActiveM2 <- length(intersect(modeids(dat$nw, mode = 2), idsActive))
    anyActive <- ifelse(nActiveM1 > 0 & nActiveM2 > 0, TRUE, FALSE)
  }

  # Pull network model parameters
  nwparam <- get_nwparam(dat)

  # Serosorting model check
  statOnNw <- ("status" %in% get_formula_terms(nwparam$formation))
  status <- dat$attr$status
  if (statOnNw == TRUE && length(unique(status)) == 1) {
    stop("Stopping simulation because status in formation formula and ",
         "no longer any discordant nodes",
         call. = TRUE)
  }

  # Set up nwstats df
  if (dat$control$save.nwstats == TRUE) {
    if (at == 2) {
      nwstats <- attributes(dat$nw)$stats
      dat$stats$nwstats <- as.data.frame(nwstats)
    }
  }

  # Network simulation
  if (anyActive > 0 & dat$control$depend == TRUE) {
    suppressWarnings(
      dat$nw <- simulate(dat$nw,
                         formation = nwparam$formation,
                         dissolution = nwparam$coef.diss$dissolution,
                         coef.form = nwparam$coef.form,
                         coef.diss = nwparam$coef.diss$coef.adj,
                         constraints = nwparam$constraints,
                         time.start = at,
                         time.slices = 1,
                         time.offset = 0,
                         monitor = dat$control$nwstats.formula,
                         control = dat$control$set.control.stergm))

    # Set up nwstats df
    if (dat$control$save.nwstats == TRUE) {
      dat$stats$nwstats <- rbind(dat$stats$nwstats,
                                 tail(attributes(dat$nw)$stats, 1))
    }

    if (dat$control$delete.nodes == TRUE) {
      dat$nw <- network.extract(dat$nw, at = at)
      inactive <- which(dat$attr$active == 0)
      dat$attr <- deleteAttr(dat$attr, inactive)
    }

  }

  return(dat)
}


#' @title Adjustment for the Edges Coefficient with Changing Network Size
#'
#' @description Adjusts the edges coefficient in a dynamic network model
#'              simulated in \code{\link{netsim}} to preserve the mean
#'              degree of nodes in the network.
#'
#' @param dat Master object in \code{netsim} simulations.
#' @param at Current time step.
#'
#' @keywords internal
#' @export
#'
edges_correct <- function(dat, at) {

  if (dat$control$depend == TRUE) {
    if (dat$param$modes == 1) {
      old.num <- dat$epi$num[at - 1]
      new.num <- sum(dat$attr$active == 1)
      dat$nwparam[[1]]$coef.form[1] <- dat$nwparam[[1]]$coef.form[1] +
        log(old.num) -
        log(new.num)
    }
    if (dat$param$modes == 2) {
      mode <- idmode(dat$nw)
      old.num.m1 <- dat$epi$num[at - 1]
      old.num.m2 <- dat$epi$num.m2[at - 1]
      new.num.m1 <- sum(dat$attr$active == 1 & mode == 1)
      new.num.m2 <- sum(dat$attr$active == 1 & mode == 2)
      dat$nwparam[[1]]$coef.form[1] <- dat$nwparam[[1]]$coef.form[1] +
        log(2 * old.num.m1 * old.num.m2 / (old.num.m1 + old.num.m2)) -
        log(2 * new.num.m1 * new.num.m2/ (new.num.m1 + new.num.m2))
    }
  }
  return(dat)
}
