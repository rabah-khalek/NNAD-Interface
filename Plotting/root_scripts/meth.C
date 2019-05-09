void meth()
{
  TString filename = "meth";
  TTree * t = new TTree();
  t->ReadFile(filename+".dat","seed:iterations:init_chi2:final_chi2:time");
  t->SetMarkerStyle(20);
  TCanvas * c = new TCanvas("methodology","methodology");
  t->Draw("iterations:time","","");
  c->SaveAs(filename+".pdf");
}
