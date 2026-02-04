#!/bin/env/bash

#Rationale: do a GWAS of severe asthma cases VS all-other asthma.

src_path="/rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src"

#Create input table:
##exclude people who exacerbate in the all-other asthma:
##add age at onset as covariate, in addition to the other covariates (genetic sex, age at recruitment, age at recruitment^2, 10PCs):
##custom prefix for path for the data:
Rscript ${src_path}/pheno_cov_sevasthmaVSallotherasthma.R "prefix_path_1" "prefix_path_2"

#GWAS:
sbatch ${src_path}/plink_QC_eur.sh
sbatch ${src_path}/run_regenie_step1.sh #running this at the moment
sbatch -a 1-22 ${src_path}/run_regenie_step2.sh

#Post GWAS:
