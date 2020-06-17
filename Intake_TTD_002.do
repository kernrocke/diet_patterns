clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		Intake_TTD_002.do
**  Project:      	Dietary Patterns in Trinidad and Tobago
**	Sub-Project:	Sex-Differences in Reporting of Energy Intake
**  Analyst:		Kern Rocke
**	Date Created:	17/06/2020
**	Date Modified: 	17/06/2020
**  Algorithm Task: Logistic Regression Model (Table 2)


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150


*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/OneDrive - The University of the West Indies"
*/
*MAC OS
local datapath "/Users/kernrocke/OneDrive - The University of the West Indies"
cd "/Users/kernrocke/OneDrive - The University of the West Indies"

/*
Gender-differences in Plausibility in Reporting Dietary Intake among adults 
residing in a Caribbean Small Island Developing State.
*/

*Load in data for analysis
use "`datapath'/Manuscripts/Diet Intake/Data/Diet_TTD_v1", clear

*-------------------------------------------------------------------------------

*Binary Logistic Regression Models
foreach x in i.age_grp i.education_new i.ethnicity i.physical_1 i.bmi_cat {

	*Overall
	logistic miss_report `x', vce(robust) cformat(%9.2f)
	
	*Female
	logistic miss_report `x' if sex==0, vce(robust) cformat(%9.2f)
	
	*Male
	logistic miss_report `x' if sex==1, vce(robust) cformat(%9.2f)
	
	}

*-------------------------------------------------------------------------------




