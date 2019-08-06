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
    outFile.write('#SBATCH --job-name=stampy \n')
    outFile.write('#SBATCH --error=stampy.%J.err \n')
    outFile.write('#SBATCH --output=stampy.%J.out \n')  
    count=0
    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        
        for row in csv_reader:
            if count !=0:
               outFile.write(f'./stampy.py -g sa -h sa -M $WORK/SNP/data/{row[0]}_1.fastq $WORK/SNP/data/{row[0]}_2.fastq -o -f $WORK/SNP-outputs/stampy/{row[0]}.sam \n')
            count =count + 1

