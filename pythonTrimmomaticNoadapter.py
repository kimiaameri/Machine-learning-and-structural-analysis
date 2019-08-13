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
    outFile.write('#SBATCH --job-name=Trim \n')
    outFile.write('#SBATCH --error=Trim.%J.err \n')
    outFile.write('#SBATCH --output=Trim.%J.out \n')  
    count=0
    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        
        for row in csv_reader:
            if count !=0:
              outFile.write(f' cd $WORK/SNP/Length/\n' )
              outFile.write(f'export LengthReverse=$(( `cat length_filtered_{row[0]}_2.fastq.txt` ))  \n' )
              outFile.write("LengthReverse=${LengthReverse%.*} \n")
              outFile.write(f'{minicondaBin}trimmomatic PE -threads 4 -phred33 -trimlog $WORK/SNP-outputs/trimmomatic/trimlog/{row[0]}.trimlog $WORK/SNP/data/filtered_{row[1]} $WORK/SNP/data/filtered_{row[2]} $WORK/SNP-outputs/trimmomatic/{row[0]}-R1.paired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R1.unpaired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R2.paired.fq $WORK/SNP-outputs/trimmomatic/{row[0]}-R2.unpaired.fq SLIDINGWINDOW:4:15 MAXINFO:50:0.5 LEADING:3 TRAILING:3 MINLEN:$LengthReverse \n')
            count =count + 1
 
