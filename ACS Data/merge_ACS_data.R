

##################################
## In this doc, we merge all of ##
## the ACS data we have         ##
## collected for modeling       ##
##################################

##############################
## First, the ACS DPO3 form ##
## contains information on  ##
## - unemployment           ##
## - income                 ##
## - poverty                ##
## - insurance              ##
##############################

## First we load the datasets
df_10 <- read.csv("DP03/ACS_10_5YR_DP03_with_ann.csv", header = T)
df_11 <- read.csv("DP03/ACS_11_5YR_DP03_with_ann.csv", header = T)
df_12 <- read.csv("DP03/ACS_12_5YR_DP03_with_ann.csv", header = T)
df_13 <- read.csv("DP03/ACS_13_5YR_DP03_with_ann.csv", header = T)
df_14 <- read.csv("DP03/ACS_14_5YR_DP03_with_ann.csv", header = T)
df_15 <- read.csv("DP03/ACS_15_5YR_DP03_with_ann.csv", header = T)
df_16 <- read.csv("DP03/ACS_16_5YR_DP03_with_ann.csv", header = T)
df_17 <- read.csv("DP03/ACS_17_5YR_DP03_with_ann.csv", header = T)

##
## Changes in data reporting in 2018
##

df_18 <- read.csv("DP03/ACSDP5Y2018.DP03_data_with_overlays_2020-08-28T142832.csv", header = T)
df_19 <- read.csv("DP03/ACSDP5Y2019.DP03_data_with_overlays_2021-08-15T185016.csv", header = T)
df_20 <- read.csv("DP03/ACSDP5Y2020.DP03_data_with_overlays_2022-04-22T163517.csv", header = T)


## In df_10 - df_17, the county FIPS code is contained within the GEO.id2 variable
## However, in later years, the county FIPS is contained at the end of the GEO_ID variable
## THe following code pulls the FIPS code out of GEO_ID and places it into GEO.id2

## First we create a helper function that will let us pull the final five characters
## From GEO_ID which contain the FIPS code
## Note that the function is general and the user must specify how many of the final characters to extract
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

df_18$GEO.id2 <- as.numeric(substrRight(as.character(df_18$GEO_ID),5))
df_19$GEO.id2 <- as.numeric(substrRight(as.character(df_19$GEO_ID),5))
df_20$GEO.id2 <- as.numeric(substrRight(as.character(df_20$GEO_ID),5))

##
## Next, we are going to start generating our final dataset
## We will only include counties for which there is data in 2010.
##

## We grab the 2nd and 3rd columns from the df_10 data.frame
## These columns contain the fips code and the county name
final_df <- df_10[-c(1),c(2:3)]

## We then rename the counties for convenience
colnames(final_df) <- c("ID","County")

## We then include a year variable, indicating that this set of rows 
## is for data corresponding to 2010
final_df$Year <- 2010

## Now we want to create rows for 2011 through 2020
## So first we will create a duplicate of one year of data by copying final_df
sample <- final_df

## Next we will loop through each year from 2011 to 2020 
## WE will take the copy of one year of data and change the year to the given year
## Last we will add this updated dataframe to the end of final_df
for(year in 2011:2020){
  add <- sample
  add$Year <- year
  
  final_df <- rbind(final_df, add)
}

## the ID variable somehow ended up being character data
## So here we just convert it into numeric data
final_df$ID <- as.numeric(final_df$ID)

## Now the frame of our final dataset has been generated
## So now we will start adding the actual data to it!

##################
## Unemployment ##
##################

## 2010
final_df$Unemployment_Rate <- NA

##
## For 2010-2012 dataset
## HC03_VC13 is the percent
##

## We will loop through every county in our dataset
## We loop through df_10 because it allows us to loop through each county once
for(i in 2:nrow(df_10)){
  
  ## We extract the FIPS code for the given county
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  
  ## We use the FIPS code to then extract the unemployment rate from the appropriate dataset
  unemployment_rate <- as.numeric(as.character(df_10$HC03_VC13[i]))
  
  ## Then we save the unemployment rate
  final_df$Unemployment_Rate[final_df$ID == id &
                               final_df$Year == 2010] <- unemployment_rate
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_11$HC03_VC13[i]))
  
  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2011] <- unemployment_rate
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_12$HC03_VC13[i]))

  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2012] <- unemployment_rate
  
}

## 2013

##
## For 2013-7 dataset
## HC03_VC07 is the percent
##

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_13$HC03_VC07[i]))
  
  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2013] <- unemployment_rate
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_14$HC03_VC07[i]))

  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2014] <- unemployment_rate

}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_15$HC03_VC07[i]))
 
  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2015] <- unemployment_rate

}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_16$HC03_VC07[i]))

  final_df$Unemployment_Rate[final_df$ID == id& final_df$Year == 2016] <- unemployment_rate

}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  unemployment_rate <- as.numeric(as.character(df_17$HC03_VC07[i]))

  final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2017] <- unemployment_rate

}

## For 2018-2020 DP03_0005PE is the percent

## 2018

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  ## The sizes of datasets changed beginning in 2018, so this just makes sure
  ## the FIPS code we grabbed is in the final dataset
  if(id %in% final_df$ID){
    unemployment_rate <- as.numeric(as.character(df_18$DP03_0005PE[i]))
   
    final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2018] <- unemployment_rate
    
    }
}

## 2019
for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% final_df$ID){
    unemployment_rate <- as.numeric(as.character(df_19$DP03_0005PE[i]))
       
    final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2019] <- unemployment_rate
   }
}

## 2020
for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% final_df$ID){
    unemployment_rate <- as.numeric(as.character(df_20$DP03_0005PE[i]))
    
    final_df$Unemployment_Rate[final_df$ID == id & final_df$Year == 2020] <- unemployment_rate
  }
}

######################
## End Unemployment ##
######################

############################
## Median and Mean Income ##
############################

## Median HC01_VC85
## Mean HC01_VC86

## 2010
final_df$Median_Household_Income <- NA
final_df$Mean_Household_Income <- NA


for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  median <- as.numeric(as.character(df_10$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_10$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2010] <- median
  final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2010] <- mean
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  median <- as.numeric(as.character(df_11$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_11$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2011] <- median
  final_df$Mean_Household_Income[final_df$ID == id& final_df$Year == 2011] <- mean
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  median <- as.numeric(as.character(df_12$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_12$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id& final_df$Year == 2012] <- median
  final_df$Mean_Household_Income[final_df$ID == id& final_df$Year == 2012] <- mean
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  median <- as.numeric(as.character(df_13$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_13$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2013] <- median
  final_df$Mean_Household_Income[final_df$ID == id& final_df$Year == 2013] <- mean
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  median <- as.numeric(as.character(df_14$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_14$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2014] <- median
  final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2014] <- mean
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  median <- as.numeric(as.character(df_15$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_15$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id& final_df$Year == 2015] <- median
  final_df$Mean_Household_Income[final_df$ID == id& final_df$Year == 2015] <- mean
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  median <- as.numeric(as.character(df_16$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_16$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2016] <- median
  final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2016] <- mean
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  median <- as.numeric(as.character(df_17$HC01_VC85[i]))
  mean <- as.numeric(as.character(df_17$HC01_VC86[i]))
  
  final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2017] <- median
  final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2017] <- mean
  
}

## 2018
## Median DP03_0062E
## Mean DP03_0063E

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    median <- as.numeric(as.character(df_18$DP03_0062E[i]))
    mean <- as.numeric(as.character(df_18$DP03_0063E[i]))
    
    final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2018] <- median
    final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2018] <- mean
  }
  
}

## 2019

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    median <- as.numeric(as.character(df_19$DP03_0062E[i]))
    mean <- as.numeric(as.character(df_19$DP03_0063E[i]))
    
    final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2019] <- median
    final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2019] <- mean
  }
  
}

## 2020

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    median <- as.numeric(as.character(df_20$DP03_0062E[i]))
    mean <- as.numeric(as.character(df_20$DP03_0063E[i]))
    
    final_df$Median_Household_Income[final_df$ID == id & final_df$Year == 2020] <- median
    final_df$Mean_Household_Income[final_df$ID == id & final_df$Year == 2020] <- mean
  }
  
}
################################
## End Median and Mean Income ##
################################

#############
## Poverty ##
#############

## Poverty for 2010 - 2012
## HC03_VC156

final_df$Proportion_Poverty <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_10$HC03_VC156[i]))
 
  final_df$Proportion_Poverty[final_df$ID == id & final_df$Year == 2010] <- poverty
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_11$HC03_VC156[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2011] <- poverty
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_12$HC03_VC156[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2012] <- poverty
  
}

## Poverty for 2013 - 2017
## HC03_VC161

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_13$HC03_VC161[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2013] <- poverty
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_14$HC03_VC161[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2014] <- poverty
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_15$HC03_VC161[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2015] <- poverty
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_16$HC03_VC161[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2016] <- poverty
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  poverty <- as.numeric(as.character(df_17$HC03_VC161[i]))
  
  final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2017] <- poverty
  
}

## 2018
#DP03_0119PE

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    poverty <- as.numeric(as.character(df_18$DP03_0119PE[i]))
    
    final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2018] <- poverty
    
  }
  
}

## 2019
for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    poverty <- as.numeric(as.character(df_19$DP03_0119PE[i]))
    
    final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2019] <- poverty
    
  }
  
}

## 2020
for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    poverty <- as.numeric(as.character(df_20$DP03_0119PE[i]))
    
    final_df$Proportion_Poverty[final_df$ID == id& final_df$Year == 2020] <- poverty
    
  }
  
}

#################
## End Poverty ##
#################

###############
## Uninsured ##
###############

##
## Data only for 2012 - 2017
## for 2012: HC03_VC131
## for 2013-7: HC03_VC134

final_df$Proportion_Uninsured <- NA

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_12$HC03_VC131[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id& final_df$Year == 2012] <- uninsured
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_13$HC03_VC134[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2013] <- uninsured
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_14$HC03_VC134[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2014] <- uninsured
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_15$HC03_VC134[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2015] <- uninsured
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_16$HC03_VC134[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2016] <- uninsured
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  uninsured <- as.numeric(as.character(df_17$HC03_VC134[i]))
  
  final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2017] <- uninsured
  
  
}

## 2018 DP03_0099PE

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    uninsured <- as.numeric(as.character(df_18$DP03_0099PE[i]))
    
    final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2018] <- uninsured
    
  }
}

## 2019 

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    uninsured <- as.numeric(as.character(df_19$DP03_0099PE[i]))
    
    final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2019] <- uninsured

  }
}

## 2020

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    uninsured <- as.numeric(as.character(df_20$DP03_0099PE[i]))
    
    final_df$Proportion_Uninsured[final_df$ID == id & final_df$Year == 2020] <- uninsured
    
  }
}

###################
## End Uninsured ##
###################


##############################
## Next, the ACS DPO4 form  ##
## contains information on  ##
## - vehicle ownership      ##
## - proprotion of income   ##
##    spent on housing      ##
##      - as owner          ##
##      - as rentor         ##
##############################

df_10 <- read.csv("DP04/ACS_10_5YR_DP04_with_ann.csv", header = T)
df_11 <- read.csv("DP04/ACS_11_5YR_DP04_with_ann.csv", header = T)
df_12 <- read.csv("DP04/ACS_12_5YR_DP04_with_ann.csv", header = T)
df_13 <- read.csv("DP04/ACS_13_5YR_DP04_with_ann.csv", header = T)
df_14 <- read.csv("DP04/ACS_14_5YR_DP04_with_ann.csv", header = T)
df_15 <- read.csv("DP04/ACS_15_5YR_DP04_with_ann.csv", header = T)
df_16 <- read.csv("DP04/ACS_16_5YR_DP04_with_ann.csv", header = T)
df_17 <- read.csv("DP04/ACS_17_5YR_DP04_with_ann.csv", header = T)
df_18 <- read.csv("DP04/ACSDP5Y2018.DP04_data_with_overlays_2020-08-22T042350.csv", header = T)
df_19 <- read.csv("DP04/ACSDP5Y2019.DP04_data_with_overlays_2021-07-29T170002.csv", header = T)
df_20 <- read.csv("DP04/ACSDP5Y2020.DP04_data_with_overlays_2022-04-23T225601.csv", header = T)


df_18$GEO.id2 <- as.numeric(substrRight(as.character(df_18$GEO_ID),5))
df_19$GEO.id2 <- as.numeric(substrRight(as.character(df_19$GEO_ID),5))
df_20$GEO.id2 <- as.numeric(substrRight(as.character(df_20$GEO_ID),5))



#######################
## Vehicle Ownership ##
#######################

## 2010 - 2012: HC03_VC82
## 2013 - 2014: HC03_V84
## 2015 - 2017: HC03_V85
## 2018 DP04_0058PE

final_df$Proportion_Homes_No_Vehicle <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_10$HC03_VC82[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2010] <- no_vehicle
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_11$HC03_VC82[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2011] <- no_vehicle
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_12$HC03_VC82[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2012] <- no_vehicle

}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_13$HC03_VC84[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2013] <- no_vehicle
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_14$HC03_VC84[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2014] <- no_vehicle
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_15$HC03_VC85[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2015] <- no_vehicle
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_16$HC03_VC85[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2016] <- no_vehicle
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  no_vehicle <- as.numeric(as.character(df_17$HC03_VC85[i]))
  
  final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2017] <- no_vehicle
  
}

## 2018 DP04_0058PE
for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  if(id %in% unique(final_df$ID)){
    no_vehicle <- as.numeric(as.character(df_18$DP04_0058PE[i]))
    
    final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2018] <- no_vehicle
  }
  
}

## 2019 DP04_0058PE
for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  if(id %in% unique(final_df$ID)){
    no_vehicle <- as.numeric(as.character(df_19$DP04_0058PE[i]))
    
    final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2019] <- no_vehicle
  }
  
}

## 2020
for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  if(id %in% unique(final_df$ID)){
    no_vehicle <- as.numeric(as.character(df_20$DP04_0058PE[i]))
    
    final_df$Proportion_Homes_No_Vehicle[final_df$ID == id & final_df$Year == 2020] <- no_vehicle
  }
  
}

###########################
## End Vehicle Ownership ##
###########################


############################################
## Income Spent on Homeownership and Rent ##
############################################

## Note that these are homeowners WITH a mortgage

## Homeowner
## 2010 - 2012: HC03_VC160
## 2013 - 2014: HC03_VC162
## 2015 - 2017: HC03_VC164
## 2018 - 2020 DP04_0115PE


## Renter
## 2010 - 2012: HC03_VC197
## 2013 - 2014: HC03_VC202
## 2015 - 2017: HC03_VC204
## 2018 - 2020 DP04_0142PE

final_df$Proportion_Homeowners_35Perc_Income_on_Home <- NA
final_df$Proportion_Renters_35Perc_Income_on_Rent <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  home <- as.numeric(as.character(df_10$HC03_VC160[i]))
  rent <- as.numeric(as.character(df_10$HC03_VC197[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2010] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2010] <- rent
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  home <- as.numeric(as.character(df_11$HC03_VC160[i]))
  rent <- as.numeric(as.character(df_11$HC03_VC197[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2011] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2011] <- rent
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  home <- as.numeric(as.character(df_12$HC03_VC160[i]))
  rent <- as.numeric(as.character(df_12$HC03_VC197[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2012] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2012] <- rent
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  home <- as.numeric(as.character(df_13$HC03_VC162[i]))
  rent <- as.numeric(as.character(df_13$HC03_VC202[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2013] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2013] <- rent
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  home <- as.numeric(as.character(df_14$HC03_VC162[i]))
  rent <- as.numeric(as.character(df_14$HC03_VC202[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2014] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2014] <- rent
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  home <- as.numeric(as.character(df_15$HC03_VC164[i]))
  rent <- as.numeric(as.character(df_15$HC03_VC204[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2015] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2015] <- rent
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  home <- as.numeric(as.character(df_16$HC03_VC164[i]))
  rent <- as.numeric(as.character(df_16$HC03_VC204[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2016] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2016] <- rent
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  home <- as.numeric(as.character(df_17$HC03_VC164[i]))
  rent <- as.numeric(as.character(df_17$HC03_VC204[i]))
  
  final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2017] <- home
  final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2017] <- rent
  
}


## 2018 

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    home <- as.numeric(as.character(df_18$DP04_0115PE[i]))
    rent <- as.numeric(as.character(df_18$DP04_0142PE[i]))
    final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2018] <- home
    final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2018] <- rent
  }
}

## 2019 

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    home <- as.numeric(as.character(df_19$DP04_0115PE[i]))
    rent <- as.numeric(as.character(df_19$DP04_0142PE[i]))
    final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2019] <- home
    final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2019] <- rent
  }
}

## 2020

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    home <- as.numeric(as.character(df_20$DP04_0115PE[i]))
    rent <- as.numeric(as.character(df_20$DP04_0142PE[i]))
    final_df$Proportion_Homeowners_35Perc_Income_on_Home[final_df$ID == id & final_df$Year == 2020] <- home
    final_df$Proportion_Renters_35Perc_Income_on_Rent[final_df$ID == id & final_df$Year == 2020] <- rent
  }
}

######################
## End Income Spent ## 
######################



##############################
## Next, the ACS DPO5 form  ##
## contains information on  ##
## - race/ethnicity         ##
## - proportion male        ##
##############################

df_10 <- read.csv("DP05/ACS_10_5YR_DP05_with_ann.csv", header = T)
df_11 <- read.csv("DP05/ACS_11_5YR_DP05_with_ann.csv", header = T)
df_12 <- read.csv("DP05/ACS_12_5YR_DP05_with_ann.csv", header = T)
df_13 <- read.csv("DP05/ACS_13_5YR_DP05_with_ann.csv", header = T)
df_14 <- read.csv("DP05/ACS_14_5YR_DP05_with_ann.csv", header = T)
df_15 <- read.csv("DP05/ACS_15_5YR_DP05_with_ann.csv", header = T)
df_16 <- read.csv("DP05/ACS_16_5YR_DP05_with_ann.csv", header = T)
df_17 <- read.csv("DP05/ACS_17_5YR_DP05_with_ann.csv", header = T)
df_18 <- read.csv("DP05/ACSDP5Y2018.DP05_data_with_overlays_2020-08-24T033452.csv", header = T)
df_19 <- read.csv("DP05/ACSDP5Y2019.DP05_data_with_overlays_2021-07-22T130002.csv", header = T)
df_20 <- read.csv("DP05/ACSDP5Y2020.DP05_data_with_overlays_2022-04-22T101310.csv", header = T)

df_18$GEO.id2 <- as.numeric(substrRight(as.character(df_18$GEO_ID),5))
df_19$GEO.id2 <- as.numeric(substrRight(as.character(df_19$GEO_ID),5))
df_20$GEO.id2 <- as.numeric(substrRight(as.character(df_20$GEO_ID),5))

###
#Race (alone or in combination with other races)
# White 2010 - 2012: HC03_VC72 2013 - 2016: HC03_VC78 2017: HC03_VC83
# Black 2010 - 2012: HC03_VC73 2013 - 2016: HC03_VC79 2017: HC03_VC84
# American Indian/Alaska Native 2010 - 2012: HC03_VC74 2013 - 2016: HC03_VC80 2017: HC03_VC85
# Asian 2010 - 2012: HC03_VC75 2013 - 2016: HC03_VC81 2017: HC03_VC86
# Native Hawaiian and Other Pacific Islander 2010 - 2012: HC03_VC76  2013 - 2016: HC03_VC82 2017: HC03_VC87
##

final_df$Proportion_White <- NA
final_df$Proportion_Black <- NA
final_df$Proportion_American_Indian_Alaska_Native <- NA
final_df$Proportion_Asian <- NA
final_df$Proportion_Native_Hawaiian_Pacific_Islander <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_10$HC03_VC72[i]))
  black <- as.numeric(as.character(df_10$HC03_VC73[i]))
  indigenous <- as.numeric(as.character(df_10$HC03_VC74[i]))
  asian <- as.numeric(as.character(df_10$HC03_VC75[i]))
  pacific <- as.numeric(as.character(df_10$HC03_VC76[i]))
  
  final_df$Proportion_White[final_df$ID == id & final_df$Year == 2010] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2010] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2010] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2010] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2010] <- pacific
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_11$HC03_VC72[i]))
  black <- as.numeric(as.character(df_11$HC03_VC73[i]))
  indigenous <- as.numeric(as.character(df_11$HC03_VC74[i]))
  asian <- as.numeric(as.character(df_11$HC03_VC75[i]))
  pacific <- as.numeric(as.character(df_11$HC03_VC76[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2011] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2011] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2011] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2011] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2011] <- pacific
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_12$HC03_VC72[i]))
  black <- as.numeric(as.character(df_12$HC03_VC73[i]))
  indigenous <- as.numeric(as.character(df_12$HC03_VC74[i]))
  asian <- as.numeric(as.character(df_12$HC03_VC75[i]))
  pacific <- as.numeric(as.character(df_12$HC03_VC76[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2012] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2012] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2012] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2012] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2012] <- pacific
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_13$HC03_VC78[i]))
  black <- as.numeric(as.character(df_13$HC03_VC79[i]))
  indigenous <- as.numeric(as.character(df_13$HC03_VC80[i]))
  asian <- as.numeric(as.character(df_13$HC03_VC81[i]))
  pacific <- as.numeric(as.character(df_13$HC03_VC82[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2013] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2013] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2013] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2013] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2013] <- pacific
  
}

# ## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_14$HC03_VC78[i]))
  black <- as.numeric(as.character(df_14$HC03_VC79[i]))
  indigenous <- as.numeric(as.character(df_14$HC03_VC80[i]))
  asian <- as.numeric(as.character(df_14$HC03_VC81[i]))
  pacific <- as.numeric(as.character(df_14$HC03_VC82[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2014] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2014] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2014] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2014] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2014] <- pacific
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_15$HC03_VC78[i]))
  black <- as.numeric(as.character(df_15$HC03_VC79[i]))
  indigenous <- as.numeric(as.character(df_15$HC03_VC80[i]))
  asian <- as.numeric(as.character(df_15$HC03_VC81[i]))
  pacific <- as.numeric(as.character(df_15$HC03_VC82[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2015] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2015] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2015] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2015] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2015] <- pacific
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_16$HC03_VC78[i]))
  black <- as.numeric(as.character(df_16$HC03_VC79[i]))
  indigenous <- as.numeric(as.character(df_16$HC03_VC80[i]))
  asian <- as.numeric(as.character(df_16$HC03_VC81[i]))
  pacific <- as.numeric(as.character(df_16$HC03_VC82[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2016] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2016] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2016] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2016] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2016] <- pacific
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  
  white <- as.numeric(as.character(df_17$HC03_VC83[i]))
  black <- as.numeric(as.character(df_17$HC03_VC84[i]))
  indigenous <- as.numeric(as.character(df_17$HC03_VC85[i]))
  asian <- as.numeric(as.character(df_17$HC03_VC86[i]))
  pacific <- as.numeric(as.character(df_17$HC03_VC87[i]))
  
  
  final_df$Proportion_White[final_df$ID == id& final_df$Year == 2017] <- white
  final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2017] <- black
  final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2017] <- indigenous
  final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2017] <- asian
  final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2017] <- pacific
  
}

### 2018
### White DP05_0064PE
### Black DP05_0065PE
### Indigenous DP05_0066PE
### Asian DP05_0067PE
### Pacific DP05_0068PE

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    white <- as.numeric(as.character(df_18$DP05_0064PE[i]))
    black <- as.numeric(as.character(df_18$DP05_0065PE[i]))
    indigenous <- as.numeric(as.character(df_18$DP05_0066PE[i]))
    asian <- as.numeric(as.character(df_18$DP05_0067PE[i]))
    pacific <- as.numeric(as.character(df_18$DP05_0068PE[i]))
    
    
    final_df$Proportion_White[final_df$ID == id& final_df$Year == 2018] <- white
    final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2018] <- black
    final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2018] <- indigenous
    final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2018] <- asian
    final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2018] <- pacific
    
  }
}

### 2019

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    white <- as.numeric(as.character(df_19$DP05_0064PE[i]))
    black <- as.numeric(as.character(df_19$DP05_0065PE[i]))
    indigenous <- as.numeric(as.character(df_19$DP05_0066PE[i]))
    asian <- as.numeric(as.character(df_19$DP05_0067PE[i]))
    pacific <- as.numeric(as.character(df_19$DP05_0068PE[i]))
    
    
    final_df$Proportion_White[final_df$ID == id& final_df$Year == 2019] <- white
    final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2019] <- black
    final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2019] <- indigenous
    final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2019] <- asian
    final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2019] <- pacific
    
  }
}

### 2020

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    white <- as.numeric(as.character(df_20$DP05_0064PE[i]))
    black <- as.numeric(as.character(df_20$DP05_0065PE[i]))
    indigenous <- as.numeric(as.character(df_20$DP05_0066PE[i]))
    asian <- as.numeric(as.character(df_20$DP05_0067PE[i]))
    pacific <- as.numeric(as.character(df_20$DP05_0068PE[i]))
    
    
    final_df$Proportion_White[final_df$ID == id& final_df$Year == 2020] <- white
    final_df$Proportion_Black[final_df$ID == id& final_df$Year == 2020] <- black
    final_df$Proportion_American_Indian_Alaska_Native[final_df$ID == id& final_df$Year == 2020] <- indigenous
    final_df$Proportion_Asian[final_df$ID == id& final_df$Year == 2020] <- asian
    final_df$Proportion_Native_Hawaiian_Pacific_Islander[final_df$ID == id& final_df$Year == 2020] <- pacific
    
  }
}

##
## Proportion Male
## 2010 - 2017: HC03_VC04
## 2018 - 2020 DP05_0002PE

final_df$Proportion_Male <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  male <- as.numeric(as.character(df_10$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2010] <- male
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  male <- as.numeric(as.character(df_11$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2011] <- male
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  male <- as.numeric(as.character(df_12$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2012] <- male
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  male <- as.numeric(as.character(df_13$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2013] <- male
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  male <- as.numeric(as.character(df_14$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2014] <- male
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  male <- as.numeric(as.character(df_15$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2015] <- male
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  male <- as.numeric(as.character(df_16$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2016] <- male
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  male <- as.numeric(as.character(df_17$HC03_VC04[i]))
  
  final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2017] <- male
  
}

## 2018 DP05_0002PE

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    male <- as.numeric(as.character(df_18$DP05_0002PE[i]))
    
    final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2018] <- male
  }

}

## 2019 DP05_0002PE

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    male <- as.numeric(as.character(df_19$DP05_0002PE[i]))
    
    final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2019] <- male
  }
  
}

## 2020 DP05_0002PE

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    male <- as.numeric(as.character(df_20$DP05_0002PE[i]))
    
    final_df$Proportion_Male[final_df$ID == id& final_df$Year == 2020] <- male
  }
  
}

##############################
## Next, the ACS S1501 form ##
## contains information on  ##
## - education              ##
##############################

df_10 <- read.csv("S1501/ACS_10_5YR_S1501_with_ann.csv", header = T)
df_11 <- read.csv("S1501/ACS_11_5YR_S1501_with_ann.csv", header = T)
df_12 <- read.csv("S1501/ACS_12_5YR_S1501_with_ann.csv", header = T)
df_13 <- read.csv("S1501/ACS_13_5YR_S1501_with_ann.csv", header = T)
df_14 <- read.csv("S1501/ACS_14_5YR_S1501_with_ann.csv", header = T)
df_15 <- read.csv("S1501/ACS_15_5YR_S1501_with_ann.csv", header = T)
df_16 <- read.csv("S1501/ACS_16_5YR_S1501_with_ann.csv", header = T)
df_17 <- read.csv("S1501/ACS_17_5YR_S1501_with_ann.csv", header = T)
df_18 <- read.csv("S1501/ACSST5Y2018.S1501_data_with_overlays_2020-08-20T172344.csv", header = T)
df_19 <- read.csv("S1501/ACSST5Y2019.S1501_data_with_overlays_2021-07-29T195527.csv", header = T)
df_20 <- read.csv("S1501/ACSST5Y2020.S1501_data_with_overlays_2022-04-23T222730.csv", header = T)

df_18$GEO.id2 <- as.numeric(substrRight(as.character(df_18$GEO_ID),5))
df_19$GEO.id2 <- as.numeric(substrRight(as.character(df_19$GEO_ID),5))
df_20$GEO.id2 <- as.numeric(substrRight(as.character(df_20$GEO_ID),5))


##
## Percent with High School Education or greater 2010 - 2014: HC01_EST_VC16 2015 - 2017: HC02_EST_VC17
## Percent with College Education or greater 2010 - 2014: HC01_EST_VC17 2015 - 2017: HC02_EST_VC18
##

final_df$Proportion_High_School_or_Greater <- NA
final_df$Proportion_Bachelors_Degree_or_Greater <- NA

## 2010

for(i in 2:nrow(df_10)){
  
  id <- as.numeric(as.character(df_10$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_10$HC01_EST_VC16[i]))
  college <- as.numeric(as.character(df_10$HC01_EST_VC17[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2010] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id& final_df$Year == 2010] <- college
  
}

## 2011

for(i in 2:nrow(df_11)){
  
  id <- as.numeric(as.character(df_11$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_11$HC01_EST_VC16[i]))
  college <- as.numeric(as.character(df_11$HC01_EST_VC17[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2011] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2011] <- college
  
}

## 2012

for(i in 2:nrow(df_12)){
  
  id <- as.numeric(as.character(df_12$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_12$HC01_EST_VC16[i]))
  college <- as.numeric(as.character(df_12$HC01_EST_VC17[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2012] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2012] <- college
  
}

## 2013

for(i in 2:nrow(df_13)){
  
  id <- as.numeric(as.character(df_13$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_13$HC01_EST_VC16[i]))
  college <- as.numeric(as.character(df_13$HC01_EST_VC17[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2013] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2013] <- college
  
}

## 2014

for(i in 2:nrow(df_14)){
  
  id <- as.numeric(as.character(df_14$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_14$HC01_EST_VC16[i]))
  college <- as.numeric(as.character(df_14$HC01_EST_VC17[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2014] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2014] <- college
  
}

## 2015

for(i in 2:nrow(df_15)){
  
  id <- as.numeric(as.character(df_15$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_15$HC02_EST_VC17[i]))
  college <- as.numeric(as.character(df_15$HC02_EST_VC18[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2015] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2015] <- college
  
}

## 2016

for(i in 2:nrow(df_16)){
  
  id <- as.numeric(as.character(df_16$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_16$HC02_EST_VC17[i]))
  college <- as.numeric(as.character(df_16$HC02_EST_VC18[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2016] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id& final_df$Year == 2016] <- college
  
}

## 2017

for(i in 2:nrow(df_17)){
  
  id <- as.numeric(as.character(df_17$GEO.id2[i]))
  
  highschool <- as.numeric(as.character(df_17$HC02_EST_VC17[i]))
  college <- as.numeric(as.character(df_17$HC02_EST_VC18[i]))
  
  final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2017] <- highschool
  final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2017] <- college
  
}

## 2018
## high school S1501_C02_014E
## bachelors or greater S1501_C02_015E

for(i in 2:nrow(df_18)){
  
  id <- as.numeric(as.character(df_18$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    highschool <- as.numeric(as.character(df_18$S1501_C02_014E[i]))
    college <- as.numeric(as.character(df_18$S1501_C02_015E[i]))
    final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2018] <- highschool
    final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2018] <- college
    
  }
}

## 2019

for(i in 2:nrow(df_19)){
  
  id <- as.numeric(as.character(df_19$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    highschool <- as.numeric(as.character(df_19$S1501_C02_014E[i]))
    college <- as.numeric(as.character(df_19$S1501_C02_015E[i]))
    final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2019] <- highschool
    final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2019] <- college
    
  }
}

## 2020

## 2019

for(i in 2:nrow(df_20)){
  
  id <- as.numeric(as.character(df_20$GEO.id2[i]))
  
  if(id %in% unique(final_df$ID)){
    highschool <- as.numeric(as.character(df_20$S1501_C02_014E[i]))
    college <- as.numeric(as.character(df_20$S1501_C02_015E[i]))
    final_df$Proportion_High_School_or_Greater[final_df$ID == id & final_df$Year == 2020] <- highschool
    final_df$Proportion_Bachelors_Degree_or_Greater[final_df$ID == id & final_df$Year == 2020] <- college
    
  }
}


#################
## Output Data ##
#################

write.csv(final_df,"ACS_Data_2010-2020.csv")
