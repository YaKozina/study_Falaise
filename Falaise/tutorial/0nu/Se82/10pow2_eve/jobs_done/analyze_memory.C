void analyze_memory() {
    FILE* f = fopen("memory_raw.txt", "r");
    if (!f) {
        printf("Cannot open memory_raw.txt\n");
        return;
    }

    std::vector<double> values;
    char line[256];
    fgets(line, sizeof(line), f);  // Пропускаємо заголовок
    while (fgets(line, sizeof(line), f)) {
        double val;
        if (sscanf(strrchr(line, '\t'), "\t%lf", &val) == 1)
            values.push_back(val);
    }
    fclose(f);

    if (values.empty()) {
        printf("No data\n");
        return;
    }

    // Визначення меж
    double min = *std::min_element(values.begin(), values.end());
    double max = *std::max_element(values.begin(), values.end());
    int nBins = 30;
    double binWidth = (max - min) / nBins;

    // Підготовка даних для графіка
    std::vector<double> x, y, ex, ey;
    for (int i = 0; i < nBins; ++i) {
        double binLow = min + i * binWidth;
        double binHigh = binLow + binWidth;
        double binCenter = (binLow + binHigh) / 2.0;

        // Підрахунок подій у біні
        int count = 0;
        for (auto v : values) {
            if (v >= binLow && v < binHigh)
                ++count;
        }

        if (count > 0) {
            x.push_back(binCenter);
            y.push_back(count);
            ex.push_back(binWidth / 2.0);
            ey.push_back(std::sqrt(count));
        }
    }

    // Створення графіка з похибками
    auto gr = new TGraphErrors(x.size(), x.data(), y.data(), ex.data(), ey.data());
    gr->SetTitle("Memory Usage Distribution;Memory [MB];Entries");
    gr->SetMarkerStyle(20);
    gr->SetMarkerSize(1);
    gr->SetLineColor(kBlue);
    gr->SetMarkerColor(kBlue);

    // Фіт функцією Гауса
    auto gaus = new TF1("gaus", "gaus", min, max);
    gr->Fit(gaus, "Q");

    // Запис результатів у файл
    FILE* out = fopen("memory_fit_results.txt", "w");
    fprintf(out, "[TGraphErrors + Gaussian Fit]\nMean: %.3f\nSigma: %.3f\n", gaus->GetParameter(1), gaus->GetParameter(2));
    fclose(out);

    // Візуалізація
    auto c = new TCanvas("c_memory_graph", "Memory Graph", 800, 600);
    gr->Draw("AP");
    gaus->Draw("same");
    c->SaveAs("memory_graph.png");

    // Збереження в ROOT файл
    TFile* fout = new TFile("memory_graph.root", "RECREATE");
    gr->Write("memory_graph");
    gaus->Write("gaus_fit");
    c->Write();
    fout->Close();
}

