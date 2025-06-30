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
    auto h = new TH1D("h_runtime", "Runtime distribution;Time [s];Entries", 30, min - 1, max + 1);
    for (auto v : values) h->Fill(v);

    h->Fit("gaus");
    auto f1 = h->GetFunction("gaus");

    FILE* out = fopen("runtime_fit_results.txt", "w");
    fprintf(out, "[ROOT Gaussian Fit]\nMean: %.3f\nSigma: %.3f\n", f1->GetParameter(1), f1->GetParameter(2));
    fclose(out);

    auto c = new TCanvas("c_runtime", "Runtime", 800, 600);
    h->Draw();
    c->Update();

    TFile* fout = new TFile("runtime_hist.root", "RECREATE");
    h->Write();
    c->Write();
    fout->Close();
}

