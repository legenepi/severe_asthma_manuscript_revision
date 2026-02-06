#!/usr/bin/env Rscript

#Scatter plot effect size of the 68 sentinel variants between the discovery GWAS and the sensitivity analysis with
#BMI or SI as covariate

#in bash:
#grep -w -F -f /rfs/TobinGroup/nnp5/data/sugg_68_sentinels.txt /rfs/TobinGroup/nnp5/data/maf001_broad_pheno_1_5_ratio_betase_input_mungestat  | \
#    grep -v "CAA" \
#    > /scratch/gen1/nnp5/manuscript_revision/68sentvars_gwas

#In R:
suppressMessages(library(tidyverse))
suppressMessages(library(data.table))
library(readxl)
library(cowplot) # it allows you to save figures in .png file
library(smplot2)
library(ggpubr)
library("ggrepel")

#input file:
gwas <- fread("/scratch/gen1/nnp5/manuscript_revision/68sentvars_gwas") %>% select(V1, V6)
colnames(gwas) <- c("snpid", "logodds_gwas")

##BMI as covariate:
BMI <- fread("/scratch/gen1/nnp5/manuscript_revision/BMI_broad_pheno_1_5_ratio/output/BMI_broad_pheno_1_5_ratio_allchr.assoc.txt") %>% select(V3, V10)
colnames(BMI) <- c("snpid", "logodds_BMI")
BMI$snpid <- as.character(BMI$snpid)
df_plot <- gwas %>% left_join(BMI, by = "snpid")
df_plot$logOR_diff <- abs(df_plot$logodds_gwas - df_plot$logodds_BMI)


png("/rfs/TobinGroup/GWAtraits/severe_asthma/Manuscript_review/BMI_covariate_discGWAS_68suggestive_effectsize_comparison.png",units="in", width=10, height=10, res=800)
ggplot(data = df_plot, aes(x = logodds_BMI, y = logodds_gwas)) +
  sm_statCorr(color = "black", corr_method = "pearson", text_size = 3, size = 0.5) +
  geom_abline(intercept = 0, slope = 1, color = "grey", size = 0.25, linetype = "dashed") +
  geom_smooth(method="lm") +
  geom_point(data = df_plot, aes(x = logodds_BMI,color="#D55E00",size=0.15)) +
  theme_minimal() + geom_vline(xintercept = 0, linetype="dashed", color = "grey", size = 0.25) +
  geom_hline(yintercept = 0, linetype="dashed", color="grey", size = 0.5) +
  ylim(-0.8, +0.5) + xlim(-0.8, + 0.5) +
  xlab("Beta (Sensitivity BMI covariate)") + ylab("Beta (Discovery)") +
  geom_text_repel(
    data = subset(df_plot, logOR_diff >= 0.1 ),
    aes(label = snpid),
    size = 5,
    box.padding = unit(0.35, "lines"),
    point.padding = unit(0.3, "lines")) +
  theme(legend.position="none")
dev.off()


##SI as covariate:
SI <- fread("/scratch/gen1/nnp5/manuscript_revision/SI_broad_pheno_1_5_ratio/output/SI_broad_pheno_1_5_ratio_allchr.assoc.txt") %>% select(V3, V10)
colnames(SI) <- c("snpid", "logodds_SI")
SI$snpid <- as.character(SI$snpid)
df_plot <- gwas %>% left_join(SI, by = "snpid")
df_plot$logOR_diff <- abs(df_plot$logodds_gwas - df_plot$logodds_SI)


png("/rfs/TobinGroup/GWAtraits/severe_asthma/Manuscript_review/SI_covariate_discGWAS_68suggestive_effectsize_comparison.png",units="in", width=10, height=10, res=800)
ggplot(data = df_plot, aes(x = logodds_SI, y = logodds_gwas)) +
  sm_statCorr(color = "black", corr_method = "pearson", text_size = 3, size = 0.5) +
  geom_abline(intercept = 0, slope = 1, color = "grey", size = 0.25, linetype = "dashed") +
  geom_smooth(method="lm") +
  geom_point(data = df_plot, aes(x = logodds_SI,color="#D55E00",size=0.15)) +
  theme_minimal() + geom_vline(xintercept = 0, linetype="dashed", color = "grey", size = 0.25) +
  geom_hline(yintercept = 0, linetype="dashed", color="grey", size = 0.5) +
  ylim(-0.8, +0.5) + xlim(-0.8, + 0.5) +
  xlab("Beta (Sensitivity smoking status covariate)") + ylab("Beta (Discovery)") +
  geom_text_repel(
    data = subset(df_plot, logOR_diff >= 0.1 ),
    aes(label = snpid),
    size = 5,
    box.padding = unit(0.35, "lines"),
    point.padding = unit(0.3, "lines")) +
  theme(legend.position="none")
dev.off()