`conv.test` <-
function(x,alpha=0.05,error=0.00001,keep.rares.conv=FALSE){

     if(class(x)=="reg"){
        a<-print.reg(list(x,TRUE))
        x[[length(x)]]<-as.data.frame(x[[length(x)]])    
        b<-a[[2]]$Haplotypes
        names(x[[length(x)]])<-c(a[[1]]$Haplotypes[-length(a[[1]]$Haplotypes)],paste("reg.",b,sep=""))
     }
     if(class(x)=="freq"){
        a<-print.freq(x)
        x[[length(x)]]<-as.data.frame(x[[length(x)]][,1:nrow(a)])
        names(x[[length(x)]])<-a$Haplotypes
     }

     if ((keep.rares.conv==FALSE)&&(class(x)=="reg")){
        i<-1
        col.ok<-NULL
        for (i in 1:ncol(x[[length(x)]])){ 
             col.ok<-c(col.ok,!("reg.Rares"%in%strsplit(names(x[[length(x)]]),split=":",fixed=TRUE)[[i]]))       
        }
        x[[length(x)]]<-x[[length(x)]][,col.ok]
     }
     mat<-as.matrix(x[[length(x)]])
     res<-boa.handw(mat,error,alpha)
     return(res)
}

