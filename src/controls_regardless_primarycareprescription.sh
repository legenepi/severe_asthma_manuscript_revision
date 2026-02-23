#!/bin/bash

#Comparison: Create controls for GWAS (severe-asthma + all-asthma) VS respiratory-disease free controls.
#Controls are not excluded for lack of primary prescription records/prescriptions.
#Re-create the controls cohort.

PATH_DATA="/scratch/gen1/nnp5/manuscript_revision"
PATH_exclusions="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/UKBiobank_datafields"
PATH_OUTPUT="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data"
PATH_APPL="/rfs/TobinGroup/data/UKBiobank/application_56607"


#check that the files for exclusions criteria exist:
ls -lthr | grep "asthma_noncancer_illcode_selfrep_20002.txt\|eid_QC_RP_asthma.txt\|Eid_asthma_treatment_medication_code_selfrep_20003.txt\|eid_less70_Best_FEV1_FVC_ratio_20150_20151.txt\|eid_less60_Predicted_percentage_FEV1_20154.txt\|Eid_with_asthmascripts\|Eid_NO_treatment_medication_code_selfrep_20003.txt\|Eid_withdrawn_participants_upFeb2022.txt"

#need to re-create file Eid_NO_treatment_medication_code_selfrep_20003.txt
#exclude participant with no record for datafield 20003:
awk -F "," '{print $1, $2}' /rfs/TobinGroup/data/UKBiobank/application_56607/20003_self_meds.csv.csv | awk -F " "  '{if ($2  !~ /[0-9]/) print $1}' | \
    tail -n +2 | sed s/'"'//g \
    > ${PATH_DATA}/Eid_NO_treatment_medication_code_selfrep_20003.txt


#merge participants from each exclusion criteria (not included Eid_NO_gp_scripts_edit.txt for this case-control comparison)
cat ${PATH_OUTPUT}/Eid_intersection_asthma_diagnosis_ATLEAST_1_evidence.txt \
    ${PATH_exclusions}/data/asthma_noncancer_illcode_selfrep_20002.txt \
    ${PATH_exclusions}/data/eid_QC_RP_asthma.txt \
    ${PATH_exclusions}/data/Eid_asthma_treatment_medication_code_selfrep_20003.txt \
    ${PATH_exclusions}/data/eid_less70_Best_FEV1_FVC_ratio_20150_20151.txt \
    ${PATH_exclusions}/data/eid_less60_Predicted_percentage_FEV1_20154.txt \
    ${PATH_exclusions}/data/Eid_with_asthmascripts \
    ${PATH_DATA}/Eid_NO_treatment_medication_code_selfrep_20003.txt \
    ${PATH_exclusions}/data/Eid_withdrawn_participants_upFeb2022.txt \
    ${PATH_exclusions}/output/eid_union_ecb_ATLEAST_1_evidence.txt \
    ${PATH_exclusions}/data/eid_QC_RP_ecb.txt \
    ${PATH_exclusions}/data/eid_respiratory_selfreported_20002.txt |
    sort -u | sed s/'"'//g \
    > ${PATH_DATA}/Eid_to_exclude_control_asthmafree_regardless_prescriptions.txt

#eid column:
awk -F '","' '{print $1}' ${PATH_APPL}/ukb48371.csv | sed s/'"'//g > ${PATH_DATA}/tmp_control_eid.txt

#Controls respiratory disease-free:
grep -v -w -F -f ${PATH_DATA}/Eid_to_exclude_control_asthmafree_regardless_prescriptions.txt ${PATH_DATA}/tmp_control_eid.txt \
    > ${PATH_DATA}/Eid_control_respiratoryfree_regardless_prescriptions.txt

#Back-up file:
cp ${PATH_DATA}/Eid_control_respiratoryfree_regardless_prescriptions.txt ${PATH_OUTPUT}