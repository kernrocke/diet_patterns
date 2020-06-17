clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		PAL_TTO_001.do
**  Project:      	Physical Activity Level Trinidad
**  Analyst:		Kern Rocke
**	Date Created:	11/05/2020
**	Date Modified: 	11/05/2020
**  Algorithm Task: Population Pyramid - Physical Activity TTO


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


use "/Users/kernrocke/Downloads/compositional_analysis.dta", clear
gen agegrp = age
recode agegrp (18/19=1) (20/24=2) (25/29=3) (30/34=4) (35/39=5) (40/44=6) ///
			  (45/49=7) (50/54=8) (55/59=9) (60/64=10) (65/69=11) (70/74=12) ///
			  (75/79=13) (80/84=14) (85/max=15)
label var agegrp "Age Groups"
label define agegrp 1 "18-19" ///
					2 "20-24" ///
					3 "25-29" ///
					4 "30-34" ///
					5 "35-39" ///
					6 "40-44" ///
					7 "45-49" ///
					8 "50-54" ///
					9 "55-59" ///
					10 "60-64" ///
					11 "65-69" ///
					12 "70-74" ///
					13 "75-79" ///
					14 "80-84" ///
					15 "85 & over"
label value agegrp agegrp					
tab agegrp

replace sex = 2 in 30
replace agegrp = 15 in 30

gen pop = 1
collapse (sum) pop, by(agegrp sex)

drop if sex == .
drop if agegrp == .


egen sp1 = sum(pop)
gen pop1 = pop/sp1

recode sex (0=1) (1=2)
label define sex 1"Female" 2"Male", modify
label value sex sex
gen pop_tt = .
replace pop_tt= 48577 if sex==1 & agegrp==1
replace pop_tt= 56788 if sex==1 & agegrp==2
replace pop_tt= 61197 if sex==1 & agegrp==3
replace pop_tt= 51641 if sex==1 & agegrp==4
replace pop_tt= 45645 if sex==1 & agegrp==5
replace pop_tt= 42642 if sex==1 & agegrp==6
replace pop_tt= 47385 if sex==1 & agegrp==7
replace pop_tt= 43164 if sex==1 & agegrp==8
replace pop_tt= 36450 if sex==1 & agegrp==9
replace pop_tt= 28940 if sex==1 & agegrp==10
replace pop_tt= 22925 if sex==1 & agegrp==11
replace pop_tt= 15995 if sex==1 & agegrp==12
replace pop_tt= 11370 if sex==1 & agegrp==13
replace pop_tt= 7182 if sex==1 & agegrp==14
replace pop_tt= 6268 if sex==1 & agegrp==15
				
replace pop_tt= 49424 if sex==2 & agegrp==1 
replace pop_tt= 56983 if sex==2 & agegrp==2 
replace pop_tt= 61811 if sex==2 & agegrp==3 
replace pop_tt= 53519 if sex==2 & agegrp==4 
replace pop_tt= 46538 if sex==2 & agegrp==5 
replace pop_tt= 43190 if sex==2 & agegrp==6 
replace pop_tt= 48365 if sex==2 & agegrp==7 
replace pop_tt= 43737 if sex==2 & agegrp==8 
replace pop_tt= 36554 if sex==2 & agegrp==9 
replace pop_tt= 29503 if sex==2 & agegrp==10 
replace pop_tt= 21458 if sex==2 & agegrp==11 
replace pop_tt= 14101 if sex==2 & agegrp==12 
replace pop_tt= 9188 if sex==2 & agegrp==13 
replace pop_tt= 5265 if sex==2 & agegrp==14 
replace pop_tt= 3893 if sex==2 & agegrp==15 


egen sp2 = sum(pop_tt)
drop pop1
reshape wide pop pop_tt, i(agegrp) j(sex)

browse
gen zero = 0
gen pop1_per = pop1/sp1 // Sample Female
gen pop2_per = pop2/sp1 // Sample Male

gen pop_tt1_per = pop_tt1/sp2 // CSO Female
gen pop_tt2_per = pop_tt2/sp2 // CSO Female


replace pop2_per = -pop2_per

replace pop_tt2_per = -pop_tt2_per

#delimit ;
	twoway 
	/// PAL KABP - women
	(bar pop1_per agegrp, horizontal lw(thin) lc(gs11) fc(gold*0.8) ) ||
	/// PAL KABP - men 
	(bar pop2_per agegrp, horizontal lw(thin) lc(gs11) fc(purple*0.8) ) ||
	/// BSS 2010
	(connect agegrp pop_tt1_per, symbol(T) mc(gs0) lc(gs0))
	(connect agegrp pop_tt2_per, symbol(T) mc(gs0) lc(gs0))
	
	(sc agegrp zero, mlabel(agegrp) mlabcolor(black) msymbol(i))
	, 

	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)

	title("Trinidad PAL Survey Population by Age Groups", c(black))
	xtitle("Proportion of Residents withn Age Group", size(small)) ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(0.5))
	xlabel(-0.1 "0.1" -0.08 "0.08" -0.06 "0.06" -0.04 "0.04" -0.02 "0.02" 0 "0" 
	0.02 "0.02" 0.04 "0.04" 0.06 "0.06" 0.08 "0.08" 0.1 "0.1", tlength(0) 
	nogrid gmin gmax)
	caption("Source: COVID-19 KABP, Central Statistical Office- TTD, UN World Population Prospectus", span size(vsmall))
	legend(size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(4)
	region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3)
	lab(1 "Females") 
	lab(2 "Males")
	lab(3 "CSO 2020")
	);
#delimit cr
