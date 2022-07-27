#####################
##
## This file can be used to merge all of the data sources
## It will create one file in which an obsrevation is a county-year
## The code can be used to generate just the predictor data
## If you have access to the restricted mortality data
## This code can also handle it!
##
######################

## First, we have a boolean called restricted
## If you have access to the restricted mortality data, set this to TRUE
## Otherwise, set it to FALSE

restricted <- FALSE

## Next, we are going to load each of our datasets we are merging
## Data sources include:

## American Community Survey
ACS <- read.csv("ACS Data/ACS_Data_2010-2020.csv")[,-c(1)]

## County Business Patterns
CBP <- read.csv("CBP/CBP_data_2010-2020.csv")[,-c(1)]

## Data on county urbanicity
Urbanicity <- read.csv("Geography Data/Urbanicity.csv")[,c(1,7)]

## National Forensic Laboratory Information System
NFLIS <- read.csv("NFLIS/NFLIS_long.csv")

## IQVIA Xponent Prescribing Data Accessed Through CDC Website
ORx <- read.csv("Opioid Prescribing Data/Opioid_Prescribing_per_100.csv")[,c(3:5)]

## Restricted Mortality Records
if(restricted){
  overdose <- read.csv(file.choose())[,-c(1)]
}else{
  overdose <- read.csv("Unrestricted Mortality/Unrestricted_Mortality_with_Gravity_2010-2020.csv")[,-c(1)]
  overdose$FIPS <- overdose$County.Code
  }

## We need two columns to be consistently named and structured
### FIPS (numeric)
### Year (numeric)
## We will go through each dataset and change column names or type when appropriate

colnames(ACS)[colnames(ACS) == "ID"] <- "FIPS"
colnames(Urbanicity) <- c("FIPS","Urbanicity")
colnames(ORx) <- c("FIPS","ORx_per_100","Year")

## We also have some missing data in the ORx dataset
## We will, for now, assign missing data 0 so we can still use the data
## WE are assuming missing data is reflective of it not occuring
ORx$ORx_per_100 <- as.numeric(ORx$ORx_per_100)
ORx$ORx_per_100[is.na(ORx$ORx_per_100)] <- 0


if(restricted){
  colnames(overdose)[colnames(overdose) == "year"] <- "Year"
}

##
## Finally, we will merge all the data together
##

Final_Data <- merge(ACS, CBP, by = c("FIPS", "Year"), all.x = T)
Final_Data <- merge(Final_Data, Urbanicity, by = c("FIPS"), all.x = T)
Final_Data <- merge(Final_Data, ORx, by = c("FIPS","Year"), all.x = T)

##
## NFLIS is a tad trickier to merge, since we have State, not county data
## To handle this, we will create a State_FIPS variable in our final dataset
## This will allow us to use merge!
##

Final_Data$State_FIPS <- floor(Final_Data$FIPS/1000)

## Need to rename the NFLIS column FIPS to State_FIPS
colnames(NFLIS)[colnames(NFLIS) == "FIPS"] <- "State_FIPS"
## Also we are going to remove unneeded columns
NFLIS <- NFLIS[,colnames(NFLIS) %in% c("State_FIPS", "Year", "Fentanyl_Total")]

## Now we can merge the data
Final_Data <- merge(Final_Data, NFLIS, by = c("State_FIPS", "Year"), all.x = T)


if(restricted){
  ## We are going to remove some of the excess columns
  overdose <- overdose[,!(colnames(overdose) %in% c("county_name","state_abbr",
                           "state_name","state_FIPS",
                           "county_FIPS"))]
  
  Final_Data <- merge(Final_Data, overdose, by = c("FIPS","Year"), all.x = T)
  
}else{
  overdose <- overdose[,!(colnames(overdose) %in% c("Notes","County",
                                                    "County.Code","Year.Code",
                                                    "Crude.Rate"))]
  
  Final_Data <- merge(Final_Data, overdose, by = c("FIPS","Year"), all.x = T)
}

## Now that the final dataset has been generated, we will output it
if(restricted){
  write.csv(Final_Data, "Restricted_County_Level_Data_2010-2020.csv")
} else{
  write.csv(Final_Data, "Unrestricted_County_Level_Data_2010-2020.csv")
}

