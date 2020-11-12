/**************************************************************************
	
	main-trust-codes.do
	
	AC Forrester
	
	Last update: 12.23.2019
	
	Main file to set directories for the Nowrasteh & Forrester (2019) 
	trust paper.
	
**************************************************************************/	
	
	clear all
	mat drop _all
	set more off
	set type double 
	set maxvar 10000

	di "* ------------------------------------------------ *"
	di "Starting time is $S_TIME"
	di "* ------------------------------------------------ *"
			
	loc start_time = "$S_TIME"
	
	* global project directory (change this if needed!)
	gl dir U:\projects\bea-data
	
	* main directories
	gl build	${dir}/build/
	gl output	${dir}/output/
	gl merge	${dir}/merge/
	gl code 	${dir}/code/
	
/**************************************************************************
	
	Get a list of the code files
	
**************************************************************************/	
	
	* list of code files
	loc code_fetch  	"get_bea_accts.do"
	loc code_sainc4 	"clean_bea_sainc4.do"
	loc code_sainc51	"clean_bea_sainc51.do"
	loc code_geogr  	"clean_census_geog.do"
	loc code_pcepi  	"clean_fred_pce.do"
	loc code_merge  	"merge_bea_data.do"
	
/**************************************************************************
	
	Which code files to run?
	
**************************************************************************/	
	
	* assign the 
	# delimit ; 

	local switches_all 
		fetch
		sainc4
		sainc51
		pcepi
		merge;

	# delimit cr	
	
	* set parameters (which files to run)
	loc	switch_fetch   = 1	// Fetch and unzip thew data
	loc	switch_sainc4  = 1	// SAINC4  - income/emp/population
	loc	switch_sainc51 = 1	// SAINC51 - disposable income
	loc	switch_pcepi   = 1	// PCE from FRED
	loc	switch_merge   = 1	// Merge all of the data
	
	
/**************************************************************************
	
	Get a list of the code files
	
**************************************************************************/	
	
	* loop over all of the requested code
	foreach switch of local switches_all {
		disp "`switch'"
		if `switch_`switch'' {
			disp "working on `CODE'/`code_`switch''"
			do ${code}/`code_`switch''
		}
	}

	local finishing_time = "$S_TIME"

	di "* ------------------------------------------------ *"
	di "*  Starting time is `start_time'"
	di "* ------------------------------------------------ *"
	di "*  Ending time is `finishing_time'"
	di "* ------------------------------------------------ *"
	
***************************************************************************	
	
*	End of file	
