void analyze_memory() {
    FILE* f = fopen("memory_raw.txt", "r");
    if (!f) { printf("Cannot open memory_raw.txt\n"); return; }

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

    double sum = 0.0, sum_sq = 0.0;
    for (auto v : values) {
        sum += v;
        sum_sq += v * v;
    }

    double mean = sum / values.size();
    double variance = (sum_sq / values.size()) - (mean * mean);
    double sigma_manual = std::sqrt(variance);

    double min = *std::min_element(values.begin(), values.end());
    double max = *std::max_element(values.begin(), values.end());
    auto h = new TH1D("h_memory", "Memory Usage;Memory [MB];Entries", 30, min - 1, max + 1);
    for (auto v : values) h->Fill(v);

    h->Fit("gaus");
    auto f1 = h->GetFunction("gaus");


    FILE* out = fopen("memory_fit_results.txt", "w");
    fprintf(out, "[Manual Calculation]\nMean: %.3f\nSigma: %.3f\n\n", mean, sigma_manual);
    fprintf(out, "[ROOT Gaussian Fit]\nMean: %.3f\nSigma: %.3f\n", f1->GetParameter(1), f1->GetParameter(2));
    fclose(out);

    auto c = new TCanvas("c_memory", "Memory", 800, 600);
    h->Draw();
    c->Update();

    TFile* fout = new TFile("memory_hist.root", "RECREATE");
    h->Write();
    c->Write();
    fout->Close();
}

