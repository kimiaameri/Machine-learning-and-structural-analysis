import csv
import sys

if len(sys.argv) < 4:
    sys.stderr.write('No Input CSV file and samtools\n')
    sys.exit(0)
    
inputFile = sys.argv[1]
minicondaBin = sys.argv[2]
n= sys.argv[3]
index = n.split('.')[0][10:]
outputFile ="snpEff{}.sh".format(index)
with open(outputFile,'w') as outFile:
    outFile.write('#!/bin/sh \n')
    outFile.write('#SBATCH --time=100:00:00   # Run time in hh:mm:ss  \n')
    outFile.write('#SBATCH --mem-per-cpu=64gb  \n')
    # Maximum memory required per CPU (in megabytes')
    outFile.write('#SBATCH --job-name=snpEff \n')
    outFile.write('#SBATCH --error=snpEff.%J.err \n')
    outFile.write('#SBATCH --output=snpEff.%J.out \n')  
    outFile.write('sed -i \'s/^chr/Chromosome/\' $WORK/SNP-outputs/bcfoutput/*.vcf;\n')

    count=0
    with open(inputFile) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            outFile.write(f'{minicondaBin}snpEff -v Staphylococcus_aureus_subsp_aureus_nctc_8325 $WORK/SNP-outputs/bcfoutput/{row[0]}.vcf > $WORK/SNP-outputs/snpEff/{row[0]}.ann.vcf \n')
            outFile.write('mv $WORK/SNP/snpEff_genes.txt $WORK/SNP-outputs/snpEff/snpEff-gene/{row[0]}.txt \n')
            outFile.write('mv $WORK/SNP/snpEff_summary.html $WORK/SNP-outputs/snpEff/snpEff-summary/{row[0]}.html \n')
            #filter_variant = "(Cases[0] = 3) & (Controls[0] = 0) & ((ANN[*].IMPACT = 'HIGH') | (ANN[*].IMPACT = 'MODERATE'))"
            #outFile.write(f'cat $WORK/SNP-outputs/snpEff/{row[0].ann.vcf | {minicondaBin}SnpSift.jar filter {filter_variant} > $WORK/SNP-outputs/snpEff/snpEff-filtered/{row[0]}.filtered.vcf \n')
