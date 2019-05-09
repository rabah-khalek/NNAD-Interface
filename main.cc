#include "Timer.h"

#include "AnalyticCostFunction.h"
#include "AutoDiffCostFunction.h"
//#include "NumericCostFunction.h"
#include "Globals.h"

// YAML
#include "yaml-cpp/yaml.h"

// Standard libs
#include <iostream>
#include <math.h>
#include <cstdlib>
#include <fstream>
#include <string>


using namespace std;

int main(int argc, char *argv[])
{
  YAML::Node InputCard;
  string InputCardName;
  int Seed;

  switch (argc)
  {
  case 2: //if Seed is not given by the user
    InputCardName = argv[1];
    InputCard = YAML::LoadFile((InputCardName).c_str());
    if (InputCard["Seed"].as<int>() == -1)
    {
      srand(time(NULL));
      Seed = rand();
    }
    else
      Seed = InputCard["Seed"].as<int>();
    break;

  case 3: //if Seed is given by the user
    InputCardName = argv[1];
    Seed = atoi(argv[2]);
    break;

  default:
    cerr << "Usage: " << argv[0] << " <inputcardNAME.yaml> <Seed[optional]>" << endl;
    exit(-1);
  }

  InputCard = YAML::LoadFile((InputCardName).c_str());

  //Allocating a result folder name in string
  std::time_t t_temp = std::time(0); // get time now
  std::tm *now = std::localtime(&t_temp);

  string ResultsFolder = "results/" + to_string(now->tm_mday) + '.' +
                         to_string((now->tm_mon + 1)) + '.' +
                         to_string((now->tm_year + 1900)) + '-' +
                         to_string(now->tm_hour) + '.' +
                         to_string(now->tm_min) + '.' +
                         to_string(now->tm_sec);

  ifstream f((ResultsFolder).c_str());
  if (f.good())
    exit(1);

  system(("mkdir " + ResultsFolder).c_str());
  system(("cp " + InputCardName + " " + ResultsFolder + "/InputCard.yaml").c_str());

  // Timer
  Timer t;

  // ============================================================
  // Initialise NN to be fitted to data.
  // ============================================================
  //FeedForwardNN* nn = new FeedForwardNN{{2, 10, 3}, time(NULL)};
  vector<int> NNarchitecture = InputCard["NNarchitecture"].as<vector<int>>();
  FeedForwardNN<double> *nn = new FeedForwardNN<double>(NNarchitecture, Seed);

  // Generate pseudo data
  //vector<pair<double, double>> Data = GenerateData(Preds, 0.005, 0.01);
  // ============================================================

  // ============================================================
  // Prepare the model
  // ============================================================
/*
  const int n = 100;
  vectdata Data;
  double xmin = 0;
  double xmax = 6.28;
  for (int i = 0; i < n; i++)
  {
    Datapoint tuple;
    double x = xmin + i * xmax / n;
    double y = sin(x);
    double sd = 1e-2 * (rand() % 100) + 0.001;
    get<0>(tuple) = x;
    get<1>(tuple) = y;
    get<2>(tuple) = sd;
    Data.push_back(tuple);
  }
*/
  Compute<double> compute(Seed, InputCardName);
  vectdata Data = compute.PseudoData();
  // Put initial parameters in a vector<double*> for initialising
  // the ceres solver.
  const int np = nn->GetParameterNumber();
  const vector<double> pars = nn->GetParameters();
  vector<double *> initPars(np);
  for (int ip = 0; ip < np; ip++)
    initPars[ip] = new double(pars[ip]);

  // Allocate "Problem" instance
  ceres::Problem problem;

  // Allocate a "Chi2CostFunction" instance to be fed to ceres for
  // minimisation based on the choice from InputCard.yaml
  ceres::CostFunction *analytic_chi2cf = nullptr;
  ceres::DynamicAutoDiffCostFunction<AutoDiffCostFunction, GLOBALS::kStride> *automatic_chi2cf = nullptr;
  //ceres::DynamicNumericDiffCostFunction<NumericCostFunction> *numeric_chi2cf = nullptr;

  string DerivativesChoice = InputCard["Derivatives"].as<string>();
  map<string, int> StrIntMapDerivatives;
  StrIntMapDerivatives["Analytic"] = 0;
  StrIntMapDerivatives["Automatic"] = 1;
  StrIntMapDerivatives["Numeric"] = 2;

  switch (StrIntMapDerivatives[DerivativesChoice])
  {
  //Analytic
  case 0:
    analytic_chi2cf = new AnalyticCostFunction(np, Seed, Data, InputCardName);
    delete automatic_chi2cf;
    //delete numeric_chi2cf;
    problem.AddResidualBlock(analytic_chi2cf, NULL, initPars);
    break;

  //Automatic
  case 1:
    automatic_chi2cf = new ceres::DynamicAutoDiffCostFunction<AutoDiffCostFunction, GLOBALS::kStride>(new AutoDiffCostFunction(Seed, InputCardName, np, Data));
    delete analytic_chi2cf;
    //delete numeric_chi2cf;
    for (int i = 0; i < np; i++)
      automatic_chi2cf->AddParameterBlock(1);
    automatic_chi2cf->SetNumResiduals(Data.size());
    problem.AddResidualBlock(automatic_chi2cf, NULL, initPars);

    break;

  //Numeric
  /*
  case 2:
    numeric_chi2cf = new ceres::DynamicNumericDiffCostFunction<NumericCostFunction>(new NumericCostFunction(np, Data, NNarchitecture, Seed));
    delete analytic_chi2cf;
    delete automatic_chi2cf;
    for (int i = 0; i < np; i++)
      numeric_chi2cf->AddParameterBlock(1);
    numeric_chi2cf->SetNumResiduals(Data.size());
    problem.AddResidualBlock(numeric_chi2cf, NULL, initPars);

    break;
*/
  //Error
  default:
    cerr << "Check if \"" << InputCard["Derivatives"].as<string>() << "\" exists in the InputCard.yaml" << endl;
    exit(-1);
  }
  
  // ============================================================

  // ============================================================
  // Run the solver with some options.
  // ============================================================

  ceres::Solver::Options options;
    options.minimizer_type = ceres::TRUST_REGION;
  options.max_num_iterations = InputCard["Iterations"].as<int>();
  options.use_nonmonotonic_steps = InputCard["use_nonmonotonic_steps"].as<bool>();
  options.minimizer_progress_to_stdout = true;
  options.function_tolerance = 1e-10;
  options.parameter_tolerance = 1e-10;
  options.gradient_tolerance = 1e-10;
  ceres::Solver::Summary summary;
  Solve(options, &problem, &summary);
  cout << summary.FullReport() << "\n";

  std::vector<double> final_pars;
  final_pars.reserve(np);
  for(int i=0;i<np;i++)
    final_pars.push_back(initPars[i][0]);

  PDFs<double> pdfs(Seed, InputCardName);
  pdfs.SetParameters(final_pars);

  std::cout << "\033[1;32mResults in: \033[1;36m" << ResultsFolder << "\033[0m\033[0m\n";
  std::cout << "\n";

  cout << "Generating PDFgrids..." << endl;
  double xmax_grid = 1;
  double xmin_grid = 1e-3;
  double n = 1001;
  double xstep = (log(xmax_grid) - log(xmin_grid)) / n;

  string grids_OutputFile = ResultsFolder + "/PDFGrids";
  ifstream f_grids((grids_OutputFile).c_str());
  if (!(f_grids.good()))
    system(("mkdir " + grids_OutputFile).c_str());


    double xx = log(xmin_grid);

    ofstream SigmaGridtxt((grids_OutputFile + "/Sigma.dat").c_str(), ios::out | ios::app);
    ofstream GluonGridtxt((grids_OutputFile + "/Gluon.dat").c_str(), ios::out | ios::app);
    ofstream T8Gridtxt((grids_OutputFile + "/T8.dat").c_str(), ios::out | ios::app);

    SigmaGridtxt << "#x Sigma Sigma_error" << endl;
    GluonGridtxt << "#x Gluon Gluon_error" << endl;
    T8Gridtxt << "#x T8 T8_error" << endl;


    double Ag;
    bool MSR = InputCard["MSR"].as<bool>();
    double reference_MSR=compute.Getreference_MSR();
    if (MSR)
      Ag = pdfs.MSR(reference_MSR);
    else
      Ag = 1;

    for (int xi = 0; xi < n; xi++) //[cogged]
    {
      double x = exp(xx); //[cogged]
      vector<double> vpdfs = pdfs.Evaluate({x, log(x)});

      SigmaGridtxt << x << " " << vpdfs[0] << endl;
      GluonGridtxt << x << " " << Ag * vpdfs[1] << endl;
      T8Gridtxt << x << " " << vpdfs[2] << endl;

      xx += xstep;
    }
  

  //===============

  return 0;
}