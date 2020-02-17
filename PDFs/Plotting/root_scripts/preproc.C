void preproc()
{
  TString fit="TEST";
  system("rm figs/preproc/*");
  system("mkdir figs/preproc");
  TString filename = "reps/"+fit+"/0/PreProc.dat";
  TTree * t = new TTree();
  t->ReadFile(filename,"#alpha_{#Sigma}:#alpha_{g}:#alpha_{T_{8}}:#beta_{#Sigma}:#beta_{g}");
  t->SetMarkerStyle(20);

  gStyle->SetOptStat(101);
  t->SetFillColor(38);
  TCanvas * c0 = new TCanvas("PreProc0","PreProc0");
  t->Draw("#alpha_{#Sigma}","","");
  c0->SaveAs("figs/preproc/0.alpha_sigma.pdf");

  TCanvas * c1 = new TCanvas("PreProc1","PreProc1");
  t->Draw("#alpha_{g}","","");
  c1->SaveAs("figs/preproc/1.alpha_gluon.pdf");

    TCanvas * c2 = new TCanvas("PreProc2","PreProc2");
  t->Draw("#alpha_{T_{8}}","","");
  c2->SaveAs("figs/preproc/2.alpha_t8.pdf");

  //t->SetFillStyle( 3001);
t->SetFillColor(46);
    TCanvas * c3 = new TCanvas("PreProc3","PreProc4");
  t->Draw("#beta_{#Sigma}","","");
  c3->SaveAs("figs/preproc/3.beta_sigma.pdf");

    TCanvas * c4 = new TCanvas("PreProc4","PreProc4");
  t->Draw("#beta_{g}","","");
  c4->SaveAs("figs/preproc/4.beta_g.pdf");

  system("gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=figs/preproc.pdf figs/preproc/*.pdf");
}
