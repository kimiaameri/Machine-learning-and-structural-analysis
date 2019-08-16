#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SNP
#SBATCH --error=SNP.%J.err
#SBATCH --output=SNP.%J.out


export MINICONDA_HOME="~/miniconda3/envs/sanva/bin/"
export GITHUB_DIR=`pwd`
module load R
cd $WORK
mkdir SNP-outputs
cd $WORK/SNP-outputs
mkdir trimmomatic
cd trimmomatic
mkdir trimlog
cd ../
mkdir samfiles
mkdir bamfiles
mkdir flagsam
mkdir sortsam
mkdir depth
mkdir stats
mkdir picard
mkdir freebayesoutput
cd picard
mkdir picardlog
cd $WORK/SNP/
mkdir length
#-------------------- create file name
Rscript fileName.R $GITHUB_DIR/data $GITHUB_DIR/InputFiles.csv
split -l 10 InputFiles.csv new    
rename -n  's/new/inputfilemm' new*

for x in `cat inputs.txt`; do 
python3 pythonVariantAnalysis.py ./$x $MINICONDA_HOME $GITHUB_DIR $x

done
