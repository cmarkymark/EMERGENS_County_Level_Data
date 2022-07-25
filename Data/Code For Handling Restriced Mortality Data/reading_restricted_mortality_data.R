#########
# This script can be used to generate annual, county-level overdose death counts
# From the CDC Restricted Mortality Records
# We cannot publicly provide these records, but this code can be used once you have access
#########

## First, mortality records indicate two locations:
##    1) The county of the death
##    2) The county the person resides in
## This boolean, "residence", let's you choose whether to record deaths by location or residence
## If you set residence equal to TRUE (or T), death counts will represents deaths of residents
## If you set residence equal to FALSE (or F), death counts will represent number of deaths in county
residence <- F

## First, we load a file which includes a list of all counties
## It contains two important pieces of information, 
data <- read.csv("Data/county_fips_master.csv", header = T)

## We will create a placeholder variable for the year
data$year <- NA

## Next you can set which range of years you would like to generate death counts for
initial_year <- 2010
final_year <- 2020

## This code can be used to generate total overdose deaths
## And also creates drug specific counts
## HOWEVER: Different counties have different reporting practices
## Some drug types are not counted in some places, or weren't counted well in the past
## Caution should be used when using the drug-specific death counts
data$overdose_deaths <- 0
data$synthetic_opioid_overdose_deaths <- 0
data$heroin_overdose_deaths <- 0
data$cocaine_overdose_deaths <- 0
data$meth_overdose_deaths <- 0

## The drug counts are initialized at 0 and as we read the death records
## We will increment county-level total by 1 for every death identified

## We are going to create a placeholder for our final counts
## At the end this will be a dataframe with all of the annual, county-level death counts
final_counts <- NA

## We will loop through each year for which we are generating death counts for
for(year in initial_year:final_year){
  
  ## This will print out the year. This is just for progress checking.
  print(year)
  
  ## We will start by creating a copy of our data file, which we will call temp
  temp <- data
  
  ## We will set the year equal to the year variable we are iterating through
  temp$year <- year
  
  ## Next we need to load in the appropriate dataset
  ## I am using the file names as they have been provided by the CDC
  ## If you use a different naming convention, you will need to edit these lines
  ## The following lines open a file connection with the appropriate years file
  file_name <- paste("Data/Mult",year,".USAllCnty.txt", sep = "")
  conn <- file(file_name, open = "r")
  
  ## The readLines function allows us to iterate through each line
  ## Each line represents a distinct mortality measure
  line <- readLines(conn, n = -1)
  
  ## Here we iterate through each line
  for(i in 1:length(line)){
    
    ## This line simply prints out the line number every 100,000 records
    ## I put this in because I can be inpatient and I like seeing the progress
    ## Simply delete or comment out if you do not want this.
    if(i%%100000 == 0){print(i)}
    
    ## First we take the line and convert it into an array
    temp_line <- strsplit(line[[i]], "")
  
    ## Our main goal is to determine if the record is an overdose death
    ## So we create a boolean called overdose and we label it false
    ## If the record is an overdose, we will convert this to true
    overdose <- F
    
    ## Characters 146-149 of the record contain the UCD (underlying cause of death) code
    ## We will check this to determine if it is an overdose
    UCD <- temp_line[[1]][146:149]
    
    ##
    ## Need to check all overdose death codes
    ## X40-X44
    ## X60-X64
    ## X85
    ## Y10-14
    ##
    
    ## The following logic checks if the UCD code for the record is an overdose
    ## An if-statement could be created for every code, there are likely more concise ways to write this
    if(UCD[1] == "X"){
      if(UCD[2] == "4" || UCD[2] == "6"){
        if(UCD[3] %in% c("0","1","2","3","4")){
          overdose <- T ## This captures codes X40-X44 and codes X60-X64
        }
      }
      if(UCD[2] == "8" && UCD[3] == "5"){
        overdose <- T ## This captures code X85
      }
    }
    
    if(UCD[1] == "Y" && UCD[2] == "1" && UCD[3] %in% c("0","1","2","3","4")){
      overdose <- T ## This captures codes Y10-Y14
    }
    
    ## If the death is not an overdose, then we will skip to the next record
    ## If the death is an overdose, then we are going to:
    ## 1) record the death in the appropriate county
    ## 2) check the drug-specific death codes.
    if(overdose){
      
      ## First we need to get the county code
      ## We grab the location of the death from 21-25 of the array
      ## A bit annoyingly, instead of providing the fips code
      ## THey provide a 2 letter state abbreviation followed by 3 digit county fip
      FIPS <- temp_line[[1]][21:25]
      
      ## If we were interested in the residence of the person who died
      ## We overwrite the location FIPS and replace it with the residence FIPS
      if(residence){
        FIPS <- temp_line[[1]][33:37] 
      }
      
      ## We are going to convert the state abbreviation into the numeric fips
      ## We do this by calling to our original dataset which has state abbreviations and states fips
      state_abbr <- paste(FIPS[1], FIPS[2], sep ="")
      state_fips <- data$state_FIPS[data$state_abbr == state_abbr][1]
      
      ## Finally, we will generate the full fips code that we can use
      FIPS <- as.numeric(paste(state_fips,FIPS[3],FIPS[4],FIPS[5], sep = ""))
      
      ## We need to make sure the county is in our master file
      ## Some death records may be from US territories which might not be in our dataset
      ## Insert something hear about American Imperialism
      if(nrow(temp[which(temp$FIPS == FIPS),]) == 1){
        
        ## First, we will increment the counties overdose death count by one
        temp$overdose_deaths[which(temp$FIPS == FIPS)] <- temp$overdose_deaths[which(temp$FIPS == FIPS)] + 1
        
        
        ## Next we will check the multiple cause of death codes to determine drug-specific
        ## Need to identify the appropriate MCD codes
        ## Heroin (T40.1)
        ## Synthetic (T40.4)
        ## Cocaine (T40.5)
        ## Meth (psychostimulahnts) (T43.6)
        
        ## The MCD_count tells us the total number of MCD codes in the record
        ## There are not always the same number
        MCD_count <- temp_line[[1]][163:164]
        MCD_count <- as.numeric(paste(MCD_count[1], MCD_count[2],sep=""))
        
        ## We create a vector to hold all of the MCD codes
        MCD_list <- c()
        
        ## We iterate through the number of identified codes
        for(j in 1:MCD_count){
          
          ## The record provides 7 character slots for each code
          ## Thus for each code, we will increment where we check the record by 7
          adder <- (j-1)*7
          
          ## We extract the MCD code from the file
          MCD_code <- temp_line[[1]][(167+adder):(170+adder)]
          MCD_code <- paste(MCD_code[1],MCD_code[2],MCD_code[3],MCD_code[4],sep="")
          
          ## We add the code to the list
          MCD_list <- c(MCD_list,MCD_code)
          
        }

        ## Finally, we will go through each MCD code and check if the given drug code is there
        ## First we check for heroin
        if("T401" %in% MCD_list){
           temp$heroin_overdose_deaths[which(temp$FIPS == FIPS)] <- temp$heroin_overdose_deaths[which(temp$FIPS == FIPS)] + 1
        }
        
        ## Then we check synthetic opioids
        if("T404" %in% MCD_list){
          temp$synthetic_opioid_overdose_deaths[which(temp$FIPS == FIPS)] <- temp$synthetic_opioid_overdose_deaths[which(temp$FIPS == FIPS)] + 1
        }
        
        ## Then we check cocaine
        if("T405" %in% MCD_list){
          temp$cocaine_overdose_deaths[which(temp$FIPS == FIPS)] <- temp$cocaine_overdose_deaths[which(temp$FIPS == FIPS)] + 1
        }
        
        ## Then we check meth
        if("T436" %in% MCD_list){
          temp$meth_overdose_deaths[which(temp$FIPS == FIPS)] <- temp$meth_overdose_deaths[which(temp$FIPS == FIPS)] + 1
        }
        
        ## We have now completed going through this record!
      }
    }
  }
  
  ## Once we have gone through every record, we will add the annual county-level overdose death counts to our final counts
  ## If this was the first year we looked at then final_counts will be NA
  if(is.na(final_counts)){
    ## In this case, we will simply make final_counts equal to our temp dataframe
    final_counts <- temp
  }else{
    ## Otherwise, we will add the temp data frame to final_counts
    final_counts <- rbind(final_counts, temp)
  }
}

## Finally, we will export the file
## We will dynamically generate file name based on the year range and residence vs. location
if(residence){
  
  filename <- paste("county_level_mortality_by_residence_",initial_year,"-",final_year,".csv", sep = "")
  write.csv(final_counts, filename)
  
}else{
  
  filename <- paste("county_level_mortality_by_location_",initial_year,"-",final_year,".csv", sep = "")
  write.csv(final_counts, filename)
  
}


