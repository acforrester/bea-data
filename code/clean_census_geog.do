/**************************************************************************	
	
	Program:  clean_census_geo.do
	Authors:  AC Forrester
	
	Purpose: Clean the the Census FIPS codes.
		- State, region, and division codes/names
		
**************************************************************************/	
	
	* Project params
	loc	main	census-bureau
	
	* Main directories
	gl	raw	${build}`main'/raw/
	gl	zip	${build}`main'/zip/
	gl	dta	${build}`main'/dta/

/**************************************************************************
	
	Download the Census Excel file
	
**************************************************************************/	
		
	* Pull the file
	cap confirm file ${raw}state-geocodes-v2017.xlsx
	if _rc {
		* URL
		loc url	https://www2.census.gov/programs-surveys/popest/geographies/2017/
		* go get the file
		copy `url'state-geocodes-v2017.xlsx ${raw}
	}
	
/**************************************************************************
	
	Load and clean the Census FIPS codes
	
**************************************************************************/	
	
	* Open the xlsx file
	import excel using ${raw}state-geocodes-v2017.xlsx, clear
	
	* Rename column names
	ren (A B C D) (region_code division_code state_code geo_name)
	
	* Var labels
	foreach var of varlist * {
		lab var `var' "`=`var'[6]'"
	}
	drop in 1/6
	
	* Drop the headers
	destring *, replace
	
	* Sort
	sort region division state_code
	
	* Region name
	bys region_code (division_code): gen region_name = geo_name[1]
	
	* Division name
	bys region_code division_code: gen division_name = geo_name[1]
	
	* Drop the regions/divisions
	drop if (state_code == 0)
	
/**************************************************************************

	Rename/apply labels and save
	
**************************************************************************/	
	
	* rename geo name
	ren geo_name state_name
	
	* labels 
	lab var region_code     	"Region FIPS"
	lab var division_code    	"Division FIPS"
	lab var region_name     	"Region name"
	lab var division_name    	"Division name"
	lab var state_code	"State FIPS"
	lab var state_name	"State name"
	
	* reorder
	order state* region* division*
	
	* Sort
	sort state_code

	* label data
	lab data "Census: FIPS codes"
	
	* print summary
	desc
	
	* Save in merge 
	save ${merge}census_regions, replace
	
***************************************************************************	
	
*	END OF FILE	
