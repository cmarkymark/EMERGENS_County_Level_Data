## In This Directory

Each folder corresponds to a specific data source used to compile the data. These folders contain the raw data from these sources, description of where they can be downloaded from, and code to clean them for merging into the final data set. Some of the folders contain compressed data - ***you will need to look into them an uncompress those data items***.

### Merge Data Script

There is one R script in this folder. When run, it will merge all of the data into the final dataset. 

### Unrestricted Vs. Restricted Mortality Data

Within the merge data script, there is an option to indicate whether or not you have the restricted mortality data. If you do not have the restricted mortality data, the merge data script will, if prompted correctly, include the unrestricted, imputed mortality data. If you have the restricted mortality, you can upload it into the appropriate folder and run the appropriate scripts.
