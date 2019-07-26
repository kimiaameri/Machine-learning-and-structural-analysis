#!/bin/sh
#SBATCH --job-name=SRAtoolkit
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=168:00:00
#SBATCH --mem=10gb
#SBATCH --output=SRAtoolkit.%J.out
#SBATCH --error=SRAtoolkit.%J.err

module load SRAtoolkit/2.9

for x in `cat SraAccList.txt`; do 
fastq-dump --split-files $x ;  
sleep 5;
done
