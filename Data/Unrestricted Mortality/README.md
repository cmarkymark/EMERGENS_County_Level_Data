## What Is In This Folder

This folder contains unrestricted county-level annual overdose mortality data from the wonder.cdc.gov platform. The CDC will not provide the overdose count for a county X year 
with less than 10 deaths...given that this is the majority of countyXyears, this is not ideal. However, the CDC also recommends an imputation procedure if the data is to be used,
in which you subtract the number of unrestricted county overdose death counts from the state total for that year and then disperse the remaining deaths evenly (by population) across
all of the counties with restricted counts.

So, in this folder is the county-level and state-level annual overdose death counts and county population sizes, extracted from the CDC Wonder database. Additionally, there is R
code which runs the imputations on the datasets and also that generates the gravity variable used in our studies.

## Adding New Years of Data

Whenever new data is released to the CDC Wonder platform, data can be added by heading to wonder.cdc.gov and doing the following: Under **Deaths - All Ages** select the _Underlying Cause of Death_ button; next select **1999-202X: Underlying Cause of Death...** button; 
next scroll down (read the info) and select **I Agree**; next you will see a large form, under **Group Results By** select County in the first drop down and select Year in the second drop down;
next scroll down to section 4 and select all of the years you wish to output data for (the old years and the new one); next under section 6 click the Drug/Alcohol Induced causes button and then select the lines corresponding to X40-44, X60-64, x85, and Y10-Y14; finally, you will select Export Results, unselect Show Totals, selecte Show Zero Values, and select Show Suppressed Values; 
then you will hit the Send button. Once you have done this, a .txt file will be downloaded - you need to open this file and scroll to the bottom and delete all the notes and text at the bottom of the file. Now this is your new dataset, place it where the old one was and run the code!

