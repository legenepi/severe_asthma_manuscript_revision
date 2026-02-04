#!/usr/bin/env Rscript

#Ratioane: add smokign as per u-biopred definition in the pheno-covariate table to be used as covariate for sensitivity analysis.

#Import libraries
suppressMessages(library(tidyverse))
suppressMessages(library(data.table))

args <- commandArgs(T)
path_prefix_1 = args[1]
path_prefix_2 = args[2]

#Read files:
demo_eur <- fread(paste0(path_prefix_1,"demo_EUR_pheno_cov_broadasthma.txt"))

#Smoking status: use the smoking status from the smoking behaviour paper.
#/data/gen1/UKBiobank/Smoking/clean_phenotypes_jan17/ukb648_smoking_behaviour_pheno_covar_270617
smk_status_648 <- fread("/data/gen1/UKBiobank/Smoking/clean_phenotypes_jan17/ukb648_smoking_behaviour_pheno_covar_270617") %>%
                        select(app_id.648,SI) %>% rename(app648 = "app_id.648")
smk_status_648$app648 <- as.character(smk_status_648$app648)

#bridge file, app648 to app56607:
bridge_app648_56607 <- fread("/data/gen1/UKBiobank_500K/severe_asthma/data/bridge_app648_56607",sep=" ",header=T)
colnames(bridge_app648_56607) <- c("app648","app56607")
bridge_app648_56607$app56607 <- as.character(bridge_app648_56607$app56607)
bridge_app648_56607$app648 <- as.character(bridge_app648_56607$app648)
smk_status_56607 <- smk_status_648 %>% left_join(bridge_app648_56607, by="app648") %>% select(-app648)
smk_status_56607 <- smk_status_56607 %>% rename("IID"='app56607')

#merge smoking status into pheno-cov file:
demo_eur$IID <- as.character(demo_eur$IID)
demo_eur <- demo_eur %>% left_join(smk_status_56607, by = "IID")
table(demo_eur$broad_pheno_1_5_ratio,demo_eur$SI, useNA = "always") # visual check values are the same as reported in the manuscript Table1

##save output phenotype-covariate file with smoking status 'SI':
write.table(demo_eur, paste0(path_prefix_2,"demo_EUR_pheno_cov_smokingstatus.txt"),  row.names=F, quote=F, sep="\t", na = "NA")

#run as :
#Rscript src/add_smoking_as_covariate.R "/rfs/TobinGroup/GWAtraits/severe_asthma/" "/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data/"


