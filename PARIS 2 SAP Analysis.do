/**** PARIS 2 DATA ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 06/07/2020 ****/
/**** Purpose: Analysis of PARIS II data as per SAP ****/

/*** SAP Table 1: Demographics ***/

// Age at randomisation
hist dem_age
qnorm dem_age
tabstat dem_age, stats(n mean sd min max q iqr) by(randomisation_arm)

// Weight
hist dem_adm_weight
qnorm dem_adm_weight
tabstat dem_adm_weight, stats(n mean sd min max q iqr) by(randomisation_arm)

// Gender
tab sex randomisation_arm, m col
tab sex randomisation_arm, col

// Ethnicity
tab dem_ethn_cat randomisation_arm, m col
tab dem_ethn_cat randomisation_arm, col

// Premature birth
tab hrf_prematurity randomisation_arm, m col
tab hrf_prematurity randomisation_arm, col
tab hrf_prematurity randomisation_arm if hrf_prematurity~=3, m col
tab hrf_prematurity randomisation_arm if hrf_prematurity~=3, col

// Neonatal respiratory 
* Manually change jet ventilation to invasive ventilation (subjid 0115-0297)
tab hrf_resp_supp_post_birth randomisation_arm, m col
tab hrf_resp_supp_post_birth randomisation_arm, col
tab hrf_resp_supp_post_birth randomisation_arm if hrf_resp_supp_post_birth~=3, m col
tab hrf_resp_supp_post_birth randomisation_arm if hrf_resp_supp_post_birth~=3, col
*preserve
*keep if hrf_resp_supp_post_birth==1
tab hrf_resp_supp_post_birth randomisation_arm, m col
tab hrf_resp_supp_post_birth randomisation_arm, col
foreach v of varlist hrf_resp_supp_post_birth_inv hrf_resp_supp_post_birth_niv hrf_resp_supp_post_birth_hfnc hrf_resp_supp_post_birth_other hrf_resp_supp_post_birth_specify hrf_resp_supp_post_birth_modalit hrf_resp_supp_post_birth_unknown hrf_resp_supp_post_birth_comb {
	tab `v' randomisation_arm, m col
	tab `v' randomisation_arm, col
}
*restore

// Previous hospital admission for respiratory disease
tab hrf_prev_resp_adm randomisation_arm, m col
tab hrf_prev_resp_adm randomisation_arm, col
tab hrf_prev_resp_adm randomisation_arm if hrf_prev_resp_adm~=3, m col
tab hrf_prev_resp_adm randomisation_arm if hrf_prev_resp_adm~=3, col

// Previous ICU admission for respiratory support 
tab hrf_prev_icu_adm randomisation_arm, m col
tab hrf_prev_icu_adm randomisation_arm, col
tab hrf_prev_icu_adm randomisation_arm if hrf_prev_icu_adm~=3, m col
tab hrf_prev_icu_adm randomisation_arm if hrf_prev_icu_adm~=3, col
foreach v of varlist hrf_prev_icu_adm_inv hrf_prev_icu_adm_niv hrf_prev_icu_adm_hfnc hrf_prev_icu_adm_other hrf_prev_icu_adm_specify hrf_prev_icu_adm_unknown hrf_prev_icu_adm_comb {
*	tab `v' randomisation_arm if hrf_prev_icu_adm==1, m col
*	tab `v' randomisation_arm if hrf_prev_icu_adm==1, col
	tab `v' randomisation_arm if hrf_prev_icu_adm~=3, m col
	tab `v' randomisation_arm if hrf_prev_icu_adm~=3, col
}

// Chronic lung disease
tab hrf_history_cld randomisation_arm, m col
tab hrf_history_cld randomisation_arm if hrf_history_cld~=3, col

// Congenital heart disease 
tab hrf_history_chd randomisation_arm, m col
tab hrf_history_chd randomisation_arm if hrf_history_chd~=3, col

// Patient history of wheeze 
tab hrf_history_wheeze randomisation_arm, m col
tab hrf_history_wheeze randomisation_arm if hrf_history_wheeze~=3, col

// Family history of asthma
tab hrf_history_asthma randomisation_arm, m col
tab hrf_history_asthma randomisation_arm if hrf_history_asthma~=3, col

// Family history of allergy
tab hrf_history_allergy randomisation_arm, m col
tab hrf_history_allergy randomisation_arm if hrf_history_allergy~=3, col

// Currently attending child care
tab hrf_attending_care randomisation_arm, m col
tab hrf_attending_care randomisation_arm, col

// Viral aetiology
tab npa_taken randomisation_arm, m col
tab npa_taken randomisation_arm, col
*preserve
*keep if npa_taken==1
* Adenovirus
tab npa_adenovirus randomisation_arm, m col
tab npa_adenovirus randomisation_arm, col
* Influenza
tab npa_influenza randomisation_arm, m col
tab npa_influenza randomisation_arm, col
* Metapneumovirus
tab npa_human_metapneu randomisation_arm, m col
tab npa_human_metapneu randomisation_arm, col
* Respiratory syncytial virus (RSV)
tab npa_rsv randomisation_arm, m col
tab npa_rsv randomisation_arm, col
* Multiple viruses
tab npa_multiple randomisation_arm, m col
tab npa_multiple randomisation_arm, col
* No virus detected on nasopharyngeal aspirate
tab npa_nad randomisation_arm, m col
tab npa_nad randomisation_arm, col
*restore

// Diagnosis at admission
tab inc_adm_dx_group randomisation_arm, m col
tab inc_adm_dx_group randomisation_arm, col

// Diagnosis at admission 
tab inc_adm_dx_obs randomisation_arm, m col
tab inc_adm_dx_obs randomisation_arm, col
tab inc_adm_dx_non_obs randomisation_arm, m col
tab inc_adm_dx_non_obs randomisation_arm, col

// Severity pre-enrolment
* Heart rate beats/min 
hist pre_rand_hr
qnorm pre_rand_hr
tabstat pre_rand_hr, stats(n mean sd min max q iqr) by(randomisation_arm)
* Respiratory rate breaths/min 
hist pre_rand_rr
qnorm pre_rand_rr
tabstat pre_rand_rr, stats(n mean sd min max q iqr) by(randomisation_arm)
* SpO2 
hist pre_rand_spo2
qnorm pre_rand_spo2
tabstat pre_rand_spo2, stats(n mean sd min max q iqr) by(randomisation_arm)

// Time from presentation to randomisation (days)
hist present_to_randomise_days
qnorm present_to_randomise_days
tabstat present_to_randomise_days, stats(n mean sd min max q iqr) by(randomisation_arm)

// Time of onset of illness to presentation in days
hist onset_of_illness_days
qnorm onset_of_illness_days
tabstat onset_of_illness_days, stats(n mean sd min max q iqr) by(randomisation_arm)

// Hospital has on-site intensive care unit
tab hosp_tertiary randomisation_arm, m col
tab hosp_tertiary randomisation_arm, col

// Country of hospital
tab hosp_country randomisation_arm, m col
tab hosp_country randomisation_arm, col

// Summary table: note, doesn't include all fields as some depend on a reduced number of cases
preserve
table1_mc, by(randomisation_arm) ///
		   vars(dem_age conts %4.1f \ ///
			    dem_adm_weight conts %4.1f \ ///
				sex cat \ ///
				dem_ethn_cat cat \ ///
				hrf_prematurity cat \ ///
				hrf_resp_supp_post_birth cat \ ///
				hrf_prev_resp_adm cat \ /// 
				hrf_history_cld cat \ ///
				hrf_history_chd cat \ /// 
				hrf_history_wheeze cat \ /// 
				hrf_history_asthma cat \ /// 
				hrf_history_allergy cat \ /// 
				hrf_attending_care cat \ /// 
				npa_taken cat \ ///
				inc_adm_dx_group cat \ ///
				inc_adm_dx_obs cat \ ///
				inc_adm_dx_non_obs cat \ ///
				pre_rand_hr contn %4.0f \ ///
				pre_rand_rr conts %4.0f \ ///
				pre_rand_spo2 conts %4.0f \ ///
				onset_of_illness_days conts %4.0f \ ///
				hosp_country cat  ) ///
				saving("PARIS2 Table 1.xlsx", replace) clear
restore

/*** SAP Table 2: Primary and secondary outcomes as per ITT ***/

/* Primary outcome: hospital LOS */
hist los_hosp
qnorm los_hosp
tabstat los_hosp, stats(n mean sd min max q iqr) by(randomisation_arm)
xi: qreg los_hosp b(1).randomisation_arm

* Primary analysis and sensitivity analyses
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
sts graph, by(randomisation_arm) xtick(0(4)44) xlabel(0(4)44) xscale(range (0 44)) title("") scheme(s1mono) ///
		legend(lab(1 "Standard Oxygen Therapy") lab(2 "Nasal High-Flow")) xtitle("Days since randomisation") ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f))
* Truncate graph at 28 days: ITT
preserve
rename randomisation_arm Group
label drop study_arm
label define Group 1 "SOT" 2 "NHF"
label values Group Group
replace los_hosp=28 if los_hosp>28
stset los_hosp
sts graph, by(Group) xtick(0(4)28) xlabel(0(4)28) xscale(range (0 28)) title("") scheme(s1mono) ///
		legend(lab(1 "SOT") lab(2 "NHF")) xtitle("Days since randomisation") risktable ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f)) ///
		 text(0.36 12 "aHR: 0.83" 0.3 12 "95% CI: 0.75, 0.92" 0.24 12 "p<0.001", placement(east))
restore		
* Truncate graph at 8 days: ITT
preserve
rename randomisation_arm Group
label drop study_arm
label define Group 1 "SOT" 2 "NHF"
label values Group Group
stset los_hosp, exit(time 8)
sts graph, by(Group) xtick(0(1)8) xlabel(0(1)8) xscale(range (0 8)) title("") scheme(s1mono) ///
		legend(lab(1 "SOT") lab(2 "NHF")) xtitle("Days since randomisation") risktable ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f)) ///
		 text(0.36 4 "aHR: 0.83" 0.3 4 "95% CI: 0.75, 0.92" 0.24 4 "p<0.001", placement(east))
restore		
* Truncate graph at 5 days: ITT
preserve
rename randomisation_arm Group
label drop study_arm
label define Group 1 "standard-oxygen" 2 "high-flow"
label values Group Group
stset los_hosp, exit(time 5)
sts graph, by(Group) xtick(0(1)5) xlabel(0(1)5) xscale(range (0 5)) title("") scheme(s1mono) ///
		legend(lab(1 "standard-oxygen") lab(2 "high-flow")) xtitle("Days since randomisation") risktable ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f)) ///
		 text(0.56 3 "aHR: 0.83" 0.5 3 "95% CI: 0.75, 0.92" 0.44 3 "p<0.001", placement(east))
restore		
* Truncate graph at 28 days: per-protocol
preserve
rename randomisation_arm Group
label drop study_arm
label define Group 1 "SOT" 2 "NHF"
label values Group Group
replace los_hosp=28 if los_hosp>28
stset los_hosp
sts graph, by(Group) xtick(0(4)28) xlabel(0(4)28) xscale(range (0 28)) title("") scheme(s1mono) ///
		legend(lab(1 "SOT") lab(2 "NHF")) xtitle("Days since randomisation") risktable ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f)) ///
		 text(0.36 12 "aHR: 0.81" 0.3 12 "95% CI: 0.70, 0.93", placement(east))
restore		  
* Truncate graph at 8 days: per-protocol
preserve
rename randomisation_arm Group
label drop study_arm
label define Group 1 "SOT" 2 "NHF"
label values Group Group
replace los_hosp=28 if los_hosp>28
stset los_hosp, exit(time 8)
sts graph, by(Group) xtick(0(1)8) xlabel(0(1)8) xscale(range (0 8)) title("") scheme(s1mono) ///
		legend(lab(1 "SOT") lab(2 "NHF")) xtitle("Days since randomisation") risktable ///
		 ytitle("Probability of remaining in hospital") ytick(0(0.2)1) ylabel(0(0.2)1, format(%4.1f)) ///
		 text(0.36 4 "aHR: 0.81" 0.3 4 "95% CI: 0.70, 0.93", placement(east))
restore		  
		 
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: obstructive diagnosis
preserve
keep if inc_adm_dx_group==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: non-obstructive diagnosis
preserve
keep if inc_adm_dx_group==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: diagnosis - interaction
stset los_hosp
xi: mestreg b(1).randomisation_arm##b(2).inc_adm_dx_group || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: obstructive diagnosis at discharge
preserve
keep if dc_dx_gr==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: non-obstructive diagnosis at discharge
preserve
keep if dc_dx_gr==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: diagnosis at discharge - interaction
xi: mestreg b(1).randomisation_arm##b(2).dc_dx_gr || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: age = 1 year old
preserve
keep if dem_age_yr==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: age = 2 year old
preserve
keep if dem_age_yr==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: age = 3 years old
preserve
keep if dem_age_yr==3
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: age = 4 years old
preserve
keep if dem_age_yr==4
hist los_hosp
graph box los_hosp, over(randomisation_arm)
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
xi: qreg los_hosp b(1).randomisation_arm
stset los_hosp
xi: mestreg b(1).randomisation_arm, distribution(weibull)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
restore

* Subgroup analysis: age - interaction
preserve
keep if dem_age_yr<=4 & dem_age_yr>=1
xi: mestreg b(1).randomisation_arm##b(1).dem_age_yr b(2).inc_adm_dx_group || siteid:, distribution(weibull)
testparm i.randomisation_arm#i.dem_age_yr
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp
restore
	
/* Secondary outcomes */

// Analyse tolerance outcomes
local outcomes_cont "cs_clinician_01_score cs_clinician_change cs_parent_01_score cs_parent_change"
foreach v of varlist `outcomes_cont' {

	* Descriptive statistics
	hist `v'
	qnorm `v'
	tabstat `v', by(randomisation_arm) stats(n mean sd min max q iqr)
		
	* Primary outcome
	reg `v' b(1).randomisation_arm
	xi: meglm `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:
	* Test assumptions
	predict pr, xb
	predict r, residuals
	scatter r pr
	drop pr r
	
}

// Analyse continuous outcomes related to change in therapy
local outcomes_cont "cot_hr_change cot_rr_change"
foreach v of varlist `outcomes_cont' {

	preserve
	keep if cot_recieved_outcome==1
	* Descriptive statistics
	hist `v'
	qnorm `v'
	tabstat `v', by(randomisation_arm) stats(n mean sd min max q iqr)
		
	* Primary outcome
	reg `v' b(1).randomisation_arm
	xi: meglm `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:
	* Test assumptions
	predict pr, xb
	predict r, residuals
	scatter r pr
	drop pr r
	
	restore
	
}

// Analyse binary outcomes related to change in therapy
local outcomes_binary "cot_recieved_outcome cot_icu cot_transfer_hosp esc_therapy" 
foreach v of varlist `outcomes_binary' {

	* Descriptive statistics
	capture noisily tab `v' randomisation_arm, m col
	capture noisily tab `v' randomisation_arm, col
	capture noisily prtest `v', by(randomisation_arm)
	
	* Primary outcome
	capture noisily logistic `v' b(1).randomisation_arm
	capture noisily xi: melogit `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
	* Test assumptions
	capture noisily linktest, nolog
	capture noisily predict p
	capture noisily predict devr, dev
	capture noisily scatter devr p, yline(0) mlabel(subjid)
	capture noisily drop p devr
	
}

// Analyse binary outcomes related to those who had a change in oxygen therapy
local outcomes_binary_cot "cot_ewt_review1 cot_oct_wob1 cot_oct_dloc1 cot_oct_docfwipp1 cot_oct_staffing1 cot_oct_cjamo1 cot_oct_icu_review1 cot_oct_other1" 
foreach v of varlist `outcomes_binary_cot' {

	preserve
	keep if cot_recieved_outcome==1
	tab `v' randomisation_arm if cot_recieved_outcome==1, m col
	* Descriptive statistics
	capture noisily tab `v' randomisation_arm, m col
	capture noisily tab `v' randomisation_arm, col
	capture noisily prtest `v', by(randomisation_arm)
	
	* Primary outcome
	capture noisily logistic `v' b(1).randomisation_arm
	capture noisily xi: melogit `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
	* Test assumptions
	capture noisily linktest, nolog
	capture noisily predict p
	capture noisily predict devr, dev
	capture noisily scatter devr p, yline(0) mlabel(subjid)
	capture noisily drop p devr
	
	restore
	
}

// Analyse binary outcomes related to those who had a change in oxygen therapy: assume missing is no (apart from EWT review at the sites where it wasn't collected)
preserve
keep if cot_recieved_outcome==1
replace cot_ewt_review1=0 if cot_ewt_review1==. | cot_ewt_review1==3
replace cot_ewt_review1=0 if cot_recieved_outcome~=1
replace cot_ewt_review1=. if siteid==57 | siteid==112
tab cot_ewt_review1 randomisation_arm if cot_recieved_outcome==1, m col
* Descriptive statistics
capture noisily tab cot_ewt_review1 randomisation_arm, m col
capture noisily tab cot_ewt_review1 randomisation_arm, col
	
* Primary outcome
capture noisily logistic cot_ewt_review1 b(1).randomisation_arm
capture noisily xi: melogit cot_ewt_review1 b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
* Test assumptions
capture noisily linktest, nolog
capture noisily predict p
capture noisily predict devr, dev
capture noisily scatter devr p, yline(0) mlabel(subjid)
capture noisily drop p devr
restore

local outcomes_binary_cot "cot_ewt_review1 cot_oct_wob1 cot_oct_dloc1 cot_oct_docfwipp1 cot_oct_staffing1 cot_oct_cjamo1 cot_oct_icu_review1 cot_oct_other1 cot_intolerance1" 
foreach v of varlist `outcomes_binary_cot' {

	preserve
	*keep if cot_recieved_outcome==1
	replace `v'=0 if `v'==. | `v'==3
	replace `v'=0 if cot_recieved_outcome~=1
	tab `v' randomisation_arm if cot_recieved_outcome==1, m col
	* Descriptive statistics
	capture noisily tab `v' randomisation_arm, m col
	capture noisily tab `v' randomisation_arm, col
	capture noisily prtest `v', by(randomisation_arm)
	
	* Primary outcome
	capture noisily logistic `v' b(1).randomisation_arm
	capture noisily xi: melogit `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
	* Test assumptions
	capture noisily linktest, nolog
	capture noisily predict p
	capture noisily predict devr, dev
	capture noisily scatter devr p, yline(0) mlabel(subjid)
	capture noisily drop p devr
	
	restore
	
}

// Analyse binary outcomes related to adverse events
local outcomes_binary_ae "adv_death adv_air_leak adv_emerg_int adv_cardiac_arrest adv_resp_arrest adv_other"
foreach v of varlist `outcomes_binary_ae' {

	* Descriptive statistics
	capture noisily tab `v' randomisation_arm, m col
	capture noisily tab `v' randomisation_arm, col
	
	* Primary outcome
	capture noisily logistic `v' b(1).randomisation_arm
	capture noisily xi: melogit `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
	* Test assumptions
	capture noisily linktest, nolog
	capture noisily predict p
	capture noisily predict devr, dev
	capture noisily scatter devr p, yline(0) mlabel(subjid)
	capture noisily drop p devr
	
}

// Analyse survival outcomes
local outcomes_surv "los_hosp_total los_o2"
foreach v of varlist `outcomes_surv' {

	* Descriptive statistics
	hist `v'
	qnorm `v'
	tabstat `v', by(randomisation_arm) stats(n mean sd min max q iqr)
	xi: qreg `v' b(1).randomisation_arm
		
	* Primary outcome
	stset `v'
	streg b(1).randomisation_arm, distribution(weibull)
	xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
	* Test assumptions
	predict s, surv
	gen lnls=log(-1*log(s))
	gen log_`v'=log(`v')
	scatter lnls log_`v'
	drop s lnls log_`v'
	
}

// Sensitivity analysis using multiple imputation for the primary outcome
mi register imputed los_hosp
mi impute chained (regress) los_hosp = b(1).randomisation_arm b(2).inc_adm_dx_group, add(10) rseed(54321) savetrace(trace1,replace)

* Re-run the primary analysis
stset los_hosp
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Sensitivity analysis: ICU + >3/4 clinical criteria
tab cot_icu_sens randomisation_arm, m col
tab cot_icu_sens randomisation_arm, col
xi: melogit cot_icu_sens b(1).randomisation_arm, or
xi: melogit cot_icu_sens b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(subjid)
drop p devr

* Sensitivity analysis: transfer + >3/4 clinical criteria
tab cot_transfer_sens randomisation_arm, m col
tab cot_transfer_sens randomisation_arm, col
xi: melogit cot_transfer_sens b(1).randomisation_arm, or
xi: melogit cot_transfer_sens b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(subjid)
drop p devr

// Extra analyses

* Comparison of length of ICU stay between treatment groups for those patients who were admitted to ICU
preserve
keep if cot_icu==1
* Descriptive statistics
hist los_hosp_total
qnorm los_hosp_total
tabstat los_hosp_total, by(randomisation_arm) stats(n mean sd min max q iqr)
	
* Primary analysis and sensitivity analyses
stset los_hosp_total, failure(los_hosp)_event)
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp_total=log(los_hosp_total)
scatter lnls log_los_hosp_total
drop s lnls log_los_hosp_total

restore

* Randomisation to change of therapy hours
tabstat rand_to_cot_hours if cot_recieved_outcome==1, by(Group) stats(n mean sd min max q iqr)

* Physiological parameters prior to change in oxygen therapy
preserve
keep if cot_recieved_outcome==1

table1_mc, by(randomisation_arm) ///
		   vars(cot_hr1 contn %4.1f \ ///
				cot_rr1 contn %4.1f \ ///
				cot_spo21 conts %4.1f \ ///
				cot_wob1 cat \ ///
				cot_ewtscore1 conts %4.1f \ ///
				rand_to_cot_hours conts %4.1f ) ///
				saving("PARIS2 eTable x.xlsx", replace) clear
restore


* Adverse event: other
tab adv_other_specify randomisation_arm

* Protocol deviation relating to first therapy received
tab pd_cot randomisation_arm, col m
tab pd_cot randomisation_arm, col

/*** Supplementary information ***/

/* Length of stay by hospital */
tabstat los_hosp, by(siteid) stats(n mean sd min max q iqr)
tabstat los_hosp_total, by(siteid) stats(n mean sd min max q iqr)))
/* Investigating change of therapy */
preserve
keep if randomisation_arm==1
tab cot_received1 if cot_location1==4 | cot_location1==1 , m
drop if cot_received1~=1 | (cot_received1==1 & cot_location1~=1 & cot_location1~=4)
tab cot_received1, m

* First change
tab cot_therapy1, m
tab cot_therapy_specify1, m
drop if cot_therapy1~=2 // keep only NHF

* Second change
tab cot_therapy2, m
tab cot_therapy_specify2, m
drop if cot_therapy2~=2 // keep only SOT

* Third change
tab cot_therapy3, m
tab cot_therapy_specify3, m
drop if cot_therapy2~=2 // keep only NHF
