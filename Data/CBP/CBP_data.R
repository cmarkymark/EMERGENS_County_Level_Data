library(tidyverse)
library(dplyr)
library(readr)
rm(list = ls())

## In this file, we are going to generate three variables
### 1) Number of employees employed in March of given year
### 2) Employee capacity for given year
### 3) Payroll for given year
##
## Employee capacity is measured by summing up businesses at each size
## CPB data contains a column for business with employeee sizes:
### 1-4, 5-9, 10-19, 20-49, 50-99, 100-249, 250-499, 500-999, 1000-1499,1,500-2499, 2500-4999, 5000+
### To get annual employment capacity, we multiply the number of companies in a given bracket by the brackets mid-point

#To read County business patterns for 2009
# Each row represents a county-industry. Meaning that each county has multiple rows, one for each identified industry
CBP<-read.table(file= paste("Data/cbp","09","co.txt", sep = "", collapse = NULL), header =TRUE, sep = ",")

## For ease of organizing the data, lets merge the state and county fips codes
CBP$FIPS <- CBP$fipstate*1000 + CBP$fipscty

#For convenience, we are going to remove column n_1000
## This column has the number of businesses with 1000+ employees
## This information is redundant with the next columns for 1000-1499, 1500-2499, etc
CBP<-CBP[,-20]

# We will remove observations that do not have a county
CBP<- CBP[-which(CBP$fipscty == 999),]

#AS mentioned, the report includes the number of businesses within a employee number range
## Here we note the center (mean average) of each range
## For our purposes, we assume that a business with 5000+ contributes 7500 capacity
#  N1_4 1-4 centre 2.5
#  N5_9 5-9 centre 7
#  N10_19 10-19 centre 14.5
#  N20_49  20-49 centre  34.5
#  N50_99   centre 74.5
#  N100_249 centre 174.5
#  N250_499 centre 374.5
#  N500_999 centre 749.5
#  N1000_1 centre 1249.5
#  N1000_2 centre 1999.5
#  N1000_3 centre 3749.5
#  N1000_4 centre 5,000

## Here we supply the centers into a vector
classcenters<- c(2.5,7,14.5,34.5,74.5,174.5,374.5,749.5, 1249.5,1999.5,3749,7500)

## Next we will estimate the employee capacity
## We will create a variable intialized at 0
CBP$EmployeesInIndustrySum<- 0

## WE will then go through each of the 12 classes and sum up the employee capacity
## This is done by multiplying the number of businesses in a given class by the center value for that business type
## Loop through each of the 12 columns
for(i in 12:23){
  ## We add the product of number of businesses and business employee mean size to the total number of employees
  CBP$EmployeesInIndustrySum<-CBP$EmployeesInIndustrySum+(CBP[,i]*classcenters[(i-11)])
}

#Next, we take the total sum of employees from all industries by county
# We use tidyverse notation. First, we use group_by() to group observations by matching FIPS codes
# Then, we use the summarize function to create a new variable for the sum of employee capacity
# We will also take the sum of the "emp" variable, which is a measure of number of employees employed in industry in Mid-March
ByCounty<-CBP %>%
  group_by(FIPS) %>%
  summarise(sum(EmployeesInIndustrySum), sum(emp), sum(ap)) 

## Let's name that column something that makes more sense
names(ByCounty)[2:4]<- c("Employee_Capacity","Total_Employees_March_Snapshot", "Total_Annual_Payroll")

## Let's also add a year column - this way, we can create the final dataset in long-format
ByCounty$Year <- 2009

## Now that we have created our first year of data, we are going to loop through the next years
## We will first loop through 2010 to 2017. The structure of the data changed slightly in 2018, requiring slightly different code
#2010 to 2017
#Next repeat the same for every other file of each new year, 2010 to 2016;2018 needs one correction because it looses one column; see for-loop below
# SO we will loop through each year, abbreviating 2010 to 10, 2011 to 11, etc
for (h in 10:20)
{
  
  #To read County business patterns
  CBP<-read.table(file= paste("Data/cbp",h,"co.txt", sep = "", collapse = NULL), header =TRUE, sep = ",")
  
  ## Do to some inconsistency in the capitalization of variable names across files
  names(CBP)<-tolower(names(CBP))
  
  ## In 2018, they removed a column from the data.frame.
  ## To ensure our code still works nicely, given it is dependent on column numbers
  ## WE just add a leading empty column to our data frame
  if(h > 17){
    CBP <- cbind(NA, CBP)
  }
  
  ## For ease of organizing the data, lets merge the state and county fips codes
  CBP$FIPS <- CBP$fipstate*1000 + CBP$fipscty
  
  #For convenience, we are going to remove column n_1000
  ## This column has the number of businesses with 1000+ employees
  ## This information is redundant with the next columns for 1000-1499, 1500-2499, etc
  
  CBP<-CBP[,-20]
  # We will remove observations that do not have a county
  CBP<- CBP[-which(CBP$fipscty == 999),]
  
  #We will also take all NA values and make them 0
  #That way any that appear will not contribute to count and won't throw error
  CBP[is.na(CBP)] <- 0
  
  ## Weirdly, instead of 0 values, for the year 2017, there is an N, so need to replace N with 0
  if(h >= 17){
    CBP <- data.frame(lapply(CBP, function(x) {
                        gsub("N", "0", x)
                 }))
    CBP$n.5 <- as.numeric(CBP$n.5)
    CBP$n5_9 <- as.numeric(CBP$n5_9)
    CBP$n10_19 <- as.numeric(CBP$n10_19)
    CBP$n20_49 <- as.numeric(CBP$n20_49)
    CBP$n50_99 <- as.numeric(CBP$n50_99)
    CBP$n100_249 <- as.numeric(CBP$n100_249)
    CBP$n250_499 <- as.numeric(CBP$n250_499)
    CBP$n500_999 <- as.numeric(CBP$n500_999)
    CBP$n1000_1 <- as.numeric(CBP$n1000_1)
    CBP$n1000_2 <- as.numeric(CBP$n1000_2)
    CBP$n1000_3 <- as.numeric(CBP$n1000_3)
    CBP$n1000_4 <- as.numeric(CBP$n1000_4)
    CBP$emp <- as.numeric(CBP$emp)
    CBP$ap <- as.numeric(CBP$ap)
    }
  
  ## WE will then go through each of the 12 classes and sum up the employee capacity
  ## This is done by multiplying the number of businesses in a given class by the center value for that business type
  ## Loop through each of the 12 columns
  CBP$EmployeesInIndustrySum <- 0 
  
  for(i in 12:23){
    ## We add the product of number of businesses and business employee mean size to the total number of employees
    CBP$EmployeesInIndustrySum <- CBP$EmployeesInIndustrySum + (CBP[,i]*classcenters[(i-11)])
  }

  # Next, takes the total sum of employees at all industries by county
  ByCounty2<-CBP %>%
    group_by(FIPS) %>%
    summarise(sum(EmployeesInIndustrySum), sum(emp), sum(ap)) 
  
  ## Let's name that column something that makes more sense
  names(ByCounty2)[2:4]<- c("Employee_Capacity","Total_Employees_March_Snapshot", "Total_Annual_Payroll")
  
  ## Let's also add a year column - this way, we can create the final dataset in long-format
  ByCounty2$Year <- 2000 + h
  
  ByCounty <- rbind(ByCounty, ByCounty2)
  
}

##########
## At this point we have created an annual county-level dataset with three variables
### 1) Number of employees in March (snapshot)
### 2) Approximated employment capacity
### 3) Size of payroll
## 
## We are also going to create three difference variables
## For each variable, we will create a new variable
## Which captures the change from the year prior for that county
##########

## First we will create our new variables
ByCounty$Employee_Capacity_Change <- NA
ByCounty$Total_Employees_March_Snapshot_Change <- NA
ByCounty$Total_Annual_Payroll_Change <- NA

## We will iterate through 2010 - 2020
## Note that we don't have data prior to 2009, so cannot calculate value for that year

for(year in 2010:2020){
  
  ## Then we will iteratre through each county in the dataset
  for(fips in unique(ByCounty$FIPS)){
    
    ## Employee Capacity
    EC_current <- ByCounty$Employee_Capacity[ByCounty$FIPS == fips & ByCounty$Year ==  year]
    EC_prior <- ByCounty$Employee_Capacity[ByCounty$FIPS == fips & ByCounty$Year ==  (year - 1)]
    
    EC_change <- EC_current - EC_prior
    
    if(length(EC_change) > 0){
      ByCounty$Employee_Capacity_Change[ByCounty$FIPS == fips & ByCounty$Year ==  year] <- EC_change
    }
    
    ## Total Employees
    TE_current <- ByCounty$Total_Employees_March_Snapshot[ByCounty$FIPS == fips & ByCounty$Year ==  year]
    TE_prior <- ByCounty$Total_Employees_March_Snapshot[ByCounty$FIPS == fips & ByCounty$Year ==  (year - 1)]
    
    TE_change <- TE_current - TE_prior
    
    if(length(TE_change) > 0){
      ByCounty$Total_Employees_March_Snapshot_Change[ByCounty$FIPS == fips & ByCounty$Year ==  year] <- TE_change
    }
    
    ## Total Payroll
    TP_current <- ByCounty$Total_Annual_Payroll[ByCounty$FIPS == fips & ByCounty$Year ==  year]
    TP_prior <- ByCounty$Total_Annual_Payroll[ByCounty$FIPS == fips & ByCounty$Year ==  (year - 1)]
    
    TP_change <- TP_current - TP_prior
    
    if(length(TE_change) > 0){
      ByCounty$Total_Annual_Payroll_Change[ByCounty$FIPS == fips & ByCounty$Year ==  year] <- TP_change
    }
  }
}

## Finally, let's save the file

write.csv(ByCounty,"CBP_data_2010-2020.csv")
