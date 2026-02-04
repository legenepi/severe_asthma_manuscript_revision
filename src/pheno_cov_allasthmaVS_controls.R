#!/usr/bin/env Rscript

#Create a phenotype of ALL asthma as cases and healthy controls

#Import libraries
suppressMessages(library(tidyverse))
suppressMessages(library(data.table))

args <- commandArgs(T)
path_prefix_1 = args[1]
path_prefix_2 = args[2]


#path_prefix_1 = "/rfs/TobinGroup/GWAtraits/severe_asthma/"
#path_prefix_2 = "/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"


#Read files:
demo_eur <- fread(paste0(path_prefix_1,"demo_EUR_pheno_cov_broadasthma.txt"))
asthma_diag <- fread(paste0(path_prefix_2,"Eid_intersection_asthma_diagnosis_ATLEAST_1_evidence.txt"),header=F)
asthma_diag <- asthma_diag %>% rename("IID" = 'V1')
controls <- fread(paste0(path_prefix_2,"Eid_control_respiratoryfree.txt"))
controls <- controls %>% rename("IID"="V1")

controls$IID <- as.character(controls$IID)
demo_eur$IID <- as.character(demo_eur$IID)
asthma_diag$IID <- as.character(asthma_diag$IID)

#add asthma diagnosis:
asthma_diag$yes_asthma <- as.factor(1)
demo_eur <- demo_eur %>% left_join(asthma_diag, by = "IID")

#add controls:
controls$controls_checked <- as.factor(0)
demo_eur <- demo_eur %>% left_join(controls, by = "IID")

#Create phenotype column (if severe asthma == 1 or asthma_diag == 1, 1, else, NA):
demo_eur <- demo_eur %>%
  mutate(
    pheno_allasthma = case_when(
      broad_pheno_1_5_ratio == 1 | yes_asthma == 1 ~ 1,
      controls_checked == 0 ~ 0,
      TRUE ~ NA_real_
    )
  )

table(demo_eur$pheno_allasthma, useNA = "always") # check that it is the expected number
##save output phenotype-covariate file:
write.table(demo_eur, paste0(path_prefix_2,"demo_EUR_pheno_cov_allasthma.txt"),  row.names=F, quote=F, sep="\t", na = "NA")

#run as :
#Rscript src/pheno_cov_allasthmaVS_controls.R "/rfs/TobinGroup/GWAtraits/severe_asthma/" "/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"



