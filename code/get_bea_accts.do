/**************************************************************************	
	
	Program:  get_bea_accts.do
	Authors:  AC Forrester
	
	Purpose: Download and unpack the BEA state-level accounts.
		- BEA data contain each file by state (don't need those)
		- Only keep the necessary datasets (SAINC4 and SAINC51)
		
**************************************************************************/	
	
	* Project params
	loc	main	bea-data
	
	* Main directories
	gl	raw	${build}`main'/raw/
	gl	zip	${build}`main'/zip/
	gl	dta	${build}`main'/dta/

/**************************************************************************
	
	Download and unzip the files
	- A lot of unnecessary file (To-do -> map into R to DL)
	
**************************************************************************/	
	
	* do we have the file? If not - go and get it
	cap confirm file ${raw}SAINC4.csv
	if _rc {
	
		* Do we have the necessary ZIP file?
		cap confirm file ${zip}SAINC.zip
		if _rc {
			loc url https://apps.bea.gov/regional/zip/SAINC.zip
			copy `url' ${zip}
		} 
		
		*  location to unzip
		cd ${raw}
		
		* unzip (a lot of files)
		unzipfile ${zip}SAINC.zip
		
		* now lets clean up
		loc file_list : dir `"${raw}"' files *
		
		* rename the two files we want
		copy SAINC4__ALL_AREAS_1929_2019.csv   SAINC4.csv, replace
		copy SAINC51__ALL_AREAS_1948_2019.csv SAINC51.csv, replace
		
		* now clean up
		foreach file of local file_list {
			erase `file'
		}
		
	}

***************************************************************************	
	
*	End of file
