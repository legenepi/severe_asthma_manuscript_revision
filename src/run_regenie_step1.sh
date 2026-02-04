#!/bin/bash

#Regenie Step 1

#SBATCH --job-name=regenie1
#SBATCH --cpus-per-task=3
#SBATCH --mem=140G
#SBATCH --time=15:00:00
#SBATCH --export=NONE
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err



PATH_DATA="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"
scratch_dir="/scratch/gen1/nnp5/manuscript_revision"
pheno="pheno_sa_otherashtma"
software_path="/home/n/nnp5/software"

#use REGENIE v2.2.4 as used for the discovery GWAS:
#wget https://github.com/rgcgithub/regenie/releases/download/v2.2.4/regenie_v2.2.4.gz_x86_64_Linux_mkl.zip
#unzip regenie_v2.2.4.gz_x86_64_Linux_mkl.zip

${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
  --step 1 \
  --bed ${scratch_dir}/ukb_cal_allchr_v2 \
  --extract ${scratch_dir}/ukb_cal_allchr_eur_qc.snplist \
  --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
  --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt \
  --phenoCol ${pheno} \
  --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt \
  --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,age_onset_merge \
  --bt \
  --bsize 1000 \
  --loocv \
  --threads 4 \
  --gz \
  --out ${scratch_dir}/${pheno}.regenie.step1