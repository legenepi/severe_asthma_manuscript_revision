#!/bin/bash

#QC file to run regenie step 1

#SBATCH --job-name=qc_plink
#SBATCH --cpus-per-task=3
#SBATCH --mem=140G
#SBATCH --time=02:00:00
#SBATCH --export=NONE

PATH_DATA="/data/gen1/UKBiobank_500K/severe_asthma/Noemi_PhD/data"
geno_dir="/data/ukb/genotyped"
scratch_dir="/scratch/gen1/nnp5/manuscript_revision"

#to create list of eur ids
#awk {'print $1, $2'} ${PATH_DATA}/demo_EUR_pheno_cov_SAvsOtherAsthma_noexacerbation.txt | tail -n +2 > ${scratch_dir}/ukb_eur_ids

#cp from /rfs to my scratch the .fam
#cp /rfs/TobinGroup/data/UKBiobank/application_56607/ukb56607_cal_chr1_v2_s488239.fam ${scratch_dir}/

#rm ${scratch_dir}/list_plink_files
#for chr in {2..22}
#do echo "${geno_dir}/ukb_cal_chr${chr}_v2.bed ${geno_dir}/ukb_cal_chr${chr}_v2.bim ${scratch_dir}/ukb56607_cal_chr1_v2_s488239.fam" \
#     >> ${scratch_dir}/list_plink_files
#done

module load plink
plink --bed ${geno_dir}/ukb_cal_chr1_v2.bed \
	--bim ${geno_dir}/ukb_cal_chr1_v2.bim \
	--fam ${scratch_dir}/ukb56607_cal_chr1_v2_s488239.fam \
	--merge-list ${scratch_dir}/list_plink_files \
	--make-bed --out ${scratch_dir}/ukb_cal_allchr_v2 &&

awk '{print $1, $1}' ${PATH_DATA}/Eid_withdrawn_participants_upFeb2022.txt \
    > ${scratch_dir}/ukb_withdrawns_ids &&

module load plink2
plink2 --bfile ${scratch_dir}/ukb_cal_allchr_v2 \
	--maf 0.01 --mac 100 --geno 0.1 --hwe 1e-15 \
	--keep ${scratch_dir}/ukb_eur_ids \
	--remove ${scratch_dir}/ukb_withdrawns_ids \
	--mind 0.1 \
	--write-snplist --write-samples --no-id-header \
	--out ${scratch_dir}/ukb_cal_allchr_eur_qc