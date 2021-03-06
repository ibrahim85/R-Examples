# Copyright (C) 2009 
# Sebastien Dejean, Institut de Mathematiques, Universite de Toulouse et CNRS (UMR 5219), France
# Ignacio Gonzalez, Genopole Toulouse Midi-Pyrenees, France
# Kim-Anh Le Cao, French National Institute for Agricultural Research and 
# ARC Centre of Excellence ins Bioinformatics, Institute for Molecular Bioscience, University of Queensland, Australia
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


Mfold <-
function(X, Y, lambda1, lambda2, folds, M) 
{

    xscore = NULL
    yscore = NULL
     
    for (m in 1:M) {
        omit = folds[[m]]
        result = rcc(X[-omit, ], Y[-omit, ], 1, lambda1, lambda2,method="ridge")
        X[omit, ][is.na(X[omit, ])] = 0
        Y[omit, ][is.na(Y[omit, ])] = 0
        xscore = c(xscore, X[omit, ] %*% result$loadings$X[, 1])
        yscore = c(yscore, Y[omit, ] %*% result$loadings$Y[, 1])
    }
     
    cv.score = cor(xscore, yscore, use = "pairwise")
    return(invisible(cv.score))
}
