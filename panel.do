
* Creating files
usespss "SRS_PRE_FINAL_cleaned.sav", clear
mata usespss_dates()
count
rename profile_newspaper_readership_pdl profile_newspaper_readership
renvars W8_fullRJ-total, postfix(W1)
save "wave1", replace
savespss "wave1.sav", replace

usespss "SRS_POST_FINAL_withBES.sav", clear
mata usespss_dates()
count
rename SRS2014ID ID
renvars BESorSRS-endtime, postfix(W2m)
renvars scotReferendumIntention-scotReferendumLeaning, postfix(W2a)
renvars scotReferendumTurnout-scotReferendumVote, postfix(W2m)
renvars reasonSwitchYes-reasonReferendumNoo, postfix(W2a)
renvars happyScotIndepResultNo-happyScotIndepResultNoScale, postfix(W2a)
renvars emotScotIndep-blameNoOthero, postfix(W2a)
renvars refContactPost-oe9, postfix(W2b)
renvars referendumContact_1-referendumContact_99, postfix(W2c)
renvars campaignTone-campaignToneNo, postfix(W2a)
renvars campaignVision-campaignAssessPost, postfix(W2m)
renvars refFairnessW2-otherSideW2, postfix(m)
renvars ScotEmpwrW2-refImportantW2, postfix(b)
renvars fairConductRefW2-refElecStakesW2, postfix(a)
renvars refClimatePost-refClimateScotPost, postfix(W2a)
renvars efficGeneral2-efficComplicated2, subst(2 W2b)
renvars efficacyPolCare, postfix(W2c) 
renvars dutyToVote22, subst(22 W2a)
renvars dutyToVoteRef2, subst(22 W2a)
renvars satDem-expectationDevoScot, postfix(W2m)
renvars unionRisks2-unionBenefitsDown2, subst(2 W2a)
renvars newpowerstime, postfix(W2a) 
renvars nationalIdentities-wellsage, postfix(W2m)
renvars bpcas2, subst(2 W2m)
renvars socgrade4_w8-PrimaryLast, postfix(W2a)
order ID-BESID, first
order *W2m, after(BESID)
order *W2a, after(bpcasW2m)
order *W2b, after(PrimaryLastW2a)
order *W2c, after(efficComplicatedW2b)
save "wave2", replace
savespss "wave2.sav", replace

usespss "SRS_Wave3_client.sav", clear
mata usespss_dates()
count
renvars core2014-Vote_w8_15, postsub(W3 )
renvars core2014-Vote_w8_15, postfix(W3)
save "wave3", replace
savespss "wave3.sav", replace

* Merging databases
use "wave1", clear
merge 1:1 ID using "wave2"
rename _merge _merge1
save "wave123merge", replace
merge 1:1 ID using "wave3"
rename _merge _merge2
gen attrition = .
replace attrition=1 if _merge1==1
replace attrition=2 if _merge1==2
replace attrition=3 if _merge1==3
replace attrition=4 if _merge2==3
lab def attrition 1"Wave 1" 2"Wave 2_BESIP" 3"Waves 1 & 2" 4"Waves 1, 2 & 3" 
lab val attrition attrition 
save "wave123merge", replace
generate StartWave2 = ., before(SRS2011ID)
generate StartWave3 = ., before(core2014W3)
savespss "wave123merge.sav", replace

use "wave1", clear
merge 1:1 ID using "Swave2"
rename _merge _merge1
save "wave12merge", replace
gen attrition = .
replace attrition=1 if _merge1==1
replace attrition=2 if _merge1==2
replace attrition=3 if _merge1==3
lab def attrition 1"Wave 1" 2"Wave 2_BESIP" 3"Waves 1 & 2"
lab val attrition attrition 
save "wave12merge", replace
generate StartWave2 = ., before(SRS2011ID)
savespss "wave12merge.sav", replace
