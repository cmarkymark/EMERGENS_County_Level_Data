## Where Did This Data Come From

This data came from the Census Bureau's County Business Patterns dataset. You can find the data by heading to https://www.census.gov/programs-surveys/cbp/data/datasets.html

This annual dataset provides information about businesses operating within each county, including information about payroll and employment.

## How To Update This Dataset

First, you will need to head to https://www.census.gov/programs-surveys/cbp/data/datasets.html and download the new year of data. Then, once you download it, you will add the data into 
the Data folder. Look at the naming convention and make sure that the new file has matching naming convention. The R code to generate the CBP dataset is partially dynamic and 
you should not have to update anything except the duration of the two main for-loops within the code. Initially, since the dataset ranges from 2010-2020, the for-loops correspond with these years. 
By updating these for-loops within the code, you can then run the R script to generate the new dataset.
