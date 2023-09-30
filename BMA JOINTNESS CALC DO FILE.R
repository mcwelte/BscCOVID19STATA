#Data imported

JDATA <- BMA_USING_INDICATORS_final[c(5:13,15:23,4)]
JDATA1 <- BMA_USING_INDICATORS_final_robust_check[c(5:13,15:22,4)]


#Equation for Bayseian Model Averaging, results found in Appendix
bmaforfinal <- bms(JDATA, burn=2000000, iter = 10000000, mcmc="bd", g="hyper", mprior="uniform", nmodel=2000, 
                     user.int=FALSE, fixed.reg = c("LTOTALCASES","Dayssincefirstpositvecasede") )

#Diagnostics plot for the MCMC
plot(bmaforfinal[1:200],lty=c(1,2))


#Defining jointness function

jointness.score <- function(JDATA, method=NA, burn=1000, iter=NA, nmodel=500,
                            mcmc="bd", g="UIP", mprior="uniform", mprior.size=NA, user.int=FALSE, start.value=NA, g.stats=TRUE,
                            logfile=FALSE, logstep=10000,
                            force.full.ols =TRUE,
                            fixed.reg=numeric(0)){
  
  jointness.bma <- bms(JDATA, burn = burn, iter = iter,
                       nmodel = nmodel, mcmc = mcmc, g = g,
                       mprior = mprior, mprior.size = mprior.size, user.int = user.int, start.value = start.value, g.stats = g.stats , logfile = logfile ,
                       logstep =logstep ,
                       force.full.ols = force.full.ols, fixed.reg=fixed.reg)



j.pips <- coef(bmaforfinal)[,1:3]
top.includes <- topmodels.bma(jointness.bma)
cov.nam <- head(row.names(top.includes),-2)
cov.no <- length(cov.nam)
pmps <- pmp.bma(jointness.bma)[,2]
pmps <- pmps/sum(pmps)
jointness <- matrix(0,cov.no,cov.no)
for(i in 1:cov.no){
  for(j in 1:cov.no){
    selected.includes <- top.includes[c(i,j),]
    tl <- sum(pmps[colSums(selected.includes)==2])
    tr <- sum(pmps[colSums(selected.includes)==0])
    bl <- sum(pmps[selected.includes[1,]==0 & selected.includes[2,]==1])
    br <- sum(pmps[selected.includes[1,]==1 & selected.includes[2,]==0])
    cr <- tl+br
    cl <- tl+bl
    if (method=="Pure"){
      ## Raw jointness statistic 1
      jointness[i,j] <- tl}
    if (method=="LS1"){
      ## Ley-Steel jointness statistic 1 
      jointness[i,j] <- tl/(cl+cr-tl)}
    if (method=="LS2"){
      ## Lee-Steel jointness statistic 2
      jointness[i,j] <- tl/(bl+br)}
    if (method=="DW1"){
      ## Doppelhofer -Weeks jointness statistic 1
      jointness[i,j] <- log(tl/(cl*cr))}
    if (method=="DW2"){
      ## Doppelhofer -Weeks jointness statistic 2
      jointness[i,j] <- log((tl*tr)/(bl*br))}
    if (method=="St"){
      ## Strachan jointness statistic
      jointness[i,j] <- cl*cr*log(tl/(bl*br))}
    if (method=="YQ"){
      ## Hofmarcher et al. jointness statistic
      jointness[i,j] <- (tl*tr-br*bl)/(tl*tr+br*bl)}
    if (method=="YQM"){
      ## Hofmarcher et al. modified jointness statistic
      jointness[i,j] <- ((tl+0.5)*(tr+0.5)- (br+0.5)*(bl+0.5))/ ((tl+0.5)*(tr+0.5)+
                                                                   (br+0.5)*(bl+0.5) -0.5)}
  } 
  }
colnames(jointness) <- cov.nam
rownames(jointness) <- cov.nam
jointness <- round(jointness ,1)
diag(jointness) <- "."
jointness <- as.data.frame(jointness)
return(jointness)
}

#Jointness calculation for the full panel 
equ.jointYQ2 <- jointness.score(JDATA,method="YQM", burn=2000000 ,iter=10000000 ,
                                mcmc="bd", g ="hyper",
                                mprior ="uniform",
                                user.int=FALSE , force.full.ols=TRUE, fixed.reg=c("LTOTALCASES","Dayssincefirstpositvecasede") )
#Jointness calculation for robustness check model without tuberculosis
equ.jointYQ3 <- jointness.score(JDATA1,method="YQM", burn=2000000 ,iter=10000000 ,
                                mcmc="bd", g ="hyper",
                                mprior ="uniform",
                                user.int=FALSE , force.full.ols=TRUE, fixed.reg=c("LTOTALCASES","Dayssincefirstpositvecasede") )
