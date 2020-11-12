# BEA Economic accounts by state, 1970-2019

This repository contains Stata code to download, import, and process economic data from the Bureau of Economic Analysis.  The data include total personal income, disposable personal income, employment, and population by state-year spanning 1970-2019. The data in question are:

- BEA-SAINC4: Personal income and employment
- BEA-SAINC51: Disposable income
- FRED PCEPI: Personal Consumption Expenditures (PCE) price index
- Census FIPS codes: GeoCodes by state

## Structure
To run all of the programs, set all appropriate directories in `./code/main_bea_codes.do` and run that `.do` file.  Each program will run sequentially according which programs are switched on (see lines 67-72 in `./code/main_bea_codes.do`).  The programs will then sequentially download the BEA, Census, and

## Notes
- To obtain the PCE data I used the Stata FRED API which will require an API key to use.
  - For reference, my API key is `e900d5f29c6df71e38616d52cbd0f93c`
- The BEA zip files contain a lot of state-level CSV files (often individual states).  THese are sequentially deleted to save space since Stata doesn't allow selective unzips.
