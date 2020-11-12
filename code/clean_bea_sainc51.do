/**************************************************************************	
	
	Program:  clean_bea_sainc51.do
	Authors:  AC Forrester
	
	Purpose: Clean the BEA accounts data st the state level (SAINC51).
		- Disposable income and population by state/year (1948-2019) 
		
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
	import delim using ${raw}SAINC51.csv, /*
		*/	varn(nonames) stringc(_all) clear
	
	* Loop over vars
	foreach var of varlist * {
		
		if (`=real(`var'[1])' > 1947 & `=real(`var'[1])' != .) {
			
			destring `var', ignore("(NA)") replace 
					
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
	ren value51 	disp_pers_inc_mill
	ren value53 	disp_pers_inc_pcap
	
	* drop extra vars
	drop value*
	
	* labels 
	lab var year             	"Year"
	lab var disp_pers_inc_mill 	"Dispos. inc. (millions)"
	lab var disp_pers_inc_pcap	"Dispos. inc. per capita"
	
	* reorder columns
	order state_code geo_name year *
	
	* label data
	lab data "BEA SAINC51: Disposable income, 1948-2019"
	
	* print summary
	desc
	
	* Save in merge
	save ${merge}bea_accts_sainc51, replace
	
*****************************************************************	
	
*	End of file
