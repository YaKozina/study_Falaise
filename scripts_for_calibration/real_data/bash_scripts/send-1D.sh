#!/bin/sh

#SBATCH --job-name=reconstruct_snemo_reco-run-1588.brio
#SBATCH --mem=3G
#SBATCH --licenses=sps
#SBATCH --time=30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

INDEX=$1

source /sps/nemo/scratch/chauveau/software/falaise/develop/this_falaise.sh


OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/testing_pipelines/scripts_for_calibration/real_data/applied-pipeline-brios" 

RECO_FILE="$OUT_BASE/1658-1D.brio"


start_time=$(date +%s)

/sps/nemo/scratch/chauveau/software/falaise/develop/install/bin/flreconstruct \
    -i snemo_run-1658_udd.brio \
    -p /sps/nemo/scratch/ykozina/Falaise/tutorial/testing_pipelines/scripts_for_calibration/real_data/1D-pipeline.conf \
    -o "$RECO_FILE"


