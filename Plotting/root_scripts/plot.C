void plot()
{
  TTree * t = new TTree();
  t->ReadFile("lorentzpeakbench.dat","bin:val:x");
  t->SetMarkerStyle(20);
  TCanvas * c = new TCanvas("val:x","master:NH");
  t->Draw("val:x","","");

  TTree *t2 = new TTree();
  t2->ReadFile("results.dat", "x2:val2");
  t2->SetMarkerStyle(20);
  t2->SetMarkerColor(2);
  t2->Draw("val2:x2", "", "SAME");

  //gPad->SetLogx();
  //gPad->SetLogy();
}
