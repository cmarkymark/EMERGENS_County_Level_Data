#######
#
# In this file, we will put the NFLIS data into long-format
#
#######

## First, we load the wide format data
NFLIS_wide <- read.csv("NFLIS_by_Year.csv")
## Rename first column to "FIPS" for ease
colnames(NFLIS_wide)[1] <- "FIPS"

## Next we are going to create the frame of our long form dataset
NFLIS_long <- NFLIS_wide[,c(1,2)]

## We are going to create a year variable and fill it with 2010
NFLIS_long$Year <- 2010

## We are going to create a fentanyl_total variable and fill it with 2010 values
NFLIS_long$Fentanyl_Total <- NFLIS_wide$NFLIS_2010

## We are going to repeat this general process - while a loop could make this go quickly
## Will go year by year

## 2011
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2011
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2011

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2012
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2012
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2012

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2013
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2013
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2013

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2014
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2014
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2014

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2015
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2015
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2015

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2016
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2016
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2016

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2017
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2017
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2017

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2018
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2018
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2018

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2019
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2019
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2019

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

## 2020
temp <- NFLIS_wide[,c(1,2)]
temp$Year <- 2020
temp$Fentanyl_Total <- NFLIS_wide$NFLIS_2020

## Then we will add into the long_form dataset
NFLIS_long <- rbind(NFLIS_long, temp)

write.csv(NFLIS_long, "NFLIS_long.csv")
