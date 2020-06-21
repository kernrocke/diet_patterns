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

*Multiple Logistic Regression Model

*Overall
logistic miss_report i.age_grp i.education_new i.ethnicity i.physical_1 ///
		 i.bmi_cat, vce(robust) cformat(%9.2f)

*Female
logistic miss_report i.age_grp i.education_new i.ethnicity i.physical_1 ///
		 i.bmi_cat if sex == 0, vce(robust) cformat(%9.2f)

*Male		 
logistic miss_report i.age_grp i.education_new i.ethnicity i.physical_1 ///
		 i.bmi_cat if sex == 1, vce(robust) cformat(%9.2f)		 
		 
		 
		 
		 
preserve
cls
*Energy Intake from macro nutrients


drop if carbs == 0
drop if fat == 0
drop if protein == 0

drop if carbs == .
drop if fat == .
drop if protein == .

gen carbs_kcal = carbs*4
gen fat_kcal = fat*9
gen protein_kcal = protein*4

*Percentage energy intake from macronutrients
gen carb_E = carbs_kcal/calories * 100
gen fat_E = fat_kcal/calories * 100
gen proetin_E = protein_kcal/calories * 100

*Create new variables for macronutrients
gen carbs_energy = (calories*.65) 
gen fats_energy = (calories*.65) 
gen protein_energy = (calories*.65) 

//Dietary Variables

*Overall
tabstat calories carbs fat protein carbs_kcal fat_kcal protein_kcal, by(ratio_1) ///
		stat(mean semean median min max) col(stat) long  nototal format (%9.1f)
		
*Female
tabstat calories carbs fat protein carbs_kcal fat_kcal protein_kcal if sex==0, by(ratio_1) ///
		stat(mean semean median min max) col(stat) long nototal format  (%9.1f)
		
*Male
tabstat calories carbs fat protein carbs_kcal fat_kcal protein_kcal if sex ==1, by(ratio_1) ///
		stat(mean semean median min max) col(stat) long nototal format  (%9.1f)

*-------------------------------------------------------------------------------
*Examine differences
foreach x in calories carbs fat protein carbs_kcal fat_kcal protein_kcal {
*Overall
anova `x' ratio_1
*Female
anova `x' ratio_1 if sex==0
*Male
anova `x' ratio_1 if sex==1	
		
		}
restore
