clear

svyset, clear
svyset HH1 [pweight=wmweight], strata(HH7)

//Birth outcomes//
*caesarean*
tab MN21
replace MN21 = 3 if MN21 ==.
gen Caesarean = 1 if MN21==1
replace Caesarean = 0 if MN21 > = 2
label define var_no 0"No" 1"Yes" 
label values Caesarean var_No
tab Caesarean
svy: tab Caesarean
*Perinatal death* 
gen perinatal = BH9U==1 & BH9N < = 7
label define var_No 0"No" 1"Yes"
label values perinatal var_No
tab perinatal
*Low birth weight*
gen LBW = 1 if MN34 < 2.5
replace LBW = 0 if MN34 > = 2.5
replace LBW = 0 if MN34 == .
label define var_Yes 1"Yes" 0"No"
label values LBW var_Yes
tab LBW

//C-section and LBW restrictions//
*Hopsital births*
gen Hospital_birth = 1 if MN21 == 1 | MN21 ==2
replace Hospital_birth = 0 if MN21 ==.
label define var_Yes 1"Yes" 0"No"
label values Hospital_birth var_Yes
tab Hospital_birth
*Weighed at birth*
gen Weighed = 1 if MN33 ==1
replace Weighed = 2 if MN33 == 2
replace Weighed =  3 if MN33 == 8
label define var_not_reported 1"Yes" 2"No" 3"not reported"
label values Weighed var_not_reported
tab Weighed LBW
tab Weighed


//Confounder variables//
*Twins*
gen Twins = BH2
label define var_single 1"single" 2"multiple" 
label values Twins var_single
tab Twins
svy: tab Twins
*Sex of child*
gen Sex = BH3
label define var_boy 1"boy" 2"girl"
label values Sex var_boy
tab Sex
svy: tab Sex

*Implementation outcomes*
*Penetration*
gen Penetration = 1 if Eight_ANC == 1
replace Penetration = 0 if Eight_ANC == 0
label define var_8vANC 0"Less than 8vANC" 1"8vANC"
label values Penetration var_8vANC
tab Penetration
*Fidelity*
gen first_trimester = MN4AN < 12
tab first_trimester 
label define var_Yes 1"Yes" 0"No" 
label values first_trimester var_Yes
tab first_trimester
recode MN6A (1=1 "Yes") (2=0 "No") (9=.), gen(lp_bloodpressure)
recode MN6B (1=1 "Yes") (2=0 "No") (9=.), gen(lp_urines)
recode MN6C (1=1 "Yes") (2=0 "No") (9=.), gen(lp_bloodsample)
gen lp_tetanusvac = 1 if MN9 < = 1 | MN9==.
replace lp_tetanusvac = 2 if MN9 > = 2 & MN9 < = 7
tab lp_tetanusvac, missing nolab 
egen lp_servcount=rowtotal(lp_bloodpressure lp_urines lp_bloodsample lp_tetanusvac first_trimester), missing 
tab lp_servcount 
gen Fidelity = 1 if lp_servcount ==6
replace Fidelity = 0 if lp_servcount < =5
label define var_Partial   0"Partial and Nonconcordant" 1"Concordant"
label values Fidelity var_Partial 
tab Fidelity

*Generating main fixed effect*
gen Penetration_fidelity = 0 if Penetration==0 & Fidelity==0
replace Penetration_fidelity = 1 if Penetration==0 & Fidelity==1
replace Penetration_fidelity = 2 if Penetration==1 & Fidelity==0 
replace Penetration_fidelity = 3 if Penetration==1 & Fidelity==1
label define var_Less_than 0"Less than 8vANC and Partial-NonConcordant" 1"Less than 8vANC and Concordant" 2"8vANC and Partial-NonConcordant" 3"8vANC and Concordant"
label values Penetration_fidelity var_Less_than
tab Penetration_fidelity


//Descrptive statistics of covariates//
**Environment**
tab Residence 
svy: tab Residence
tab Regions 
svy:tab Regions 

//Predisposing characteristics//
*Demographics*
*Maternal age*
tab Age 
svy: tab Age
*Children ever born*
tab Parity 
svy: tab Parity 
***Social structure***
*Religion of Household head*
tab Religion
svy:tab Religion 
*Marital Status*
tab Marital_status 
svy:tab Marital_status 
*Ethnicity*
tab ethnicity 
svy:tab ethnicity 
*Education level*
tab Eductaion_level 
svy:tab Eductaion_level 
*HH Education level*
tab HH_Education 
svy:tab HH_Education 
*Frequency of reading Newspaper/Magazine*
tab Newspaper_Magazine
svy:tab Newspaper_Magazine 
*Frequency of Listening to radio*
tab Radio 
svy:tab Radio
*Frequency of Watching TV*
tab TV 
svy:tab TV 
*Ever used Computer/Tablet*
tab Computer 
svy:tab Computer 
*Ever used Internet*
tab Internet 
svy:tab Internet 
***Health Beliefs***
*Overall life satisfaction*
tab Happiness 
svy:tab Happiness 
*Time since last sexual intercourse*
tab Sexual_behavior 
svy:tab Sexual_behavior
*Have you ever been circumcised?*
tab Ever_circumcised  
svy:tab Ever_circumcised 
* Do you think this practice should be continued or should it be discontinued?*
tab Continue_circumcision 
svy:tab Continue_circumcision 
*Wife beating justified*
tab wife_beating 
svy:tab wife_beating  
*How safe do you feel walking alone in your neighbourhood after dark?
tab Safety_neighbourhood 
svy:tab Safety_neighbourhood 
*How safe do you feel when you are at home alone after dark?
tab Safety_home 
svy:tab Safety_home 

//Enabling resources//
***Personal***
*Own Mobile Phone*
tab Mobile_phone 
svy:tab Mobile_phone 
*Health Insurance Coverage*
tab Health_insurance 
svy:tab Health_insurance 
*Own bank account*
tab Bank_account  
svy:tab Bank_account  
***Family***
*Food Insecurity*
tab Food_insecurity 
svy:tab Food_insecurity 
*Impact of COVID-19 on Food Insecurity* 
tab Covid_impact 
svy:tab Covid_impact 
*Wealth index*
tab Wealth_index  
svy:tab Wealth_index
*Transportation*
tab Transportaion_modes 
svy:tab Transportaion_modes  
*Household own land for agriculture*
tab Agriculture_land 
svy:tab Agriculture_land 
*Household own Animals*
tab Household_animals 
svy:tab Household_animals 

//Perceived Needs//
*Desire for last birth*
tab desire_last_birth 
svy:tab desire_last_birth 
*Currently pregnant*
tab Currently_pregnant 
svy:tab Currently_pregnant 
*Currently using Contraceptives*
tab Current_contraceptives 
svy:tab Current_contraceptives
*Ever used contraceptives*
tab Ever_contraceptives 
svy:tab Ever_contraceptives 


 ***Multilevel modeling mixed effects logistic regression***
//Caesarean births//
*model 1*
melogit Caesarean i.Penetration_fidelity if Hospital_birth ==1 [pweight=wmweight] || States:, or
*Calculating residuals or state random effects*
predict u1, reffects reses(use1)
tab use1
egen pickone1 = tag(States)
egen urank1 = rank(u1) if pickone==1 
serrbar u1 use1 urank, scale(1.96)
sort urank1
gen expU1 = exp(u1) 
list urank1 States expU1 if pickone1==1 
*Caterpillar plots*
generate labpos1b = expU1 + 1.96*use1 + 0.5
serrbar expU1 use1 urank1, addplot(scatter labpos1b urank1, name(model1) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)  
estimates store mod_prob1C
*ICC*
estat icc

*Model 2: Enviroment*
*Checking for multicollinearity*
reg Penetration_fidelity i.Residence i.Regions if Hospital_birth ==1 [pweight=wmweight] 
estat vif
*MLM*
melogit Caesarean i.Penetration_fidelity i.Residence i.Regions if Hospital_birth ==1 [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend 
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Residence]=0) (_b[2.Regions]=0) (_b[3.Regions]=0) (_b[4.Regions]=0) (_b[5.Regions]=0) (_b[6.Regions]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob2C
*Calculating state random effects*
predict u2, reffects reses(use2)
egen pickone2 = tag(States)
egen urank2 = rank(u2) if pickone2==1 
serrbar u2 use2 urank2, scale(1.96)
sort urank2
gen expU2 = exp(u2) 
list urank2 States expU2 if pickone2==1 
*Caterpillar plots*
generate labpos2 = expU2 + 1.96*use2 + 1.2
serrbar expU2 use2 urank, addplot(scatter labpos2 urank2, ysc(r(0.005)) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)  

*Model 3: Predisposing characteristics*
*Checking for multicollinearity*
reg Penetration_fidelity i.Age i.Parity i.Religion ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood i.Safety_home  i.Sex i.Twins if Hospital_birth ==1 [pweight=wmweight] 
estat vif
*MLM*
melogit Caesarean i.Penetration_fidelity i.Age i.Parity i.Religion ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood i.Safety_home  i.Sex i.Twins if Hospital_birth ==1 [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend 
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0)(_b[2.Age]=0) (_b[3.Age]=0) (_b[4.Age]=0) (_b[5.Age]=0) (_b[6.Age]=0) (_b[7.Age]=0) (_b[2.Parity]=0) (_b[3.Parity]=0)  (_b[4.Parity]=0) (_b[2.Religion]=0) (_b[3.Religion]=0)(_b[1.Marital_status]=0) (_b[1.ethnicity]=0) (_b[2.ethnicity]=0) (_b[3.ethnicity]=0) (_b[4.ethnicity]=0)  (_b[1.Eductaion_level]=0) (_b[2.Eductaion_level]=0) (_b[3.Eductaion_level]=0) (_b[4.Eductaion_level]=0) (_b[1.Newspaper_Magazine]=0) (_b[2.Newspaper_Magazine]=0) (_b[1.Radio]=0) (_b[2.Radio]=0) (_b[1.TV]=0) (_b[2.TV]=0) (_b[1.Computer]=0) (_b[1.Internet]=0) (_b[2.Sexual_behavior]=0) (_b[3.Sexual_behavior]=0) (_b[1.Ever_circumcised]=0) (_b[2.Ever_circumcised]=0) (_b[2.Continue_circumcision]=0) (_b[3.Continue_circumcision]=0) (_b[1.Continue_circumcision]=0) (_b[1.HH_Education]=0) (_b[2.HH_Education]=0) (_b[3.HH_Education]=0) (_b[4.HH_Education]=0)(_b[1.wife_beating]=0) (_b[2.wife_beating]=0) (_b[3.wife_beating]=0) (_b[4.wife_beating]=0) (_b[5.wife_beating]=0) (_b[6.wife_beating]=0) (_b[2.Safety_home]=0) ( _b[3.Safety_home]=0) (_b[1.Safety_neighbourhood]=0) (_b[2.Safety_neighbourhood]=0)  (_b[1.Happiness]=0) (_b[2.Happiness]=0) (_b[4.Happiness]=0)  (_b[5.Happiness]=0) (_b[2.Sex]=0) (_b[2.Twins])  
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob3C
*Calculating residuals or state random effects*
predict u3, reffects reses(use3)
egen pickone3 = tag(States)
egen urank3 = rank(u3) if pickone3==1 
serrbar u3 use3 urank3, scale(1.96)
sort urank3
gen expU3 = exp(u3) 
tab expU3
list urank3 States expU3 if pickone3==1 
*Caterpillar plots*
generate labpos3 = expU3 + 1.96*use3 + 0.5
serrbar expU3 use3 urank3, addplot(scatter labpos3 urank3, name(model3) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)  

*Model 4: Enabling resources*
*Checking for multicollinearity*
reg Penetration_fidelity ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals if Hospital_birth ==1 [pweight=wmweight] 
estat vif
*MLM*
melogit Caesarean  i.Penetration_fidelity ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals if Hospital_birth ==1 [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend 
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.Mobile_phone]=0) (_b[1.Health_insurance]=0) (_b[1.Bank_account]=0) (_b[1.Food_insecurity]=0) (_b[2.Food_insecurity]=0) (_b[3.Food_insecurity]=0) (_b[0.Food_insecurity]=0) (_b[1.Covid_impact]=0) (_b[2.Covid_impact]=0) (_b[3.Covid_impact]=0) (_b[0.Covid_impact]=0) (_b[1.Wealth_index]=0) (_b[3.Wealth_index]=0) (_b[4.Wealth_index]=0) (_b[5.Wealth_index]=0) (_b[1.Transportaion_modes]=0)  (_b[2.Transportaion_modes]=0) (_b[1.Agriculture_land]=0)  (_b[1.Household_animals]=0)  
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob4C
*Calculating residuals or state random effects*
predict u4, reffects reses(use4)
egen pickone4 = tag(States)
egen urank4 = rank(u4) if pickone4==1 
serrbar u4 use4 urank4, scale(1.96)
sort urank4
gen expU4 = exp(u4) 
list urank4 States expU4 if pickone4==1 

*Model 5: Perceived needs*
*Checking for multicollinearity*
reg Penetration_fidelity ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives if Hospital_birth ==1 [pweight=wmweight]
estat vif
*MLM*
melogit Caesarean  i.Penetration_fidelity ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives if Hospital_birth ==1 [pweight=wmweight] || States:,or
*wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.desire_last_birth]=0) (_b[3.desire_last_birth]=0)(_b[1.Currently_pregnant]=0)(_b[1.Current_contraceptives]=0)(_b[3o.Current_contraceptives]=0)(_b[2.Ever_contraceptives]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob5C
*Calculating residuals or state random effects*
predict u5, reffects reses(use5)
egen pickone5 = tag(States)
egen urank5 = rank(u5) if pickone5==1 
serrbar u5 use5 urank5, scale(1.96)
sort urank5
gen expU5 = exp(u5) 
list urank5 States expU5 if pickone5==1 

*Model 6: Final model*
*Checking for multicollinearity*
reg Penetration_fidelity i.Residence i.Age i.Parity ib5.ethnicity i.Eductaion_level i.TV i.Sexual_behavior i.Covid_impact i.HH_Education  ib2.Bank_account ib2.Current_contraceptives i.Twins if Hospital_birth ==1 [pweight=wmweight]
estat vif
*MLM*
melogit Caesarean  i.Penetration_fidelity i.Residence i.Age i.Parity ib5.ethnicity i.Eductaion_level i.TV i.Sexual_behavior i.Covid_impact i.HH_Education  ib2.Bank_account ib2.Current_contraceptives i.Twins if Hospital_birth ==1 [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Residence]=0) (_b[2.Age]=0) (_b[3.Age]=0) (_b[4.Age]=0) (_b[5.Age]=0) (_b[6.Age]=0) (_b[7.Age]=0) (_b[2.Parity]=0) (_b[3.Parity]=0) (_b[4.Parity]=0) (_b[1.ethnicity]=0) (_b[2.ethnicity]=0) (_b[3.ethnicity]=0) (_b[4.ethnicity]=0) (_b[1.Eductaion_level]=0) (_b[2.Eductaion_level]=0) (_b[3.Eductaion_level]=0) (_b[4.Eductaion_level]=0) (_b[1.TV]=0) (_b[2.TV]=0) (_b[2.Sexual_behavior]=0)(_b[3.Sexual_behavior]=0) (_b[1.Safety_home]=0) (_b[2.Safety_home]=0) (_b[1.Bank_account]=0) (_b[1.Current_contraceptives]=0) (_b[2.Current_contraceptives]=0) (_b[2.Twins]=0) (_b[1.HH_Education]=0) (_b[2.HH_Education]=0) (_b[3.HH_Education]=0) (_b[4.HH_Education]=0)
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob6C
*Calculating residuals or state random effects*
predict u6, reffects reses(use6)
egen pickone6 = tag(States)
egen urank6 = rank(u6) if pickone6a==1 
serrbar u6 use6 urank6, scale(1.96)
sort urank6
gen expU6 = exp(u6) 
list urank6 States expU6 if pickone6a==1 
*Caterpillar plots*
generate labpos6 = expU6 + 1.96*use6 + 0.5
serrbar expU6 use6 urank6, addplot(scatter labpos6 urank6, name(model6) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off) 

*Goodness of fit test*
estimates stats mod_prob1C mod_prob2C mod_prob3C mod_prob4C  mod_prob5C  mod_prob6C
*Figure 2*
gr combine model1b model6a, col(1) ysize(5) xsize(6)iscale(.5)



//Low birth weight//
*model 1*
melogit LBW i.Penetration_fidelity  if Weighed==1 [pweight=wmweight] || States:, or
*ICC*
estat icc
AIC/BIC*
estimates store mod_probL
*Calculating residuals or state random effects*
predict ul, reffects reses(usel)
tab usel
egen pickonel= tag(States)
egen urankl = rank(ul) if pickonel==1 
serrbar ul usel urankl, scale(1.96)
gen expUl = exp(ul) 
sort urankl
list urankl States expUl if pickonel==1 
*Caterpillar plots*
generate labposl = expUl + 1.96*usel + 0.5
serrbar expUl usel urankl, addplot(scatter labposl urankl, name(modell) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)

*Model 2: Enviroment*
*Checking for multicollinearity*
reg Penetration_fidelity i.Residence i.Regions if Weighed==1 [pweight=wmweight]
estat VIF
*MLM*
melogit LBW i.Penetration_fidelity i.Residence i.Regions if Weighed==1 [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test  (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Residence]=0) (_b[2.Regions]=0) (_b[3.Regions]=0) (_b[4.Regions]=0) (_b[5.Regions]=0) (_b[6.Regions]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob2L
*Calculating residuals or state random effects*
predict ul2, reffects reses(usel2)
tab usel2
egen pickonel2 = tag(States)
egen urankl2 = rank(ul2) if pickonel2==1 
serrbar ul2 usel2 urankl2, scale(1.96)
gen expUl2= exp(ul2) 
list urankl2 States expUl2 if pickonel2==1 

*Model 3: Predisposing characteristics*
*Checking for multicollinearity*
reg Penetration_fidelity ib2.Age i.Parity i.Religion ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood i.Safety_home i.Sex i.Twins if Weighed==1 [pweight=wmweight] 
estat vif
*MLM*
melogit LBW i.Penetration_fidelity ib2.Age i.Parity i.Religion ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood i.Safety_home i.Sex i.Twins if Weighed==1 [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend 
test  (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0)(_b[2.Age]=0) (_b[3.Age]=0) (_b[4.Age]=0) (_b[5.Age]=0) (_b[6.Age]=0) (_b[7.Age]=0) (_b[2.Parity]=0) (_b[3.Parity]=0)  (_b[4.Parity]=0) (_b[2.Religion]=0) (_b[3.Religion]=0) (_b[1.Marital_status]=0) (_b[1.ethnicity]=0) (_b[2.ethnicity]=0) (_b[3.ethnicity]=0) (_b[4.ethnicity]=0)  (_b[1.Eductaion_level]=0) (_b[2.Eductaion_level]=0) (_b[3.Eductaion_level]=0) (_b[4.Eductaion_level]=0) (_b[1.Newspaper_Magazine]=0) (_b[2.Newspaper_Magazine]=0) (_b[1.Radio]=0) (_b[2.Radio]=0) (_b[1.TV]=0) (_b[2.TV]=0) (_b[1.Computer]=0) (_b[1.Internet]=0) (_b[2.Sexual_behavior]=0) (_b[3.Sexual_behavior]=0) (_b[1.Ever_circumcised]=0) (_b[2.Ever_circumcised]=0) (_b[2.Continue_circumcision]=0) (_b[3.Continue_circumcision]=0) (_b[1.Continue_circumcision]=0) (_b[1.HH_Education]=0) (_b[2.HH_Education]=0) (_b[3.HH_Education]=0) (_b[4.HH_Education]=0)(_b[1.wife_beating]=0) (_b[2.wife_beating]=0) (_b[3.wife_beating]=0) (_b[4.wife_beating]=0) (_b[5.wife_beating]=0) (_b[6.wife_beating]=0) (_b[1.Safety_neighbourhood]=0) (_b[2.Safety_neighbourhood]=0) (_b[1.Safety_home]=0) (_b[2.Safety_home]=0) (_b[1.Happiness]=0) (_b[2.Happiness]=0) (_b[4.Happiness]=0)  (_b[5.Happiness]=0) ( _b[2.Sex]=0) (_b[2.Twins]=0)
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob3L
*Calculating residuals or state random effects*
predict ul3, reffects reses(usel3)
tab usel3
egen pickonel3 = tag(States)
egen urankl3 = rank(ul3) if pickonel3==1 
serrbar ul3 usel3 urankl3, scale(1.96)
sort urankl3
gen expUl3= exp(ul3) 
list urankl3 States expUl3 if pickonel3==1 
*Caterpillar plots*
generate labposl3 = expUl3 + 1.96*usel3 + 0.7
serrbar expUl3 usel3 urankl3, addplot(scatter labposl3 urankl3, name(modell3) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)

*Model 4: Enabling resources*
*Checking for multicollinearity*
reg Penetration_fidelity  ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals if Weighed==1 [pweight=wmweight] 
estat vif
*MLM*
melogit LBW i.Penetration_fidelity  ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals if Weighed==1 [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend 
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.Mobile_phone]=0) (_b[1.Health_insurance]=0) (_b[1.Bank_account]=0) (_b[1.Food_insecurity]=0) (_b[2.Food_insecurity]=0) (_b[3.Food_insecurity]=0) (_b[4.Food_insecurity]=0) (_b[1.Covid_impact]=0) (_b[2.Covid_impact]=0) (_b[3.Covid_impact]=0) (_b[4.Covid_impact]=0) (_b[1.Wealth_index]=0) (_b[3.Wealth_index]=0) (_b[4.Wealth_index]=0) (_b[5.Wealth_index]=0) (_b[1.Transportaion_modes]=0)  (_b[2.Transportaion_modes]=0) (_b[1.Agriculture_land]=0)  (_b[1.Household_animals]=0) (_b[_cons]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob4L
*Calculating residuals or state random effects*
predict ul4, reffects reses(usel4)
tab usel4
egen pickonel4 = tag(States)
egen urankl4 = rank(ul4) if pickonel4==1 
serrbar ul4 usel4 urankl4, scale(1.96)
sort urankl4
gen expUl4= exp(ul4) 
tab expU
list urankl4 States expUl4 if pickonel4==1 

*Model 5: Perceived needs*
*Checking for multicollinearity*
reg Penetration_fidelity  ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives if Weighed==1 [pweight=wmweight]
estat vif 
*MLM*
melogit LBW i.Penetration_fidelity  ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives if Weighed==1 [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.desire_last_birth]=0) (_b[3.desire_last_birth]=0)(_b[1.Currently_pregnant]=0)(_b[1.Current_contraceptives]=0)(_b[3o.Current_contraceptives]=0)(_b[2.Ever_contraceptives]=0) (_b[1.Previous_loss]=0) (_b[_cons]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob5L
*Calculating residuals or state random effects*
predict ul5, reffects reses(usel5)
tab usel5
egen pickonel5 = tag(States)
egen urankl5 = rank(ul5) if pickonel5==1 
serrbar ul5 use5l urankl5, scale(1.96)
sort urankl5
gen expUl5= exp(ul5) 
list urankl5 States expUl5 if pickonel5==1 

*Model 6: final model*
*Checking for multicollinearity*
reg Penetration_fidelity i.Age i.Regions i.Parity ib2.Marital_status  ib3.Happiness i.Covid_impact ib2.Agriculture_land ib2.desire_last_birth i.Twins if Weighed==1 [pweight=wmweight] 
estat vif
*MLM*
melogit LBW i.Penetration_fidelity i.Age i.Regions i.Parity ib2.Marital_status  ib3.Happiness i.Covid_impact ib2.Agriculture_land ib2.desire_last_birth i.Twins if Weighed==1 [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Regions]=0) (_b[3.Regions]=0) (_b[4.Regions]=0) (_b[5.Regions]=0) (_b[6.Regions]=0) (_b[2.Parity]=0) (_b[3.Parity]=0) (_b[4.Parity]=0) (_b[2.Religion]=0) (_b[3.Religion]=0) (_b[1.Marital_status]=0) (_b[1.ethnicity]=0) (_b[2.ethnicity]=0)(_b[3.ethnicity]=0) (_b[4.ethnicity]=0) (_b[1.Eductaion_level]=0) (_b[2.Eductaion_level]=0) (_b[3.Eductaion_level]=0)(_b[4.Eductaion_level]=0) (_b[1.Happiness]=0)  (_b[2.Happiness]=0)  (_b[4.Happiness]=0) (_b[5.Happiness]=0)(_b[1.Covid_impact]=0) (_b[2.Covid_impact]=0) (_b[3.Covid_impact]=0) (_b[4.Covid_impact]=0) (_b[1.desire_last_birth]=0) (_b[3.desire_last_birth]=0) (_b[1.Agriculture_land]=0)  
*ICC*
estat icc
AIC/BIC*
estimates store mod_prob6L
*Calculating residuals or state random effects*
predict u6l, reffects reses(use6l)
egen pickone6l = tag(States)
egen urank6l = rank(u6l) if pickone6l==1 
serrbar u6l use6l urank6l, scale(1.96)
sort urank6l
gen expU6l = exp(u6l) 
list urank6l States expU6l if pickone6l==1 
*Caterpillar plots*
generate labpos6l = expU6l + 1.96*use6l + 0.5
serrbar expU6l use6l urank6l, addplot(scatter labpos6l urank6l, name(model6l) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off) 

*Goodness of fit test*
estimates stats mod_probL mod_prob2L mod_prob3L mod_prob4L  mod_prob5L mod_prob6L
*Figure 3*
gr combine modella modell3, col(1) ysize(5) xsize(6)iscale(.5)


//Perinatal death//
*model 1*
melogit perinatal i.Penetration_fidelity  [pweight=wmweight] || States:, or
*Calculating residuals or state random effects*
predict up1, reffects reses(usep1)
tab usep1
egen pickonep1 = tag(States)
egen urankp1 = rank(up1) if pickonep1==1 
serrbar up1 usep1 urankp1, scale(1.96)
sort urankp1
gen expUp1= exp(up1) 
list urankp1 States expUp1 if pickonep1==1 
*Caterpillar plots*
generate labposp1 = expUp1 + 1.96*usep1 + 0.4
serrbar expUp1 usep1 urankp1, addplot(scatter labposp1 urankp1, name(modelp) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off)
*ICC*
estat icc
AIC/BIC*
estimates store mod_probP

*Model 2: Enviroment*
*Checking for multicollinearity*
reg Penetration_fidelity i.Residence i.Regions [pweight=wmweight]
estat vif
*MLM*
melogit perinatal i.Penetration_fidelity i.Residence i.Regions [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Residence]=0) (_b[2.Regions]=0) (_b[3.Regions]=0) (_b[4.Regions]=0) (_b[5.Regions]=0) (_b[6.Regions]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob2P
*Calculating residuals or state random effects*
predict up2, reffects reses(usep2)
tab usep2
egen pickonep2 = tag(States)
egen urankp2 = rank(up2) if pickonep2==1 
serrbar up2 usep2 urankp2, scale(1.96)
sort urankp2
gen expUp2= exp(up2) 
list urankp2 States expUp2 if pickonep2==1 
tab urankp2

*Model 3: Predisposing characteristics*
reg Penetration_fidelity  i.Age i.Parity ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood ib3.Safety_home i.Sex i.Twins [pweight=wmweight] 
estat vif
*MLM*
melogit perinatal Penetration_fidelity  i.Age i.Parity ib2.Marital_status ib5.ethnicity i. Eductaion_level i.Newspaper_Magazine i.Radio i.TV ib2.Computer ib2.Internet i.Sexual_behavior ib3.Ever_circumcised ib4.Continue_circumcision ib3.Happiness i.HH_Education i.wife_beating ib3.Safety_neighbourhood ib3.Safety_home i.Sex i.Twins [pweight=wmweight] || States:, or 
*Wald test*
melogit, coeflegend 
test  (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Age]=0) (_b[3.Age]=0) (_b[4.Age]=0) (_b[5.Age]=0) (_b[6.Age]=0) (_b[7.Age]=0) (_b[2.Parity]=0) (_b[3.Parity]=0)  (_b[4.Parity]=0) (_b[2.Religion]=0) (_b[3.Religion]=0) (_b[1.Marital_status]=0) (_b[1.ethnicity]=0) (_b[3.ethnicity]=0) (_b[4.ethnicity]=0) (_b[2.ethnicity]=0) (_b[1.Eductaion_level]=0) (_b[2.Eductaion_level]=0) (_b[3.Eductaion_level]=0) (_b[4.Eductaion_level]=0) (_b[1.Newspaper_Magazine]=0) (_b[2.Newspaper_Magazine]=0) (_b[1.Radio]=0) (_b[2.Radio]=0) (_b[1.TV]=0) (_b[2.TV]=0) (_b[1.Computer]=0) (_b[1.Internet]=0) (_b[2.Sexual_behavior]=0) (_b[3.Sexual_behavior]=0) (_b[1.Ever_circumcised]=0) (_b[2.Ever_circumcised]=0) (_b[2.Continue_circumcision]=0) (_b[3.Continue_circumcision]=0) (_b[1.Continue_circumcision]=0)  (_b[1.HH_Education]=0) (_b[2.HH_Education]=0) (_b[3.HH_Education]=0) (_b[4.HH_Education]=0)(_b[1.wife_beating]=0) (_b[2.wife_beating]=0) (_b[3.wife_beating]=0) (_b[4.wife_beating]=0) (_b[5.wife_beating]=0) (_b[6.wife_beating]=0) (_b[1.Safety_neighbourhood]=0) (_b[2.Safety_neighbourhood]=0) (_b[1.Safety_home]=0) (_b[2.Safety_home]=0) (_b[1.Happiness]=0) (_b[2.Happiness]=0) (_b[4.Happiness]=0)  (_b[3.Happiness]=0)  
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob3P
*Calculating residuals or state random effects*
predict up3, reffects reses(usep3)
tab usep3
egen pickonep3 = tag(States)
egen urankp3 = rank(up3) if pickonep3==1 
serrbar up3 usep3 urankp3, scale(1.96)
sort urank3v
gen expUp3= exp(up3) 
list urankp3 States expUp3 if pickonep3==1 
*Caterpillar plots*
generate labposp3 = expUp3 + 1.96*usep3 + .2
serrbar expUp3 usep3 urankp3, addplot(scatter labposp3 urankp3, name(modelp3) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline(1) legend(off) 

*Model 4: Enabling resources*
*Checking for multicollinearity*
reg Penetration_fidelity  ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals [pweight=wmweight]
estat vif
*MLM*
melogit perinatal i.Penetration_fidelity  ib2.Mobile_phone ib2.Health_insurance ib2.Bank_account i.Food_insecurity i.Covid_impact ib2.Wealth_index i.Transportaion_modes ib2.Agriculture_land ib2.Household_animals [pweight=wmweight] || States:, or
*Wald test*
melogit, coeflegend 
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.Mobile_phone]=0) (_b[1.Health_insurance]=0) (_b[1.Bank_account]=0) (_b[1.Food_insecurity]=0) (_b[2.Food_insecurity]=0) (_b[3.Food_insecurity]=0) (_b[4.Food_insecurity]=0) (_b[1.Covid_impact]=0) (_b[2.Covid_impact]=0) (_b[3.Covid_impact]=0) (_b[4.Covid_impact]=0) (_b[1.Wealth_index]=0) (_b[3.Wealth_index]=0) (_b[4.Wealth_index]=0) (_b[5.Wealth_index]=0) (_b[1.Transportaion_modes]=0)  (_b[2.Transportaion_modes]=0) (_b[1.Agriculture_land]=0)  (_b[1.Household_animals]=0) (_b[_cons]=0) 
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob4P
*Calculating residuals or state random effects*
predict up4, reffects reses(usep4)
egen pickonep4 = tag(States)
egen urankp4 = rank(up4) if pickonep4==1 
serrbar up4 usep4 urankp4, scale(1.96)
sort urankp4
gen expUp4= exp(up4) 
list urankp4 States expUp4 if pickonep4==1 

*Model 5: Perceived needs*
*Checking for multicollinearity*
reg Penetration_fidelity  ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives [pweight=wmweight]
estat vif
*MLM*
melogit perinatal i.Penetration_fidelity  ib2.desire_last_birth ib2.Currently_pregnant ib2.Current_contraceptives ib2.Ever_contraceptives [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[1.desire_last_birth]=0) (_b[3.desire_last_birth]=0)(_b[1.Currently_pregnant]=0)(_b[1.Current_contraceptives]=0)(_b[3o.Current_contraceptives]=0)(_b[1.Ever_contraceptives]=0) (_b[_cons]=0)
estat icc
*AIC/BIC*
estimates store mod_prob5P
*Calculating residuals or state random effects*
predict up5, reffects reses(usep5)
egen pickonep5 = tag(States)
egen urankp5 = rank(up5) if pickonep5==1 
serrbar up5 usep5 urankp5, scale(1.96)
gen expUp5= exp(up5) 
list urankp5 States expUp5 if pickonep5==1 

*Model 6: Final model*
*Checking for multicollinearity*
reg Penetration_fidelity  i.Residence i.Regions i.Age i.Parity ib5.ethnicity ib2.Computer ib3.Ever_circumcised ib3.Happiness i.HH_Education ib2.Mobile_phone ib2.Currently_pregnant i.Twins i.Sex [pweight=wmweight]
estat vif 
*MLM*
melogit perinatal i.Penetration_fidelity i.Residence i.Parity i.Regions i.Age ib5.ethnicity ib2.Computer ib3.Ever_circumcised ib3.Happiness i.HH_Education ib2.Mobile_phone ib2.Currently_pregnant i.Twins i.Sex [pweight=wmweight] || States:,or
*Wald test*
melogit, coeflegend
test (_b[1.Penetration_fidelity]=0) (_b[2.Penetration_fidelity]=0) (_b[3.Penetration_fidelity]=0) (_b[2.Age]=0) (_b[3.Age]=0) (_b[4.Age]=0) (_b[5.Age]=0) (_b[6.Age]=0) (_b[7.Age]=0) (_b[2.Residence]=0) (_b[2.Regions]=0) (_b[3.Regions]=0) (_b[4.Regions]=0) (_b[5.Regions]=0) (_b[6.Regions]=0) (_b[1.ethnicity]=0) (_b[2.ethnicity]=0) (_b[3.ethnicity]=0) (_b[4.ethnicity]=0) (_b[1.Ever_circumcised]=0) (_b[2.Ever_circumcised]=0) (_b[1.Happiness]=0) (_b[2.Happiness]=0) (_b[4.Happiness]=0) (_b[5.Happiness]=0) (_b[1.Computer]=0) (_b[1.Mobile_phone]=0) (_b[1.Currently_pregnant]=0) (_b[1.HH_Education]=0) (_b[2.HH_Education]=0) (_b[3.HH_Education]=0) (_b[4.HH_Education]=0) (_b[2.Twins]=0) (_b[2.Sex]=0)
*ICC*
estat icc
*AIC/BIC*
estimates store mod_prob6P
*Calculating residuals or state random effects*
predict up6, reffects reses(usep6)
egen pickonep6 = tag(States)
egen urankp6 = rank(up6) if pickonep6==1 
serrbar up6 usep6 urankp6, scale(1.96)
gen expUp6= exp(up6) 
sort urankp6
list urankp6 States expUp6 if pickonep6==1 
*Caterpillar plots*
generate labposp6 = expUp6 + 1.96*usep6 + 0.3
serrbar expUp6 usep6 urankp6, addplot(scatter labposp6 urankp6, name(modelp6) mlabel(States) mlabangle (vertical 90) msymbol(none) mlabpos(0) mlabsize(tiny)) scale(1.96) yline (1)  legend(off) 

*Goodness of fit test*
estimates stats mod_probP mod_prob2P mod_prob3P mod_prob4P mod_prob5P mod_prob6P

*Figure 4*
gr combine modelp modelp6a, col(1) ysize(5) xsize(6)iscale(.5) 
