clear all
capture log close
cd "/Users/harryspooner/Downloads/"
use "WV6_Data_Stata_v20180912 2.dta"

/// drop unneccessary variables

keep V2 V242 V240 V248 V141 V28 V29 V85 V86 V87 V88 V89

/// define variable label sets

label define comp_v_nocomp 1 "Compulsory" 0 "Not compulsory", add
label define sanct_v_nosanct 1 "Enforced" 0 "Not enforced", add
label define latinam_dummy 1 "LA" 0 "Not LA", add

/// COMPULSORY VOTING VARIABLES

/// add in compulsory voting dummy variable V3 distinguishes between compulsory voting = 1 and voluntary voting = 0

gen V3=0

replace V3 = 1 if V2 == 56 
replace V3 = 1 if V2 == 792 
replace V3 = 1 if V2 == 442 
replace V3 = 1 if V2 == 756 
replace V3 = 1 if V2 == 68
replace V3 = 1 if V2 == 218 
replace V3 = 1 if V2 == 604 
replace V3 = 1 if V2 == 858 
replace V3 = 1 if V2 == 36 
replace V3 = 1 if V2 == 702 
replace V3 = 1 if V2 == 764 
replace V3 = 1 if V2 == 818
replace V3 = 1 if V2 == 300 
replace V3 = 1 if V2 == 32 
replace V3 = 1 if V2 == 76 
replace V3 = 1 if V2 == 188 
replace V3 = 1 if V2 == 222 
replace V3 = 1 if V2 == 320 
replace V3 = 1 if V2 == 340 
replace V3 = 1 if V2 == 484
replace V3 = 1 if V2 == 591 
replace V3 = 1 if V2 == 600 
replace V3 = 1 if V2 == 862 
replace V3 = 1 if V2 == 418 

rename V3 compvote_dummy
label variable compvote_dummy "Compulsory Voting"
label values compvote_dummy comp_v_nocomp


/// add in compulsory voting dummy variable V4 distinguishes between sanctioned compulsory voting = 1 and unsanctioned compuslory and voluntary voting = 0

gen V4=0

replace V4 = 1 if V2 == 56 
replace V4 = 1 if V2 == 792 
replace V4 = 1 if V2 == 442 
replace V4 = 1 if V2 == 756 
replace V4 = 1 if V2 == 68
replace V4 = 1 if V2 == 218 
replace V4 = 1 if V2 == 604 
replace V4 = 1 if V2 == 858 
replace V4 = 1 if V2 == 36 
replace V4 = 1 if V2 == 702 
replace V4 = 1 if V2 == 764 
replace V4 = 1 if V2 == 818

rename V4 sanctcompvote_dummy
label variable sanctcompvote_dummy "Sanctioned Compulsory Voting"
label values sanctcompvote_dummy sanct_v_nosanct

/// add in Latin American dummy variable

gen V5=0

replace V5 = 1 if V2 == 84
replace V5 = 1 if V2 == 188
replace V5 = 1 if V2 == 222
replace V5 = 1 if V2 == 320
replace V5 = 1 if V2 == 340
replace V5 = 1 if V2 == 484
replace V5 = 1 if V2 == 558
replace V5 = 1 if V2 == 591
replace V5 = 1 if V2 == 31
replace V5 = 1 if V2 == 68
replace V5 = 1 if V2 == 76
replace V5 = 1 if V2 == 152
replace V5 = 1 if V2 == 170
replace V5 = 1 if V2 == 218
replace V5 = 1 if V2 == 328
replace V5 = 1 if V2 == 600
replace V5 = 1 if V2 == 604
replace V5 = 1 if V2 == 740
replace V5 = 1 if V2 == 858
replace V5 = 1 if V2 == 862

rename V5 latinamerica_dummy
label variable latinamerica_dummy "Latin America"
label values latinamerica_dummy latinam_dummy

/// add in age of democracy variable

gen V6=0
rename V6 democracy_age
label variable democracy_age "Age of democracy"

/// add in electoral participation variable


/// add in electoral system variable


/// rename WVS variables

rename V2 country
rename V28 laborunion_mem
rename V29 polparty_mem
rename V85 petition_part
rename V86 boycott_part
rename V87 demo_part
rename V88 strike_part
rename V89 otherprotest_part
rename V141 democraticgov_op
rename V240 sex
rename V242 age
rename V248 highestedulevel

/// merge external data

merge m:1 country using "/Users/harryspooner/Downloads/dissexternalinfo.dta" 

/// manipulate data for logistic regression

replace laborunion_mem = . if laborunion_mem < 0
replace laborunion_mem = 1 if laborunion_mem >1
replace polparty_mem = . if polparty_mem < 0
replace polparty_mem = 1 if polparty_mem >1
replace boycott_part = . if boycott_part < 1
replace boycott_part = 0 if boycott_part > 1
replace petition_part = . if petition_part < 1
replace petition_part = 0 if petition_part > 1
replace demo_part = . if demo_part < 1
replace demo_part = 0 if demo_part > 1
replace strike_part = . if strike_part < 1
replace strike_part = 0 if strike_part > 1
replace otherprotest_part = . if otherprotest_part < 1
replace otherprotest_part = 0 if otherprotest_part > 1
replace sex = 0 if sex == 1
replace sex = 1 if sex == 2

gen ageindex = age / 100
replace ageindex = . if ageindex < 0

gen educationindex = highestedulevel / 10
replace educationindex = . if education index < 0

/// relabel

label variable highestedulevel "Education level"
label variable freedomhouse "Democratic freedom"
label variable turnout "Turnout"
label variable electoralsystemcoded "Electoral system"
label variable gdppercapitalog "GDP per capita (log)"
label variable populationlog "Population (log)"
label variable corruption "Corruption perceptions"

/// rename, amend and label variables 

logit polparty_mem ageindex sex educationindex compvote_dummy corruption electoralsystemcoded freedomhouse latinamerica_dummy
outreg2 using "regression_results", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
	title ("Compulsory voting and political party membership") ///
	ctitle ("Model 1") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///

logit polparty_mem ageindex sex educationindex sanctcompvote_dummy corruption electoralsystemcoded freedomhouse latinamerica_dummy
outreg2 using "regression_results", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	title ("Compulsory voting and political party membership") ///
	ctitle ("Model 2") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit laborunion_mem ageindex sex educationindex compvote_dummy corruption electoralsystemcoded freedomhouse latinamerica_dummy
outreg2 using "regression_results2", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
	title ("Compulsory voting and labor union membership") ///
	ctitle ("Model 1") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///

logit laborunion_mem ageindex sex educationindex sanctcompvote_dummy corruption electoralsystemcoded freedomhouse latinamerica_dummy
outreg2 using "regression_results2", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	title ("Compulsory voting and labor union membership") ///
	ctitle ("Model 2") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") 	
	
logit petition_part ageindex sex educationindex compvote_dummy corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results3", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
	title ("Compulsory voting and petiton activity") ///
	ctitle ("Model 1") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit petition_part ageindex sex educationindex sanctcompvote_dummy corruption corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results3", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	title ("Compulsory voting and petition activity") ///
	ctitle ("Model 2") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit boycott_part ageindex sex educationindex compvote_dummy corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results4", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
	title ("Compulsory voting and boycott activity") ///
	ctitle ("Model 1") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit boycott_part ageindex sex educationindex sanctcompvote_dummy corruption corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results4", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	title ("Compulsory voting and boycott activity") ///
	ctitle ("Model 2") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit demo_part ageindex sex educationindex compvote_dummy corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results5", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
	title ("Compulsory voting and demo activity") ///
	ctitle ("Model 1") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
logit demo_part ageindex sex educationindex sanctcompvote_dummy corruption corruption gdppercapitalog freedomhouse latinamerica_dummy 
outreg2 using "regression_results5", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	title ("Compulsory voting and demo activity") ///
	ctitle ("Model 2") nonote ///
	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
/// regress turnout ageindex sex educationindex compvote_dummy corruption corruption gdppercapitalog populationlog freedomhouse latinamerica_dummy
/// outreg2 using "regression_results6", dec(3) addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word replace ///
///	title ("Compulsory voting and turnout") ///
///	ctitle ("Model 1") nonote ///
///	addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
/// regress turnout ageindex sex educationindex sanctcompvote_dummy corruption corruption gdppercapitalog populationlog freedomhouse latinamerica_dummy
/// outreg2 using "regression_results6", side addstat(Pseudo R-squared, `e(r2_p)', "Wald chi2 (`=e(df_m)') ", e(chi2), Prob > chi2,  e(p)) label word append ///
	/// title ("Compulsory voting and turnout") ///
	/// ctitle ("Model 2") nonote ///
	///addnote ("Robust standard errors in parentheses. *, **, and *** denote statistical significance at 10%, 5%, 1%") ///
	
	

