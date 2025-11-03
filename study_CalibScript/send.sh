#!/bin/sh

#SBATCH --job-name=reconstruct_1556.brio
#SBATCH --mem=5G
#SBATCH --licenses=sps
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

INDEX=$1

source /sps/nemo/scratch/chauveau/software/falaise/develop/this_falaise.sh


OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/CalibrationScript/Tutorial" 

RECO_FILE="$OUT_BASE/reco-PTD_1556-100.brio"


start_time=$(date +%s)
#1)
#/sps/nemo/scratch/chauveau/software/falaise/develop/install/bin/flreconstruct \
#    -i CD_1556.brio \
#    -p /sps/nemo/scratch/ykozina/Falaise/tutorial/CalibrationScript/Tutorial/reco.conf \
#    -o "$RECO_FILE"
    
#2) CalibrationCutsModule


#flreconstruct -i /path/to/input.brio -p /path/to/config.conf

#/sps/nemo/scratch/chauveau/software/falaise/develop/install/bin/flreconstruct \
#	-i reco-PTD_1556-100.brio \
#	 -p calibration_cuts.conf


#3) SNCalib
/sps/nemo/scratch/ykozina/Falaise/tutorial/CalibrationScript/build/SNCalib/sncalib \
	-i extracted_data.root \
	-o /sps/nemo/scratch/ykozina/Falaise/tutorial/CalibrationScript/Tutorial/output.csv \
	-p /sps/nemo/scratch/ykozina/Falaise/tutorial/CalibrationScript/build/SNCalib/params.conf -s -V

#end
