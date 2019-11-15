
clear
capture log close
cls


**  DO FILE META-DATA
**  Program:		CRC_diet_001.do
**  Project:      	CRC Risk Factor Study
**	Sub-Project:	Dietary Patterns among Trinidad Adults
**  Analyst:		Kern Rocke
**	Date Created:	15/11/2019
**	Date Modified: 	15/11/2019
**  Algorithm Task: Multiple Imputation and Lasso Model Prediction for Dietary Data


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to folder location
local datapath "/Users/kernrocke/Documents/Statistical Data Anlaysis/2018"

*Load in Dataset
use "`datapath'/Knowledge_CC_Study/Data/Knowledge_Paper_v1_2018_11_04.dta", clear

preserve
*Setting macros
global food fruitjui-friedhot
global pcode

*Multiple Imputation using complex chainded equations
mi set mlong
misstable sum bmi perknoscore ethicgrp fruitjui-friedhot
mi register imputed bmi
set seed 29390
mi impute chained (regress) bmi = ethicgrp $food, add(20)

*Final count of final dataset
count

*Create training and testing data for models
gen sample = _mi_m
recode sample (1/max=1)

*Principle Component Analysis of Dietary Patterns Model
paran $food, graph color seed(29390)
pca $food, mineigen(1) blank(0.3) components(6)
screeplot, yline(1)
scoreplot, components(6)
rotate, varimax blank(0.3) components(6)
predict com1 com2 com3 com4 com5 com6

*Lasso Model
lasso2 bmi $food, adaptive long lambda()
lasso2, lic(bic)
*Lowest BIC lambda = 17.74206968651617
lasso2 bmi $food, adaptive long lambda(17.74206968651617)
predict bmi_lasso

summ bmi bmi_lasso if _mi_m==0

restore