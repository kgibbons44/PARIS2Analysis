The PARIS 2 study dataset is contained within two data sources; the first containing records on all screened (data fields include date of screening, inclusion criteria, exclusion criteria, eligibility status, informed consent process, withdrawal of consent) and enrolled (randomisation group, demographics, clinical history, interventions, escalation of therapy, PICU outcomes, tolerance scores) patients, and the second a set of comma-separated value (CSV) files from the online tool used for randomisation. 

The primary PARIS 2 study dataset will be exported from WebSpirit using the in-built functionality as a series of five datasets, each in CSV format (.csv).  Associated Stata do-files (.do) are exported that assist with labelling the variables.  This do-file is not provided in this repository as they were not constructed by the author, however components of it are used in the "PARIS 2 Data Transformation.do" file.

The randomisation data is exported from the Griffith Online Randomisation Tool.  There is one CSV file per study site.  These are imported and transformed using the "PARIS 2 Data Transformation.do" file.

The code is broken into the three sections:

Part A: Import and transformation of datasets (“PARIS 2 Data Transformation.do”)

Part B: Analysis of screening dataset (“PARIS 2 CONSORT.do”)

Part C: Analysis of primary dataset (“PARIS 2 SAP Analysis.do”)

We have chosen to include all code, including code for assessing completeness, distribution and range, as well as the code to undertake the analyses.

The do files should be executed in the order contained in "PARIS 2 Analysis.do".
