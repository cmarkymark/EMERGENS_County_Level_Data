## In This Folder

This folder contains a single CSV file, containing annual county-level opioid prescribing rates per 100 people. 

## Adding New Year of Data

This data is collected by IQVIA Xponent, which is typically not publicly available. However, the CDC makes annual county-level opioid prescribing rate maps available here: https://www.cdc.gov/drugoverdose/rxrate-maps/index.html
To add a new year of data you will first need to click on the year in the menu corresponding to that year. Then, below the map there will be a table with the counties, their FIPS codes, and the overall rates.
You will need to highlight this table and copy it into the .csv file in this repo, below the last line. Be sure to make sure the columns are organized correctly. 

Future steps would be to upload each year as a distinct CSV and use R code to merge them. However, since this involves copy-pasting the table into a CSV, it seemed that this time could
simply be used to upload into the master file.
