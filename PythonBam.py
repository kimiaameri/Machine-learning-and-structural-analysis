import csv
import sys

if len(sys.argv) < 3:
    sys.stderr.write('No Input CSV file and samtools\n')
    sys.exit(0)
    
inputFile = sys.argv[1]
minicondaBin = sys.argv[2]
outputFile = "bam.sh"
with open(outputFile,'w') as outFile:
    outFile.write('#!/bin/sh \n')
    outFile.write('#SBATCH --time=100:00:00   # Run time in hh:mm:ss  \n')
    outFile.write('#SBATCH --mem-per-cpu=64gb  \n')
    # Maximum memory required per CPU (in megabytes')
    outFile.write('#SBATCH --job-name=BAM \n')
    outFile.write('#SBATCH --error=BAM.%J.err \n')
    outFile.write('#SBATCH --output=BAM.%J.out \n')  
    count=0
    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            if count !=0 :
               outFile.write(f'{minicondaBin}/samtools view -bt $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/BWAIndex/genome.fa $WORK/SNP-outputs/samfiles/{row[0]}.sam >$WORK/SNP-outputs/bamfiles/{row[0]}.bam\n')
               outFile.write(f'{minicondaBin}/samtools flagstat $WORK/SNP-outputs/bamfiles/{row[0]}.bam > $WORK/SNP-outputs/flagsam/{row[0]}.flagstat.log\n')
               outFile.write(f'{minicondaBin}/samtools sort $WORK/SNP-outputs/bamfiles/{row[0]}.bam -O bam -o $WORK/SNP-outputs/sortsam/{row[0]}.sorted.bam\n')
               outFile.write(f'{minicondaBin}/samtools stats $WORK/SNP-outputs/sortsam/{row[0]}.sorted.bam >$WORK/SNP-outputs/stats/{row[0]}.txt \n')

            count =count +1
