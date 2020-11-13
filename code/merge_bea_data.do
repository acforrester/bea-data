/**************************************************************************	
	
	Program:  merge_bea_data.do
	Authors:  AC Forrester
	
	Purpose: Merge the BEA state-level accounts.
		- BEA data contain each file by state (don't need those)
		- Only keep the necessary datasets (SAINC4 and SAINC51)
		- Merge in Census FIPS codes
		- Merge in PCE and adjust for inflation
		
**************************************************************************/	
	
	* Project params
	loc	main	bea-data
	
	* Main directories
	gl	raw	${build}`main'/raw/
	gl	zip	${build}`main'/zip/
	gl	dta	${build}`main'/dta/
	
/**************************************************************************

	Merge data
	
**************************************************************************/	
	
	* start with BEA SAINC4
	use ${merge}bea_accts_sainc4, clear
	
	* merge in BEA: SAINC51
	merge 1:1 state_code geo_name year using ${merge}bea_accts_sainc51, nogen
	
	* merge in Census FIPS codes
	merge m:1 state_code using ${merge}census_regions, nogen
	
	* merge in FRED price index
	merge m:1 year using ${merge}fred_pce_index, nogen
	
/**************************************************************************
	
	Basic clean-up
		- Subset data (1970-2019)
		- Adjust for inflation using PCE
		- Sort descending by state
		
**************************************************************************/	
	
	* subset cols (drop BEA name and division)
	drop geo_name region*
	
	* subset rows (1970-on)
	drop if year < 1970
	
	* income vars
	local income_vars pers_inc_mill pers_inc_pc disp_pers_inc_mill disp_pers_inc_pcap
	
	* adjust for inflation with PCE
	foreach var of local income_vars {
		replace `var' = `var'/pce2019
	}
	
	* sort descending
	sort state_code year
	
	* reorder cols
	order state_code state_name state_name division* year *
	
	* label data
	lab data "BEA Data 1970-2019: Income, population, employment"
	
	* print summary
	desc
	
	* Save in merge
	save ${clean}bea_accts_data, replace
	
*****************************************************************	
	
*	End of file
