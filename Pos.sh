#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SAVEA
#SBATCH --error=SAVEA.%J.err
#SBATCH --output=SAVEA.%J.out
cd $WORK/SNP-outputs/snpEff/filtered/
cut -f1 cut_filtered*.vcf | sort -n | uniq | grep -v POS > $WORK/SNP-outputs/uniq.pos.txt
