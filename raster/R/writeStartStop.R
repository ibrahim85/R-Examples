# Author: Robert J. Hijmans
# Date :  September 2009
# Version 0.9
# Licence GPL v3

if (!isGeneric('writeStart')) {
	setGeneric('writeStart', function(x, filename, ...)
		standardGeneric('writeStart'))
}

if (!isGeneric('writeStop')) {
	setGeneric('writeStop', function(x)
		standardGeneric('writeStop'))
}
	


setMethod('writeStart', signature(x='RasterLayer', filename='character'), 
function(x, filename, options=NULL, format, prj=FALSE, ...) {

	if (trim(filename) == '') { 
		filename <- rasterTmpFile() 
	}
	filename <- .fullFilename(filename, expand=TRUE)
	if (!file.exists(dirname(filename))) {
		stop("Attempting to write a file to a path that does not exist:\n  ", dirname(filename))
	}
	
	filetype <- .filetype(format=format, filename=filename)
	filename <- .getExtension(filename, filetype)
	if (filetype=='ascii') { 
		x <- .startAsciiWriting(x, filename, ...)
	} else if ( filetype %in% .nativeDrivers() ) { 
		x <- .startRasterWriting(x, filename, format=filetype, ...)
	} else if ( filetype == 'CDF' ) { 
		x <- .startWriteCDF(x, filename, ...)
#	} else if ( filetype == 'big.matrix' ) { 
#		x <- .startBigMatrixWriting(x, filename, ...)
	} else {
		x <- .startGDALwriting(x, filename, options=options, format=filetype, ...)
	}		
	
	if (prj) {
		crs <- crs(x, asText=T)
		if (!is.na(crs)) {
			if (.requireRgdal(FALSE)) { 
				writeLines(rgdal::showWKT(crs(x, asText=TRUE)), extension(filename, 'prj') )
			}
		}
	}
	return(x)
})


setMethod('writeStart', signature(x='RasterBrick', filename='character'), 
function(x, filename, options=NULL, format, prj=FALSE, ...) {

	if (trim(filename) == '') { 
		filename <- rasterTmpFile() 
	}
	filename <- .fullFilename(filename, expand=TRUE)
	filetype <- .filetype(format=format, filename=filename)
	filename <- .getExtension(filename, filetype)
	
	if (filetype=='ascii') { 
		stop('ARC-ASCII files cannot contain multiple layers') 
	}
	native <- filetype %in% c(.nativeDrivers(), 'ascii')
	if (native) { 
		x <- .startRasterWriting(x, filename, format=filetype, ...) 
	} else if ( filetype == 'CDF' ) { 
		x <- .startWriteCDF(x, filename, ...)
#	} else if ( filetype == 'big.matrix' ) { 
#		x <- .startBigMatrixWriting(x, filename, ...)
	} else {
		x <- .startGDALwriting(x, filename, options=options, format=filetype, ...) 
	}
	
	if (prj) {
		crs <- crs(x, asText=T)
		if (!is.na(crs)) {
			if (.requireRgdal(FALSE)) { 
				writeLines(rgdal::showWKT(crs), extension(filename, 'prj') )
			}
		}
	}	
	
	return(x)
})


setMethod('writeStop', signature(x='RasterLayer'), 
	function(x) {
		driver <- x@file@driver
		if ( driver %in% .nativeDrivers() ) { 
			return( .stopRasterWriting(x) )
#		} else if ( driver == 'big.matrix' ) { 
#			return( .stopBigMatrixWriting(x) )
		} else if ( driver == 'ascii' ) { 
			return( .stopAsciiWriting(x) )
		} else if ( driver == 'netcdf' ) { 
			return( .stopWriteCDF(x) )
		} else {
			return( .stopGDALwriting(x) )
		}
	}
)

setMethod('writeStop', signature(x='RasterBrick'), 
	function(x) {
		driver <- x@file@driver
		if (driver  %in% .nativeDrivers()) { 
			return( .stopRasterWriting(x) )
		} else if ( driver == 'netcdf' ) { 
			return( .stopWriteCDF(x) )
#		} else if ( driver == 'big.matrix' ) { 
#			return( .stopBigMatrixWriting(x) )
		} else {
			return( .stopGDALwriting(x) )
		}
	}
)

