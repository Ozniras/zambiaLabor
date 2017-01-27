library(doBy)
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
temp$usEmpOcc <- df$S4Q8
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

rm(list=c('temp', 'df'))

table(lfs2008$prov)
lfs2008$prov <- factor(lfs2008$prov, levels = c('1', '2', '3', '4', '5', '6', '7', '8', '9'),
                       labels = c('Central', 'Copperbelt', 'Eastern', 'Luapula', 'Lusaka', 'Northern', 'Northwestern', 'Southern', 'Western'))
table(lfs2008$prov)


table(lfs2008$demSex)
lfs2008$demSex <- factor(lfs2008$demSex, levels = c('1', '2'), labels = c('Male', 'Female'))
table(lfs2008$demSex)


# 0 is none
# <= 6 is none or primary incomplete
# grade 7 is primary complete
# 8 - 12 is secondary, with 12 secondary complete
# 13 is some college
# unskilled labor: eduLvlAch <= 6 primary incomplete
# semi-skilled: eduLvlAch > 6 and <  14 
# skilled: eduLvlAch >= 14 college complete
table(lfs2008$eduLvlAch)
lfs2008$eduLvlAch <- cut(lfs2008$eduLvlAch, 
                         c(-Inf, 6, 13, Inf), 
                         labels = c('Unskilled', 'Semi-skilled', 'Skilled'))
table(lfs2008$eduLvlAch)

# 11 - 32 "Agriculture, Forestry and Fishing" 
# 51 - 99 "Mining" 
# 101 - 332 "Manufacturing" 
# 351 - 390 "Public utilities" 
# 410 - 439 "Construction"  
# 451 - 479 "Commerce" 
# 491 - 639 "Transport and Comnunications" 
# 641 - 829 "Financial and Business Services" 
# 841 - 843 "Public Administration" 
# 851 - 990 "Other Services, Unspecified"
# Most numbres from 101 to 9892. Probably a fourth digit of precision, so divide by 100 and keep int
# Exception: 6 with value 11. We will turn that to 111 so it becomes agriculture
# Also, checking codes in manual, the 45 with 101 and 4 with 110 look suspicous. 
# We first will turn those to 1010 and 1110 so they become manufacturing
lfs2008$usEmpInd[lfs2008$usEmpInd == 11] <- 111
lfs2008$usEmpInd[lfs2008$usEmpInd == 101 | lfs2008$usEmpInd == 110] <- 1010
lfs2008$usEmpInd <- cut(as.integer(lfs2008$usEmpInd / 100), 
                        c(0, 3, 9, 33, 39, 43, 47, 63, 82, 84, 99), 
                        labels = c('Agriculture', 'Mining', 'Manufacturing', 'Public utilities', 'Construction', 'Commerce', 'Transport and Comm', 'Fin and Bus serv', 'Public Admin', 'Other serv'))
table(lfs2008$usEmpInd)

table(lfs2008$usWrkType)
# 1 Permanent 2 Fixed Period 3 Temporary 4 Part-Time 5 Seasonal 9 Don't know
# 6 is an error, we'll put in 9
lfs2008$usWrkType[lfs2008$usWrkType == 6] <- 9
lfs2008$usWrkType <- factor(lfs2008$usWrkType, levels = c('1', '2', '3', '4', '5', '9'), 
                            labels = c('Permanent', 'Fixed period', 'Temporary', 'Part-time', 'Seasonal', "Don't know"))
table(lfs2008$usWrkType)

table(lfs2008$usBusType) # Business type (1 Central Gov etc)
lfs2008$usBusType <- factor(lfs2008$usBusType, levels = c('1', '2', '3', '4', '5', '6', '7'),
                            labels = c('Central Gov', 'Local Gov', 'Parastatal', 'Private', 'NGO or church', 'International', 'Household'))
table(lfs2008$usBusType) 

table(lfs2008$usEmpEmplStat) # Empl status: 1 Self employed, 2 Employer, 3 paid employee, 4 unpaid family worker, 5 Other
lfs2008$usEmpEmplStat <- factor(lfs2008$usEmpEmplStat, levels = c('1', '2', '3', '4', '5'),
                                labels = c('Self employed', 'Employer', 'Paid employee', 'Unpaid family worker', 'Other'))
table(lfs2008$usEmpEmplStat) 

table(lfs2008$usEmpOcc)
# Totals for the occupation, professionals 
# 1 "Senior officials, managers" 
# 2 "Professionals" 
# 3 "Technicians" 
# 4 "Clerks" 
# 5 "Service and market sales workers" 
# 6 "Skilled agricultural" 
# 7 "Craft workers" 
# 8 "Machine operators" 
# 9 "Elementary occupations" 
# 10  or 0 "Armed forces"  
# 99 "Others"
lfs2008$usEmpOcc <- factor(as.integer(substr(lfs2008$usEmpOcc, 1, 1)), 
                           levels = c('1', '2', '3', '4', '5', '6', '7', '8', '9', '0'),
                           labels = c('Senior, managers', 'Professionals', 'Technicians', 'Clerks', 'Service and market sales', 
                                      'Skilled agricultural', 'Craft', 'Machine operators', 'Elementary occupations', 'Armed forces'))
table(lfs2008$usEmpOcc)



write.csv(lfs2008, '2_data/lfs2008Ready.csv')
save(lfs2008, file = '2_data/lfs2008Ready.Rda')
