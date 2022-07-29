## In This Directory

Each folder corresponds to a specific data source used to compile the data. These folders contain the raw data from these sources, description of where they can be downloaded from, and code to clean them for merging into the final data set. Some of the folders contain compressed data - ***you will need to look into them an uncompress those data items***.

### Merge Data Script

There is one R script in this folder. When run, it will merge all of the data into the final dataset. 

### Unrestricted Vs. Restricted Mortality Data

Within the merge data script, there is an option to indicate whether or not you have the restricted mortality data. If you do not have the restricted mortality data, the merge data script will, if prompted correctly, include the unrestricted, imputed mortality data. If you have the restricted mortality, you can upload it into the appropriate folder and run the appropriate scripts.

### Adding New Data Sources

This repo is structured such that each data source gets its own folder. Then the data sources are all merged using the merge_data.R data script. Since each observation in this dataset is a county X year, when you add a new data source you will need to produce a county X year dataset with two ID fields: FIPS (county code indentifier) and Year (year identifier). You can then use the merge() function in R to add the new data source to the existing data set.

### Adding New Years of Data

Over time, new data sources will come available. Within each data source file is a description of how new years of data can be added. Some are more straightforward than others. Each data source folder contains a link to where new data can be found, as well as instructions for adding the new data to the existing datasets.
