import excel "/Users/marius/Documents/Marius Uni/6th Semester/Covid 19 mortality BA/owid-covid-data start.xlsx", sheet("Sheet1") cellrange( A1:AE71185) firstrow

destring, replace

xtset c_id date

gen totalcasesper1000 =  ( total_cases /  population )*1000

gen totaldeathsper1000infections= ( total_deaths / total_cases )*1000

by c_id: gen Governmentstringlag15= stringency_index[_n-15]

by c_id: egen meangovstrin = mean(stringency_index)


label variable totalcasesper1000 "Total Covid Cases per 1000 persons"

label variable totaldeathsper1000infections "Mortality Variable of total deaths at day x per sum of infections over complete time frame"


## Main Mortality Variable ##

gen LDEATH =log(totaldeathsper1000infections)

gen LDEATH2=log(total_deaths_per_million)

## Infections & Vacinations ##

gen LTOTALCASES = log(totalcasesper1000)

gen LTOTALTEST = log(total_tests_per_thousand)

gen LTOTALVAC = log((total_vaccinations / population)*1000) 


## Comorbidities ##
 
gen LDIAB =log(diabetes_prevalence)

gen LCARDI = log(cardiovasculardeathrates)

gen LRESP = log(chronicresperatorydeathrate)

gen LOBESE = log(Prevalenceofoverweightofa)

gen LSMOKE = log(Smokingprevalencetotalages)

gen LALC = log(Totalalcoholconsumptionperca)



## Population Stats ##

gen LPOPDENSE = log(population_density)

gen LMEDAGE = log(median_age)
 
gen LOLDAGE = log(aged_65_older)

## Other Infectious Diseases ##

gen LHIV = log(IncidenceofHIVallper1000)

gen LMALERIA = log(Incidenceofmalariaper1000)

gen LTUBER = log(Incidenceoftuberculosisper1)

## Socio Economic Variables ##

gen LHEALTHCAREQ = log(Healthcareaccessandqualityindex)

gen LHOSPITALBEDS = log(Hospitalbedper1000people)

gen LMPOVERTY = log(MultidimensionalpovertyHeadco)

gen LNATPOVERT = log(Povertyheadcountratioatnatio)

gen LPOLLUT = log(PM25airpollutionmeanannual)

gen LEDUC = log(educationalattainmentpostseco)

gen LGOVSTR = log(stringency_index)

gen LGOVSTRIN15 = log(Governmentstringlag15)


label variable LDEATH "Total death per 1000 COVID cases"

label variable LDEATH2 "Total deaths per 1 million inhabitants"

label variable LTOTALCASES "Total COVID infections per 1000 inhabitants"

label variable LTOTALTEST "Total COVID tests administered per thousand"

label variable LTOTALVAC "Total vaccinations per 1000 inhabitants"

label variable LDIAB "Diabetes prevalence (% of population aged 20 to 79)"

label variable LCARDI "Death rate from cardiovascular disease per 100,000 people"

label variable LRESP "Chronic resperatory death rate per 100thousnad  people"

label variable LOBESE "Prevalence of overweight adults is the percentage of adults ages 18 and over whose Body Mass Index (BMI) is more than 25 kg/m2"

label variable LSMOKE "Prevalence of current tobacco use (% of adults)"

label variable LALC "Total alcohol consumption per capita (liters of pure alcohol, projected estimates, 15+ years of age)"

label variable LPOPDENSE "Number of people divided by land area, measured in square kilometers, most recent year available"

label variable LMEDAGE "Median Age"

label variable LOLDAGE "hare of the population that is 65 years and older, most recent year available"

label variable LHIV "Incidence of HIV, all (per 1,000 uninfected population)"

label variable LMALERIA "Incidence of malaria (per 1,000 population at risk)"

label variable LTUBER "Incidence of tuberculosis (per 100,000 people)"

label variable LHEALTHCAREQ "Healthcareaccessandqualityindex"

label variable LHOSPITALBEDS "Hospital beds per 1,000 people, most recent year available"

label variable LMPOVERTY "Multidimensional poverty, Headcount ratio (% of population)"

label variable LNATPOVERT "Poverty headcount ratio at national poverty lines (% of population)"
 
label variable LPOLLUT "PM2.5 air pollution, mean annual exposure (micrograms per cubic meter)"

label variable LEDUC "Educational attainment, at least completed lower secondary, population 25+"

label variable LGOVSTR "Government Response Stringency Index: composite measure based on 9 response indicators including school closures, workplace closures, and travel bans, rescaled to a value from 0 to 100 (100 = strictest response)"

recode LDEATH (mis = 0)
recode LDEATH2 (mis = 0)
recode LTOTALVAC(mis = 0)
recode totaldeathsper1000infections (mis = 0)


1#Basic Model not accounting for Comorbidities using only time varying virus data and old age dependancy
2#Model Accounting for Comorbidities withiout socio economic
3#Model only accounting for Socio Economic and Demographic variable without comorbidities
4#Model Accounting for full Spectrum but taking out smoke and alc because to avoid probles
5#Model Accounting for full Spectrum but taking out smoke and alc because to avoid probles using National Poverty Line
6#Model Accounting for full Spectrum but taking out smoke and alc because to avoid probles if before October 2020
7#Model Accounting for full Spectrum but taking out smoke and alc because to avoid probles after October 2020

ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LDIAB LCARDI LRESP LOBESE LSMOKE LALC Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LPOPDENSE LHOSPITALBEDS LNATPOVERT LPOLLUT LEDUC Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LDIAB LCARDI LRESP LOBESE LHOSPITALBEDS LMPOVERTY LPOLLUT LEDUC LPOPDENSE Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LDIAB LCARDI LRESP LOBESE LHOSPITALBEDS LNATPOVERT LPOLLUT LEDUC LPOPDENSE Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LDIAB LCARDI LRESP LOBESE LHOSPITALBEDS LMPOVERTY LPOLLUT LEDUC LPOPDENSE Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000 & date<td(01oct2020)
ppml LDEATH LTOTALCASES LOLDAGE LGOVSTRIN15 LDIAB LCARDI LRESP LOBESE LHOSPITALBEDS LMPOVERTY LPOLLUT LEDUC LPOPDENSE Dayssincefirstpositvecasede if LDEATH>=0 & population>1000000 & date>td(01oct2020)






## Heatplot by c_id  1 ## still add dates for all missing countries
gen c_id2 = -c_id
labmask c_id2, val(location)
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id<=30 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.4) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(2)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

## Heatplot by c_id 2
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id>30 & c_id<=60 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(2)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

## Heatplot by c_id 3 
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id>60 & c_id<=90 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(2)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

## Heatplot by c_id 4
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id>90 & c_id<=120 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(1)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

## Heatplot by c_id 5
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id>120 & c_id<=150 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(2)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

## Heatplot by c_id 6
summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id>150 & c_id<=184 & c_id!= 5 & c_id!= 24 & c_id!= 33 & c_id!= 63 & c_id!= 64 & c_id!= 71 & c_id!= 74 & c_id!= 81 & c_id!= 116 & c_id!= 123 & c_id!=134 & c_id!= 157 & c_id!= 172 & c_id!= 182 & c_id!= 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(2)250) ramp(right space(10) label(0(25)250)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))

###Heatplot for those countries with peak deaths of 250 or more of 1000 infections

summ date
  local x1 = `r(min)'
  local x2 = `r(max)'
heatplot totaldeathsper1000infections i.c_id2 date if c_id== 5 | c_id== 24 | c_id== 33 | c_id== 63 | c_id== 64 | c_id== 71 | c_id== 74 | c_id== 81 | c_id== 116 | c_id== 123 | c_id==134 | c_id== 172 | c_id== 182 | c_id== 184, yscale(noline) ylabel(, nogrid labsize(*0.7)) xlabel(`x1'(10)`x2', labsize(*0.6) angle(vertical) format(%tdDD-Mon) nogrid) color(inferno, reverse) cuts(0(4)500) ramp(right space(10) label(0(20)500)) p(lcolor(black%10) lwidth(*0.15)) ytitle("") xtitle("", size(vsmall)) title("COVID-19 Deaths per 1000 infections") note("Data source: Oxford COVID-19 Government Response Tracker.", size(vsmall))



######Heatplot correlation matrix then edit in graph editor 

quietly correlate LDEATH LTOTALCASES LTOTALCASES LTOTALVAC LDIAB LCARDI LRESP LOBESE LSMOKE LALC LPOPDENSE LMEDAGE LOLDAGE LHIV LMALERIA LTUBER LHEALTHCAREQ LHOSPITALBEDS LMPOVERTY LNATPOVERT LPOLLUT LEDUC LGOVSTR
matrix C = r(C)
heatplot C, values(format(%9.3f)) color(hcl, diverging intensity(.6)) legend(off) aspectratio(0.5)

########## BMA ######### 
For the BMA the missing values were replaced with the mean becasue the BMS package in R does not deal well with missing values and deletes an entire observation even if only one value within his obs is missing. 

gen LGOVSTRIN = log(meangovstrin)
 egen misLDIAB =mean(LDIAB)
 replace LDIAB = misLDIAB if missing(LDIAB)
 egen misLCARDI = mean(LCARDI)
 replace LCARDI = misLCARDI if missing(LCARDI)
 egen misLRESP = mean(LRESP) 
 replace LRESP = misLRESP if missing(LRESP)
 egen misLOBESE = mean(LOBESE)
 replace LOBESE = misLOBESE if missing(LOBESE)
 egen misLSMOKE = mean(LSMOKE)
 replace LSMOKE = misLSMOKE if missing(LSMOKE)
 egen misLALC = mean(LALC)
 replace LALC = misLALC if missing(LALC)
 egen misLPOPDENSE = mean(LPOPDENSE)
 replace LPOPDENSE = misLPOPDENSE if missing(LPOPDENSE)
 egen misLMEDAGE = mean(LMEDAGE)
 replace LMEDAGE = misLMEDAGE if missing(LMEDAGE)
 egen misLOLDAGE = mean(LOLDAGE)
 replace LOLDAGE = misLOLDAGE if missing(LOLDAGE)
 egen misLTUBER = mean(LTUBER)
 replace LTUBER = misLTUBER if missing(LTUBER)
 egen misLHEALTHCAREQ = mean(LHEALTHCAREQ)
 replace LHEALTHCAREQ = misLHEALTHCAREQ if missing(LHEALTHCAREQ)
 egen misLHOSPITALBEDS = mean(LHOSPITALBEDS)
 replace LHOSPITALBEDS = misLHOSPITALBEDS if missing(LHOSPITALBEDS)
 egen misLMPOVERTY = mean(LMPOVERTY)
 replace LMPOVERTY = misLMPOVERTY if missing(LMPOVERTY)
 egen misLNATPOVERT = mean(LNATPOVERT)
 replace LNATPOVERT = misLNATPOVERT if missing(LNATPOVERT)
 egen misLPOLLUT = mean(LPOLLUT) 
 replace LPOLLUT = misLPOLLUT if missing(LPOLLUT)
 egen misLEDUC = mean(LEDUC)
 replace LEDUC = misLEDUC if missing(LEDUC)
 egen misLGOVSTRIN = mean(LGOVSTRIN)
 replace LGOVSTRIN = misLGOVSTRIN if missing(LGOVSTRIN)



