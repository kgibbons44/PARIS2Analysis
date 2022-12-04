/**** PARIS 2 ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 26/10/2020 ****/
/**** Purpose: Executable file to run all PARIS II related anlalyses ****/

log using "221125_PARIS 2 Analysis.txt", text replace

/* Import the data and prepare variables for analysis */
do "PARIS 2 Data Transformation.do"

/* Generate figures for CONSORT diagram */
do "PARIS 2 CONSORT.do"

/* Run the analysis - ITT */

// Keep only the randomised, enrolled participants
keep if randomisation_arm~=.
keep if consent_status==1

// Add on the Griffith randomisation
destring study_id, replace
sort siteid study_id
merge 1:1 siteid study_id using "Output\PARIS 2 Griffith Rand"
keep if _merge==1 | _merge==3
/* Finalise the randomisation variable */
replace randomisation_arm=studygroup if studygroup~=.

mvdecode cot_ewt_review1 cot_oct_wob1 cot_oct_dloc1 cot_oct_docfwipp1 ///
		 cot_oct_staffing1 cot_oct_cjamo1 cot_oct_icu_review1 cot_oct_other1, ///
		 mv(3=.)
		 
// Recruitment graph
gen int week_num = floor(randomisation_datetime-clock("21dec2017 00:00","DMYhm"))/(1000*60*60*24*7)
gen week_date=d(21dec2017)
replace week_date=week_date+(7*week_num)
format week_date %tdd-m-y
preserve
gen count_month=1
collapse (count) count_month, by(week_date)
gen id=1
bysort id (week_date) : gen cum_date=sum(count_month)
twoway (line cum_date week_date, sort scheme(s1mono) xtitle("Date of Randomisation", size(small)) ytitle("Number of Enrolled Patients", size(small)) ytick(0(100)1600, grid labsize(vsmall)) ylabel(0(100)1600, labsize(vsmall)) yscale(r(0 1600)) xlabel(, labsize(small)) tlabel(21dec2017 21mar2018 21jun2018 21sep2018 21dec2018 21mar2019 21jun2019 21sep2019 21dec2019 21mar2020, labsize(vsmall)))
restore

// Run the analysis
do "PARIS 2 SAP Analysis.do"

/* Run the analysis - per-protocol */
drop if inc_cri_not_met==1 | exc_cri_met==1
keep if randomisation_arm==commencement_arm
drop if ( cot_location1==4 | cot_location1==1 | (cot_location1==3 & tf_mater==1) )
do "PARIS 2 SAP Analysis.do"

log close
