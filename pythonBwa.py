import csv
import sys

if len(sys.argv) < 2:
    sys.stderr.write('No Input CSV file \n')
    sys.exit(0)
    

inputFile = sys.argv[1]
minicondaBin = sys.argv[2]
outputFile = "bwa.sh"
with open(outputFile,'w') as outFile:
    outFile.write('#!/bin/sh \n')
    outFile.write('#SBATCH --time=100:00:00   # Run time in hh:mm:ss  \n')
    outFile.write('#SBATCH --mem-per-cpu=64gb  \n')
    # Maximum memory required per CPU (in megabytes')
    outFile.write('#SBATCH --job-name=BWA \n')
    outFile.write('#SBATCH --error=BWA.%J.err \n')
    outFile.write('#SBATCH --output=BWA.%J.out \n') 
    outFile.write('cd $WORK/SNP-outputs/trimmomatic/ \n')  
    outFile.write('mkdir 1 \n')  
    outFile.write('cp $WORK/SNP-outputs/trimmomatic/* $WORK/SNP-outputs/trimmomatic/1/ \n')  
    count =0

    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            if count !=0:
                outFile.write(f'sed -E "s/^((@|\+)ERR[^.]+\.[^.]+)\.(1|2|3|4|5)/\\1/" row[0]-R1.paired.fq > row[0]-R1.paired.fq\n')
                outFile.write(f'sed -E "s/^((@|\+)ERR[^.]+\.[^.]+)\.(1|2|3|4|5)/\\1/" row[0]-R2.paired.fq > row[0]-R2.paired.fq\n')
                outFile.write(f'{minicondaBin}bwa mem $WORK/SNP_reference_genome/Staphylococcus_aureus_NCTC_8325/NCBI/2006-02-13/Sequence/BWAIndex/genome.fa $WORK/SNP-outputs/trimmomatic/{row[0]}-R1.paired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R2.paired.fq >$WORK/SNP-outputs/samfiles/{row[0]}.sam\n')
            count =count+1
