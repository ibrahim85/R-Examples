#'Hierachical ordered density clustering (HODC) Algorithm with input generated by Mclust
#'@param pvalue a vector of p-values obtained from large scale statistical hypothesis testing
#'@details Without the information of networking, we can have an approximation to the marginal density by DPM model fitting on \strong{r}. Suppose the number of finite mixture normals is equal to L_0+L_1, which means the number of classes we have, we apply HODC algorithm in partitioning the $L_0$ and $L_1$ components into two classes,
#'For this function, the input is generated by Mclust
#'@return a list of HODC algorithm returned parameters. 
#'\describe{
#'\item{mean}{the mean of each of two clusters}
#'\item{variance}{the variance of each of two clusters}
#'\item{pro}{the probability of each of two clusters}
#'\item{classificaiton}{The classification corresponding to each cluster}
#'}
#'@examples rstat=c(rnorm(50,mean=1),rnorm(50,mean=2),rnorm(100,mean=4),rnorm(100,mean=8))
#'pvalue=pnorm(-rstat)
#'mclustHODC=MclustHODC(pvalue)
#'@export
EM.HODC=function(pvalue)
{
  rstat=Transfer(pvalue)
  mclust=Mclust(rstat)
  
  while (length(mclust$parameter$variance$sigmasq)!=length(unique(mclust$parameter$variance$sigmasq))){
    for (i in 1:length(mclust$parameter$mean)){
      for (j in 1:length(mclust$parameter$mean)){
        if(i!=j){if(mclust$parameter$variance$sigmasq[i]==mclust$parameter$variance$sigmasq[j]){mclust$parameter$variance$sigmasq[j]=mclust$parameter$variance$sigmasq[j]+0.0001}}
      }
    }
  }
  
  while (length(mclust$parameter$pro)!=length(unique(mclust$parameter$pro))){
    for (i in 1:length(mclust$parameter$mean)){
      for (j in 1:length(mclust$parameter$mean)){
        if(i!=j){if(mclust$parameter$pro[i]==mclust$parameter$pro[j]){mclust$parameter$pro[j]=mclust$parameter$pro[j]+0.0001}}
        
      }
    }
  }
  
  if (length(mclust$parameter$mean)==1) {print("warning: the input is not appropriate for mclust since only one cluster was detected by the function Mclust" )}
  if (length(mclust$parameter$mean)==1) break
  ###Step1 find the min distance
  if (length(mclust$parameter$mean)==2) {
    hodcmclust=list()
    hodcmclust$mean=unique(mclust$parameter$mean)
    hodcmclust$pro=unique(mclust$parameter$pro)
    hodcmclust$variance=unique(mclust$parameter$variance$sigmasq[!is.na(mclust$parameter$variance$sigmasq)])
    hodcmclust$classification=mclust$classification
  }else{
    repeat{
      
      distance_all=0
      mclust$parameter$mean=unique(mclust$parameter$mean)
      mclust$parameter$pro=unique(mclust$parameter$pro)
      mclust$parameter$variance$sigmasq=unique(mclust$parameter$variance$sigmasq[!is.na(mclust$parameter$variance$sigmasq)])
      for (i in 1:(length(mclust$parameter$mean)-1))
      {
        distance=Inte_Distance(i,mclust)
        distance_all=c(distance_all,distance)
      }
      lmin=which(distance_all[-1]==min(distance_all[-1]))
      
      if (length(lmin)!=1){lmin=sample(lmin,1)}
      
      for (l in 1:(length(mclust$parameter$mean)-1))
      {
        if (l<lmin){mclust$parameter$mean[l]=mclust$parameter$mean[l]
        mclust$parameter$pro[l]=mclust$parameter$pro[l]
        
        }else if (l==lmin){mclust$parameter$mean[l]=mclust$parameter$mean[l]*mclust$parameter$pro[l]/(mclust$parameter$pro[l]+mclust$parameter$pro[l+1])+mclust$parameter$mean[l+1]*mclust$parameter$pro[l+1]/(mclust$parameter$pro[l]+mclust$parameter$pro[l+1])
        mclust$parameter$pro[l]=mclust$parameter$pro[l]+ mclust$parameter$pro[l+1]
        k=lmin
        repeat{
          k=k+1                           
          if (length(mclust$classification[which(mclust$classification==k)])!=0){mclust$classification[which(mclust$classification==k)]=lmin
          break}
        }
        
        if (mclust$parameter$variance$modelName!="E"){mclust$parameter$variance$sigmasq[l]=var(rstat[which(mclust$classification==l)])}
        }else if (l>lmin){mclust$parameter$mean[l]=mclust$parameter$mean[l+1]
        mclust$parameter$variance$sigmasq[l]=mclust$parameter$variance$sigmasq[l+1]
        mclust$parameter$pro[l]=mclust$parameter$pro[l+1]
        }
        
      }
      
      if (lmin==(length(mclust$parameter$mean)-1)){mclust$parameter$mean=mclust$parameter$mean[-length(mclust$parameter$mean)]
      mclust$parameter$pro=mclust$parameter$pro[-length(mclust$parameter$pro)]
      if (mclust$parameter$variance$modelName!="E"){mclust$parameter$variance$sigmasq=mclust$parameter$variance$sigmasq[-length(mclust$parameter$variance$sigmasq)] }}
      if (length(unique(mclust$parameter$mean))==2) break
    }
    hodcmclust=list()
    index=sort(unique(mclust$classification))
    hodcmclust$mean[1]=mean(rstat[which(mclust$classification==index[1])])
    hodcmclust$mean[2]=mean(rstat[which(mclust$classification==index[2])])
    hodcmclust$variance[1]=var(rstat[which(mclust$classification==index[1])])
    hodcmclust$variance[2]=var(rstat[which(mclust$classification==index[2])])
    hodcmclust$pro[1]=length(rstat[which(mclust$classification==index[1])])/length(rstat)
    hodcmclust$pro[2]=length(rstat[which(mclust$classification==index[2])])/length(rstat)
    hodcmclust$classification=mclust$classification
  }
  return(hodcmclust) 
}
