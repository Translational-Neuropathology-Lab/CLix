#' Corticolimbic Index (CLix) Function
#'
#' This function will return a continuous measurement, corticolimbic index (CLix.score), along with a confidence interval. It will also assign an AD subtype (CLix.score.subtype) based on the Neurofibrillary Tangle (NFT) counts of five key brain regions for each case.
#' @param dat The data provided by the user. The dataset must contain the column names: "H1", "H2", "C1", "C2", and "C3".	\cr
#' \cr H1 and H2 refer to the neurofibrillary tangle (NFT) counts in the hippocampal subsectors of CA1 and Subiculum; C1, C2 and C3 refer to the NFT counts in the cortical regions of Temporal, Parietal and Frontal.
#' @param reference.dat The reference dataset is user provided and our findings use the FLAME-AD cohort which can be provided upon request. \cr
#' \cr The FLAME-AD cohort represents the data from AD cases in the larger Florida Autopsied Multi-Ethnic series (n=1361).
#' @param idname The unique identifier for each case, the default is NPID.
#' @param posHC.dat The default is NA.
#' @param posHC.refdat The default is NA.
#' @param crit.values The default is TRUE. Used to toggle the calculation of the ratio of Hippocampal to Cortical means, R, for the reference dataset and print them out.
#' @keywords CLix
#' @export
CLix.scoring <- function(dat = NA,
                         reference.dat = NA,
                         idname='NPID',
                         posHC.dat=NA,
                         posHC.refdat=NA,
                         crit.values=T){

  if(is.na(reference.dat))
    reference.dat <- NA
    

  if(!is.na(sum(posHC.dat)))
  {names(dat)[posHC.dat]<-c('H1','H2','C1','C2','C3')}
  if(!is.na(sum(posHC.refdat)))
  {names(reference.dat)[posHC.refdat]<-c('H1','H2','C1','C2','C3')}




  refdat <- reference.dat %>%
    mutate(
      H3 = (H1 + H2)/2,
      C4 = (C1 + C2 + C3)/3,
      R = H3/C4
    )

  dat <- dat %>% mutate(
    H3 = (H1 + H2)/2,
    C4 = (C1 + C2 + C3)/3,
    R = H3/C4
  )

##missingness imputation ----------------
  n<-length(dat$R)
  ind<-is.na(dat$R)
  n.with.missing <- sum(ind)
  if(n.with.missing==0){
    res<-CLix.scoring.nomissing(dat,refdat,idname=idname,crit.values=crit.values)
  }else{
    cat('No. of cases with missing data is',n.with.missing,'of',length(ind),'\n')
    dat$CLix.score.subtype <- rep(NA,n)
    dat$CLix.score <- rep(NA,n)
    dat$score.lo <- rep(NA,n)
    dat$score.hi <- rep(NA,n)
    # first find the minimum possible score (most CLix) the case could have:
    dat.lo<-dat
    dat.lo$H1[is.na(dat.lo$H1)]<-max(0,min(refdat$H1,na.rm=T)-1)
    dat.lo$H2[is.na(dat.lo$H2)]<-max(0,min(refdat$H2,na.rm=T)-1)
    dat.lo$C1[is.na(dat.lo$C1)]<-max(refdat$C1,na.rm=T)+1
    dat.lo$C2[is.na(dat.lo$C2)]<-max(refdat$C2,na.rm=T)+1
    dat.lo$C3[is.na(dat.lo$C3)]<-max(refdat$C3,na.rm=T)+1
    res.lo <- CLix.scoring.nomissing(dat.lo,refdat,idname=idname,crit.values=crit.values)
    scores.lo<-res.lo$CLix.score[is.na(dat$R)]
    # then the max possible score (most Limbic):
    dat.hi<-dat
    dat.hi$H1[is.na(dat.hi$H1)]<-max(refdat$H1,na.rm=T)+1
    dat.hi$H2[is.na(dat.hi$H2)]<-max(refdat$H2,na.rm=T)+1
    dat.hi$C1[is.na(dat.hi$C1)]<-max(0,min(refdat$C1,na.rm=T)-1)
    dat.hi$C2[is.na(dat.hi$C2)]<-max(0,min(refdat$C2,na.rm=T)-1)
    dat.hi$C3[is.na(dat.hi$C3)]<-max(0,min(refdat$C3,na.rm=T)-1)
    res.hi<- CLix.scoring.nomissing(dat.hi,refdat,idname=idname,crit.values=F)
    scores.hi<-res.hi$CLix.score[is.na(dat$R)]
    # Now the imputed score (need at least one H and at least one C measure)
    dat.impute<-dat
    can.impute<-((is.na(dat$H1)+is.na(dat$H2))!=2)&((is.na(dat$C1)+is.na(dat$C2)+is.na(dat$C3))!=3)
    dat.impute$H1[is.na(dat.impute$H1)&can.impute]<-dat.impute$H2[is.na(dat.impute$H1)&can.impute]
    dat.impute$H2[is.na(dat.impute$H2)&can.impute]<-dat.impute$H1[is.na(dat.impute$H2)&can.impute]
    dat.impute$C1[is.na(dat.impute$C1)&can.impute]<-apply(dat.impute[is.na(dat.impute$C1&can.impute),match(c('C2','C3'),names(dat))],1,mean,na.rm=T)
    dat.impute$C2[is.na(dat.impute$C2)&can.impute]<-apply(dat.impute[is.na(dat.impute$C2&can.impute),match(c('C1','C3'),names(dat))],1,mean,na.rm=T)
    dat.impute$C3[is.na(dat.impute$C3)&can.impute]<-apply(dat.impute[is.na(dat.impute$C3&can.impute),match(c('C1','C2'),names(dat))],1,mean,na.rm=T)
    res.impute<-CLix.scoring.nomissing(dat.impute,refdat,idname=idname,crit.values=F)
    # Now put it all together
    res<-res.impute
    res[,match(c('R','H1','H2','H3','C1','C2','C3','C4'),names(res))]<-dat[,match(c('R','H1','H2','H3','C1','C2','C3','C4'),names(dat))]
    res$score.lo <- rep(NA,n)
    res$score.hi <- rep(NA,n)
    res$score.lo[is.na(dat$R)]<-scores.lo
    res$score.hi[is.na(dat$R)]<-scores.hi
    ind.allmissing<-is.na(dat$H1)&is.na(dat$H2)&is.na(dat$C1)&is.na(dat$C2)&is.na(dat$C3)
    res$CLix.score.subtype[ind.allmissing]<-'No data'
    res$score.lo[ind.allmissing]<-NA
    res$score.hi[ind.allmissing]<-NA
  }
  res
}

##-------------------------
rev.percent <- function(x,xrefdat=x,type='le'){
  result<-NULL

  if(length(xrefdat)<100)
    {stop('ref data set n < 100')}
  if(type=='le'){
    for(i in seq(along=x)){
      result[i] <- mean(xrefdat <= x[i],na.rm=T)*100
    }
  }
  if(type=='lt'){
    for(i in seq(along=x)){
      result[i] <- mean(xrefdat < x[i],na.rm=T)*100
    }
  }
  if(type=='ge'){
    for(i in seq(along=x)){
      result[i] <- mean(xrefdat >= x[i],na.rm=T)*100
    }
  }
  if(type=='gt'){
    for(i in seq(along=x)){
      result[i] <- mean(xrefdat > x[i],na.rm=T)*100
    }
  }
  result
}

max2<-function(x){sort(x,decreasing=T)[2]}
min2<-function(x){sort(x,decreasing=F)[2]}


CLix.category <- function(dat,
                          R25=NA,
                          R75=NA,
                          H1med=NA,
                          H2med=NA,
                          H3med=NA,
                          C1med=NA,
                          C2med=NA,
                          C3med=NA,
                          C4med=NA,
                          reference.dat=NULL){

  if(is.na(R25+R75+H1med+H2med+H3med+C1med+C2med+C3med+C4med)){
    if(!is.null(reference.dat)){
      cat('Calculating percentiles from reference data...')
      R25 <- NA
    }
    else{stop('Need percentiles or reference data...')}
  }
}


## function created scores---------------
CLix.scoring.nomissing <- function(dat,
                                   reference.dat,
                                   idname='NPID',
                                   details=F,
                                   crit.values=T){
  refdat <- reference.dat
  refdat$H3 <- (refdat$H1 + refdat$H2)/2
  refdat$C4 <- (refdat$C1 + refdat$C2 + refdat$C3)/3
  refdat$R <- refdat$H3/refdat$C4
  nums.missing<-is.na(refdat$H1)+is.na(refdat$H2)+is.na(refdat$C1)+is.na(refdat$C2)+is.na(refdat$C3)
  if(crit.values&(max(nums.missing)>0)){
    cat('Have',sum(nums.missing==5),'of',length(nums.missing),'rows with all data missing in Reference data. These are DELETED. \n')
    cat('Have',sum((nums.missing>0)&(nums.missing<5)),'of',sum(nums.missing<5),'rows with partial missing data. These are USED. \n')
  }
  refdat <- refdat[nums.missing<5,]
  # now similar for the data to be scored; note the score is NA if any of the values are NA because need R
  dat$H3 <- (dat$H1 + dat$H2)/2
  dat$C4 <- (dat$C1 + dat$C2 + dat$C3)/3
  dat$R <- dat$H3/dat$C4
  #  if(any(is.na(dat$R))){stop('Missing values in data to be scored')}
  if(crit.values){
    # now let's calculate the critical vals and print them out
    cat(paste('25th %ile of R = ',quantile(refdat$R,prob=0.25,na.rm=T),'\n'))
    cat(paste('median of R = ',quantile(refdat$R,prob=0.5,na.rm=T),'\n'))
    cat(paste('75th %ile of R = ',quantile(refdat$R,prob=0.75,na.rm=T),'\n'))
    cat(paste('median of H1 = ', median(refdat$H1,na.rm=T),'\n'))
    cat(paste('median of H2 = ', median(refdat$H2,na.rm=T),'\n'))
    cat(paste('median of H3 = ', median(refdat$H3,na.rm=T),'\n'))
    cat(paste('median of C1 = ', median(refdat$C1,na.rm=T),'\n'))
    cat(paste('median of C2 = ', median(refdat$C2,na.rm=T),'\n'))
    cat(paste('median of C3 = ', median(refdat$C3,na.rm=T),'\n'))
    cat(paste('median of C4 = ', median(refdat$C4,na.rm=T),'\n'))
  }
  # so we can identify whether more Hippocampal Sparing (negative) - raw score, k, is between 0 and 50
  # or more Limbic (positive), or neither if R = median, k is between 50 and 100
  dat$direction<-sign(dat$R-median(refdat$R,na.rm=T))
  ind<-(!is.na(dat$direction))&(dat$direction==-1)
  # set up the variables to put the k values in:
  n<-length(dat$R)
  dat$kR <-rep(NA,n)
  dat$kH1 <-rep(NA,n)
  dat$kH2 <-rep(NA,n)
  dat$kH3 <-rep(NA,n)
  dat$kH <- rep(NA,n)
  dat$kC1 <-rep(NA,n)
  dat$kC2 <-rep(NA,n)
  dat$kC3 <-rep(NA,n)
  dat$kC4 <-rep(NA,n)
  dat$kC <-rep(NA,n)
  dat$kstar<-rep(NA,n)
  dat$CLix.score.subtype <-rep(NA,n)
  dat$CLix.score<-rep(NA,n)
  dat$kR <- rev.percent(dat$R,refdat$R,'lt')
  # filling these for those in the Hippocampal direction with k less than 50:
  dat$kH1[ind] <- rev.percent(dat$H1[ind],refdat$H1,'lt')/2
  dat$kH2[ind] <- rev.percent(dat$H2[ind],refdat$H2,'lt')/2
  dat$kH3[ind] <- rev.percent(dat$H3[ind],refdat$H3,'lt')/2
  dat$kH[ind] <- apply(cbind(dat$kH1,dat$kH2,dat$kH3)[ind,],1,max) # max of Hs
  dat$kC1[ind] <- rev.percent(dat$C1[ind],refdat$C1,'ge')/2
  dat$kC2[ind] <- rev.percent(dat$C2[ind],refdat$C2,'ge')/2
  dat$kC3[ind] <- rev.percent(dat$C3[ind],refdat$C3,'ge')/2
  dat$kC4[ind] <- rev.percent(dat$C4[ind],refdat$C4,'ge')/2
  dat$kC[ind] <- apply(cbind(dat$kC1[ind],dat$kC2[ind],dat$kC3[ind],dat$kC4[ind]),1,max2)  # second highest of Cs
  dat$kstar[ind]<- apply(cbind(dat$kR,dat$kH,dat$kC)[ind,],1,max) # max of all these three is the final percent!  values of 25 or less are CLix
  # filling these for those in the Limbic direction with k greater than 50:
  ind<-(!is.na(dat$direction))&(dat$direction==1)
  dat$kH1[ind] <- 100-rev.percent(dat$H1[ind],refdat$H1,'ge')/2
  dat$kH2[ind] <- 100-rev.percent(dat$H2[ind],refdat$H2,'ge')/2
  dat$kH3[ind] <- 100-rev.percent(dat$H3[ind],refdat$H3,'ge')/2
  dat$kH[ind] <- apply(cbind(dat$kH1,dat$kH2,dat$kH3)[ind,],1,min2) # second lowest of Hs
  dat$kC1[ind] <- 100-rev.percent(dat$C1[ind],refdat$C1,'le')/2
  dat$kC2[ind] <- 100-rev.percent(dat$C2[ind],refdat$C2,'le')/2
  dat$kC3[ind] <- 100-rev.percent(dat$C3[ind],refdat$C3,'le')/2
  dat$kC4[ind] <- 100-rev.percent(dat$C4[ind],refdat$C4,'le')/2
  dat$kC[ind] <- apply(cbind(dat$kC1[ind],dat$kC2[ind],dat$kC3[ind],dat$kC4[ind]),1,min2)  # second lowest of Cs
  dat$kstar[ind]<- apply(cbind(dat$kR,dat$kH,dat$kC)[ind,],1,min) # min of all these three is the final percent!  values >=75 are Limbic
  ind<-(!is.na(dat$direction))&(dat$direction==0)
  dat$kR[ind] <- 50
  dat$kH1[ind] <- 50
  dat$kH2[ind] <- 50
  dat$kH3[ind] <- 50
  dat$kH[ind] <- 50
  dat$kC1[ind] <- 50
  dat$kC2[ind] <- 50
  dat$kC3[ind] <- 50
  dat$kC4[ind] <- 50
  dat$kC[ind] <- 50
  dat$kstar[ind]<-50
  dat$CLix.score <- 0.4*dat$kstar
  dat$CLix.score.subtype[dat$CLix.score<10]<-'HpSp'
  dat$CLix.score.subtype[(dat$CLix.score>=10)&(dat$CLix.score<30)]<-'Typical'
  dat$CLix.score.subtype[dat$CLix.score>=30]<-'Limbic'
  dat$CLix.score.subtype[is.na(dat$R)]<- 'Missing Data'
  if(details){res<-dat}else{
    res<-dat[,match(c(idname,'R','H1','H2','H3','C1','C2','C3','C4','CLix.score.subtype','CLix.score'),names(dat))]
  }
  res
}

