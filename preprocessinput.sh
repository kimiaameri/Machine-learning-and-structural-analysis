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


#mkdir length
#for fastq in *_2.fastq
#do
#  cat  $fastq | grep -o "length=.*$" | cut -f2 -d'=' > ../length/$fastq.txt
#done
#cd ../length/
#for fastq in filtered_*.txt
#do
 #   awk '{ total += $1; count++ } END { print total/count }'  $fastq >length_$fastq
#done
