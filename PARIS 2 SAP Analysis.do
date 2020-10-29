/**** PARIS 2 DATA ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 06/07/2020 ****/
/**** Purpose: Analysis of PARIS II data as per SAP ****/

/* Keep only the randomised, enrolled participants */
keep if randomisation_arm~=.
keep if revocation_status~=1
keep if consent_status==1

/* Add on the Griffith randomisation */
destring study_id, replace
sort siteid study_id
merge 1:1 siteid study_id using "Output\PARIS 2 Griffith Rand"
keep if _merge==1 | _merge==3
/* Finalise the randomisation variable */
replace randomisation_arm=studygroup if studygroup~=.

mvdecode cot_ewt_review1 cot_oct_wob1 cot_oct_dloc1 cot_oct_docfwipp1 ///
		 cot_oct_staffing1 cot_oct_cjamo1 cot_oct_icu_review1 cot_oct_other1, ///
		 mv(3=.)

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
tab hrf_resp_supp_post_birth randomisation_arm, m col
tab hrf_resp_supp_post_birth randomisation_arm, col
preserve
keep if hrf_resp_supp_post_birth~=3
tab hrf_resp_supp_post_birth randomisation_arm, m col
tab hrf_resp_supp_post_birth randomisation_arm, col
foreach v of varlist hrf_resp_supp_post_birth_inv hrf_resp_supp_post_birth_niv hrf_resp_supp_post_birth_hfnc hrf_resp_supp_post_birth_other hrf_resp_supp_post_birth_specify hrf_resp_supp_post_birth_unknown {
	tab `v' randomisation_arm, m col
	tab `v' randomisation_arm, col
}
restore

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
foreach v of varlist hrf_prev_icu_adm_inv hrf_prev_icu_adm_niv hrf_prev_icu_adm_hfnc hrf_prev_icu_adm_other hrf_prev_icu_adm_specify hrf_prev_icu_adm_unknown {
	tab `v' randomisation_arm if hrf_prev_icu_adm~=3, m col
	tab `v' randomisation_arm if hrf_prev_icu_adm~=3, col
}

// Chronic lung disease
tab hrf_history_cld randomisation_arm, m col
tab hrf_history_cld randomisation_arm, col

// Congenital heart disease 
tab hrf_history_chd randomisation_arm, m col
tab hrf_history_chd randomisation_arm, col

// Patient history of wheeze 
tab hrf_history_wheeze randomisation_arm, m col
tab hrf_history_wheeze randomisation_arm, col

// Family history of asthma
tab hrf_history_asthma randomisation_arm, m col
tab hrf_history_asthma randomisation_arm, col

// Family history of allergy
tab hrf_history_allergy randomisation_arm, m col
tab hrf_history_allergy randomisation_arm, col

// Currently attending child care
tab hrf_attending_care randomisation_arm, m col
tab hrf_attending_care randomisation_arm, col

// Viral aetiology
tab npa_taken randomisation_arm, m col
tab npa_taken randomisation_arm, col
preserve
keep if npa_taken==1
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
restore

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

// Time from presentation to randomisation (hours)

// Time of onset of illness to presentation in days
hist onset_of_illness_days
qnorm onset_of_illness_days
tabstat onset_of_illness_days, stats(n mean sd min max q iqr) by(randomisation_arm)

// Country of hospital
tab hosp_country randomisation_arm, m col
tab hosp_country randomisation_arm, col

/*** SAP Table 2: Primary and secondary outcomes as per ITT ***/

/* Primary outcome: hospital LOS */
hist los_hosp
qnorm los_hosp
tabstat los_hosp, stats(n mean sd min max q iqr) by(randomisation_arm)

* Primary analysis and sensitivity analyses
stset los_hosp
xi: mestreg b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, distribution(weibull)
stcurve, survival at(randomisation_arm==1) at(randomisation_arm==2)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: non-obstructive diagnosis
preserve
keep if inc_adm_dx_group==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: obstructive diagnosis
preserve
keep if inc_adm_dx_group==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: diagnosis - interaction
xi: mestreg b(1).randomisation_arm##b(2).inc_adm_dx_group || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: non-obstructive diagnosis at discharge
preserve
keep if inc_adm_dx_group==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: obstructive diagnosis at discharge
preserve
keep if inc_adm_dx_group==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: diagnosis at discharge - interaction
xi: mestreg b(1).randomisation_arm##b(2).inc_adm_dx_group || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp

* Subgroup analysis: age
preserve
keep if dem_age_yr==1
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: age
preserve
keep if dem_age_yr==2
hist los_hosp
tabstat los_hosp, by(randomisation_arm) stats(n mean sd min max q iqr)
restore

* Subgroup analysis: age - interaction
xi: mestreg b(1).randomisation_arm##b(4).dem_age_yr || siteid:, distribution(weibull)
* Test assumptions
predict s, surv
gen lnls=log(-1*log(s))
gen log_los_hosp=log(los_hosp)
scatter lnls log_los_hosp
drop s lnls log_los_hosp
	
/* Secondary outcomes */
// Create variable lists for remaining outcome variables
local outcomes_cont "cs_clinician_01_score cs_clinician_02_score cs_parent_01_score cs_parent_02_score"
local outcomes_binary "cot_received_any cot_icu cot_transfer_hosp esc_therapy cot_ewt_review1 cot_oct_wob1 cot_oct_dloc1 cot_oct_docfwipp1 cot_oct_staffing1 cot_oct_cjamo1 cot_oct_icu_review1 cot_oct_other1 adv_death adv_air_leak adv_emerg_int adv_cardiac_arrest adv_resp_arrest adv_other"
local outcomes_surv "los_hosp_total los_o2"

// Analyse continuous outcomes
foreach v of varlist `outcomes_cont' {

	* Descriptive statistics
	hist `v'
	qnorm `v'
	tabstat `v', by(randomisation_arm) stats(n mean sd min max q iqr)
		
	* Primary outcome
	xi: meglm `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:
	* Test assumptions
	predict pr, xb
	predict r, residuals
	scatter r pr
	drop pr r
	
}

// Analyse binary outcomes
foreach v of varlist `outcomes_binary' {

	* Descriptive statistics
	noisily capture tab `v' randomisation_arm, m col
	noisily capture tab `v' randomisation_arm, col
	
	* Primary outcome
	noisily capture xi: melogit `v' b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
	* Test assumptions
	noisily capture linktest, nolog
	noisily capture predict p
	noisily capture predict devr, dev
	noisily capture scatter devr p, yline(0) mlabel(subjid)
	noisily capture drop p devr
	
}

// Analyse survival outcomes
foreach v of varlist `outcomes_surv' {

	* Descriptive statistics
	hist `v'
	qnorm `v'
	tabstat `v', by(randomisation_arm) stats(n mean sd min max q iqr)
		
	* Primary outcome
	stset `v'
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
xi: melogit cot_icu_sens b(1).randomisation_arm b(2).inc_adm_dx_group || siteid:, or
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(subjid)
drop p devr

* Sensitivity analysis: transfer + >3/4 clinical criteria
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

* Adverse event: other
tab adv_other_specify randomisation_arm

* Protocol deviation relating to first therapy received
tab pd_cot randomisation_arm, col m
tab pd_cot randomisation_arm, col