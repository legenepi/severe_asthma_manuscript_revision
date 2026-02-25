#!/usr/bin/env Rscript
#Ratioanale: check that reported sex and genetic sex match

library(tidyverse)
library(data.table)

demo <- fread("/rfs/TobinGroup/GWAtraits/severe_asthma/demo_EUR_pheno_cov_broadasthma.txt") %>% select(sex_sample_file,genetic_sex,broad_pheno_1_5_ratio)
demo <- na.omit(demo)
print("Case/control cohort size")
table(demo$broad_pheno_1_5_ratio)
print("Case/control cohort compare reported sex and genetic sex:")
table(demo$sex_sample_file,demo$genetic_sex)
print("Case/control cohort compare reported sex and genetic sex by case/control status:")
table(demo$sex_sample_file,demo$genetic_sex,demo$broad_pheno_1_5_ratio)

#Run as: Rscript /rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src/sex_check.R > /rfs/TobinGroup/GWAtraits/severe_asthma/Manuscript_review/sex_check.txt
