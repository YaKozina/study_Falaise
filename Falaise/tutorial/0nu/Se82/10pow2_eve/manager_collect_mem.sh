##!/bin/bash
#JOBID=58721310
#echo "seff $JOBID:"
#seff "$JOBID" | grep "Memory Utilized"
#*******************************************

##!/bin/bash
#RUNTIME_FILE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done/runtime_raw.txt"
#echo "Перевірка памʼяті для всіх JobID із $RUNTIME_FILE"
#echo

#tail -n +2 "$RUNTIME_FILE" | while IFS=$'\t' read -r idx jobid runtime; do
#    echo "INDEX: $idx    JobID: $jobid"
#    seff "$jobid" | grep "Memory Utilized"
#    echo
#done

#***************************************************************

#!/bin/bash

module load root

# === Шляхи ===
OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done"
RUNTIME_FILE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done/runtime_raw.txt"
MEMORY_FILE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done/memory_raw.txt"

# === Заголовок ===
echo -e "Index\tJobID\tMemory MB" > "$MEMORY_FILE"

# === Обхід усіх рядків ===
tail -n +2 "$RUNTIME_FILE" | while IFS=$'\t' read -r idx jobid runtime; do
    mem_line=$(seff "$jobid" | grep "Memory Utilized")
    echo "JobID $jobid → $mem_line"

    mem_value=$(echo "$mem_line" | awk '{print $3}')

    echo -e "$idx\t$jobid\t$mem_value" >> "$MEMORY_FILE"
done

echo "Memory saved to: $MEMORY_FILE"
cat << 'EOF' > "$OUT_BASE/analyze_memory.C"
void analyze_memory() {
    FILE* f = fopen("memory_raw.txt", "r");
    if (!f) {
        printf("Cannot open memory_raw.txt\n");
        return;
    }

    std::vector<double> values;
    char line[256];

    // ??????????? ?????????
    fgets(line, sizeof(line), f);

    while (fgets(line, sizeof(line), f)) {
        double val;
        if (sscanf(strrchr(line, '\t'), "\t%lf", &val) == 1) {
            values.push_back(val);
        }
    }
    fclose(f);

    if (values.empty()) {
        printf("No data to analyze\n");
        return;
    }

    double min = *std::min_element(values.begin(), values.end());
    double max = *std::max_element(values.begin(), values.end());

    auto h = new TH1D("h", "Memory usage;Memory [MB];Entries", 30, min - 1, max + 1);
    for (auto v : values) h->Fill(v);

    h->Fit("gaus");

    auto f1 = h->GetFunction("gaus");
    FILE* out = fopen("memory_fit_results.txt", "w");
    fprintf(out, "Mean: %.3f\nSigma: %.3f\n", f1->GetParameter(1), f1->GetParameter(2));
    fclose(out);
}

EOF

# === Запуск ROOT-аналізу ===
cd "$OUT_BASE"
root -l -b -q analyze_memory.C

 


