library(survey)
library(foreign)
library(dplyr)
setwd('~/dataDrive/dataProjects/povMap/zambiaLFSmapping/')
df <- read.dta('0_originalData/lfs/ZM_2012LFS_vFinal.dta')
# variables D4 and D8 are missing. D4 is important as it tells us employment status. 
# We can deduce if it's paid employee / apprentice or employer / self-employed / unpaid family worker as only paid employee / apprenctice
# answer D6 - D3 (with D7 and D8 also missing)
# and the same answer section FA while the latter answer FB

df <- df %>% rename(age = A3, sex = A2)
df$C1 <- as.numeric(df$C1)
df$C2 <- as.numeric(df$C2)
df <- subset(df, age >= 5 & C1 < 8) # for compatibility with 2008, drop if C1 == 8 (in school); from 9 on, jump sections

df$lfEmployed <- (df$C1 >= 1 & df$C1 <= 3) | (df$C2 == 1) | (df$C3 == 1) 
summary(df$lfEmployed)
# there are 278 NA's because they have C3 as NA even though C2 == 2, so they should have something there

df$hintEmplStatusPaid <- !is.na(df$FA1)
df$hintEmplStatusSelf <- !is.na(df$FB1)

summary(df$hintEmplStatusPaid)
summary(df$hintEmplStatusSelf)
nrow(df)
# 6,172 out of 20,905 which should have income info are wihtout income info
df$incomePaid <- df$FA5B
summary(df$FA6)

temp <- as.numeric(df$FA6)
df$incomePaidRange <- 250000 / 2 * (temp == 1) +
  (250000 + 500000) / 2 * (temp == 2) +
  (500000 + 1000000) / 2 * (temp == 3) +
  (1000000 + 1500000) / 2 * (temp == 4) +
  (1500000 + 2000000) / 2 * (temp == 5) +
  (2000000 + 3000000) / 2 * (temp == 6) +
  (3000000 + 5000000) / 2 * (temp == 7) +
  (5000000 + 10000000) / 2 * (temp == 8) +
  (10000000 + 20000000) / 2 * (temp == 9) +
  (20000000) / 2 * (temp == 10)
df$incomePaidRange <- ifelse(temp > 10 | is.na(temp), NA, df$incomePaidRange)

sum(!is.na(df$incomePaid))
sum(!is.na(df$incomePaidRange))
sum(!is.na(df$incomePaid) & !is.na(df$incomePaidRange))
sum(is.na(df$incomePaid) & !is.na(df$incomePaidRange))
# what a mess, there are 3674 with both, 4217 with the actual pay and 3906 with the range
# but they actually ask different things: pay after deductions for taxes and soc sec contrib
# vs without asking for those deductions
# there are 232 with exact pay (and deductions) without range. LET'S CHECK 2008