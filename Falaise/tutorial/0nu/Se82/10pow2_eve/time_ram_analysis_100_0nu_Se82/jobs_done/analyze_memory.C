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

