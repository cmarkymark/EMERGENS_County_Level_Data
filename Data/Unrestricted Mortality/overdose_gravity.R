#################
## In this file we will take annual county-level overdose death counts
## And we will generate a "gravity" variable to capture the burden
## of overdose in neighboring counties
## THe higher the overdose burden in neighboring counties, the higher
## the gravity value for a given county-year
#################

## Firsst we are going to read in our overdose data
data <- read.csv("imputed_unrestricted_mortality_2010-2020.csv")[,-c(1)]

## Need to fix up FIPS variable real quick
data$FIPS <- data$County.Code

## Now that we have the populations, we can generate an overdose death rate
## We will just do this for overall overdose, though can easily be adapted for drug-specific
data$overdose_death_rate <- (data$Deaths/data$Population)*100000

## To create out county gravity variable we are going to need a dataset with the distances
## Between each county, which we will call distances
distances <- read.csv("Data/County_Distances.csv", header = T)

## WE will create an empty variable where we will store our gravity variable
data$overdose_gravity_add <- NA

## Now we are going to loop through our dataset
## This will be time consuming
## For each county, we are going to:
##  1) Identify every county within 200 miles (using centroid measurement)
##  2) Get the overdose death rate for each neighboring county
##  3) Divide the neighbors death rate by the distance squared
##  4) Sum together all the values to get our new value
for(i in 1:nrow(data)){
  
  ## THis is just to check progress, can comment out or delete
  if(i%%100 == 0){print(i)}
  
  ## We need to get the county and the year
  fips <- data$FIPS[i]
  year <- data$Year[i]
  
  ## This grabs every county within 200 miles of the county
  dist <- distances[distances$county1 == fips & distances$mi_to_county < 200,]
  
  ## WE now initiate a counter where we will generate our final value
  overdose_gravity_add <- 0
  
  ## We will now iterate through each neighboring county
  for(j in 1:nrow(dist)){
    
    ## We will get the fips code for it and the distance to the central county
    fips2 <- dist$county2[j]
    d <- dist$mi_to_county[j]
    
    ## Next we will get that counties overdose death rate
    overdose2 <- data$overdose_death_rate[data$FIPS == fips2 & data$Year == year]
    
    ## WE will then add the overdose death rate divided by distance squared to our total
    ## THe if statement is to check for missing data
    if(length(overdose2) > 0 & length(d) > 0 & length(overdose2) > 0 ){
      
      if(!is.na((overdose2)/(d^2)))
      overdose_gravity_add <- overdose_gravity_add + ((overdose2)/(d^2))
       
    }
    
    
  }
  ## Finally, we will store the new value in the data.frame
  data$overdose_gravity_add[i] <- overdose_gravity_add
  
}

filename <- paste("Unrestricted_Mortality_with_Gravity_",min(data$Year),"-",max(data$Year),".csv",sep="")

write.csv(data, filename)
