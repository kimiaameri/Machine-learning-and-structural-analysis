##!/bin/sh
#SBATCH --job-name=process
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=168:00:00
#SBATCH --mem=10gb
#SBATCH --output=process.%J.out
#SBATCH --error=process.%J.err

#for fastq in *.fastq
#do
 #awk 'BEGIN {FS = "\t" ; OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >25) {print header, seq, qheader, qseq}}' < $fastq > filtered_$fastq
#done

#find . -name "*.fastq" -size 0k -delete

#for x in `cat unpaird.finallist.isolates.txt`; do 
#find . -name "filtered_$x*"  -delete
#done
#for x in `cat SRA.removed.txt`; do 
#find . -name "filtered_$x*"  -delete
#done


#-------------------download and install Stamphy ---------------------------#
wget https://005.medsci.ox.ac.uk/files-library/stampy-latest.tgz 
tar zxvf stampy-latest.tgz
rm stampy-latest.tgz
cd stampy-1.0.32 
 
make python=python2.7

./stampy.py -G sa $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/BWAIndex/genome.fa.gz
./stampy.py -g sa -H sa

cd $WORK/SNP-outputs
mkdir stampy
