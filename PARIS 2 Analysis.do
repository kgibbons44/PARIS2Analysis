/**** PARIS 2 ANALYSIS ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 26/10/2020 ****/
/**** Purpose: Executable file to run all PARIS II related anlalyses ****/

log using "201029_PARIS 2 Analysis.txt", text replace

/* Import the data and prepare variables for analysis */
do "PARIS 2 Data Transformation.do"

/* Generate figures for CONSORT diagram */
do "PARIS 2 CONSORT.do"

/* Run the analysis - ITT */
local `analysis_group' randomisation_arm
do "PARIS 2 SAP Analysis.do"

/* Run the analysis - per-protocol */
clear
local `analysis_group' commencement_arm
do "PARIS 2 Data Transformation.do"
do "PARIS 2 SAP Analysis.do"

log close
