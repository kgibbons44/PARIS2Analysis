/**** PARIS 2 DATA ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 06/07/2020 ****/
/**** Purpose: Analysis of PARIS II data as per SAP ****/

/*** CONSORT Diagram ***/

// Remove deleted patients
drop if subjstat=="deleted"

// Number of patients screened for eligibility
count if adm_datetime~=.

// Inclusion criteria
gen inc_cri_not_met=0
foreach v of varlist inc_age inc_ahrf inc_adm_required inc_o2_required inc_tachypnoea {
	tab `v', m
	tab `v'
	replace inc_cri_not_met=1 if `v'==0
}
tab inc_cri_not_met, m

// Exclusion criteria
gen exc_cri_met=0
foreach v of varlist exc_ed_o2 exc_prev_hf exc_upper_airway exc_apnoeas exc_craniofacial exc_fractured exc_trauma exc_dloc exc_chd exc_home_o2 exc_trachy exc_cf exc_oncology exc_palliative exc_critically_ill exc_cpu {
	tab `v', m
	tab `v'
	replace exc_cri_met=1 if `v'==1
}
tab exc_cri_met, m
gen exc_other=1 if exc_apnoeas==1 | exc_craniofacial==1 | exc_fractured==1 | exc_trauma==1 | exc_dloc==1 | exc_chd==1 | exc_home_o2==1 | exc_trachy==1 | exc_cf==1 | exc_oncology==1 | exc_palliative==1 | exc_cpu==1
tab exc_other

// Inclusion criteria met and no exclusion criteria
tab inc_cri_not_met exc_cri_met, m

// Number who were consented
tab consent_status, m

// Non-consent reasons
// Not approached = clinical decision + missed + not available
tab non_consent_reason, m

// Eligible for consent-to-continue
tab consent_type_eligible

// Number who were randomised
tab randomisation_status, m

// Randomisation group
tab consent_status randomisation_arm, m

// Withdrawal
tab revocation_status randomisation_arm, m
tab data_collection_status randomisation_arm, m
tab revocation_party, m
tab study_withdrawal_reason, m

drop if revocation_status==1 & data_collection_status==0

// Crossed over
tab cot_received1 randomisation_arm if ( cot_location1==4 | cot_location1==1 | (cot_location1==3 & tf_mater==1) )
tab cot_therapy_withfly1 randomisation_arm if cot_received1==1 & ( cot_location1==4 | cot_location1==1 | (cot_location1==3 & tf_mater==1) )
tab cot_therapy_specify1 if cot_received1==1 & ( cot_location1==4 | cot_location1==1 | (cot_location1==3 & tf_mater==1) ) & randomisation_arm==1 // SOT
tab cot_therapy_specify1 if cot_received1==1 & ( cot_location1==4 | cot_location1==1 | (cot_location1==3 & tf_mater==1) ) & randomisation_arm==2 // NHF

// ICU
tab cot_icu if cot_therapy1==2 & randomisation_arm==1, m
tab cot_icu if cot_received1~=1 & randomisation_arm==2, m
