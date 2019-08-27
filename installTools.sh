if [ -z $WORK ]; then WORK=`pwd`; fi


####      Bioconda          ####
cd 
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
cd $WORK/SNP
conda env create -f snpvariant.environment.yaml
conda activate
conda activate snpvariant
