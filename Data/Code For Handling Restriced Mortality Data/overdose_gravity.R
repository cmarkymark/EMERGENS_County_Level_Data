#################
## In this file we will take annual county-level overdose death counts
## And we will generate a "gravity" variable to capture the burden
## of overdose in neighboring counties
## THe higher the overdose burden in neighboring counties, the higher
## the gravity value for a given county-year
#################

## Firsst we are going to read in our overdose data
data <- read.csv("county_level_mortality_by_location_2010-2020.csv")[,-c(1)]

## Next, we need to get population data
pop_data <- read.csv("Data/county_annual_population_2010-2020.csv")[,c(2:20)]

## We need to generate a FIPS code for the pop data by merging state and county fips variables
pop_data$FIPS <- pop_data$STATE*1000 + pop_data$COUNTY

## We will now add a population variable to our main data
data$population <- NA

## Now we will loop through data and grab the appropriate data from pop_data
for(i in 1:nrow(data)){
  
  ## get the county identifier and year
  fips <- data$FIPS[i]
  year <- data$year[i]
  
  ## we will create a placeholder for population
  pop <- NA
  
  ## Because this dataset just has a different column for each year
  ## we will need an if statement for each possible year.
  ## This is a little bit annoying
  if(year == 2010){
    pop <- pop_data$POPESTIMATE2010[pop_data$FIPS == fips]
  }else if(year == 2011){
    pop <- pop_data$POPESTIMATE2011[pop_data$FIPS == fips]
  }else if(year == 2012){
    pop <- pop_data$POPESTIMATE2012[pop_data$FIPS == fips]
  }else if(year == 2013){
    pop <- pop_data$POPESTIMATE2013[pop_data$FIPS == fips]
  }else if(year == 2014){
    pop <- pop_data$POPESTIMATE2014[pop_data$FIPS == fips]
  }else if(year == 2015){
    pop <- pop_data$POPESTIMATE2015[pop_data$FIPS == fips]
  }else if(year == 2016){
    pop <- pop_data$POPESTIMATE2016[pop_data$FIPS == fips]
  }else if(year == 2017){
    pop <- pop_data$POPESTIMATE2017[pop_data$FIPS == fips]
  }else if(year == 2018){
    pop <- pop_data$POPESTIMATE2018[pop_data$FIPS == fips]
  }else if(year == 2019){
    pop <- pop_data$POPESTIMATE2019[pop_data$FIPS == fips]
  }else if(year == 2020){
    pop <- pop_data$POPESTIMATE2020[pop_data$FIPS == fips]
  }
  
  ## we will now save the population we retrieved
  ## If statement checks in case of missing data
  if(length(pop) > 0){data$population[i] <- pop}
  
}

## Now that we have the populations, we can generate an overdose death rate
## We will just do this for overall overdose, though can easily be adapted for drug-specific
data$overdose_death_rate <- (data$overdose_deaths/data$population)*100000

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
  year <- data$year[i]
  
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
    overdose2 <- data$overdose_death_rate[data$FIPS == fips2 & data$year == year]
    
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

filename <- paste("Restricted_Mortality_with_Gravity_",min(data$year),"-",max(data$year),".csv",sep="")

write.csv(data, filename)