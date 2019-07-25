for fastq in *.fastq
do
 awk 'BEGIN {FS = "\t" ; OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >8) {print header, seq, qheader, qseq}}' < $fastq > filtered_$fastq
done

find . -name "*.fastq" -size 0k -delete


