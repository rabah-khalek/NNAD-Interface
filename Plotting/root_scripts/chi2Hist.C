void chi2Hist()
{
  TString filename = "newest_LS";
  TTree * t = new TTree();
  t->ReadFile(filename+".dat",filename);
  t->SetMarkerStyle(20);
  TCanvas * c = new TCanvas("residuals","residuals");
  t->Draw(filename,"","");
  c->SaveAs(filename+".pdf");
}
