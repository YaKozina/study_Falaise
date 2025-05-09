#!/bin/bash

module load root

OUT_BASE="/sps/nemo/scratch/ykozina/Falaise/tutorial/0nu/Se82/10pow2_eve/jobs_done"
RUNTIME_FILE="$OUT_BASE/runtime_raw.txt"
MEMORY_FILE="$OUT_BASE/memory_raw.txt"

mkdir -p "$OUT_BASE/log"

echo -e "Index\tJobID\tRuntime sec" > "$RUNTIME_FILE"

for i in {0..99}; do
    sbatch send_0nu.sh $i
    sleep 0.2
done

echo "Waiting for jobs to finish..."
while squeue -u "$USER" | grep -q "send_0nu"; do
    sleep 15
done
echo "All jobs completed."

cat << 'EOF' > "$OUT_BASE/analyze_runtime.C"
void analyze_runtime() {
    FILE* f = fopen("runtime_raw.txt", "r");
    if (!f) { printf("Cannot open runtime_raw.txt\n"); return; }

    std::vector<double> values;
    char line[256];
    fgets(line, sizeof(line), f);
    while (fgets(line, sizeof(line), f)) {
        double val;
        if (sscanf(strrchr(line, '\t'), "\t%lf", &val) == 1)
            values.push_back(val);
    }
    fclose(f);
    if (values.empty()) { printf("No data\n"); return; }

    double min = *std::min_element(values.begin(), values.end());
    double max = *std::max_element(values.begin(), values.end());
    auto h = new TH1D("h", "Runtime distribution;Time [s];Entries", 30, min-1, max+1);
    for (auto v : values) h->Fill(v);
    h->Fit("gaus");
    auto f1 = h->GetFunction("gaus");
    FILE* out = fopen("runtime_fit_results.txt", "w");
    fprintf(out, "Mean: %.3f\nSigma: %.3f\n", f1->GetParameter(1), f1->GetParameter(2));
    fclose(out);
}
EOF

cd "$OUT_BASE"
root -l -b -q analyze_runtime.C
echo "Runtime info written and analyzed."
echo "120 seconds to wait for memory info to become available..."
sleep 120

echo -e "Index\tJobID\tMemory MB" > "$MEMORY_FILE"

tail -n +2 "$RUNTIME_FILE" | while IFS=$'\t' read -r idx jobid runtime; do
    mem_line=$(seff "$jobid" | grep "Memory Utilized")
    echo "JobID $jobid -> $mem_line"
    mem_value=$(echo "$mem_line" | awk '{print $3}')
    echo -e "$idx\t$jobid\t$mem_value" >> "$MEMORY_FILE"
done
echo "Memory saved to: $MEMORY_FILE"

cat << 'EOF' > "$OUT_BASE/analyze_memory.C"
void analyze_memory() {
    FILE* f = fopen("memory_raw.txt", "r");
    if (!f) { printf("Cannot open memory_raw.txt\n"); return; }

    std::vector<double> values;
    char line[256];
    fgets(line, sizeof(line), f);  // Пропускаємо заголовок
    while (fgets(line, sizeof(line), f)) {
        double val;
        if (sscanf(strrchr(line, '\t'), "\t%lf", &val) == 1)  // Витягуємо значення з кожного рядка
            values.push_back(val);  // Додаємо значення до вектора
    }
    fclose(f);
    if (values.empty()) { printf("No data\n"); return; }

    double sum = 0.0, sum_sq = 0.0;
    for (auto v : values) {  // Для кожного значення в масиві
        sum += v;  // Додаємо до суми
        sum_sq += v * v;  // Додаємо квадрат значення до суми квадратів
    }
    
    // Обчислення середнього та стандартного відхилення
    double mean = sum / values.size();  // Середнє
    double variance = (sum_sq / values.size()) - (mean * mean);  // Дисперсія
    double sigma = std::sqrt(variance);  // Стандартне відхилення

    // Запис результатів у файл
    FILE* out = fopen("memory_fit_results.txt", "w");
    fprintf(out, "Mean: %.3f\nSigma: %.3f\n", mean, sigma);  // Записуємо середнє і сигму в файл
    fclose(out);
    
    // Виведення результатів в термінал
    printf("Memory Analysis:\n");
    printf("Mean: %.3f MB\n", mean);
    printf("Sigma: %.3f MB\n", sigma);
}

EOF

cd "$OUT_BASE"
root -l -b -q analyze_memory.C
echo "Memory info analyzed"
