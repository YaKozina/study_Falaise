#!/bin/sh

#SBATCH --job-name=send_0nu
#SBATCH --mem=10G
#SBATCH --licenses=sps
#SBATCH --time=10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

INDEX=$1

source "${THRONG_DIR}/config/supernemo_profile.bash"
snswmgr_load_stack base@2024-09-04
snswmgr_load_setup falaise@5.1.2

OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done"
OUT_DIR="$OUT_BASE/job_$INDEX"
RUNTIME_FILE="$OUT_BASE/runtime_raw.txt"

mkdir -p "$OUT_DIR"

SIM_FILE="$OUT_DIR/Simu_0nu_Se82_${INDEX}.brio"
RECO_FILE="$OUT_DIR/Reco_0nu_Se82_${INDEX}.brio"

start_time=$(date +%s)

/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flsimulate \
    -c /sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/Simu_0nu_Se82.conf \
    -o "$SIM_FILE"

/sps/nemo/sw/redhat-9-x86_64/snsw/opt/falaise-5.1.2/bin/flreconstruct \
    -i "$SIM_FILE" \
    -p /sps/nemo/sw/Falaise/install_develop/share/Falaise-4.1.0/resources/snemo/demonstrator/reconstruction/official-2.0.0.conf \
    -o "$RECO_FILE"

end_time=$(date +%s)
runtime=$((end_time - start_time))

# записуємо час у загальний файл
echo -e "$INDEX\t$SLURM_JOB_ID\t$runtime" >> "$RUNTIME_FILE"

