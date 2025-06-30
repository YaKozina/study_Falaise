#!/bin/sh

# SLURM options:

#SBATCH --job-name=0nubb_Se82_10p2eve_single_job         	 # Job name
#SBATCH --mem=10G                     	 # RAM
#SBATCH --licenses=sps                   # When working on sps, must declare license!!

#SBATCH --time=20:00                 	 # Time for the job in format “minutes:seconds” or  “hours:minutes:seconds”, “days-hours”
#SBATCH --cpus-per-task=1                # Number of CPUs



source ${THRONG_DIR}/config/supernemo_profile.bash
snswmgr_load_stack base@2024-09-04
snswmgr_load_setup falaise@5.1.2


start_time=$(date +%s)

/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flsimulate -c /sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/Simu_0nu_Se82.conf -o /sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/Simu_0nu_Se82_10p4eve.brio

CONF_FAL="/sps/nemo/sw/Falaise/install_develop/share/Falaise-4.1.0/resources/snemo/demonstrator/reconstruction/"

/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flreconstruct -i /sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/Simu_0nu_Se82_10p4eve.brio -p $CONF_FAL/official-2.0.0.conf -o /sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/Reco_0nu_Se82_10p4eve.brio 

end_time=$(date +%s)

runtime=$((end_time - start_time))

echo "Job execution time: $runtime seconds"
