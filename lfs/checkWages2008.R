library(survey)
library(foreign)
library(dplyr)
setwd('~/dataDrive/dataProjects/povMap/zambiaLFSmapping/')

# unique person id: prov dist const ward csa sea sbn hun hhn category pn
# region = urban / rural is nor part of UID; CHECK: at ward level
# csa = census supervisory area
# sea = standard enumeration are
# CLUSTER NUMBER = csa + sea?
# sbn = survey building number
# hun = housing unit number
# hhn = household number
# pn = person number

# characteristics (demographics) module

df <- read.csv('2_data/lfs2008csv/section1demographicCharacteristics02.csv')

lfs2008 <- subset(df, select = c(PROV, DIST, CONST, WARD, CSA, SEA, REGION, SBN, HUN, HHN, CATEGORY, PN, wgt,	WEIGHT))
names(lfs2008) <- c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'region', 'sbn', 'hun', 'hhn', 'category', 'pn', 'wgt', 'weight')

lfs2008$demAge <- df$S1Q2
lfs2008$demRel <- df$S1Q3
lfs2008$demSex <- df$S1Q4
# DISCREPANCY between questionnaire in "LFS Questionnaire_2008.pdf" and what we see data
# In questionnaire, two questions for marriage status, Q5 and Q6, but only one code given
# In data, answers and skip patterns show that Q5 is only for marriage status and Q6 in data is Q7 in questionnaire
# up to Q11A, B, C in data matching Q12 1, 2, 3 in questionnaire
lfs2008$demMar <- df$S1Q5
lfs2008$demDis <- df$S1Q10

length(lfs2008)
rm(df)

# education module

df <- read.csv('2_data/lfs2008csv/section2educationCharacteristics.csv')
temp <- subset(df, select = c(PROV, DIST, CONST, WARD, CSA, SEA, REGION, SBN, HUN, HHN, CATEGORY, PN, weight))
names(temp) <- c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'regionCHECK', 'sbn', 'hun', 'hhn', 'category', 'pn', 'weightCHECK')

temp$eduRW <- df$SQ1
temp$eduEvrSchl <- df$S2Q2
temp$eduLvlAch <- df$S2Q3
temp$eduNowSchl <- df$S2Q4

nrow(lfs2008)
nrow(temp)
lfs2008$inDem <- TRUE
temp$inEdu <- TRUE 
lfs2008 <- merge(lfs2008, temp, by=c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'sbn', 'hun', 'hhn', 'category', 'pn'), all=TRUE)
nrow(filter(lfs2008, is.na(inDem) & inEdu == TRUE))
summary(lfs2008$demAge[lfs2008$inDem == TRUE & is.na(lfs2008$inEdu)])
nrow(filter(lfs2008, inDem == TRUE & is.na(inEdu)))
nrow(filter(lfs2008, inDem == TRUE & is.na(inEdu) & demAge > 5))
# There are 220 in Edu who are not in Demographics
# Of the 24,037 in Demog not in Edu, all only 314 are over 5 years old 

nrow(filter(lfs2008, round(weight, 4) != round(weightCHECK, 4)))
# This one case is the same at one decimal place. Since the original weight (wgt) is at 2dp, will keep weight
nrow(filter(lfs2008, region != regionCHECK))
lfs2008 <- select(lfs2008, -c(weightCHECK, regionCHECK))

rm(list=c('temp', 'df'))

df <- read.csv('2_data/lfs2008csv/section4usualEmployment.csv')
temp <- subset(df, select = c(PROV, DIST, CONST, WARD, CSA, SEA, REGION, SBN, HUN, HHN, CATEGORY, PN, weight))
names(temp) <- c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'regionCHECK2', 'sbn', 'hun', 'hhn', 'category', 'pn', 'weightCHECK2')

temp$usEmpLfStat <- df$S4Q1
temp$usEmpLfExtr <- (df$S4Q2 == 1) | (df$S4Q3 == 1) | (df$S4Q4 == 1) | (df$S4Q5 == 1) | (df$S4Q6 == 1) | (df$S4Q7 == 1) 
temp$usEmpInd <- df$S4Q9
temp$usWrkType <- df$S4Q10
temp$usBusType <- df$S4Q11
temp$usEmpEmplStat <- df$S4Q12
temp$usEmplHrs <- df$S4Q17

nrow(lfs2008)
nrow(temp)
temp$inUsEmpl <- TRUE 
lfs2008 <- merge(lfs2008, temp, by=c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'sbn', 'hun', 'hhn', 'category', 'pn'), all=TRUE)
nrow(filter(lfs2008, is.na(inDem) & inUsEmpl == TRUE))
summary(lfs2008$demAge[lfs2008$inDem == TRUE & is.na(lfs2008$inUsEmpl)])
nrow(filter(lfs2008, inDem == TRUE & is.na(inUsEmpl)))
nrow(filter(lfs2008, inDem == TRUE & is.na(inUsEmpl) & demAge > 5))
# There are 431 in UsEmpl who are not in Demographics
# Of the 25,569 in Demog not in UsEmpl, 1,670 are over 5 years old

nrow(filter(lfs2008, round(weight, 4) != round(weightCHECK2, 4)))
# This one case is the same at one decimal place. Since the original weight (wgt) is at 2dp, will keep weight
nrow(filter(lfs2008, region != regionCHECK2))
lfs2008 <- select(lfs2008, -c(weightCHECK2, regionCHECK2))

rm(list=c('temp', 'df'))

df <- read.csv('2_data/lfs2008csv/section5incomeEarnings.csv')
temp <- subset(df, select = c(PROV, DIST, CONST, WARD, CSA, SEA, REGION, SBN, HUN, HHN, CATEGORY, PN, weight))
names(temp) <- c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'regionCHECK3', 'sbn', 'hun', 'hhn', 'category', 'pn', 'weightCHECK3')

temp$incFreq <- df$S5Q1
temp$incTotal <- df$S5Q2

nrow(lfs2008)
nrow(temp)
temp$inInc <- TRUE 
lfs2008 <- merge(lfs2008, temp, by=c('prov', 'dist', 'const', 'ward', 'csa', 'sea', 'sbn', 'hun', 'hhn', 'category', 'pn'), all=TRUE)
nrow(filter(lfs2008, is.na(inDem) & inInc == TRUE))
summary(lfs2008$demAge[lfs2008$inDem == TRUE & is.na(lfs2008$inInc)])
nrow(filter(lfs2008, inDem == TRUE & is.na(inInc)))
nrow(filter(lfs2008, inDem == TRUE & is.na(inInc) & demAge > 5))
# There are 65 in UsEmpl who are not in Demographics
# Of the 92,127 in Demog not in UsEmpl, 61,930 are over 5 years old

nrow(filter(lfs2008, round(weight, 4) != round(weightCHECK3, 4)))
# This one case is the same at one decimal place. Since the original weight (wgt) is at 2dp, will keep weight
nrow(filter(lfs2008, region != regionCHECK3))
lfs2008 <- select(lfs2008, -c(weightCHECK3, regionCHECK3))
lfs2008 <- select(lfs2008, -(regionCHECK3))

rm(list=c('temp', 'df'))

write.csv(lfs2008, '2_data/lfs2008Ready.csv')
save(lfs2008, file = '2_data/lfs2008Ready.Rda')

################

lfs2008 <- load('2_data/lfs2008Ready.Rda')

lfs2008 <- read.csv('2_data/lfs2008Ready.csv')
lfs2008 <- lfs2008[lfs2008$demAge >= 15 & lfs2008$usEmpLfStat <= 7 & lfs2008$usEmpLfExtr != FALSE,]
# income questions are for at or over 15, with LF status from in paid employment to retired, and answered yes 
# to at least one of the "did you work at least one hour in" questions (or NA to all of them)

