#!/bin/bash

#Post GWAS results analyses - qq plot, manhattan and ldsc, and create OR.

#SBATCH --job-name=post_gwas_asthma_savaallotherasthma
#SBATCH --cpus-per-task=3
#SBATCH --mem=140G
#SBATCH --time=3:00:00
#SBATCH --export=NONE
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err



#Set variables:
PATH_OUT="/scratch/gen1/nnp5/manuscript_revision"
PHENO="pheno_sa_otherashtma"

#N of individuals, to change:
tot_n=32991

#mkdir ${PATH_OUT}/output/
#mkdir ${PATH_OUT}/output/allchr
GWAS="/scratch/gen1/nnp5/manuscript_revision/output/allchr"


merge all assoc file:
zcat ${PATH_OUT}/${PHENO}.1.regenie.step2_${PHENO}.regenie.gz | tail -n +2 | \
     awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    > ${GWAS}/${PHENO}_allchr.assoc.txt

for i in {2..22}
    do zcat ${PATH_OUT}/${PHENO}.${i}.regenie.step2_${PHENO}.regenie.gz | \
    tail -n +2 | awk -F " " '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' \
    >> ${GWAS}/${PHENO}_allchr.assoc.txt
done

gzip ${GWAS}/${PHENO}_allchr.assoc.txt

#create input ldsc file both for all vars and maf >= 0.01.

module load R
chmod o+x /rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src/create_input_munge_summary_stats.R
dos2unix /rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src/create_input_munge_summary_stats.R
Rscript /rfs/TobinGroup/GWAtraits/severe_asthma/severe_asthma_manuscript_revision/src/create_input_munge_summary_stats.R \
    ${GWAS}/${PHENO}_allchr.assoc.txt.gz \
    ${PHENO}

#LDSC interactively.
#The results are the same for set with all vars and fitlered maf 0.01., because LDSC uses only vars > 0.01. So run
#on the filtered set
#cd /home/n/nnp5/software/ldsc
#conda activate ldsc

PHENO="maf001_pheno_sa_otherashtma"

#awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}' ${PATH_OUT}/${PHENO}_betase_input_mungestat \
#    > ${PATH_OUT}/${PHENO}_betase_input_mungestat_clean

#interactively:
#/home/n/nnp5/software/ldsc/munge_sumstats.py \
#--sumstats ${PATH_OUT}/${PHENO}_betase_input_mungestat_clean \
#--N ${tot_n}   \
#--out ${PATH_OUT}/${PHENO}_allchr_step2_regenie \
#--merge-alleles /data/gen1/UKBiobank/Smoking/Meta_Analysis_AWI_UGR_UKBAFR/files/w_hm3.snplist \
#--chunksize 500000

#/home/n/nnp5/software/ldsc/ldsc.py \
#--h2 ${PATH_OUT}/${PHENO}_allchr_step2_regenie.sumstats.gz \
#--ref-ld-chr /data/gen1/reference/ldsc/eur_w_ld_chr/ \
#--w-ld-chr /data/gen1/reference/ldsc/eur_w_ld_chr/ \
#--out ${PATH_OUT}/${PHENO}_allchr_step2_regenie_h2

#conda deactivate
#cd /home/n/nnp5/PhD/PhD_project/REGENIE_assoc/

#Plots:
ldsc_intercept=????

#run Manhattan, qqplot, lambda for vars with maf >= 0.01:
module unload R/4.2.1
module load R/4.1.0
chmod o+x src/REGENIE_plots.R
dos2unix src/REGENIE_plots.R
Rscript src/REGENIE_plots.R \
    ${PATH_OUT}/${PHENO}_betase_input_mungestat \
    ${PHENO}_${test_type} \
    ${ldsc_intercept}

#extract only genome-wide significant variants:
#awk -F "\t" '$9 <= 0.00000005 {print $0}' ${PATH_OUT}/${PHENO}_betase_input_mungestat \
#    > ${PATH_OUT}/${PHENO}_genomewide_signif

#Sentinel selection:
#module unload R/4.2.1
#module load R/4.1.0
#chmod o+x src/sentinel_selection.R
#dos2unix src/sentinel_selection.R
#Rscript src/sentinel_selection.R \
#    ${PATH_OUT}/${PHENO}_betase_input_mungestat \
#    ${PHENO} \
#    500000 \
#    0.00000005 \
#    ${test_type}

#create OddsRatio and direction of effect using Create_oddsratio.R
#Rscript src/broad_phenotype/Create_oddsratio.R ${PATH_OUT}/${PHENO}${test_type}_sentinel_variants.txt ${PATH_OUT}/${PHENO}_sentinel_variants_OR.txt