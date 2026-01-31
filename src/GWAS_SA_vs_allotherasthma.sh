#!/bin/env/bash

#Rationale: do a GWAS of severe asthma cases VS all-other asthma.

#Create input table:
##exclude people who exacerbate in the all-other asthma:
##add age at onset as covariate, in addition to the other covariates (genetic sex, age at recruitment, age at recruitment^2, 10PCs):
##custom prefix for path for the data:
Rscript src/pheno_cov_sevasthmaVSallotherasthma.R "prefix_path_1" "prefix_path_2"

#Genotype data:
