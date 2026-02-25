#!/bin/bash

#Run regenie step 2 for the sensitivity analyses - BMI and Smoking status
#This is an interactive job as the association is run for 68 variants only.

PATH_DATA="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data"
scratch_dir="/scratch/gen1/nnp5/manuscript_revision"
sample_DIR="/data/gen1/UKBiobank_500K/severe_asthma/data"
pheno="broad_pheno_1_5_ratio"
software_path="/home/n/nnp5/software"


#BMI
mkdir ${scratch_dir}/BMI_${pheno}
mkdir ${scratch_dir}/BMI_${pheno}/output
for i in $(seq 1 22);
do
  ${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
    --step 2 \
    --bgen /data/ukb/imputed_v3/ukb_imp_chr${i}_v3.bgen \
    --ref-first \
    --sample ${sample_DIR}/ukbiobank_app56607_for_regenie.sample \
    --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
    --extract ${scratch_dir}/suggestive_variants_SNPID.txt \
    --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_broadasthma.txt \
    --phenoCol ${pheno} \
    --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_broadasthma.txt \
    --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,BMI \
    --bt \
    --gz \
    --threads 4 \
    --minMAC 10 \
    --minINFO 0.3 \
    --firth --approx --pThresh 0.01 \
    --pred ${scratch_dir}/BMI_${pheno}.regenie.step1_pred.list \
    --bsize 1000 \
    --out ${scratch_dir}/BMI_${pheno}/output/BMI_${pheno}.${i}.regenie.step2
done


#merge all assoc file:
cov="BMI"
zcat ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}.1.regenie.step2_${pheno}.regenie.gz | tail -n +2 | \
     awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    > ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt

for i in $(seq 2 22);
do
    zcat ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}.${i}.regenie.step2_${pheno}.regenie.gz | \
    tail -n +2 | awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    >> ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt
done
#Save the summary stats in /rfs:
cp ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt ${PATH_DATA}/


#####
#For Smoking status (SI column) covariate:
mkdir ${scratch_dir}/SI_${pheno}
mkdir ${scratch_dir}/SI_${pheno}/output
for i in $(seq 1 22);
do
  ${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
    --step 2 \
    --bgen /data/ukb/imputed_v3/ukb_imp_chr${i}_v3.bgen \
    --ref-first \
    --sample ${sample_DIR}/ukbiobank_app56607_for_regenie.sample \
    --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
    --extract ${scratch_dir}/suggestive_variants_SNPID.txt \
    --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_smokingstatus.txt \
    --phenoCol ${pheno} \
    --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_smokingstatus.txt \
    --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,SI \
    --bt \
    --gz \
    --threads 4 \
    --minMAC 10 \
    --minINFO 0.3 \
    --firth --approx --pThresh 0.01 \
    --pred ${scratch_dir}/SI_${pheno}.regenie.step1_pred.list \
    --bsize 1000 \
    --out ${scratch_dir}/SI_${pheno}/output/SI_${pheno}.${i}.regenie.step2
done


#merge all assoc file:
cov="SI"
zcat ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}.1.regenie.step2_${pheno}.regenie.gz | tail -n +2 | \
     awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    > ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt

for i in $(seq 2 22);
do
    zcat ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}.${i}.regenie.step2_${pheno}.regenie.gz | \
    tail -n +2 | awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    >> ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt
done
#Save the summary stats in /rfs:
cp ${scratch_dir}/${cov}_${pheno}/output/${cov}_${pheno}_allchr.assoc.txt ${PATH_DATA}/

#####
#For All Asthma vs respiratory disease-free controls:
pheno="pheno_allasthma"
mkdir ${scratch_dir}/${pheno}
mkdir ${scratch_dir}/${pheno}/output
for i in $(seq 1 22);
do
  ${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
    --step 2 \
    --bgen /data/ukb/imputed_v3/ukb_imp_chr${i}_v3.bgen \
    --ref-first \
    --sample ${sample_DIR}/ukbiobank_app56607_for_regenie.sample \
    --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
    --extract ${scratch_dir}/suggestive_variants_SNPID.txt \
    --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_allasthma.txt \
    --phenoCol ${pheno} \
    --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_allasthma.txt \
    --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex \
    --bt \
    --gz \
    --threads 4 \
    --minMAC 10 \
    --minINFO 0.3 \
    --firth --approx --pThresh 0.01 \
    --pred ${scratch_dir}/${pheno}.regenie.step1_pred.list \
    --bsize 1000 \
    --out ${scratch_dir}/${pheno}/output/${pheno}.${i}.regenie.step2
done
#check that all chromosome run successfully:
#grep "End time" pheno_allasthma.*.regenie.step2.log | wc -l

#merge all assoc file:
zcat ${scratch_dir}/${pheno}/output/${pheno}.1.regenie.step2_${pheno}.regenie.gz | tail -n +2 | \
     awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    > ${scratch_dir}/${pheno}/output/${pheno}_allchr.assoc.txt

for i in $(seq 2 22);
do
    zcat ${scratch_dir}/${pheno}/output/${pheno}.${i}.regenie.step2_${pheno}.regenie.gz | \
    tail -n +2 | awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    >> ${scratch_dir}/${pheno}/output/${pheno}_allchr.assoc.txt
done

#Save the summary stats in /rfs:
cp ${scratch_dir}/${pheno}/output/${pheno}_allchr.assoc.txt ${PATH_DATA}/