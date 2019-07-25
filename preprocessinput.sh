#!/bin/sh
#SBATCH --job-name=SRAtoolkit
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=168:00:00
#SBATCH --mem=10gb
#SBATCH --output=SRAtoolkit.%J.out
#SBATCH --error=SRAtoolkit.%J.err

for fastq in *.fastq
do
 awk 'BEGIN {FS = "\t" ; OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >20) {print header, seq, qheader, qseq}}' < $fastq > filtered_$fastq
done

find . -name "*.fastq" -size 0k -delete


