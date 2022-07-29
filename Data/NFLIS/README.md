## In THis Folder

This folder contains **state-level** drug seizure laboratory test data. When law enforcement seizes drugs, they send it to a lab to be tested. These records have been used to indentify the number of samples with fentanyl in them - we are using this as a proxy for the presence of fentanyl in the local, illicit drug market. It should be noted that this data does not indicate the amount of fentanyl tested, just the number of samples tested positive for fentanyl.

## Adding New Years of Data

Unfortunately, the data must be downloaded in PDF form from https://www.nflis.deadiversion.usdoj.gov/. Under the *Data Resources* header, you will click "Publications". This will take you to a site with a table with downloadable files. You will want to download the file of the form "20XX Public Data". This will download a zip with 5 PDFs. You will want Table 3. You will need to add a new column, manually to the NFLIS_by_year.csv. Since it is state-level data, the manual data entry won't take too long. Just add a new column and make sure to use the naming convention in the other columns.

Then you will run the R script which converts the data from wide format (NFLIS_by_year.csv) into long format so that it can be merged with the rest of the data.
