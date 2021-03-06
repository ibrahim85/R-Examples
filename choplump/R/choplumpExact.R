`choplumpExact` <-
function(W,Z,use.ranks=TRUE){
    ord<- order(W,Z)
    w<-W[ord]
    z<-Z[ord]
    M<-length(w[w!=0])
    m0<-length(z[w!=0 & z==0])
    m1<-M-m0
    n1<-length(z[z==1])
    N<- length(w)
    n0<-N-n1
    k0<-n0-m0
    k1<-n1-m1
    WM<-w[(N+1-M):N]
    if (use.ranks){
        RM<-rank(WM)
        NTIES<-table(RM)
        testfunc<-function(ZM){
            testfunc.wilcox.ties(chop(ZM,n1,n0,M),RM,NTIES,M)
        }
    }
    else {
        testfunc<-function(ZM){
            testfunc.DiM(chop(ZM,n1,n0,M),WM)
        }
   }
    T0<-testfunc(z[(N+1-M):N]) 
    cmout<-cm.compact(n0,n1,M)
    Ti<-apply(cmout$cm,1,testfunc)
    p.lower<- sum(cmout$weight[Ti<=T0])
    p.upper<- sum(cmout$weight[Ti>=T0])
    out<-c(p.lower=p.lower,p.upper=p.upper,p.2sided=min(1,2*min(p.lower,p.upper)))
    out
}

