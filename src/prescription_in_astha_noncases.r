#!/usr/bin/env Rscript
#Rationale: how many asthma non-cases with prescription records ?

library(tidyverse)
library(data.table)


path_prefix_1 = "/rfs/TobinGroup/GWAtraits/severe_asthma/"
path_prefix_2 = "/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"

demo_eur <- fread(paste0(path_prefix_1,"demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt"))

#scripts:
scripts <- fread("/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/UKBiobank_datafields/data/Eid_gp_scripts_edit.txt")
scripts <- scripts %>% rename("IID" = 'V1')
scripts$scripts <- as.factor("script")
demo_eur <- demo_eur %>% left_join(scripts, by = "IID")
table(demo_eur$scripts,demo_eur$yes_asthma)
table(demo_eur$scripts,demo_eur$yes_asthma,demo_eur$broad_pheno_1_5_ratio)
print("asthma non-cases with prescription: 35263 - 5783")
35263 - 5783
#29480