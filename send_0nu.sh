#!/bin/sh

# SLURM options:

#SBATCH --job-name=0nubb_Se82         	 # Job name
#SBATCH --partition=flash              # Partition choice (most generally we work with htc, but for quick debugging you can use
							         #					 #SBATCH --partition=flash. This avoids waiting times, but is limited to 1hr)
#SBATCH --mem=8G                     	 # RAM
#SBATCH --licenses=sps                   # When working on sps, must declare license!!

#SBATCH --time=10:10                 	 # Time for the job in format “minutes:seconds” or  “hours:minutes:seconds”, “days-hours”
#SBATCH --cpus-per-task=1                # Number of CPUs
# #SBATCH --output=/pbs/home/y/ykozina/tutorial/0nu/$A_$a_out.log 
# #SBATCH --error=/pbs/home/y/ykozina/tutorial/0nu/$A_$a_err.log

/pbs/home/y/ykozina/tutorial/0nu/ flsimulate -c Simu_0nu_Se82.conf -o Simu_0nu_Se82.brio
/pbs/home/y/ykozina/tutorial/0nu/ flreconstruct -p p_MiModule_v00.conf -i Simu_0nu_Se82.brio -o Reco_0nu_Se82.brio

