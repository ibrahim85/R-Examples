get.cumulative<-function(triangle)
{
  Xtriangle<-as.matrix(triangle)  
  m<-nrow(Xtriangle)	
  Xtriangle.0<-Xtriangle
  Xtriangle.0[is.na(Xtriangle)]<-0
  cumX<-t(apply(Xtriangle.0,1,cumsum))
  cumX[is.na(Xtriangle)]<-NA
  return(cumX)
}