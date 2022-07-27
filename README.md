# EMERGENS County Level Data

This repository contains data relevant to studies undertaken by the [EMERGENS Study](https://www.emergens-project) based out of UCSD. We have created this dataset for the purpose of predicting county-level overdose counts and rates across the United States. Curation of the data has been a large undertaking and so we have opted to make the data publicly available, so that others need not spend the same number of hours curating the same or similar data.

## What Has This Data Been Used For

This dataset was inititally curated for our team's 2021 Lancet Public Health [publication](https://www.thelancet.com/journals/lanpub/article/PIIS2468-2667(21)00080-3/fulltext), in which we retrospectively validated the use of a statistical regression model for predicting county-level overdose death rates one year into the future.

## Getting Started Right Away

If you would like to start using the data right away, you can download the Unrestricted dataset available at the top-level of this repo! Please read the difference between restricted and unrestricted versions (below) of this dataset before proceding too far along!

## Please Cite Us If You Use This

***[Insert information that the user needs to cite this appropriately, including grant number]***

## What is Contained In This Repository

While one option was to simply supply the full dataset, we have opted to provide the raw datasets and the code needed to compile the full dataset. We have done this for transparency, so that research teams may confidently use our dataset and be able to replicate the steps we undertook to compile this data. Within the "Data" folder, there is a directory for each data source, code used to clean these data, and code used to merge the data into a single data set. 

## Restricted vs. Unrestricted Mortality Data

As a human subjects protection, the CDC will not publicly release county-level overdose death counts for counties that experienced less than 10 deaths in a given year. So, we have provided two things. First, we have provided "unrestricted" mortality data, which was requested from the CDC Wonder platform. We have imputed the overdose death count for each county with "suppressed" overdose counts. Second, the restricted mortality data records can be requested from the CDC - instead of county-level estimates, the CDC provides files containing all mortality records for each year. While we cannot make this restricted data public, we have provided R code that can transofrm the individual-level records into county-level annual overdose counts!
