#!/bin/bash

#Regenie Step 1for sensitivity analyses: smoking and BMI

#SBATCH --job-name=regenie1_SI
#SBATCH --cpus-per-task=3
#SBATCH --mem=140G
#SBATCH --time=15:00:00
#SBATCH --export=NONE
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

#the job is called # regenie_BMI when run for BMI as covariate

PATH_DATA="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"
scratch_dir="/scratch/gen1/nnp5/manuscript_revision"
#pheno="broad_pheno_1_5_ratio"
software_path="/home/n/nnp5/software"

#use REGENIE v2.2.4 as used for the discovery GWAS:
#wget https://github.com/rgcgithub/regenie/releases/download/v2.2.4/regenie_v2.2.4.gz_x86_64_Linux_mkl.zip
#unzip regenie_v2.2.4.gz_x86_64_Linux_mkl.zip

#For BMI covariate:
#${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
#  --step 1 \
#  --bed ${scratch_dir}/ukb_cal_allchr_v2 \
#  --extract ${scratch_dir}/ukb_cal_allchr_eur_qc.snplist \
#  --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
#  --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_broadasthma.txt \
#  --phenoCol ${pheno} \
#  --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_broadasthma.txt \
#  --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,BMI \
#  --bt \
#  --bsize 1000 \
#  --loocv \
#  --threads 4 \
#  --gz \
#  --out ${scratch_dir}/BMI_${pheno}.regenie.step1

#For Smoking status (SI column) covariate:
#${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
#  --step 1 \
#  --bed ${scratch_dir}/ukb_cal_allchr_v2 \
#  --extract ${scratch_dir}/ukb_cal_allchr_eur_qc.snplist \
#  --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
#  --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_smokingstatus.txt \
#  --phenoCol ${pheno} \
#  --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_smokingstatus.txt \
#  --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,SI \
#  --bt \
#  --bsize 1000 \
#  --loocv \
#  --threads 4 \
#  --gz \
#  --out ${scratch_dir}/SI_${pheno}.regenie.step1

#For All asthma vs controls:
pheno="pheno_allasthma"
${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
  --step 1 \
  --bed ${scratch_dir}/ukb_cal_allchr_v2 \
  --extract ${scratch_dir}/ukb_cal_allchr_eur_qc.snplist \
  --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
  --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_allasthma.txt \
  --phenoCol ${pheno} \
  --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_allasthma.txt \
  --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex \
  --bt \
  --bsize 1000 \
  --loocv \
  --threads 4 \
  --gz \
  --out ${scratch_dir}/${pheno}.regenie.step1