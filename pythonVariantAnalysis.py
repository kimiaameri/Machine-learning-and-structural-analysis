import csv
import sys

if len(sys.argv) < 4:
    sys.stderr.write('No Input CSV file and miniconda path GITHUB_PATH\n')
    sys.exit(0)
    
inputFile = sys.argv[1]
minicondaBin = sys.argv[2]
githubPath = sys.argv[3]
outputFile = "trimmomatic.sh"  
with open(outputFile,'w') as outFile:
    outFile.write('#!/bin/sh \n')
    outFile.write('#SBATCH --time=100:00:00   # Run time in hh:mm:ss  \n')
    outFile.write('#SBATCH --mem-per-cpu=64gb  \n')
    # Maximum memory required per CPU (in megabytes')
    outFile.write('#SBATCH --job-name=variantAnalysis \n')
    outFile.write('#SBATCH --error=variantAnalysis.%J.err \n')
    outFile.write('#SBATCH --output=variantAnalysis.%J.out \n')  
    count=0
    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        
        for row in csv_reader:
            if count !=0:
              outFile.write(f' cd $WORK/SNP/Length/\n' )
              outFile.write(f'export LengthReverse=$(( `cat length_filtered_{row[0]}_2.fastq.txt` ))  \n' )
              outFile.write("LengthReverse=${LengthReverse%.*} \n")
              outFile.write(f'{minicondaBin}trimmomatic PE -threads 4 -phred33 -trimlog $WORK/SNP-outputs/trimmomatic/trimlog/{row[0]}.trimlog $WORK/SNP/data/filtered_{row[1]} $WORK/SNP/data/filtered_{row[2]} $WORK/SNP-outputs/trimmomatic/{row[0]}-R1.paired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R1.unpaired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R2.paired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R2.unpaired.fq SLIDINGWINDOW:4:15 MAXINFO:50:0.5 LEADING:3 TRAILING:3 MINLEN:$LengthReverse \n')
              outFile.write(f' cd $WORK/SNP-ouputs/trimmomatic/\n' )
              outFile.write(f'sed "s/\(^[@|\+].*RR[0-9]*\.[0-9]*\)\.[0-9] \(.*\)/\\1 \\2/" {row[0]}-R1.paired.fq > refined-{row[0]}-R1.paired.fq\n')
              outFile.write(f'sed "s/\(^[@|\+].*RR[0-9]*\.[0-9]*\)\.[0-9] \(.*\)/\\1 \\2/" {row[0]}-R2.paired.fq > refined-{row[0]}-R2.paired.fq\n')
              outFile.write(f'{minicondaBin}bwa mem $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/BWAIndex/genome.fa $WORK/SNP-outputs/trimmomatic/refined-{row[0]}-R1.paired.fq $WORK/SNP-outputs/trimmomatic/refined-{row[0]}-R2.paired.fq >$WORK/SNP-outputs/samfiles/{row[0]}.sam\n')
              outFile.write(f'{minicondaBin}/samtools view -bt $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/BWAIndex/genome.fa $WORK/SNP-outputs/samfiles/{row[0]}.sam >$WORK/SNP-outputs/bamfiles/{row[0]}.bam\n')
              outFile.write(f'{minicondaBin}/samtools flagstat $WORK/SNP-outputs/bamfiles/{row[0]}.bam > $WORK/SNP-outputs/flagsam/{row[0]}.flagstat.log\n')
              outFile.write(f'{minicondaBin}/samtools sort $WORK/SNP-outputs/bamfiles/{row[0]}.bam -O bam -o $WORK/SNP-outputs/sortsam/{row[0]}.sorted.bam\n')
              outFile.write(f'{minicondaBin}/samtools stats $WORK/SNP-outputs/sortsam/{row[0]}.sorted.bam >$WORK/SNP-outputs/stats/{row[0]}.txt \n')
              outFile.write(f'{minicondaBin}picard MarkDuplicates I=$WORK/SNP-outputs/sortsam/{row[0]}.sorted.bam O=$WORK/SNP-outputs/picard/{row[0]}.picard.bam M=$WORK/SNP-outputs/picard/picardlog/{row[0]}.picard.log\n')
              outFile.write(f'{minicondaBin}freebayes -f $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/WholeGenomeFasta/genome.fa $WORK/SNP-outputs/picard/{row[0]}.picard.bam >$WORK/SNP-outputs/freebayesoutput/{row[0]}.vcf\n')

            count =count + 1
