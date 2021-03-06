.HMR.read<-function(filename,dec,sep)
{
  ## Input
  ## -----
  ## filename: En tekststreng indeholdende filnavnet. Det foruds�ttes, at datamappen i forvejen er sat med "setwd".
  ##           Datafilen skal v�re organiseret i fem kolonner og opfylde flg. betingelser:
  ##
  ##           1. Indholdet af 1. r�kke ignoreres - kan evt. bruges til variabelnavne eller anden hj�lpetekst.
  ##           2. Kolonnerne indeholder (1.-5.):
  ##                - Serienavn (tekststreng)
  ##                - Kammerets volumen
  ##                - Kammerets tv�rsnitsareal
  ##                - Pr�vetagningstidspunkterne
  ##                - M�lte koncentrationer
  ##           3. Serienavnet identificerer den enkelte dataserie, s� forskellige dataserier SKAL have forskellige
  ##              serienavne. Volumen og areal skal indeholde positive tal, der er konstante indenfor den enkelte
  ##              dataserie. Indholdet af kolonne 1-3 er alts� konstant indenfor serienavn. Pr�vetagningstidspunkterne
  ##              skal v�re (strengt) stigende tal, og det f�rste tidspunkt skal v�re nul. De m�lte koncentrationer skal
  ##              v�re positive tal, og manglende v�rdier er ikke tilladte.
  ##           4. Der stilles ingen krav til fysiske enheder.
  ##
  ## dec     : Decimaltegn.
  ## sep     : S�jleseparator.

  ## Den basale indl�sning vha. "read.table"
  ## ---------------------------------------
  Rdata<-try(read.table(file=filename,header=FALSE,skip=1,blank.lines.skip=TRUE,
  dec=dec,sep=sep,col.names=c('serie','V','A','tid','konc'),
  colClasses=c('character','numeric','numeric','numeric','numeric')),silent=TRUE)

  ## Yderligere kontrol af data  
  ## --------------------------
  ##
  ## ANTAGELSE   : "serie" definerer dataserierne
  ##
  ## Kontrollerer:
  ##
  ##   1. "V" og "A" er konstante indenfor "serie"
  ##   2. Mindst 3 obs. af "V", "A", "tid" og "konc" indenfor "serie"
  ##   3. Ingen "NA" i "V", "A", "tid" eller "konc"
  ##   4. Ingen "Inf" eller "-Inf" i "V", "A", "tid" eller "konc"
  ##   5. Ingen negative v�rdier i "V", "A" eller "konc"
  ##   6. V�rdierne af "tid" skal v�re positive og stigende
  FATAL<-FALSE
  if (class(Rdata)=='try-error')
  {
    # Element�re datafejl
    FATAL<-TRUE; HMRdata<-NA; nserie<-NA
  } else
  {
    # Ingen element�re datafejl
    serie<-Rdata$serie; userie<-unique(serie); nserie<-length(userie)
    V<-Rdata$V
    A<-Rdata$A
    tid<-Rdata$tid
    konc<-Rdata$konc
    nfejlserie<-0
    HMRdata<-vector(mode='list',length=nserie)
    for (i in 1:nserie)
    {
      # Lokale variable
      itid<-tid[serie==userie[i]]
      ikonc<-konc[serie==userie[i]]
      iV<-V[serie==userie[i]]
      iA<-A[serie==userie[i]]
      serieOK<-TRUE
      # Mere end �t "V" eller "A"
      if ((length(unique(iV))>1)|(length(unique(iA))>1)) {serieOK<-FALSE} else
      {
        # Mindre end 3 obs.
        if ((length(itid)<3)|(length(ikonc)<3)|(length(iV)<3)|(length(iA)<3)) {serieOK<-FALSE} else
        {
          # "NA" i numeriske variable
          if ((sum(is.na(itid))>0)|(sum(is.na(ikonc))>0)|(sum(is.na(iV))>0)|(sum(is.na(iA))>0)) {serieOK<-FALSE} else
          {
            # "Inf" eller "-Inf" i numeriske variable
            if ((max(abs(itid))==Inf)|(max(abs(ikonc))==Inf)|(max(abs(iV))==Inf)|(max(abs(iA))==Inf)) {serieOK<-FALSE} else
            {
              # Ikke-positive v�rdier af "V", "A", "konc" eller "tid"
              if ((min(iV)<=0)|(min(iA)<=0)|(min(ikonc)<=0)|(min(itid)<0)) {serieOK<-FALSE} else
              {
                # "tid" er ikke-stigende
                if (min(itid[-1]-itid[-length(itid)])<=0) {serieOK<-FALSE} else
                {
                  # Data "userie[i]" er OK!
                  HMRdata[[i]]<-list(serie=userie[i],V=unique(iV),A=unique(iA),tid=itid,konc=ikonc,status=1) # status=0: fejl, status=1: OK
                }
              }
            }
          }
        }
      }
      # Hvis "userie[i]" indeholder fejl
      if (!serieOK) {nfejlserie<-nfejlserie+1; HMRdata[[i]]<-list(serie=userie[i],status=0)}
    }
    # Hvis fejl i alle serier
    if (nfejlserie==nserie) {FATAL<-TRUE; HMRdata<-NA}
  }

  ## Output
  list(nserier=nserie,HMRdata=HMRdata,FATAL=FATAL)
}
