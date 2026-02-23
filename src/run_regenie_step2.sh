#!/bin/bash

#Run regenie step 2

#SBATCH --job-name=regenie2_saVSotherashtma
#SBATCH --cpus-per-task=3
#SBATCH --mem=150G
#SBATCH --time=34:00:00
#SBATCH --export=NONE
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err


i=$SLURM_ARRAY_TASK_ID
PATH_DATA="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data"
scratch_dir="/scratch/gen1/nnp5/manuscript_revision"
sample_DIR="/data/gen1/UKBiobank_500K/severe_asthma/data"
pheno="pheno_sa_otherashtma"
software_path="/home/n/nnp5/software"
mkdir ${scratch_dir}/${pheno}
mkdir ${scratch_dir}/${pheno}/output


${software_path}/regenie_v2.2.4.gz_x86_64_Linux_mkl \
  --step 2 \
  --bgen /data/ukb/imputed_v3/ukb_imp_chr${i}_v3.bgen \
  --ref-first \
  --sample ${sample_DIR}/ukbiobank_app56607_for_regenie.sample \
  --keep ${scratch_dir}/ukb_cal_allchr_eur_qc.id \
  --phenoFile ${PATH_DATA}/demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt \
  --phenoCol ${pheno} \
  --covarFile ${PATH_DATA}/demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt \
  --covarColList age_at_recruitment,age2,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,genetic_sex,age_onset_merge \
  --bt \
  --gz \
  --threads 4 \
  --minMAC 10 \
  --minINFO 0.3 \
  --firth --approx --pThresh 0.01 \
  --pred ${scratch_dir}/${pheno}.regenie.step1_pred.list \
  --bsize 1000 \
  --out ${scratch_dir}/${pheno}/output/${pheno}.${i}.regenie.step2

#run as: sbatch -A gen1 -a 1-22 /rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src/run_regenie_step2.sh
#to check that it is ended correctly: grep "End time" R-regenie2_saVSotherashtma.*.out | wc -l