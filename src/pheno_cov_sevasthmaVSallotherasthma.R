#!/usr/bin/env Rscript

#Rationale: create phenotype and covariate for REGENIE for GWAS severe-asthma VS all-other-asthma. We also exclude all-other asthma with exacerbxation.

#Import libraries
suppressMessages(library(tidyverse))
suppressMessages(library(data.table))

args <- commandArgs(T)
path_prefix_1 = args[1]
path_prefix_2 = args[2]

#Read files:
demo_eur <- fread(paste0(path_prefix_1,"demo_EUR_pheno_cov_broadasthma.txt"))
asthma_diag <- fread(paste0(path_prefix_2,"Eid_intersection_asthma_diagnosis_ATLEAST_1_evidence.txt"),header=F)
exacerbation <- fread(paste0(path_prefix_2,"Exacerbation_status_app55607_eid.txt"))

#Create phenotype column (if severe asthma = 1; if asthma and not severe asthma = 0):
##add asthma diagnosis:
asthma_diag$yes_asthma <- as.factor(1)
asthma_diag <- asthma_diag %>% rename("IID" = 'V1')
demo_eur <- demo_eur %>% left_join(asthma_diag, by = "IID")
##convert healthy control into 'NA'
demo_eur <- demo_eur %>% mutate(pheno_sa_otherashtma = ifelse(demo_eur$broad_pheno_1_5_ratio == 0, NA, broad_pheno_1_5_ratio))
summary(as.factor(demo_eur$pheno_sa_otherashtma)) # check that it is the expected number


##assign status of control ('0') to all other asthma - European:
demo_eur <- demo_eur %>% mutate(pheno_sa_otherashtma = if_else(is.na(pheno_sa_otherashtma) & yes_asthma == 1, 0, pheno_sa_otherashtma))
table(demo_eur$pheno_sa_otherashtma, useNA = "always") # check that it is the expected number

##filter out people with exacerbation:
exacerbation <- exacerbation %>% rename('IID' = "ID_1")
demo_eur_exacerbation <- demo_eur %>% left_join(exacerbation, by = "IID")
table(demo_eur_exacerbation$pheno_sa_otherashtma, demo_eur_exacerbation$AnyExac, useNA = "always") # print the categories
demo_eur_exacerbation <- demo_eur_exacerbation %>% mutate(pheno_sa_otherashtma = if_else(AnyExac == 1 & pheno_sa_otherashtma == 0, NA, pheno_sa_otherashtma))
table(demo_eur_exacerbation$pheno_sa_otherashtma, demo_eur_exacerbation$AnyExac, useNA = "always") # visual check that there is no controls with exacerbation

##age at onset as covariate - check that case and control have this information:
table(demo_eur_exacerbation$pheno_sa_otherashtma, demo_eur_exacerbation$age_onset_merge, useNA = "always")
##need to exclude case and control without age at onset information:
demo_eur_exacerbation <- demo_eur_exacerbation %>% mutate(pheno_sa_otherashtma = if_else(!is.na(age_onset_merge), pheno_sa_otherashtma, NA))
table(demo_eur_exacerbation$pheno_sa_otherashtma, demo_eur_exacerbation$age_onset_merge, useNA = "always") # check again the number as as expected:
#6053 cases and 26938 controls:
table(demo_eur_exacerbation$pheno_sa_otherashtma)

##save output phenotype-covariate file:
write.table(demo_eur_exacerbation, paste0(path_prefix_2,"demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt"),  row.names=F, quote=F, sep="\t", na = "NA")

#run as :
#Rscript src/pheno_cov_sevasthmaVSallotherasthma.R "/rfs/TobinGroup/GWAtraits/severe_asthma/" "/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"

