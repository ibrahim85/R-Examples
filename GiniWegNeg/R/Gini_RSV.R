Gini_RSV <-
function(y,p=rep(1,length(y)))
{
dataset<-cbind(y,p)
ord_y<-order(y)
dataset_ord<-dataset[ord_y,] 
y<-dataset_ord[,1]
p<-dataset_ord[,2]
N<-sum(p)
yp<-y*p
C_i<-cumsum(p)
num_1<-sum(yp*C_i)
num_2<-sum(yp)
num_3<-sum(yp*p)
G_num<-(2/N^2)*num_1-(1/N)*num_2-(1/N^2)*num_3
t_neg<-subset(yp,yp<=0)
T_neg<-sum(t_neg)
T_pos<-sum(yp)+abs(T_neg)
n_RSV<-(2*(T_pos+(abs(T_neg)))/N)
mean_RSV<-(n_RSV/2)
G_RSV<-(1/mean_RSV)*G_num
list(GINI_RSV=G_RSV)
}
