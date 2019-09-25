#!/bin/sh
#SBATCH --time=100:00:00   # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=64gb     # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=SNP
#SBATCH --error=SNP.%J.err
#SBATCH --output=SNP.%J.out

export MINICONDA_HOME="~/miniconda3/envs/snpvariant/bin/"
export GITHUB_DIR=`pwd`

#-------------------- make the directories

sh makedirectories.sh
#-------------------- Download reference genome

cd SNP_reference_genome
wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz
tar -xzf Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz
rm Staphylococcus_aureus_NCTC_8325_NCBI_2006-02-13.tar.gz

#-------------------- make the inputfile list
Rscript fileName.R $GITHUB_DIR/data $GITHUB_DIR/Listdata.csv

split -l 30 Listdata.csv InputFile

for x in InputFile*; do 
python3 pythonVariantAnalysis.py ./$x $MINICONDA_HOME $GITHUB_DIR $x
done
sh SNPS.sh
python3 pythonsnpEff.py ./Listdata.csv $MINICONDA_HOME $WORK/SNP-outputs
sh snpEffMerge.sh


cd $WORK/SNP-outputs/snpEff
for x in *.vcf; do  cat $x | grep -v '##'| sed 's/AB=.*;TYPE=/TYPE=/' > $WORK/SNP-outputs/snpEff/filtered/$x; done
find . -name "*.csv" -size 1k -delete
###############               merge all files together,remove headers and sort based on positions      #########
cd $WORK/SNP-outputs/snpEff/filtered/
for x in *.vcf; do  cat $x | sort -k2,2 | grep -v '##' >$WORK/SNP-outputs/snpEff/filtered/$x;done
for x in quality*.filtered.vcf; do cat $x |cut -f 1 -d ":"  > /work/biocore/kimia/SNP-outputs/snpEff/filtered/$x; done

#------------- make SNP matrix ------------------------------#
Rscript SNP_Matrix.R $WORK/SNP-outputs/snpEff/1/merge/ $WORK/SNP-outputs/snpEff/filtered/ $WORK/SNP-outputs/snpCoreMatrix.csv
#---------------------------- For Snippy ---------------------#
cd $WORK/snippy
split -l 300 Listdata.csv InputFile

for x in InputFile*; do 
snippy-multi ./$x --ref ../SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/WholeGenomeFasta/genome.fa --cpus 64 > runme$x.sh
done

for x in *.vcf; do  cat $x | grep -v '##' >$WORK/snippy1/newsnp/$x.csv;done


for x in InputFile*; do 
python3 pythonSnippy.py ./$x  $GITHUB_DIR $x
done
