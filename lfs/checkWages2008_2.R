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

################

load('2_data/lfs2008Ready.Rda')
# lfs2008 <- read.csv('2_data/lfs2008Ready.csv')

lfs2008 <- lfs2008[lfs2008$demAge >= 15 & lfs2008$usEmpLfStat <= 7 & (lfs2008$usEmpLfExtr == TRUE | is.na(lfs2008$usEmpLfExtr)),]
# income questions are for at or over 15, with LF status from in paid employment to retired, and answered yes 
# to at least one of the "did you work at least one hour in" questions (or NA to all of them)

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
                            labels = c())

table(lfs2008$usEmpEmplStat) # Empl status: 1 Self employed, 2 Employer, 3 paid employee, 4 unpaid family worker, 5 Other
lfs2008$usEmpEmplStat <- factor(lfs2008$usEmpEmplStat, levels = c('1', '2', '3', '4', '5'),
                                labels = c('Self employed', 'Employer', 'Paid employee', 'Unpaid family worker', 'Other'))
table(lfs2008$usEmpEmplStat) 

# Totals for the occupation, professionals 
# 1 "Senior officials, managers" 
# 2 "Professionals" 
# 3 "Technicians" 
# 4 "Clerks" 
# 5 "Service and market sales workers" 
# 6 "Skilled agricultural" 
#0 7 "Craft workers" 
# 8 "Machine operators" 
# 9 "Elementary occupations" 
# 10  or 0 "Armed forces"  
# 99 "Others"

  

# outcomes: usEmplHrs, incTotal (incFreq, but total should be monthly earnings)

summary(lfs2008$usEmplHrs)
summary(lfs2008$incTotal)

summaryBy(usEmplHrs + incTotal ~ prov, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})

summaryBy(usEmplHrs + incTotal ~ skill, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})

summaryBy(usEmplHrs + incTotal ~ prov + skill, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})

summaryBy(usEmplHrs + incTotal ~ usWrkType, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})

summaryBy(usEmplHrs + incTotal ~ usEmpEmplStat, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})

summaryBy(usEmplHrs + incTotal ~ skill + usEmpEmplStat + usWrkType, data = lfs2008, FUN = function(x) {c(m = mean(x, na.rm = TRUE), s = sd(x, na.rm = TRUE))})
