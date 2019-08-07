wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh


conda create -n stampy
conda activate stampy
conda install python=2.7

conda env create -f stampy.environment.yaml

cd $WORK/SNP-sonfwares
wget https://005.medsci.ox.ac.uk/files-library/stampy-latest.tgz 
tar zxvf stampy-latest.tgz
rm stampy-latest.tgz
cd stampy-1.0.32 
make python=python2.7


