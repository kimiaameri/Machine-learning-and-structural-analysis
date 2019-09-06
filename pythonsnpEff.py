import csv
import sys

if len(sys.argv) < 4:
    sys.stderr.write('No Input CSV file and BCFTools and java\n')
    sys.exit(0)
    
inputFile = sys.argv[1]
minicondaBin = sys.argv[2]
cpath = sys.argv[3]
outputFile = "snpEffMerge.sh"
prefix = "$WORK/SNP-outputs/bcfoutput/"
count=0
with open(inputFile) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    allSamples=[]
    for row in csv_reader:
        if count !=0 :
          allSamples.append(row[0])
        count =count +1
    listAll=[]
    for sample in allSamples :
        listAll.append(prefix + sample + ".vcf.gz")
        
    allStr  = ' '.join(listAll) 
    with open (cpath +"/allSamples.txt",'w') as of:
         of.write(str(allSamples))
    length=len(allSamples)
with open(outputFile,'w') as outFile:
        outFile.write(f'{minicondaBin}bcftools merge --force {allStr} -O v -o $WORK/SNP-outputs/mergefile.vcf;\n')
        outFile.write('sed -i \'s/^chr/Chromosome/\' $WORK/SNP-outputs/mergefile.vcf;\n')
        outFile.write(f'{minicondaBin}snpEff -v Staphylococcus_aureus_subsp_aureus_nctc_8325 $WORK/SNP-outputs/mergefile.vcf > $WORK/SNP-outputs/merge_snpEff.ann.vcf \n')
        outFile.write('mv $WORK/SNP/snpEff_genes.txt $WORK/SNP-outputs/merge_snpEff.txt \n')
        outFile.write('mv $WORK/SNP/snpEff_summary.html $WORK/SNP-outputs/merge_snpEff_summary.html \n')
        outFile.write('sed -i \'s/^chr/Chromosome/\' $WORK/SNP-outputs/vcffilter-dp/*.vcf;\n')

        with open(inputFile) as csv_file:
          csv_reader = csv.reader(csv_file, delimiter=',')
          for row in csv_reader:
            if count !=0 :
              outFile.write("cd $WORK/SNP/ \n")
              outFile.write(f'{minicondaBin}snpEff -v Staphylococcus_aureus_subsp_aureus_nctc_8325 $WORK/SNP-outputs/vcffilter-dp/{row[0]}.vcf > $WORK/SNP-outputs/snpEff/{row[0]}.ann.vcf \n')
              outFile.write(f'mv $WORK/SNP/snpEff_genes.txt $WORK/SNP-outputs/snpEff/snpEff-gene/{row[0]}.txt \n')
              outFile.write(f'mv $WORK/SNP/snpEff_summary.html $WORK/SNP-outputs/snpEff/snpEff-summary/{row[0]}.html \n')
              outFile.write("cd $WORK/SNP-outputs/snpEff/ \n")
              filter_variant = "(TYPE[*] has 'snp')"
              outFile.write(f'cat $WORK/SNP-outputs/snpEff/{row[0]}.ann.vcf | {minicondaBin}SnpSift filter  "{filter_variant}"  > $WORK/SNP-outputs/snpEff/filtered/{row[0]}.filtered.vcf \n')
              outFile.write(f'cat $WORK/SNP-outputs/snpEff/filtered/{row[0]}.filtered.vcf | {minicondaBin}SnpSift filter   " ( QUAL >= 500 )"   > $WORK/SNP-outputs/snpEff/filtered/quality-{row[0]}.filtered.vcf \n')

            count =count +1
