/**************************************************************************	
	
	Program:  clean_fred_pce.do
	Authors:  AC Forrester
	
	Purpose: Clean the PCE price index from FRED.
		
**************************************************************************/	
	
	* don't need to set directory - uses API
	
/**************************************************************************
	
	Get the data from FRED and clean
	
**************************************************************************/	
	
	* import PCE in long form
	import fred PCEPI,                  	///
		daterange(1948-11-01 2019-12-31)	///
		aggregate(annual,avg)           	///
		long clear
		
	* year variable
	gen year = year(daten)

	* value in 2019
	qui sum value if year == 2019
		
	* reindex to 2018
	gen pce2019 = value/r(mean)*100
		
/**************************************************************************

	Rename/apply labels and save
	
**************************************************************************/	
	
	* rename 
	ren value pce2012
	
	* subset cols
	keep year pce2012 pce2019
	
	* labels 
	lab var year      	"Year"
	lab var pce2012 	"PCE (2012 = 100)"
	lab var pce2019 	"PCE (2019 = 100)"
	
	* reorder cols
	order year pce*

	* label data
	lab data "FRED: PCE price index"
	
	* print summary
	desc
	
	* Save in merge
	save ${merge}fred_pce_index, replace

***************************************************************************	
	
*	End of file
