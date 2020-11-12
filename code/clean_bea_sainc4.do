/**************************************************************************	
	
	Program:  clean_bea_sainc1.do
	Authors:  AC Forrester
	
	Purpose: Clean the BEA accounts data st the state level (SAINC1).
		- Income, wages, and population by state/year (1929-2019) 
		
**************************************************************************/	
	
	* Project params
	loc	main	bea-data
	
	* Main directories
	gl	raw	${build}`main'/raw/
	gl	zip	${build}`main'/zip/
	gl	dta	${build}`main'/dta/

/**************************************************************************

	Load and clean the income data
	- Keep total personal income and population

**************************************************************************/	
	
	* Open the CSV file as strings
	import delim using ${raw}SAINC4.csv, /*
		*/	varn(nonames) stringc(_all) clear
	
	* Loop over vars
	foreach var of varlist * {
		
		if (`=real(`var'[1])' > 1928 & `=real(`var'[1])' != .) {
			
			destring `var', ignore("(NA)L") replace 
					
			ren `var' value`=`var'[1]'
		
		}
		else {
			lab var `var' "`=`var'[1]'"
			ren `var' `=lower(strtoname(`var'[1]))'
		}
		
	}
	drop in 1
	
	* Drop footnotes
	drop if (geoname == "")
	
	* Geo id
	ren (geofips geoname) (state_code geo_name)
	
	* Destring
	destring *, ignore(`"""') replace
	
	* Fix geofips
	replace state_code = int(state_code / 1000)
	
	* Drop regions
	drop if (state_code > 56 | state_code < 1)
	
	* Subset
	keep geo* state_code line value*
	
	* Reshape to long (years to rows)
	reshape long value, i(state_code line) j(year)
	
	* Reshape to wide (vars to columns)
	reshape wide value, i(state_code year) j(line)
	
/**************************************************************************

	Rename/apply labels and save
	
**************************************************************************/	
	
	* Rename values
	ren value10 	pers_inc_mill
	ren value20 	population
	ren value30 	pers_inc_pc
	ren value7010 	emp_total
	ren value7020 	emp_wage_salary
	
	* drop extra vars
	drop value*
	
	* labels 
	lab var year         	"Year"
	lab var pers_inc_mill 	"Pers. inc. (millions)"
	lab var population    	"Population"
	lab var pers_inc_pc 	"Personal income per capita"
	lab var emp_total		"Total employment"
	lab var emp_wage_salary	"Wage and salary employment"
	
	* reorder columns
	order state_code geo_name year *
	
	* label data
	lab data "BEA SAINC4: Income and employment, 1929-2019"
	
	* print summary
	desc
	
	* Save in merge
	save ${merge}bea_accts_sainc4, replace

***************************************************************************	
	
*	End of file
