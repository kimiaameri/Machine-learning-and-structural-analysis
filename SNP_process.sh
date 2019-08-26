#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SNP
#SBATCH --error=SNP.%J.err
#SBATCH --output=SNP.%J.out

export MINICONDA_HOME="~/miniconda3/envs/snpvariant/bin/"
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
mkdir snpEff
cd snpEff
mkdir snpEff-gene
mkdir snpEff-summary
mkdir filtered
cd ../
mkdir samfiles
mkdir bamfiles
mkdir flagsam
mkdir sortsam
mkdir depth
mkdir stats
mkdir picard
mkdir vcffilter-q
mkdir vcffilter-q-dp
mkdir bcfoutput
mkdir freebayesoutput
mkdir intersection
mkdir vcfbed
cd picard
mkdir picardlog
cd $WORK/SNP/
mkdir length


for x in `cat inputs.txt`; do 
python3 pythonVariantAnalysis.py ./$x $MINICONDA_HOME $GITHUB_DIR $x
done
sh SNPS.sh

Rscript depth.R $WORK/SNP-outputs/depth/ $WORK/SNP-outputs/freebayesoutput/ depth.txt quality.txt 
export DEPTH=$(( `cat depth.txt` * 1 ))
export QUALITY=$((`cat quality.txt` * 1 ))
python3 pythonBCF_VCF.py ./InputFiles.csv $MINICONDA_HOME $QUALITY $DEPTH
sh BCF-VCF.sh
python3 pythonSnpEff.py ./InputFiles.csv $MINICONDA_HOME 
sh snpEff.sh
cd $WORK/SNP-outputs/snpEff
for x in *.vcf; do  cat $x | grep -v '##'| sed 's/AB=.*;TYPE=/TYPE=/' > $WORK/SNP-outputs/snpEff/filtered/$x.csv; done
find . -name "*.csv" -size <=1k -delete
