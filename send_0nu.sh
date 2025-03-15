#!/bin/sh

# SLURM options:

#SBATCH --job-name=0nubb_Se82         	 # Job name
#SBATCH --mem=5G                     	 # RAM
#SBATCH --licenses=sps                   # When working on sps, must declare license!!

#SBATCH --time=10:00                 	 # Time for the job in format “minutes:seconds” or  “hours:minutes:seconds”, “days-hours”
#SBATCH --cpus-per-task=1                # Number of CPUs

start_time=$(date +%s)

/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flsimulate -c Simu_0nu_Se82.conf -o Simu_0nu_Se82.brio
#/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flreconstruct -p p_MiModule_v00.conf -i Simu_0nu_Se82.brio -o Reco_0nu_Se82.brio
end_time=$(date +%s)

runtime=$((end_time - start_time))

echo "Job execution time: $runtime seconds"


