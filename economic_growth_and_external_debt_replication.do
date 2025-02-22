/**********************************************************************************/
/* This file contains the code for cleaning and analyzing the World Development   */
/* Indicators  dataset for the purpose of my study on Economic Growth and External*/
/* Debt: Evidence from South and South-East Asian Countries. It contains the      */
/* following sections -                                                           */
/* Section 1: Data Cleaning and Summmarizing key variables                        */
/* Section 2: Final Fixed effects and Random effects model Results                */
/* Section 3: Final Arellano-Bond Two-step system GMM model Results               */
/* Section 4: Graphs                                                              */
/*                                                                                */
/* Note: For interpretation of the results - check Section 5.2 of the paper       */
/**********************************************************************************/

* Section 1: Data Cleaning and Summmarizing key variables

/* Set working directory */
cd "C:\Users\91983\OneDrive\Desktop\Economic growth and External Debt\Data"

/* Load WDI dataset from an Excel file */
import excel "C:\Users\91983\OneDrive\Desktop\Economic growth and External Debt\Data\Raw data.xlsx", sheet(ub_long) firstrow clear

/* Encode Country Name for categorical analysis */
encode country_name, gen(country)

/* Convert key economic variables from string to numeric format */
destring external_debt_stocks_gni, gen (external_debt_stocks_gni_destr) force
destring fdi_gdp, gen (fdi_gdp_destr) force
destring gross_cap_formation_gdp , gen (gross_cap_formation_gdp_destr) force
destring trade_gdp, gen (trade_gdp_destr) force
destring gross_fixed_cap_formation_gdp, gen (gross_f_cap_formation_gdp_destr) force
destring imports_gdp, gen (imports_gdp_destr) force
destring exports_gdp, gen (exports_gdp_destr) force
destring tot_debt_service_exp, gen (tot_debt_service_exp_destr) force
destring gov_effectiveness_est, gen(gov_effectiveness_est_destr) force
destring gov_final_cons_exp_gdp, gen(gov_final_cons_exp_gdp_destr) force

/* Summary statistics of key variables */
summ external_debt_stocks_gni_destr fdi_gdp_destr gross_cap_formation_gdp_destr trade_gdp_destr gov_final_cons_exp_gdp_destr gross_f_cap_formation_gdp_destr imports_gdp_destr exports_gdp_destr

/* Winsorize variables to handle outliers */

/// GDP PPP
histogram gdp_ppp, bin(50) normal
sum gdp_ppp, detail
winsor2 gdp_ppp, cuts(1 99)
sum gdp_ppp_w, detail

/// GDP growth rate
histogram gdp_gr_rate, bin(50) normal
sum gdp_gr_rate, detail
winsor2 gdp_gr_rate, cuts(1 99)
sum gdp_gr_rate_w, detail

/// External debt
histogram external_debt_stocks_gni_destr, bin(50) normal
sum external_debt_stocks_gni_destr, detail
winsor2 external_debt_stocks_gni_destr, cuts(1 99)
sum external_debt_stocks_gni_destr_w, detail

/// Population size
histogram pop_size, bin(50) normal
sum pop_size, detail
winsor2 pop_size, cuts(1 99)
sum pop_size_w, detail

/// Trade
histogram trade_gdp_destr, bin(50) normal
sum trade_gdp_destr, detail
winsor2 trade_gdp_destr, cuts(5 95)
sum trade_gdp_destr_w, detail


/// FDI
histogram fdi_gdp_destr, bin(50) normal
sum fdi_gdp_destr, detail
winsor2 fdi_gdp_destr, cuts(1 99)
sum fdi_gdp_destr_w, detail
replace fdi_gdp_destr_w =. if fdi_gdp_destr_w <=0

/// Government final consumption expenditure
histogram gov_final_cons_exp_gdp_destr, bin(50) normal
sum gov_final_cons_exp_gdp_destr, detail
winsor2 gov_final_cons_exp_gdp_destr, cuts(1 99)
sum gov_final_cons_exp_gdp_destr, detail

/// gross_cap_formation_gdp_destr
histogram gross_cap_formation_gdp_destr, bin(50) normal
sum gross_cap_formation_gdp_destr, detail
winsor2 gross_cap_formation_gdp_destr, cuts(1 99)
sum gross_cap_formation_gdp_destr_w, detail

/// gross_cap_f_formation_gdp_destr
histogram gross_f_cap_formation_gdp_destr, bin(50) normal
sum gross_f_cap_formation_gdp_destr, detail
ren gross_f_cap_formation_gdp_destr gross_f_cap_form_gdp_destr
winsor2 gross_f_cap_form_gdp_destr, cuts(5 95)
sum gross_f_cap_form_gdp_destr_w, detail


/// Inflation
histogram Inf_con_pr, bin(50) normal
sum Inf_con_pr, detail
winsor2 Inf_con_pr, cuts(1 99)
sum Inf_con_pr_w, detail

/// tot_debt_service_exp_destr
histogram tot_debt_service_exp_destr, bin(50) normal
sum tot_debt_service_exp_destr, detail
winsor2 tot_debt_service_exp_destr, cuts(1 99)
sum tot_debt_service_exp_destr_w, detail

/* Alternatively run the following code to winsorize faster (I prefer to visualize the data and hence opt for the previous steps instead
foreach var in gdp_ppp gdp_gr_rate external_debt_stocks_gni_d pop_size trade_gdp_d fdi_gdp_d gov_final_cons_exp_gdp_d gross_cap_formation_gdp_d gross_fixed_cap_formation_gdp_d Inf_con_pr tot_debt_service_exp_d {
    histogram `var', bin(50) normal
    summarize `var', detail
    winsor2 `var', cuts(1 99)
    summarize `var'_w, detail
} */

/* Summarize winsorized variables */
summ gdp_ppp_w pop_size_w external_debt_stocks_gni_destr_w fdi_gdp_destr_w gross_cap_formation_gdp_destr_w trade_gdp_destr_w gov_final_cons_exp_gdp_destr_w gross_f_cap_form_gdp_destr_w imports_gdp_destr exports_gdp_destr

/* Creating Log-Transformed Variables */
gen log_gdp_ppp = log(gdp_ppp_w)
gen log_external_debt_stocks_gni = log(external_debt_stocks_gni_destr_w)
gen log_pop_size = log(pop_size_w)
gen log_gov_final_cons_exp_gdp = log(gov_final_cons_exp_gdp_destr_w)
gen log_gross_cap_formation_gdp = log(gross_cap_formation_gdp_destr_w)
gen log_fdi_gdp = log(fdi_gdp_destr_w)
gen log_Inf_con_pr = log(Inf_con_pr_w)
gen log_trade_gdp = log(trade_gdp_destr_w)
gen log_tot_debt_service_exp = log(tot_debt_service_exp_destr_w)
gen log_gdp_pc_ppp = log(gdp_pc_ppp)
gen log_exports_gdp = log(exports_gdp_destr)
gen log_gross_f_cap_formation_gdp = log(gross_f_cap_form_gdp_destr_w)

/* Creating Year Dummies Based on Economic Shocks */
gen year_group = .
replace year_group = 1 if inrange(year, 2000, 2008)  /* Pre-Global Financial Crisis */
replace year_group = 2 if inrange(year, 2009, 2019)  /* Post-GFC until COVID-19 */
replace year_group = 3 if inrange(year, 2020, 2022)  /* COVID-19 Period */

/* Summary Statistics for Main Variables */
summ gdp_ppp gdp_ppp external_debt_stocks_gni_destr pop_size fdi_gdp_destr trade_gdp_destr gross_cap_formation_gdp_destr 


/* Save Cleaned and Processed Dataset */
save final_data, replace

*******************************************************************************************************************************************************************************************************************

*Section 2: Final Fixed effects and Random effects model Results

/* Final fe/re results */

/* Load dataset */
use final_data.dta, clear

/* Setup as panel data */
xtset country year
xtdescribe

/* Run fixed effects model */
xtreg log_gdp_ppp L.log_external_debt_stocks_gni log_pop_size log_gross_cap_formation_gdp log_fdi_gdp log_trade_gdp year_group , fe vce(cluster country_name)

/* Run random effects model */
xtreg log_gdp_ppp L.log_external_debt_stocks_gni log_pop_size log_gross_cap_formation_gdp log_fdi_gdp log_trade_gdp year_group , re vce(cluster country_name)

/* Hausman Test */

* Fixed effects model
xtreg log_gdp_ppp L.log_external_debt_stocks_gni log_pop_size log_gross_cap_formation_gdp log_fdi_gdp log_trade_gdp  year_group , fe 
estimates store fixed

* Random effects model
xtreg log_gdp_ppp L.log_external_debt_stocks_gni log_pop_size log_gross_cap_formation_gdp log_fdi_gdp log_trade_gdp year_group , re 
estimates store random

* Test
hausman fixed random, sigmamore

*******************************************************************************************************************************************************************************************************************

* Section 3: Final Arellano-Bond Two-step system GMM model Results

/* Set working directory */
cd "C:\Users\91983\OneDrive\Desktop\Economic growth and External Debt\Data"

/* Load dataset */
use final_data.dta, clear

/* Setup as a panel data */
xtset country year

/* Run Arellano-Bond two-step system GMM */

xtabond2 log_gdp_ppp L.log_gdp_ppp L.log_external_debt_stocks_gni /// 
         log_pop_size  year_group, ///
         gmm(L4.log_gdp_ppp, lag(2 8) collapse) ///
		 gmm(L2.log_external_debt_stocks_gni, lag(2 3) collapse) ///
         twostep robust small

xtabond2 log_gdp_ppp L.log_gdp_ppp L.log_external_debt_stocks_gni ///
         log_pop_size log_fdi_gdp year_group, ///
         gmm(L4.log_gdp_ppp, lag(2 8) collapse) ///
		 gmm(L2.log_external_debt_stocks_gni, lag(2 3) collapse) ///
         twostep robust small

xtabond2 log_gdp_ppp L.log_gdp_ppp L.log_external_debt_stocks_gni ///
         log_pop_size log_fdi_gdp log_trade_gdp year_group, ///
         gmm(L4.log_gdp_ppp, lag(2 8) collapse) ///
		 gmm(L2.log_external_debt_stocks_gni, lag(2 3) collapse) ///
         twostep robust small

xtabond2 log_gdp_ppp L.log_gdp_ppp L.log_external_debt_stocks_gni ///
         log_pop_size log_fdi_gdp log_trade_gdp log_gross_cap_formation_gdp year_group, ///
         gmm(L4.log_gdp_ppp, lag(2 8) collapse) ///
		 gmm(L2.log_external_debt_stocks_gni, lag(2 3) collapse) ///
         twostep robust small		 
		 
*******************************************************************************************************************************************************************************************************************

* Section 4: Graphs

* Generate the line graph

twoway line external_debt_stocks_gni_destr year, by(country, legend(off)) ///   
    connect(L) lpattern(solid) lwidth(medium)    
    title("External Debt Stocks as a Percentage of GNI") ///
    ytitle("External Debt (% of GNI)") xtitle("Year") ///
    legend(order(1 "Bangladesh" 2 "Bhutan" 3 "Cambodia" 4 "China" 5 "India" 6 "Indonesia" 7 "Nepal" 8 "Pakistan" 9 "Philippines" 10 "Sri Lanka" 11 "Thailand" 12 "Viet Nam"))

twoway line log_external_debt_stocks_gni year, by(country, legend(off)) ///   
    connect(L) lpattern(solid) lwidth(medium)    
    ylabel(, angle(horizontal)) xlabel(, format(%ty)) ///
    title("External Debt Stocks as a Percentage of GNI") ///
    ytitle("External Debt (% of GNI)") xtitle("Year") ///
    legend(order(1 "Bangladesh" 2 "Bhutan" 3 "Cambodia" 4 "China" 5 "India" 6 "Indonesia" 7 "Nepal" 8 "Pakistan" 9 "Philippines" 10 "Sri Lanka" 11 "Thailand" 12 "Viet Nam"))

*******************************************************************************************************************************************************************************************************************
	