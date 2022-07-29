## Where Did This Data Come From

This data is from the American Community Survey, annual datasets produced by the US Census Bureau in-between official Census reports released each decade. Data can be accessed by heading to data.census.gov and searching for the appropriate tables. Within this folder, you can see sub-folders such as DP03, DP04,... These are the names of the ACS tables - if you go to the data.census.gov website and type in those table names, they should appear.

## How To Add New Data to This Folder

For each of the datasets (DP03, DPO4, etc), you need to go to the data.census.gov website, type in that dataset name, and then choose the new year of data you would like to add. You will need to go into Geography tab and choose Counties -> All Counties so that it produces a county-level dataset. Once downloaded, add the new dataset to the appropriate folder.

Once added, you will need to open the merge_ACS.R file to account for the new data. Unfortunately, the variable naming process has changed multiple times, which means that much of this merging had to be hand-coded (as opposed to coded more dynamically). As such, adding new years is a bit repetitive and tedious - within the merge file you will see that for each variable, there is code corresponding to each year. You will need to add code for the new year for each variable. This can be done: 1) by copy-pasting the code for the prior year for each variable; 2) confirming that the name of the variable in the dataset hasn't changed; and 3) if the name of the variable in the dataset did change, modifying the code accordingly.
