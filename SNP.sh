#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SNP
#SBATCH --error=SNP.%J.err
#SBATCH --output=SNP.%J.out
####  Download reference genome    ####

export MINICONDA_HOME="~/miniconda3/envs/sanva/bin/"
export GITHUB_DIR=`pwd`

cd $WORK/
mkdir SNP_reference_genome
cd SNP_reference_genome
wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz
tar -xzf Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz
rm Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz

module load R
cd $WORK
mkdir SNP-outputs
cd SNP-outputs
######## Input file #########
cd $WORK/SNP
Rscript inputFile.R $GITHUB_DIR/data $GITHUB_DIR/InputFiles.csv
######## Trimmomatic #########
## make trimmomatic directory
cd $WORK/SNP-outputs
mkdir trimmomatic
cd trimmomatic
mkdir trimlog
cd $WORK/SNP
#### for SNP if there is no adapter
python3 pythonTrimmomaticNoadapter.py ./InputFiles.csv $MINICONDA_HOME $GITHUB_DIR
##### For SNP if there is adapter
#python3 pythonTrimmomatic.py ../InputFiles.csv $MINICONDA_HOME $GITHUB_DIR

sh trimmomatic.sh > $WORK/SNP-outputs/trimmomatic.log
#### For BWA
cd $WORK/SNP-outputs
mkdir samfiles
cd $WORK/SNP
python3 pythonBwa.py ./InputFiles.csv $MINICONDA_HOME
sh bwa.sh
