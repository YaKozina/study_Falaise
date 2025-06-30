#!/bin/bash

module load root

OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done"
RUNTIME_FILE="$OUT_BASE/runtime_raw.txt"

mkdir -p "$OUT_BASE/log"

# очищуємо файл перед запуском
echo -e "Index\tJobID\tRuntime sec" > "$RUNTIME_FILE"

# запуск задач
for i in {0..19}; do
    sbatch send_0nu.sh $i
    sleep 0.2
done

# чекаємо завершення
echo "Waiting for jobs to finish..."
while squeue -u "$USER" | grep -q "send_0nu"; do
    sleep 15
done
echo "All jobs completed."
echo "Runtime info written to $RUNTIME_FILE"

# === Файл для ROOT-аналізу часу ===
cat << 'EOF' > "$OUT_BASE/analyze_runtime.C"
void analyze_runtime() {
    FILE* f = fopen("runtime_raw.txt", "r");
    if (!f) {
        printf("Cannot open runtime_raw.txt\n");
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

    auto h = new TH1D("h", "Runtime distribution;Time [s];Entries", 30, min - 1, max + 1);
    for (auto v : values) h->Fill(v);

    h->Fit("gaus");

    auto f1 = h->GetFunction("gaus");
    FILE* out = fopen("runtime_fit_results.txt", "w");
    fprintf(out, "Mean: %.3f\nSigma: %.3f\n", f1->GetParameter(1), f1->GetParameter(2));
    fclose(out);
}

EOF

# === Запуск ROOT-аналізу ===
cd "$OUT_BASE"
root -l -b -q analyze_runtime.C




