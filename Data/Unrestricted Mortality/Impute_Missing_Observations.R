
## First we will read in the unrestricted mortality data
## This was downloaded from the CDC Wonder website (wonder.cdc.gov)
## Each observatio is a year X county
## Crude death counts under 10 were suppressed
data <- read.table(file = "Data/unrestricted_overdose_by_county_2010-2020.txt", sep = '\t', header = TRUE)

## Need to clean up a few variables
## Suppresed death counts have the string "Suppressed"
## Since this is numeric, we are going to replace "Suppressed" with -99
## THis way we know it is suppressed and can have data stored as a numeric
data$Deaths <- (as.character(data$Deaths))
data$Deaths[data$Deaths == "Suppressed"] <- -99
data$Deaths <- (as.numeric(data$Deaths))

## AS well need to indicate population is numeric
data$Population <- as.numeric(data$Population)

## Finally, we will remove Alaska and Hawaii, as well as a few counties across the country
## These counties are some strange examples that don't have full data
data <- data[!(data$County.Code %in% c(51560, 51515, 48269, 46113,48301)),]
data <- data[!(floor(data$County.Code/1000) %in% c(2,11)),]

## Next we need to impute missing data
## So first we need to load in state-level overdose death counts
## We are going to impute by identifying the number of missing overdose deaths
## IN the county-level data and then distributing these deaths to 
## All the suppressed counties by population size (i.e., imputed counties within a state will all have same population rate)
state_data <- read.table(file = "Data/unrestricted_overdose_by_state_2010-2020.txt", sep = '\t', header = TRUE)

## From here we will now loop through each state and each year and do the imputations
for(state_id in unique(state_data$State.Code)){
  for(year in 2010:2020){
    
    ## we first want to get the total number of deaths for the state in that year
    total_deaths <- state_data$Deaths[state_data$State.Code == state_id & state_data$Year == year]
    
    ## then we want to subtract the number of deaths recorded 
    ## and extract the counties that were suppressed
    
    ## So we will now get the county-level data for that state and year
    county_data <- data[data$County.Code >= state_id*1000 & data$County.Code < (state_id*1000 + 1000) &data$Year == year,]
    
    ## This will hold the ids for all of the suppressed observations
    counties_suppressed <- c()
    
    ## This loop will go through each county and check if suppressed
    for(county_id in unique(county_data$County.Code)){
      
      ## First we exxtract the number of deaths
      check_death <- county_data$Deaths[county_data$County.Code == county_id]
      
      ## A value of -99 indicates that the value is suppressed
      if(check_death == -99){
        ## In this case we add the county to list of suppressed
        counties_suppressed <- c(counties_suppressed, county_id)
      }else{
        ## Otherwise, the county isn't suppressed and we remove its deaths from the total
        total_deaths <- total_deaths - check_death
      }
    }
    
    ## now we get the population rate of deaths for suppressed counties
    ## We must extract the total population across suppressed counties
    suppressed_pop <- 0
    
    ## Go through each suppressed county and add its population
    for(county_id in counties_suppressed){
      suppressed_pop <- suppressed_pop + county_data$Population[county_data$County.Code == county_id]
    }
    
    ## We will now calculate the rate
    ## However, if no counties were suppressed this would throw an error
    ## So we use an if-statement to avoid this error.
    rate <- 0
    if(suppressed_pop > 0){
      rate <- total_deaths/suppressed_pop
    }
    
    ## we now want to apply these rates to calculate an imputed value for each suppressed county in the actual data set
    ## note that we know that the crude number does not exceed 9 and thus we use the min() function to cap the value at 9
    
    for(county_id in unique(county_data$County.Code)){
      
      county_pop <- data$Population[data$County.Code == county_id & data$Year == year]
      
      if(data$Deaths[data$County.Code == county_id & data$Year == year] == -99){
        data$Deaths[data$County.Code == county_id & data$Year == year] <- min(county_pop*rate,9)
      }
    }
  }
}

## Output the results
write.csv(data, "imputed_unrestricted_mortality_2010-2020.csv")
