#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SNP
#SBATCH --error=SNP.%J.err
#SBATCH --output=SNP.%J.out

export MINICONDA_HOME="~/miniconda3/envs/snpvaraiant/bin/"
export GITHUB_DIR=`pwd`

#-------------------- make a list for file name

split -l 10 InputFiles.csv new    

cd $WORK
mkdir SNP-outputs
cd $WORK/SNP-outputs
mkdir trimmomatic
cd trimmomatic
mkdir trimlog
cd ../
mkdir bamfiles
mkdir platypus

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


for x in `cat inputs.txt`; do 
python3 pythonVariantAnalysis.py ./$x $MINICONDA_HOME $GITHUB_DIR $x
done
sh SNPS.sh

