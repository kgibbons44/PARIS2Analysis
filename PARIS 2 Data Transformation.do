/**** PARIS 2 ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 29/06/2020 ****/
/**** Purpose: Transformation of NITRIC data for analysis ****/

/*** CRF-01 ***/

clear
import delimited "paris-crf01_clean.csv"

// Define name of dataset
label data "crf01"

// Drop the pilot data
drop if study_hospital=="LCCH" | study_hospital=="RCH" | strpos(subjid,"0045")==1 | strpos(subjid,"0058")==1

// Define labels for categorical variables
* Yes/no variables
local yes_no_var "inclusion_met exclusion_met randomisation_status consent_status correct_arm"
foreach v of varlist `yes_no_var' {
	tab `v', m
	replace `v'="1" if `v'=="YES"
	replace `v'="0" if `v'=="NO"
	replace `v'="2" if `v'=="N/A"
	replace `v'="3" if `v'=="UNKNOWN"
	destring `v', replace force
	tab `v', m
}
label define yes_no 1 "Yes" 0 "No" 2 "N/A" 3 "Unknown"
* Study arms
foreach v of varlist randomisation_arm commencement_arm cs_clinician_01_therapy cs_clinician_02_therapy {
	tab `v', m
	replace `v'="1" if `v'=="CTRL"
	replace `v'="2" if `v'=="HFNC"
	replace `v'="3" if `v'=="NEITHER"
	replace `v'="4" if `v'=="NONE"
	destring `v', replace force
	tab `v', m
}
label define study_arm 1 "Control" 2 "High Flow" 3 "Neither" 4 "None"
* Work of breathing
foreach v of varlist pre_rand_wob post_rand_wob {
	tab `v', m
	replace `v'="0" if `v'=="NIL"
	replace `v'="1" if `v'=="MILD"
	replace `v'="2" if `v'=="MODERATE"
	replace `v'="3" if `v'=="SEVERE"
	replace `v'="4" if `v'=="UNKNOWN"
	destring `v', replace force
	tab `v', m
}
label define wob 0 "NIL" 1 "MILD" 2 "MODERATE" 3 "SEVERE" 4 "UNKNOWN" 5 "Not Applicable"
* Clinician
foreach v of varlist cs_clinician_01_person cs_clinician_02_person {
	tab `v', m
	replace `v'="1" if `v'=="DOCTOR"
	replace `v'="2" if `v'=="NURSE"
	destring `v', replace force
	tab `v', m
}
label define clinician 1 "Doctor" 2 "Nurse"
destring pre_rand_hr, replace force
destring pre_rand_rr, replace force
destring pre_rand_spo2, replace force
destring cs_clinician_01_score cs_clinician_02_score cs_parent_01_score cs_parent_02_score, replace force

// Apply labels to their for categorical variables
* Yes/no variables
local yes_no_all "randomisation_status inc_age-inclusion_met inclusion_met exc_none-exc_cpu consent_status post_rand_data pre_rand_o2_therapy correct_arm cs_parent_01_missing cs_parent_02_missing cs_clinician_01_missing cs_clinician_02_missing"
foreach v of varlist `yes_no_all' {
	destring `v', replace force
	label values `v' yes_no
}
* Encode list
rename study_hospital study_hospital_o
encode study_hospital_o, gen(study_hospital)
local encode_list "sex inc_adm_dx_group inc_adm_dx_obs inc_adm_dx_non_obs rand_location post_rand_o2_mode non_consent_reason"
foreach v of varlist `encode_list' {
	rename `v' `v'_o
	encode `v'_o, gen(`v')
	drop `v'_o
}
* Arms
foreach v of varlist randomisation_arm commencement_arm cs_clinician_01_therapy cs_clinician_02_therapy {
	label values `v' study_arm
}
* Scale
foreach v of varlist pre_rand_wob post_rand_wob {
	label values `v' wob
}
* Clinician
foreach v of varlist cs_clinician_01_person cs_clinician_02_person {
	label values `v' clinician
}

// Transform dates and times
local dt_vars "adm_datetime randomisation_datetime"
foreach v of varlist `dt_vars' {
	tostring `v', replace
	gen __tmp = clock(`v', "DMYhm")
	drop `v' 
	rename __tmp `v' 
	format `v' %tc
}
local dt_vars "adm_date dob consent_datetime non_consent_datetime"
foreach v of varlist `dt_vars' {
	tostring `v', replace
	gen __tmp = date(`v', "DMY")
	drop `v' 
	rename __tmp `v' 
	format `v' %td
}

// Assign labels to variables
label variable study_hospital "STUDY HOSPITAL"
label variable adm_datetime "DATE & TIME OF TRIAGE/ADMISSION"
label variable adm_date "1.1 DATE of triage or direct admission to ward *"
label variable adm_time "TIME of triage or direct admission to ward *"
label variable dob "Date of Birth *"
label variable sex "Sex *"
label variable inc_age "Aged 1 - 4 years plus 364 days? *"
label variable inc_ahrf "Presents with AHRF to the emergency department/ward *"
label variable inc_adm_required "Decision to admit to hospital *"
label variable inc_o2_required "Has an ongoing oxygen requirement (SpO2 <90/92%, as per hospital threshold, in room air for up to 10 mins preferentially) despite initial assessment and/or therapy? *"
label variable inc_tachypnoea "Persistent tachypnoea (RR >=35 resp/min >= 10 mins since presentation/admission to ward) *"
label variable inclusion_met "INCLUSION CRITERIA MET"
label variable inc_adm_dx_group "Has one of the following admission primary presumed diagnosis *"
label variable inc_adm_dx_obs "ACTUAL OBSTRUCTIVE DISEASE GROUP *"
label variable inc_adm_dx_obs_specify "If 'Other obstructive airway disease', please specify *"
label variable inc_adm_dx_non_obs "ACTUAL NON-OBSTRUCTIVE DISEASE GROUP *"
label variable inc_adm_dx_non_obs_specify "If 'Other non-obstructive airway disease', please specify *"
label variable exc_none "None of the below"
label variable exc_ed_o2 "Oxygen requirement and therapy in the emergency department existed for longer than 4 hours prior to inclusion (excludes oxygen given in ambulance or other hospital) *"
label variable exc_prev_hf "Previous use of High Flow therapy during this illness episode *"
label variable exc_upper_airway "Upper airway obstruction *"
label variable exc_apnoeas "Apnoeas (defined as requiring respiratory support such as NIV or mechanical ventilation) *"
label variable exc_craniofacial "Craniofacial malformation *"
label variable exc_fractured "Fractured basal skull *"
label variable exc_trauma "Trauma *"
label variable exc_dloc "Decreased level of consciousness *"
label variable exc_chd "Cyanotic Heart Disease (e.g. blue baby, expected normal saturation 60-94%) *"
label variable exc_home_o2 "Home Oxygen Therapy *"
label variable exc_trachy "Tracheostomy *"
label variable exc_cf "Cystic Fibrosis *"
label variable exc_oncology "Oncology patient *"
label variable exc_palliative "Palliative Care patient *"
label variable exc_critically_ill "Critically ill with immediate need for intubation or NIV and/or the need for closer observation in Intensive Care *"
label variable exc_cpu "Child Protection Case (e.g. NAI / under SYFS care) *"
label variable exclusion_met "EXCLUSION CRITERIA MET"
label variable randomisation_status "Has the patient been randomised in to the study? *"
label variable randomisation_datetime "Date & Time of randomisation (as per computer generated randomisation/enrolment logbook) *"
label variable commencement_datetime "Date & Time of commencement of randomised therapy *"
label variable study_id "Study Identification Number *"
label variable randomisation_arm "Study arm patient randomised to *"
label variable commencement_arm "Study arm patient commenced therapy on *"
label variable correct_arm "CORRECT RANDOMISATION THERAPY GIVEN"
label variable rand_location "Patient randomised in *"
label variable pre_rand_datetime "Date & Time of pre-randomisation values *"
label variable pre_rand_spo2 "SpO2 (lowest) in room air, prior to application of randomised therapy *"
label variable pre_rand_hr "HR *"
label variable pre_rand_rr "RR *"
label variable pre_rand_wob "WOB *"
label variable pre_rand_temp "Temp. *"
label variable pre_rand_ewtscore "EWT Score (if applicable) *"
label variable pre_rand_o2_therapy "Was patient started on standard oxygen therapy prior to randomisation? *"
label variable pre_rand_o2_hours "Hours *"
label variable pre_rand_o2_minutes "Minutes *"
label variable post_rand_data "[ PARIS-2 ADMIN ONLY ]"
label variable post_rand_datetime "Date/Time of post-randomisation values *"
label variable post_rand_hr "HR *"
label variable post_rand_rr "RR *"
label variable post_rand_spo2 "SpO2 *"
label variable post_rand_wob "WOB *"
label variable post_rand_temp "Temp. *"
label variable post_rand_ewtscore "EWT Score (if applicable) *"
label variable post_rand_o2_lpm "O2, L/min *"
label variable post_rand_o2_mode "O2, Mode *"
label variable post_rand_o2_mode_specify "If 'Other', please specify *"
label variable post_rand_hf_lpm "High Flow, L/min *"
label variable post_rand_hf_fio2 "High Flow, FiO2 *"
label variable consent_status "Was informed consent obtained? *"
label variable consent_datetime "Date WRITTEN INFORMED CONSENT obtained *"
label variable non_consent_reason "Reason for lack of consent *"
label variable non_consent_reason_specify "If 'Other', please specify *"
label variable non_consent_datetime "If 'No' consent obtained, date consent declined *"
label variable cs_clinician_01_missing "Missing: Not completed for this observation period"
label variable cs_clinician_01_person "Please specify if you are *"
label variable cs_clinician_01_therapy "Therapy arm child receiving *"
label variable cs_clinician_01_datetime "Date/Time of measurement of Comfort Score *"
label variable cs_clinician_01_score "How comfortable do the High Flow Therapy OR Standard Oxygen Therapy nasal cannula appear to you, on the child that you are caring for? *"
label variable cs_clinician_02_missing "Missing: Not completed for this observation period"
label variable cs_clinician_02_person "Please specify if you are *"
label variable cs_clinician_02_therapy "Therapy arm child receiving *"
label variable cs_clinician_02_datetime "Date/Time of measurement of Comfort Score *"
label variable cs_clinician_02_score "How comfortable do the High Flow Therapy OR Standard Oxygen Therapy nasal cannula appear to you, on the child that you are caring for? *"
label variable cs_parent_01_missing "Missing: Not completed for this observation period"
label variable cs_parent_01_therapy "Therapy arm child receiving *"
label variable cs_parent_01_datetime "Date/Time of measurement of Comfort Score *"
label variable cs_parent_01_score "How comfortable do the High Flow Therapy OR Standard Oxygen Therapy nasal cannula appear to be, for your child? *"
label variable cs_parent_02_missing "Missing: Not completed for this observation period"
label variable cs_parent_02_therapy "Therapy arm child receiving *"
label variable cs_parent_02_datetime "Date/Time of measurement of Comfort Score *"
label variable cs_parent_02_score "How comfortable do the High Flow Therapy OR Standard Oxygen Therapy nasal cannula appear to be, for your child? *"

// Duplicates
duplicates report subjid

// Save the dataset
save "Output\crf01.dta", replace

/*** CRF-02 ***/

clear
import delimited "paris-crf02_clean.csv"

// Define name of dataset
label data "crf02"

// Drop the pilot data
drop if study_hospital=="LCCH" | study_hospital=="RCH" | strpos(subjid,"0045")==1 | strpos(subjid,"0058")==1

// Drop the variables that will be imported from CRF 01
drop siteid subjstat visnam visdat visstat seq row study_hospital adm_datetime randomisation_arm commencement_arm correct_arm

// Define labels for categorical variables
* Yes/no variables
local yes_no_var "hrf_prematurity hrf_resp_supp_post_birth hrf_prev_resp_adm hrf_prev_icu_adm hrf_history_cld hrf_history_chd hrf_history_wheeze hrf_history_asthma hrf_history_allergy hrf_attending_care hrf_complex_pt hrf_prev_resp_adm_enr"
foreach v of varlist `yes_no_var' {
	tab `v', m
	replace `v'="1" if `v'=="YES"
	replace `v'="0" if `v'=="NO"
	replace `v'="2" if `v'=="N/A"
	replace `v'="3" if `v'=="UNKNOWN"
	destring `v', replace force
	tab `v', m
}
label define yes_no 1 "Yes" 0 "No" 2 "N/A" 3 "Unknown"
* Other variables
replace hrf_prev_resp_adm_number="5" if hrf_prev_resp_adm_number=="UNKNOWN"
destring hrf_prev_resp_adm_number, replace force
label define hrf_prev_resp_adm_number 4 "More than 3" 5 "Unknown"
destring dem_adm_weight, replace force
destring hrf_onset_weeks, replace force
destring hrf_onset_days, replace force
destring hrf_onset_hours, replace force

// Assign labels to variables
* Yes/no variables
local yes_no_all "dem_ethnicity_caucasian-dem_ethnicity_other dem_ethnicity_national hrf_onset_unknown hrf_prematurity hrf_prematurity_unknown hrf_resp_supp_post_birth_inv hrf_resp_supp_post_birth_niv hrf_resp_supp_post_birth_hfnc hrf_resp_supp_post_birth_other hrf_resp_supp_post_birth_modalit hrf_resp_supp_post_birth hrf_resp_supp_post_birth_unknown hrf_prev_resp_adm hrf_prev_icu_adm hrf_prev_icu_adm_inv hrf_prev_icu_adm_niv hrf_prev_icu_adm_hfnc hrf_prev_icu_adm_other hrf_prev_icu_adm_modalit hrf_prev_icu_adm_unknown hrf_prev_resp_adm_enr hrf_attending_care"
foreach v of varlist `yes_no_all' {
	destring `v', replace force
	label values `v' yes_no
}
* Other variables
label values hrf_prev_resp_adm_number hrf_prev_resp_adm_number

// Assign labels to variables
label variable dem_postcode "2.1 Patient's Residential Postcode *"
label variable dem_adm_weight "Admission Weight *"
label variable dem_ethnicity_caucasian "Caucasian / New Zealand European"
label variable dem_ethnicity_indigenous "Aboriginal & Torres Strait Island"
label variable dem_ethnicity_asian "Asian"
label variable dem_ethnicity_arabic "Middle Eastern or Arabic"
label variable dem_ethnicity_african "African"
label variable dem_ethnicity_maori "Maori"
label variable dem_ethnicity_islander "Pacific Islander"
label variable dem_ethnicity_samoan "Samoan"
label variable dem_ethnicity_tongan "Tongan"
label variable dem_ethnicity_niuean "Niuean"
label variable dem_ethnicity_chinese "Chinese"
label variable dem_ethnicity_indian "Indian"
label variable dem_ethnicity_unknown "Unknown"
label variable dem_ethnicity_other "Other..."
label variable dem_ethnicity_other_specify "If 'Other', please specify *"
label variable dem_ethnicity_national "Other (such as Dutch, Japanese, Tokelauan)..."
label variable dem_ethnicity_national_specify "If 'Other (such as Dutch, Japanese, Tokelauan)', please specify *"
label variable hrf_onset_weeks "Weeks"
label variable hrf_onset_days "Days"
label variable hrf_onset_hours "Hours"
label variable hrf_onset_unknown "Unknown"
label variable hrf_prematurity "2.4 Prematurity <37 weeks? *"
label variable hrf_prematurity_weeks "Weeks"
label variable hrf_prematurity_days "Days"
label variable hrf_prematurity_unknown "Unknown"
label variable hrf_resp_supp_post_birth "2.5 Did the child require respiratory support post birth (post delivery room)? *"
label variable hrf_resp_supp_post_birth_inv "Intubated and Ventilated"
label variable hrf_resp_supp_post_birth_niv "Mask Ventilation (NIV)"
label variable hrf_resp_supp_post_birth_hfnc "High Flow Therapy"
label variable hrf_resp_supp_post_birth_other "Other..."
label variable hrf_resp_supp_post_birth_specify "If 'Other', please specify *"
label variable hrf_resp_supp_post_birth_modalit "Modality unknown"
label variable hrf_resp_supp_post_birth_unknown "Unknown"
label variable hrf_prev_resp_adm "2.6 Has the child had any hospital admissions for respiratory disease previously? *"
label variable hrf_prev_resp_adm_number "If 'Yes', how many previous admissions? *"
label variable hrf_prev_resp_adm_reason "If 'Yes', please specify reason for admission? *"
label variable hrf_prev_resp_adm_enr "2.7 Has the child previously been enrolled in this study? *"
label variable hrf_prev_resp_adm_enr_id "If the child was enrolled previously, what was the Study ID? *"
label variable hrf_complex_pt "2.8 Complex Patient (chronic long term with health issues - Cardiac, Resp, Neuro) *"
label variable hrf_complex_pt_details "If 'Yes', please provide details *"
label variable hrf_prev_icu_adm "2.9 Has the child (post neonatal period) previously required ICU admission for respiratory support? *"
label variable hrf_prev_icu_adm_inv "Intubated and Ventilated"
label variable hrf_prev_icu_adm_niv "Mask Ventilation (NIV)"
label variable hrf_prev_icu_adm_hfnc "High Flow Therapy"
label variable hrf_prev_icu_adm_other "Other..."
label variable hrf_prev_icu_adm_specify "If 'Other', please specify *"
label variable hrf_prev_icu_adm_modality "Modality unknown"
label variable hrf_prev_icu_adm_unknown "Unknown"
label variable hrf_prev_icu_adm_reason "If 'Yes', please specify reason for admission *"
label variable hrf_history_cld "Diagnosis of chronic lung disease *"
label variable hrf_history_chd "Congenital heart disease *"
label variable hrf_history_wheeze "Patient history of wheeze *"
label variable hrf_history_asthma "Family history of asthma *"
label variable hrf_history_allergy "Family history of allergy *"
label variable hrf_attending_care "2.12 Is the child currently attending child care, kindergarten or school? *"

// Duplicates
duplicates report subjid

// Save the dataset
save "Output\crf02.dta", replace

/*** CRF-03 ***/

clear
import delimited "paris-crf03_clean.csv"

// Define name of dataset
label data "crf03"

// Drop the pilot data
drop if study_hospital=="LCCH" | study_hospital=="RCH" | strpos(subjid,"0045")==1 | strpos(subjid,"0058")==1

// Sort the data
sort subjid row

// Drop the variables that will be imported from CRF 01
drop siteid subjstat visnam visdat visstat seq study_hospital adm_datetime study_id randomisation_arm commencement_arm correct_arm

// Define labels for categorical variables
* Yes/no variables
local yes_no_var "npa_taken cultures_taken cultures_positive tole_same_therapy-tole_reduced_flows_better tole_changed_therapy tole_changed_therapy_better tole_correct_flows_other_methods feed_ctrl_ng_cont-feed_ctrl_peg feed_hfnc_ng_cont-feed_hfnc_reduc_flow feed_hfnc_reduc_flow_freq-feed_hfnc_ng_other"
foreach v of varlist `yes_no_var' {
	tab `v', m
	replace `v'="1" if `v'=="YES"
	replace `v'="0" if `v'=="NO"
	replace `v'="2" if `v'=="N/A"
	replace `v'="3" if `v'=="UNKNOWN"
	destring `v', replace force
	tab `v', m
}
label define yes_no 1 "Yes" 0 "No" 2 "N/A" 3 "Unknown"

// Apply labels to their for categorical variables
* Yes/no variables
local yes_no_all "npa_taken-npa_other cultures_taken cultures_positive treat_salbutamol_neb-treat_other treat_steroids-treat_nil tole_same_therapy-tole_reduced_flows_better tole_reduced_flows_unknown-tole_changed_to_ctrl_other tole_changed_to_hfnc feed_ctrl_notappl-feed_hfnc_reduc_flow feed_hfnc_reduc_flow_freq-feed_hfnc_ng_other"
foreach v of varlist `yes_no_all' {
	destring `v', replace force
	label values `v' yes_no
}
* Encode list
rename treat_salbutamol_neb_mdi_dosage treat_salbutamol_neb_mdi_dos
local encode_list "treat_salbutamol_neb_mdi_dos treat_salbutamol_iv_dos tole_changed_to_hfnc_flow_type"
foreach v of varlist `encode_list' {
	rename `v' `v'_o
	encode `v'_o, gen(`v')
	drop `v'_o
}

// Assign labels to variables
label variable npa_taken "3.1 NPA/Flocked swab taken? *"
label variable npa_adenovirus "Adenovirus"
label variable npa_influenza "Influenza"
label variable npa_influenza_a "A"
label variable npa_influenza_b "B"
label variable npa_parainfluenza "Parainfluenza"
label variable npa_parainfluenza_1 "1"
label variable npa_parainfluenza_2 "2"
label variable npa_parainfluenza_3 "3"
label variable npa_rhinovirus "Rhinovirus"
label variable npa_mycoplasma "Mycoplasma Pneumonia"
label variable npa_enterovirus "Enterovirus"
label variable npa_human_metapneu "Human Metapneumovirus (hMPV)"
label variable npa_rsv "Respiratory Syncytial Virus (RSV)"
label variable npa_picorna "Picorna Virus"
label variable npa_nad "NAD"
label variable npa_other "Other..."
label variable npa_specify "If 'Other', please specify *"
label variable cultures_taken "3.3 Blood cultures taken? *"
label variable cultures_positive "If 'Yes', were results positive? *"
label variable cultures_specify "Please specify results *"
label variable treat_salbutamol_neb "Salbutamol (nebuliser)"
label variable treat_salbutamol_iv "Salbutamol (intravenous)"
label variable treat_salbutamol_mdi "Salbutamol (MDI)"
label variable treat_saline_neb "Saline solution (nebuliser)"
label variable treat_saline_hypertonic "Hypertonic saline solution"
label variable treat_atrovent_neb "Ipratropium Bromide (Atrovent - nebuliser)"
label variable treat_atrovent_mdi "Ipratropium Bromide (Atrovent - MDI)"
label variable treat_paracetamol "Paracetamol"
label variable treat_antibiotics "Antibiotics"
label variable treat_other "Other..."
label variable treat_specify "If 'Other', please specify *"
label variable treat_steroids "Steroids"
label variable treat_ondansetron "Ondansetron"
label variable treat_magnesium "Magnesium"
label variable treat_aminophylline "Aminophylline"
label variable treat_caffeine "Caffeine"
label variable treat_adrenaline "Adrenaline"
label variable treat_heliox "Heliox"
label variable treat_ibuprofen "Ibuprofen"
label variable treat_nil "Nil medications given"
label variable treat_salbutamol_neb_mdi_dos "Salbutamol nebuliser/MDI *"
label variable treat_salbutamol_iv_dosage "Salbutamol intravenous *"
label variable treat_salbutamol_iv_specify "If 'Other', please specify *"
label variable treat_antibiotics_name "Name *"
label variable treat_antibiotics_route "Route *"
label variable tole_same_therapy "4.1 Did the child receive the same therapy as they were randomised to for the full length of oxygen therapy treatment? *"
label variable tole_correct_flows "4.2 If the child received High Flow therapy, did they receive correct weight specific flow rates at all times? *"
label variable tole_reduced_flows "If 'No', were the flows reduced? *"
label variable tole_reduced_flows_better "If the flows were reduced, did the child have better tolerance of High Flow therapy? *"
label variable tole_reduced_flows_days "Days"
label variable tole_reduced_flows_hours "Hours"
label variable tole_reduced_flows_minutes "Minutes"
label variable tole_reduced_flows_unknown "Unknown"
label variable tole_changed_therapy "4.3 Did the child require a change in therapy due to poor tolerance of randomised therapy? *"
label variable tole_changed_to_ctrl "Standard Oxygen Therapy..."
label variable tole_changed_to_ctrl_np "Subnasal Cannula"
label variable tole_changed_to_ctrl_hm "Hudson Mask"
label variable tole_changed_to_ctrl_fbo2 "Fly-By/Wafting Oxygen"
label variable tole_changed_to_ctrl_other "Other..."
label variable tole_changed_to_ctrl_specify "If 'Other', please specify *"
label variable tole_changed_to_hfnc "High Flow Therapy..."
label variable tole_changed_to_hfnc_flow_type "If 'High Flow Therapy', delivery was *"
label variable tole_changed_to_hfnc_flow_rate "Please specify flows *"
label variable tole_changed_to_other "Other Therapy..."
label variable tole_changed_to_specify "If 'Other Therapy', please specify *"
label variable tole_changed_therapy_better "4.5 Was the second therapy applied better tolerated, if known? *"
label variable tole_changed_further_actions "4.6 If 'No', specify actions taken (e.g. Fly-by/wafting oxygen) *"
label variable tole_correct_flows_other_methods "4.7 If the child remained on the correct weight specific flows, but continued to still have poor tolerance on High Flow, did you use other methods to minimise the poor tolerance of High Flow for the child? *"
label variable tole_correct_flows_methods_speci "If 'Yes', please provide details (e.g. use of sedation, distraction techniques, slow increase of flows) *"
label variable tole_other_details "4.8 Specify other details about poor tolerance (if applicable)"
label variable feed_ctrl_notappl "Not Applicable: No Control therapy received"
label variable feed_ctrl_ng_cont "Nasogastric feeds (continuous) *"
label variable feed_ctrl_ng_bolus "Nasogastric feeds (bolus) *"
label variable feed_ctrl_oral_fluid "Oral feeds (bottle/breast/drinking liquid) *"
label variable feed_ctrl_oral_solid "Oral feeds (food) *"
label variable feed_ctrl_iv "Intravenous fluids *"
label variable feed_ctrl_peg "PEG feeds (bolus or continuous) *"
label variable feed_hfnc_notappl "Not Applicable: No High Flow therapy received"
label variable feed_hfnc_ng_cont "Nasogastric feeds (continuous) *"
label variable feed_hfnc_ng_bolus "Nasogastric feeds (bolus) *"
label variable feed_hfnc_oral_fluid "Oral feeds (bottle/breast/drinking liquid) *"
label variable feed_hfnc_oral_solid "Oral feeds (food) *"
label variable feed_hfnc_iv "Intravenous fluids *"
label variable feed_hfnc_peg "PEG feeds (bolus or continuous) *"
label variable feed_hfnc_reduc_flow "4.12 If the child received oral feeds, was the flow rate reduced to 2 L/min (junior mode) or 10 L/min (adult mode)? *"
label variable feed_hfnc_reduc_flow_freq "If the flow was reduced, was it reduced *"
label variable feed_hfnc_reduc_flow_oral_fluid "Oral feeds (bottle/breast/drinking liquid) *"
label variable feed_hfnc_reduc_flow_oral_solid "Oral feeds (food) *"
label variable feed_hfnc_ng_other "4.13 While on HIGH FLOW therapy, did the patient have a nasogastric tube inserted for non-feeding purposes? *"

// Duplicates
duplicates report subjid

// Reshape the repeating data
save "Output\crf03.dta", replace
keep subjid row treat_antibiotics_name treat_antibiotics_route
reshape wide treat_antibiotics_name treat_antibiotics_route, i(subjid) j(row)
save "Output\crf03_ab.dta", replace
use "Output\crf03.dta", clear
drop treat_antibiotics_name treat_antibiotics_route
keep if row==1
merge 1:1 subjid using "Output\crf03_ab.dta"
drop _merge

// Save the dataset
save "Output\crf03.dta", replace

/*** CRF-04 ***/

clear
import delimited "paris-crf04_clean.csv"

// Define name of dataset
label data "crf04"

// Drop the pilot data
drop if study_hospital=="LCCH" | study_hospital=="RCH" | strpos(subjid,"0045")==1 | strpos(subjid,"0058")==1

// Sort the data
sort subjid row

// Drop the variables that will be imported from CRF 01
drop siteid subjstat visnam visdat visstat seq study_hospital adm_datetime study_id randomisation_arm commencement_arm correct_arm

// Define labels for categorical variables
* Yes/no variables
local yes_no_var "first_therapy_responder first_therapy_ra_only mm_90days mm_death cot_received cot_higher_care cot_ewt_review-cot_oct_other esc_transfer icu_data icu_cont_ctrl icu_esc_hfnc icu_cont_hfnc icu_weaned_hfnc_icu icu_ceased_hfnc_icu icu_cpap icu_niv icu_inv icu_ceased_hfnc_ward revocation_status data_collection_status"
foreach v of varlist `yes_no_var' {
	tab `v', m
	replace `v'="1" if `v'=="YES"
	replace `v'="0" if `v'=="NO"
	replace `v'="2" if `v'=="N/A"
	replace `v'="3" if `v'=="UNKNOWN"
	destring `v', replace force
	tab `v', m
}
label define yes_no 1 "Yes" 0 "No" 2 "N/A" 3 "Unknown"
* Study arms
foreach v of varlist cot_therapy cot_pre_therapy {
	tab `v', m
	replace `v'="1" if `v'=="CTRL"
	replace `v'="2" if `v'=="HFNC"
	replace `v'="3" if `v'=="OTHER"
	replace `v'="4" if `v'=="NONE"
	destring `v', replace force
	tab `v', m
}
label define cot_therapy 1 "Control" 2 "High Flow" 3 "Other" 4 "None"
* Work of breathing
tab cot_wob, m
replace cot_wob="1" if cot_wob=="NIL"
replace cot_wob="2" if cot_wob=="MILD"
replace cot_wob="3" if cot_wob=="MODERATE"
replace cot_wob="4" if cot_wob=="SEVERE"
replace cot_wob="5" if cot_wob=="UNKNOWN"
replace cot_wob="6" if cot_wob=="N/A"
destring cot_wob, replace force
label define cot_wob 1 "Nil" 2 "Mild" 3 "Moderate" 4 "Severe" 5 "Unknown" 6 "N/A"
rename cot_location_specify cot_loc_other_specify

// Apply labels to their for categorical variables
* Yes/no variables
local yes_no_all "first_therapy_responder first_therapy_breathed_ra_unknow first_therapy_ceased_hfnc_unknow first_therapy_ceased_hfnc_notapp first_therapy_dc_home_unknown first_therapy_ra_only dc_dx_sec_none-dc_dx_sec_other cot_received cot_higher_care cot_ewt_review cot_ewt_review-cot_oct_other esc_transfer icu_data icu_cont_ctrl icu_esc_hfnc icu_cont_hfnc adv_air_leak adv_emerg_int adv_cardiac_arrest adv_resp_arrest adv_other adv_death icu_cpap icu_niv icu_inv "
foreach v of varlist `yes_no_all' {
	destring `v', replace force
	label values `v' yes_no
}
* Encode list
local encode_list "dc_dx_primary cot_location cot_o2_mode esc_transfer_hosp esc_transfer_hosp_location icu_cont_ctrl_mode revocation_party study_withdrawal_reason"
foreach v of varlist `encode_list' {
	rename `v' `v'_o
	encode `v'_o, gen(`v')
	drop `v'_o
}
label values cot_therapy cot_therapy
label values cot_wob cot_wob
label values cot_pre_therapy cot_therapy
* Destring numeric variables
destring cot_hr cot_rr cot_spo2 cot_o2_lpm cot_hf_lpm cot_hf_fio2 cot_temp cot_ewtscore icu_cont_hfnc_flow icu_cont_hfnc_fio2, replace force

// Transform dates and times
local dt_vars "first_therapy_breathed_ra_dateti first_therapy_ceased_hfnc_dateti first_therapy_dc_home_datetime mm_death_datetime esc_change_datetime esc_icu_transfer_datetime cot_datetime cot_pre_datetime icu_esc_hfnc_datetime icu_breathed_ra_icu_datetime icu_ceased_hfnc_icu_datetime icu_cpap_commenced_datetime icu_cpap_ceased_datetime icu_niv_commenced_datetime icu_niv_ceased_datetime icu_inv_commenced_datetime icu_inv_ceased_datetime icu_dc_to_ward_datetime icu_breathed_ra_ward_datetime icu_ceased_hfnc_ward_datetime adv_air_leak_datetime adv_emerg_int_datetime adv_cardiac_arrest_datetime adv_resp_arrest_datetime adv_other_datetime adv_death_datetime revocation_datetime"
foreach v of varlist `dt_vars' {
	tostring `v', replace
	gen __tmp = clock(`v', "DMYhm")
	drop `v' 
	rename __tmp `v' 
	format `v' %tc
}

// Assign labels to variables
label variable first_therapy_responder "5.1 Patient RESPONDED to the FIRST THERAPY given as per randomisation, without any escalation/change of therapy required? *"
label variable first_therapy_breathed_ra_dateti "Date/Time patient breathed in room air (FiO2 21%) *"
label variable first_therapy_breathed_ra_unknow "Unknown"
label variable first_therapy_ceased_hfnc_dateti "Date/Time High Flow ceased *"
label variable first_therapy_ceased_hfnc_unknow "Unknown"
label variable first_therapy_ceased_hfnc_notapp "Not Applicable: No High Flow therapy received"
label variable first_therapy_dc_home_datetime "Date/Time patient discharged home *"
label variable first_therapy_dc_home_unknown "Unknown"
label variable first_therapy_ra_only "Did patient receive room air only the entire admission? (FiO2 21%) *"
label variable dc_dx_primary "Please tick only one *"
label variable dc_dx_primary_specify "If 'Other', please specify *"
label variable dc_dx_sec_none "Nil other diagnoses"
label variable dc_dx_sec_asthma "Asthma"
label variable dc_dx_sec_bronchitis "Bronchitis"
label variable dc_dx_sec_pneumonia "Pneumonia bacterial/viral"
label variable dc_dx_sec_rad "Reactive Airways Disease"
label variable dc_dx_sec_alrti "Acute lower respiratory tract infection"
label variable dc_dx_sec_ardd "Acute respiratory distress disorder"
label variable dc_dx_sec_pneumonitis "Pneumonitis"
label variable dc_dx_sec_bronchiolitis "Bronchiolitis >12 months"
label variable dc_dx_sec_bronchopneu "Bronchopneumonia"
label variable dc_dx_sec_bronchiectasis "Bronchiectasis"
label variable dc_dx_sec_aspiration "Aspiration"
label variable dc_dx_sec_viral_wheeze "Viral induced wheeze"
label variable dc_dx_sec_other "Other..."
label variable dc_dx_sec_specify "If 'Other', please specify *"
label variable mm_90days "At 90 days, is patient still in hospital? *"
label variable mm_death "Did the patient die in hospital? *"
label variable mm_death_datetime "Date/Time of death *"
label variable mm_death_outline "Reason for death (please outline here or adverse events) *"
label variable esc_change "Did the patient change therapy from Control OR High Flow therapy? *"
label variable esc_change_to_therapy "If 'Yes', therapy changed to? *"
label variable esc_change_to_therapy_specify "If 'Other', please specify *"
label variable esc_change_location "Where was the change in therapy administered? *"
label variable esc_change_datetime "Date/Time patient changed therapy *"
label variable esc_change_hr "HR remains >160/min for >2 hours *"
label variable esc_change_rr "RR remains >45/min for >2 hours *"
label variable esc_change_o2 "Oxygen required is >2L/min subnasal oxygen or >8L/min facemask oxygen for Control patients *"
label variable esc_change_ewt "Hospital early warning tool triggers a review and potential escalation of care *"
label variable esc_change_ewt_wob "The WOB assessed is increased requiring escalation of respiratory support *"
label variable esc_change_ewt_dloc "Decreased level of consciousness *"
label variable esc_change_ewt_docfwipp "Deterioration of cardiovascular function with impaired peripheral perfusion *"
label variable esc_change_ewt_cjamo "Clinical judgement of attending (senior) medical officer triggers escalation of treatment *"
label variable esc_change_ewt_other "Other... *"
label variable esc_change_ewt_specify "If 'Other', please specify *"
label variable esc_icu "Did the patient escalate to ICU? *"
label variable esc_icu_from_therapy "Which therapy did the patient escalate to ICU from? *"
label variable esc_icu_transfer_datetime "Date/Time transfer to ICU *"
label variable esc_icu_hr "HR remains >160/min for >2 hours *"
label variable esc_icu_rr "RR remains >45/min for >2 hours *"
label variable esc_icu_o2 "Oxygen required is FiO2 >40% (NHF pts) or >2L/min (nasal cannula)/>8L/min (HM) - Control pts *"
label variable esc_icu_ewt "Hospital early warning tool triggers a review and potential escalation of care *"
label variable esc_icu_ewt_wob "The WOB assessed is increased requiring escalation of respiratory support *"
label variable esc_icu_ewt_dloc "Decreased level of consciousness *"
label variable esc_icu_ewt_docfwipp "Deterioration of cardiovascular function with impaired peripheral perfusion *"
label variable esc_icu_ewt_cjamo "Clinical judgement of attending (senior) medical officer triggers escalation of treatment *"
label variable esc_icu_ewt_other "Other... *"
label variable esc_icu_ewt_specify "If 'Other', please specify *"
label variable cot_received "Did the patient receive a change in therapy from their previous therapy applied? *"
label variable cot_therapy "If 'Yes', therapy changed to? *"
label variable cot_therapy_specify "If 'Other', please specify *"
label variable cot_higher_care "Did the patient change their level of care (increased nurse/patient ratio on the ward 1:1), or HDU/ICU admission, or transfer to another hospital, or PICU to Ward? *"
label variable cot_location "Where was the patient cared for post the change in therapy or level of care? *"
label variable cot_loc_other_specify "If 'Transferred hospital', please specify *"
label variable cot_datetime "Date/Time patient changed therapy or level of care *"
label variable cot_pre_datetime "Date/Time of pre-change of therapy or pre-change in level of care parameters *"
label variable cot_hr "HR *"
label variable cot_rr "RR *"
label variable cot_spo2 "SpO2 *"
label variable cot_wob "WOB *"
label variable cot_pre_therapy "Pre-change treatment *:"
label variable cot_o2_mode "Pre-change, Oxygen Mode (Control patients) *"
label variable cot_o2_mode_specify "If 'Other', please specify *"
label variable cot_o2_lpm "Pre-change, Oxygen required (Control patients) *"
label variable cot_hf_lpm "Pre-change, L/min (NHF) *"
label variable cot_hf_fio2 "Pre-change, % FiO2 (NHF) *"
label variable cot_pre_therapy_other "Pre-change, if 'Other', please specify *"
label variable cot_temp "Temp. *"
label variable cot_ewtscore "EWT Score (if applicable) *"
label variable cot_ewt_review "Hospital early warning tool triggers a review *"
label variable cot_oct_wob "The work of breathing assessed as increased requiring escalation of respiratory support? *"
label variable cot_oct_dloc "Decreased level of consciousness? *"
label variable cot_oct_docfwipp "Deterioration of cardiovascular function with impaired peripheral perfusion? *"
label variable cot_oct_staffing "Inadequate staffing? *"
label variable cot_oct_cjamo "Clinical judgement of attending (senior) medical officer making the decision to trigger change in therapy/transfer? *"
label variable cot_oct_icu_review "ICU review involved and making decision? *"
label variable cot_oct_other "Other... *"
label variable cot_oct_specify "If 'Other', please specify *"
label variable esc_transfer "Was the patient transferred to another hospital? *"
label variable esc_transfer_hosp "Which hospital was the child transferred to *"
label variable esc_transfer_hosp_specify "If 'Other', please specify *"
label variable esc_transfer_hosp_location "Where was the child admitted at the receiving hospital? *"
label variable icu_data "Enter PICU Admission and Outcome Data? *"
label variable icu_cont_ctrl "6.1 Did the patient continue on Control only in ICU? *"
label variable icu_cont_ctrl_flow "6.2 If 'Yes', Maximum L/min in ICU? *"
label variable icu_cont_ctrl_mode "If 'Yes', Mode *"
label variable icu_cont_ctrl_mode_specify "If 'Other', please specify *"
label variable icu_esc_hfnc "6.3 Did the patient escalate to High Flow therapy in ICU? *"
label variable icu_esc_hfnc_datetime "Date/Time escalated to High Flow therapy in ICU *"
label variable icu_cont_hfnc "6.4 Did the patient continue on High Flow therapy in ICU? *"
label variable icu_cont_hfnc_flow "If 'Yes', Maximum L/min in ICU? *"
label variable icu_cont_hfnc_fio2 "If 'Yes', Maximum FiO2 *"
label variable icu_weaned_hfnc_icu "6.5 Did the patient wean from High Flow to standard oxygen therapy (nasal cannula/HM) in ICU? *"
label variable icu_ceased_hfnc_icu "6.6 Did the patient cease High Flow in ICU? *"
label variable icu_breathed_ra_icu_datetime "Date/Time breathed in room air in ICU *"
label variable icu_ceased_hfnc_icu_datetime "Date/Time cease High Flow in ICU *"
label variable icu_cpap "6.8 Did the patient receive Bubble/Mask CPAP *"
label variable icu_cpap_commenced_datetime "Date/Time commenced Bubble/Mask CPAP *"
label variable icu_cpap_ceased_datetime "Date/Time ceased Bubble/Mask CPAP *"
label variable icu_niv "6.9 Did the patient receive non-invasive ventilation? *"
label variable icu_niv_commenced_datetime "Date/Time commenced NIV *"
label variable icu_niv_ceased_datetime "Date/Time ceased NIV *"
label variable icu_inv "6.10 Was the patient mechanically intubated and ventilated? *"
label variable icu_inv_commenced_datetime "Date/Time commenced intubation/ventilation *"
label variable icu_inv_ceased_datetime "Date/Time ceased intubation/ventilation *"
label variable icu_dc_to_ward_datetime "Date/Time patient discharged to ward from ICU *"
label variable icu_ceased_hfnc_ward "6.11 Did the patient cease High Flow on the ward (post discharge from ICU) *"
label variable icu_breathed_ra_ward_datetime "Date/Time breathed in room air on the ward *"
label variable icu_ceased_hfnc_ward_datetime "Date/Time High Flow ceased on the ward *"
label variable adv_air_leak "Air leak syndrone, which includes pneumothorax"
label variable adv_air_leak_datetime "Date/Time this occurred *"
label variable adv_emerg_int "Emergency and unexplained intubation"
label variable adv_emerg_int_datetime "Date/Time this occurred *"
label variable adv_cardiac_arrest "Cardiac arrest"
label variable adv_cardiac_arrest_datetime "Date/Time this occurred *"
label variable adv_resp_arrest "Unexplained Respiratory arrest requiring mechanical ventilation"
label variable adv_resp_arrest_datetime "Date/Time this occurred *"
label variable adv_other "Other..."
label variable adv_other_specify "If 'Other', please specify *"
label variable adv_other_datetime "Date/Time this occurred *"
label variable adv_death "Death"
label variable adv_death_datetime "Date/Time of death *"
label variable adv_death_outline "Reason for death (outline below) *"
label variable adv_event_outline "Outline your comments for Adverse Event:"
label variable revocation_status "8.1 Has consent been withdrawn (revoked)? *"
label variable revocation_datetime "If 'Yes', date/time withdrawn *"
label variable revocation_party "8.2 Patient withdrawn by *"
label variable data_collection_status "8.3 Has consent been given to continue to obtain the data if patient withdrawn from the study? *"
label variable study_withdrawal_reason "8.4 Reason for withdrawal from trial *"
label variable study_withdrawal_outline "If 'Other', please outline specifics *"

// Duplicates
duplicates report subjid

// Reshape the repeating data
save "Output\crf04.dta", replace
keep subjid row cot_received-cot_oct_specify cot_location cot_o2_mode cot_datetime cot_pre_datetime
reshape wide cot_received-cot_oct_specify cot_location cot_o2_mode cot_datetime cot_pre_datetime, i(subjid) j(row)
save "Output\crf04_ch_ther.dta", replace
use "Output\crf04.dta", clear
drop cot_received-cot_oct_specify cot_location cot_o2_mode cot_datetime cot_pre_datetime
keep if row==1
merge 1:1 subjid using "Output\crf04_ch_ther.dta"
drop _merge

// Save the dataset
save "Output\crf04.dta", replace

/*** CRF-05 ***/

clear
import delimited "paris-crf05_clean.csv"

// Define name of dataset
label data "crf05"

// Drop the pilot data
drop if study_hospital=="LCCH" | study_hospital=="RCH" | strpos(subjid,"0045")==1 | strpos(subjid,"0058")==1

// Sort the data
sort subjid row

// Drop the variables that will be imported from CRF 01
keep subjid crf09_cat-crf9_ptart_02_07_notappl

// Define labels for categorical variables
* Yes/no variables
local yes_no_var "crf9_pia_03_01 crf9_pia_03_02 crf9_pia_03_03 crf9_pia_03_04 crf9_pia_03_05 crf9_pia_03_07_notappl crf9_ptart_02_01 crf9_ptart_02_02 crf9_ptart_02_03 crf9_ptart_02_04 crf9_ptart_02_05"
label define yes_no 1 "Yes" 0 "No" 2 "Unknown" 3 "Not in hospital"
* Study arms
foreach v of varlist `yes_no_var' {
	replace `v'="1" if `v'=="Yes"
	replace `v'="0" if `v'=="No"
	replace `v'="2" if `v'=="Unknown"
	replace `v'="3" if `v'=="Not in hospital"
	destring `v', replace force
	label values `v' yes_no
	tab `v', m
}
local yes_no_all "crf9_pia_03_06_01 crf9_pia_03_06_02 crf9_pia_03_06_03 crf9_pia_03_06_notappl crf9_pia_03_07_notappl crf9_ptart_02_06_01 crf9_ptart_02_06_02 crf9_ptart_02_06_03 crf9_ptart_02_06_notappl crf9_ptart_02_07_notappl"
foreach v of varlist `yes_no_all' {
	label values `v' yes_no
}

// Apply labels to their for categorical variables
* Encode list
local encode_list "crf9_pia_01 crf9_pia_02 crf9_ptart_01"
foreach v of varlist `encode_list' {
	rename `v' `v'_o
	encode `v'_o, gen(`v')
	drop `v'_o
}

// Transform dates and times
local dt_vars "crf9_pia_dt crf9_ptart_act_dt crf9_ptart_adm_dt"
foreach v of varlist `dt_vars' {
	tostring `v', replace
	gen __tmp = clock(`v', "DMYhm")
	drop `v' 
	rename __tmp `v' 
	format `v' %tc
}

// Assign labels to variables
label variable crf09_cat "Category *"
label variable crf9_pia_dt "Date/Time of Admission to ICU *"
label variable crf9_pia_01 "Randomised in *"
label variable crf9_pia_02 "Direct from *"
label variable crf9_pia_02_01 "If 'Tertiary ED to ICU', was the patient in ED *"
label variable crf9_pia_03_01 "Heart rate remains >160/min for longer than two hours prior to admission to intensive care/high dependency care *"
label variable crf9_pia_03_02 "Was burst therapy administered during this time? *"
label variable crf9_pia_03_02_01 "If 'Yes', was burst therapy administered *"
label variable crf9_pia_03_03 "Respiratory rate remains >45/min for longer than two hours prior to admission to intensive care/high dependency care *"
label variable crf9_pia_03_04 "Oxygen requirement in NHF therapy arm exceeds FiO2 > 40/50%, or oxygen requirement in control oxygen arm exceeds standard oxygen therapy (2L/min by nasal prong, or 8L/min by face mask), prior to admission to intensive care/high dependency care *"
label variable crf9_pia_03_05 "The hospital internal Early Warning Tool (EWT) calls for medical review prior to escalation *"
label variable crf9_pia_03_06_01 "Weight specific flow rate"
label variable crf9_pia_03_06_02 "Below weight specific flow rate"
label variable crf9_pia_03_06_03 "Above weight specific flow rate"
label variable crf9_pia_03_06_notappl "Not Applicable"
label variable crf9_pia_03_07 "Highest FiO2 prior to ICU admission *"
label variable crf9_pia_03_07_notappl "Not Applicable"
label variable crf9_ptart_notappl "Tick if Not Applicable for this Patient"
label variable crf9_ptart_act_dt "Date/Time of Retrieval Call (Activation Time) *"
label variable crf9_ptart_adm_dt "Date/Time Admitted *"
label variable crf9_ptart_01 "Admitted *"
label variable crf9_ptart_02_01 "Heart rate remains >160/min for longer than two hours prior to request for transfer *"
label variable crf9_ptart_02_02 "Was burst therapy administered during this time? *"
label variable crf9_ptart_02_02_01 "If 'Yes', was burst therapy administered *"
label variable crf9_ptart_02_03 "Respiratory rate remains >45/min for longer than two hours prior to request for transfer *"
label variable crf9_ptart_02_04 "Oxygen requirement in NHF therapy arm exceeds FiO2 > 40/50%, or oxygen requirement in control oxygen arm exceeds standard oxygen therapy (2L/min by nasal prong, or 8L/min by face mask), prior to request for transfer *"
label variable crf9_ptart_02_05 "The hospital internal Early Warning Tool (EWT) calls for medical review prior to request for transfer *"
label variable crf9_ptart_02_06_01 "Weight specific flow rate"
label variable crf9_ptart_02_06_02 "Below weight specific flow rate"
label variable crf9_ptart_02_06_03 "Above weight specific flow rate"
label variable crf9_ptart_02_06_notappl "Not Applicable"
label variable crf9_ptart_02_07 "Highest FiO2 prior to request for transfer *"
label variable crf9_ptart_02_07_notappl "Not Applicable"

// Duplicates
duplicates report subjid

// Save the dataset
save "Output\crf05.dta", replace

/*** Merge the datasets ***/
use "Output\crf01.dta", clear
// CRF 02
merge 1:1 subjid using "Output\crf02.dta"
drop _merge
// CRF 03
merge 1:1 subjid using "Output\crf03.dta"
drop _merge
// CRF 04
merge 1:1 subjid using "Output\crf04.dta"
drop _merge
// CRF 05
merge 1:1 subjid using "Output\crf05.dta"
drop _merge
save "PARIS2.dta", replace

/*** Import the Griffith randomisation tool data ***/

/* Starship */
clear
import delimited "Griffith Randomisation Reports\170062.PARIS-2   Starship Children's Hospital.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 56
save "Output\Rand_Starship.dta", replace
clear

/* GCUH */
import delimited "Griffith Randomisation Reports\170063.PARIS-2   GCUH.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 48
save "Output\Rand_GCUH.dta", replace
clear

/* LCCH */
import delimited "Griffith Randomisation Reports\170073.PARIS 2 LCCH.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 111
save "Output\Rand_LCCH.dta", replace
clear

/* RCH */
import delimited "Griffith Randomisation Reports\170074.PARIS 2 RCH.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 112
tostring hospitalidentificationnumber, replace
save "Output\Rand_RCH.dta", replace
clear

/* SEQ Regional */
import delimited "Griffith Randomisation Reports\180076.PARIS-2 SEQ Regional Centre .final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 50 if sitestrata=="Caboolture Hospital"
replace siteid = 47 if sitestrata=="Ipswich Hospital"
replace siteid = 51 if sitestrata=="Redcliffe Hospital"
replace siteid = 54 if sitestrata=="The Prince Charles Hospital"
save "Output\Rand_SEQ Regional.dta", replace
clear

/* JHCH */
import delimited "Griffith Randomisation Reports\180078.PARIS-2 John Hunter Children's Hospital.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 116
save "Output\Rand_JHCH.dta", replace
clear

/* Monash */
import delimited "Griffith Randomisation Reports\180079.PARIS-2 Monash Health Services.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
tostring hospitalidentificationnumber, replace
gen siteid = 57
save "Output\Rand_Monash.dta", replace
clear

/* Perth */
import delimited "Griffith Randomisation Reports\180080.PARIS-2 Perth Children's Hospital.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 115
save "Output\Rand_Perth.dta", replace
clear

/* Townsville */
import delimited "Griffith Randomisation Reports\180083.PARIS-2 Townsville Hospital.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
tostring hospitalidentificationnumber, replace
gen siteid = 53
save "Output\Rand_Townsville.dta", replace
clear

/* Waikato */
import delimited "Griffith Randomisation Reports\180084.PARIS-2 Waikato Hospital.final-report.csv", encoding(ISO-8859-2) 
gen __tmp = date(randomisedon, "DMY")
drop randomisedon 
rename __tmp randomisedon
format randomisedon %td
gen siteid = 122
save "Output\Rand_Waikato.dta", replace
clear

/* Merge the files */
use "Output\Rand_Starship"
append using "Output\Rand_GCUH"
append using "Output\Rand_LCCH"
append using "Output\Rand_RCH"
append using "Output\Rand_SEQ Regional"
append using "Output\Rand_JHCH"
append using "Output\Rand_Monash"
append using "Output\Rand_Perth"
append using "Output\Rand_Townsville"
append using "Output\Rand_Waikato"
rename study study_id
sort siteid study_id
tab studygroup, m
replace studygroup="1" if studygroup=="Control"
replace studygroup="2" if studygroup=="High Flow"
destring studygroup, replace force
label define study_arm 1 "Control" 2 "High Flow"
label values studygroup study_arm
save "Output\PARIS 2 Griffith Rand", replace

/*** Prepare the variables ***/
use PARIS2, clear

// Determine prospective or consent-to-continue
gen consent_type_eligible=1 if study_hospital_o=="KIDZ" | study_hospital_o=="PERTH" | study_hospital_o=="JHCH" | study_hospital_o=="STAR" | study_hospital_o=="WAIK"
replace consent_type_eligible=2 if consent_type_eligible==.
gen consent_type=1 if (study_hospital_o=="KIDZ" | study_hospital_o=="PERTH" | study_hospital_o=="JHCH" | study_hospital_o=="STAR" | study_hospital_o=="WAIK") & randomisation_datetime~=.
replace consent_type=1 if consent_type==. & (consent_datetime<dofc(randomisation_datetime)) & consent_datetime~=. & randomisation_datetime~=.
replace consent_type=2 if consent_type==. & (consent_datetime>dofc(randomisation_datetime)) & consent_datetime~=. & randomisation_datetime~=.
label define consent_type 1 "Prospective" 2 "Consent-to-continue"
label values consent_type consent_type
label values consent_type_eligible consent_type
tab consent_type, m
tab consent_type_eligible, m

// Age
gen dem_age=(dofc(adm_datetime)-dob)/365

// Age - rounded to year
gen dem_age_yr=floor(dem_age)

// Ethnicity
gen dem_ethn_cat_nz=1 if dem_ethnicity_maori==1
replace dem_ethn_cat_nz=2 if (dem_ethnicity_islander==1 | dem_ethnicity_samoan==1 | dem_ethnicity_tongan==1 | dem_ethnicity_niuean==1) & dem_ethn_cat_nz==.
replace dem_ethn_cat_nz=3 if dem_ethnicity_indigenous==1 & dem_ethn_cat_nz==.
replace dem_ethn_cat_nz=4 if dem_ethnicity_asian==1 & dem_ethn_cat_nz==.
replace dem_ethn_cat_nz=5 if (dem_ethnicity_indian==1 | dem_ethnicity_other==1) & dem_ethn_cat_nz==.
replace dem_ethn_cat_nz=6 if dem_ethnicity_caucasian==1 & dem_ethn_cat_nz==.
replace dem_ethn_cat_nz=7 if dem_ethnicity_unknown==1 & dem_ethn_cat_nz==.
gen dem_ethn_cat_aus=1 if dem_ethnicity_indigenous==1
replace dem_ethn_cat_aus=2 if dem_ethnicity_maori==1 & dem_ethn_cat_aus==.
replace dem_ethn_cat_aus=3 if (dem_ethnicity_islander==1 | dem_ethnicity_samoan==1 | dem_ethnicity_tongan==1 | dem_ethnicity_niuean==1) & dem_ethn_cat_aus==.
replace dem_ethn_cat_aus=4 if dem_ethnicity_asian==1 & dem_ethn_cat_aus==.
replace dem_ethn_cat_aus=5 if (dem_ethnicity_other==1 | dem_ethnicity_indian==1 | dem_ethnicity_arabic==1) & dem_ethn_cat_aus==.
replace dem_ethn_cat_aus=6 if dem_ethnicity_caucasian==1 & dem_ethn_cat_aus==.
replace dem_ethn_cat_aus=7 if dem_ethnicity_unknown==1 & dem_ethn_cat_aus==.

gen dem_ethn_cat=1 if dem_ethn_cat_nz==6 | dem_ethn_cat_aus==6
replace dem_ethn_cat=2 if (dem_ethn_cat_nz==3 | dem_ethn_cat_aus==1) & dem_ethn_cat==.
replace dem_ethn_cat=3 if (dem_ethn_cat_nz==4 | dem_ethn_cat_aus==4) & dem_ethn_cat==.
replace dem_ethn_cat=4 if (dem_ethn_cat_nz==1 | dem_ethn_cat_aus==2) & dem_ethn_cat==.
replace dem_ethn_cat=5 if (dem_ethn_cat_nz==3 | dem_ethn_cat_aus==1) & dem_ethn_cat==.
replace dem_ethn_cat=6 if (dem_ethn_cat_nz==5 | dem_ethn_cat_aus==5) & dem_ethn_cat==.
replace dem_ethn_cat=7 if (dem_ethn_cat_nz==7 | dem_ethn_cat_aus==7) & dem_ethn_cat==.
label define dem_ethn_cat 1 "Caucasian" 2 "ATSI" 3 "Asian" 4 "Maori" 5 "Pacific Islander" 6 "Other" 7 "Unknown"
label values dem_ethn_cat dem_ethn_cat

// Nasopharyngeal aspirate: multiple viruses
egen npa_multiple_count=rowtotal(npa_adenovirus npa_influenza npa_parainfluenza npa_rhinovirus npa_mycoplasma npa_enterovirus npa_human_metapneu npa_rsv npa_picorna npa_other)
gen npa_multiple=1 if npa_multiple_count>=1 & npa_multiple_count~=.
replace npa_multiple=0 if npa_multiple==. & npa_taken==1
label values npa_multiple yes_no

// Calculte time from onset of illness to presentation in days
replace hrf_onset_weeks=0 if hrf_onset_weeks==. & hrf_onset_unknown~=1
replace hrf_onset_days=0 if hrf_onset_days==. & hrf_onset_unknown~=1
replace hrf_onset_hours=0 if hrf_onset_hours==. & hrf_onset_unknown~=1
gen onset_of_illness_days = (hrf_onset_weeks*7*24 + hrf_onset_days*7 + hrf_onset_hours)/24
replace onset_of_illness_days = . if hrf_onset_unknown==1 | (hrf_onset_weeks==. & hrf_onset_days==. & hrf_onset_hours==.)

// Calculte time from presentation to randomisation in hours
gen present_to_randomise_hr=hours(randomisation_datetime-adm_datetime)/24

// Generate variable capturing country of hospital
gen hosp_country=1 if study_hospital_o=="CAB" | study_hospital_o=="GCUH" | study_hospital_o=="IP" | study_hospital_o=="JHCH" | study_hospital_o=="LCCH-RCT" | ///
					  study_hospital_o=="MON" | study_hospital_o=="PERTH" | study_hospital_o=="RCH" | study_hospital_o=="RCH-RCT" | study_hospital_o=="REDC" | ///
					  study_hospital_o=="TOWN" | study_hospital_o=="TPCH"
replace hosp_country=2 if study_hospital_o=="KIDZ" | study_hospital_o=="STAR" | study_hospital_o=="WAIK"
label define hosp_country 1 "Australia" 2 "New Zealand"
label values hosp_country hosp_country

// Calculate length of hospital stay
gen los_hosp=hours(first_therapy_dc_home_datetime-randomisation_datetime)/24

// Calculate total length of hospital stay
gen los_hosp_total=hours(first_therapy_dc_home_datetime-adm_datetime)/24

// Calculate length of oxygen therapy
gen los_o2_calc_var=first_therapy_breathed_ra_dateti if randomisation_arm==1
replace los_o2_calc_var=first_therapy_breathed_ra_dateti if randomisation_arm==2 & first_therapy_breathed_ra_dateti>=first_therapy_ceased_hfnc_dateti & first_therapy_breathed_ra_dateti~=. & first_therapy_ceased_hfnc_dateti~=.
replace los_o2_calc_var=first_therapy_ceased_hfnc_dateti if randomisation_arm==2 & first_therapy_ceased_hfnc_dateti>=first_therapy_breathed_ra_dateti & first_therapy_breathed_ra_dateti~=. & first_therapy_ceased_hfnc_dateti~=.
gen los_o2=hours(los_o2_calc_var-randomisation_datetime)/24

// Determine if change of therapy received in general ward
gen cot_received_any=0
foreach v of varlist cot_received* {
	replace cot_received_any=1 if `v'==1
}

// Determine if ICU/HDU admission occurred
gen cot_icu=0
foreach v of varlist cot_location* {
	replace cot_icu=1 if `v'==2
}

// Determine if child was transferred to another hospital
gen cot_transfer_hosp=0
foreach v of varlist cot_location* {
	replace cot_transfer_hosp=1 if `v'==3
}
* Only include if they originated from a non-tertiary hospital
replace cot_transfer_hosp=. if study_hospital_o~="CAB" & study_hospital_o~="IP" & study_hospital_o~="REDC" & study_hospital_o~="TPCH"

// Determine if the child received escalation of therapy
// Defined as admission to ICU/HDU or ventilation in ICU
gen esc_therapy=0
replace esc_therapy=1 if cot_icu==1
replace esc_therapy=1 if icu_cpap==1 | icu_niv==1 | icu_inv==1

// Create variables for sensitivity analyses
* Analysis 1: ICU admission + 3/4 clinical criteria
gen sens_icu=0 if crf09_cat=="TT ESC TRANSFER" | crf09_cat=="RT ESC TRANSFER" | crf09_cat=="ESC ONLY"
egen sens_icu_count=anycount(crf9_pia_03_01 crf9_pia_03_03 crf9_pia_03_04 crf9_pia_03_05), values(1)
replace sens_icu=1 if sens_icu_count==3 | sens_icu_count==4
* Analysis 2: transfer
gen sens_transfer=0 if crf09_cat=="TT ESC TRANSFER" | crf09_cat=="RT ESC TRANSFER" | crf09_cat=="TRANSFER ONLY"
egen sens_transfer_count=anycount(crf9_ptart_02_01 crf9_ptart_02_03 crf9_ptart_02_04 crf9_ptart_02_05), values(1)
replace sens_transfer=1 if sens_transfer_count==3 | sens_transfer_count==4

// Protocol deviation: change of therapy
gen pd_cot=1 if randomisation_arm~=commencement_arm
replace pd_cot=2 if (randomisation_arm==1 & commencement_arm==2) | (randomisation_arm==2 & commencement_arm==1)
replace pd_cot=3 if commencement_arm==3
replace pd_cot=4 if commencement_arm==4
label define pd_cot 1 "No PD" 2 "Other treatment" 3 "Neither treatment" 4 "No treatment"
label values pd_cot pd_cot

save "PARIS2.dta", replace