#include "Utilities.h"
#include "Timer.h"

//cpp
#include <vector>
#include <map>
#include <iostream>
#include <math.h>
#include <cstdlib>
#include <fstream>
#include <string>
#include <cstdlib>
#include <sstream>
#include <iomanip>
#include <utility>
#include <algorithm> // std::sort

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "LHAPDF/LHAPDF.h"
// YAML
#include "yaml-cpp/yaml.h"

using namespace std;

int main(int argc, char **argv)
{
  string txt_with_all_results;
  double chi2_tolerance=99;
  int Nbest_replicas=100;
  int c;
  bool output=1;
  while ((c = getopt(argc, argv, "r:c:b:o:")) != -1)
    switch (c)
    {
    case 'r':
      txt_with_all_results = optarg   ;
      break;
    case 'c':
      chi2_tolerance = atof(optarg);
      break;
    case 'b':
      Nbest_replicas = atoi(optarg);
    case 'o':
      output = atoi(optarg);
      break;
    case '?':
      if (optopt == 'r')
        fprintf(stderr, "Option -%c requires the name of the txt file containing a list of <seed> <result_name> <chi2>.\n", optopt);
      else if(optopt == 'c')
        fprintf(stderr, "Option -%c requires the minimal chi2 to accept a replica: <chi2>.\n", optopt);
      else if(optopt == 'b')
        fprintf(stderr, "Option -%c requires the number of best fit to include in the averaging.\n", optopt);
      else if (optopt == 'o')
        fprintf(stderr, "Option -%c requires 1 to output grids in plotting/ or 0 to ouptut LHAPDF.\n", optopt);

      else if (isprint(optopt))
          fprintf(stderr, "Unknown option `-%c'.\n", optopt);
      else
        fprintf(stderr,
                "Unknown option character `\\x%x'.\n",
                optopt);
      return 1;
    default:
      abort();
    }

  Timer timer;
  string ResultsFolder;

  ifstream f(txt_with_all_results.c_str());
  if (!(f.good()))
    Error("The result [" + (string)txt_with_all_results + "] doesn't seem to exist");

  double chi2_max = chi2_tolerance;

  ResultsFolder = (string)txt_with_all_results;

  string s_temp;
  s_temp = ResultsFolder.substr(0, ResultsFolder.find("."));
  string OutputFile = "results/" + s_temp;

  fstream result_file;
  stringstream input_card("");
  input_card << ResultsFolder;
  result_file.open(input_card.str().c_str(), ios::in);
  string line;

  string result;
  double chi2;

  map<double,string> m;
  vector<pair<int,double>> seeds;
  vector<string> results;
  vector<double> xs;

  int rep_counter = 0;
  int total_rep_counter = 0;
  double avg_chi2 = 0;
  //processing and parsing
  while (getline(result_file, line))
  {
    int seed;
    total_rep_counter++;
    istringstream iss(line);
    iss >> seed;
    iss >> chi2;
    iss >> result;

    std::pair<int, double> p;
    p.first = seed;
    p.second = chi2;
    seeds.push_back(p);
    if (chi2 > chi2_max)
      continue;
    m[chi2] = result;
  }
  //removing seeds duplicates
  for(int i=0;i<seeds.size();i++)
  {
    int n=0;
    for(int j=0;j<seeds.size();j++)
    {
      if(seeds.at(i).first==seeds.at(j).first)
      {
        n++;
      }
    }
    if(n>=2)
      m.erase(seeds.at(i).second);
  }

  cout<<"taken chi2s: [ ";
  for (std::map<double, string>::iterator i = m.begin(); i != m.end(); i++)
  {
    if(rep_counter>Nbest_replicas-1) break;
    
    results.push_back(i->second);
    rep_counter++;
    avg_chi2+=i->first;
    cout << i->first<<" ";
  }
  cout<<"]\n\n";
  if (rep_counter < Nbest_replicas - 1)
    {
      cout<<"The # of replicas["<<rep_counter<<"] after cuts is less than the # required["<<Nbest_replicas<<"]. continue?"<<endl;
      bool answer;
      cin>>answer;
    }
  /*for(int i=0;i<temp_results.size();i++)
  {
    double DoubleCounts = std::count(temp_results.begin(), temp_results.end(), temp_results.at(i));
    if (DoubleCounts == 1)
    results.push_back(temp_results.at(i));
  }*/
  /*
  std::vector<string> DoubleCountingFolders;
  for (int i = 0; i < results.size(); i++)
  {
    double DoubleCounts=0;
    DoubleCounts = std::count(results.begin(), results.end(), results.at(i));
    if(DoubleCounts>1)
    {
      DoubleCountingFolders.push_back(results.at(i));
    }
  }
  if (DoubleCountingFolders.size() != 0)
  {
    string ErrorOutput;
    for (int i = 0; i < DoubleCountingFolders.size(); i++)
    {
      ErrorOutput += DoubleCountingFolders.at(i) + " ";
    }
    Error("Double counting of outputs: " + ErrorOutput);
  }*/

  cout << "avg_chi2=" << avg_chi2 / rep_counter << endl;


  ifstream f2((OutputFile).c_str());
  if (!(f2.good()))
    system(("mkdir " + OutputFile).c_str());
  else
  {
    system(("rm -r " + OutputFile).c_str());
    system(("mkdir " + OutputFile).c_str());
  }

  string input_card_name = "../../cards/InputCard.yaml";
  YAML::Node InputCard = YAML::LoadFile(input_card_name.c_str());

  string Case = "Datasets";

  int Nx = 1001;

  vector<string> fls = {"Sigma", "Gluon", "T8"};

  bool ONCE = 1;
  int Npdf = results.size();

    for (auto fl : fls)
    {
      vector<double> cvs(Nx, 0);
      vector<double> sds(Nx, 0);
      ofstream PDFGridtxt((OutputFile + "/" + fl + ".dat").c_str());

      for (auto result : results)
      {

        string f = result + "/PDFGrids/" + fl + ".dat";
        fstream reader;
        stringstream input("");
        input << f;
        reader.open(input.str().c_str(), ios::in);
        string line;
        double x;
        double pdf;
        getline(reader, line); //skip first line
        int counter = 0;

        while (getline(reader, line))
        {
          istringstream iss(line);
          iss >> x;
          iss >> pdf;
          if (ONCE)
            xs.push_back(x);

          cvs.at(counter) += pdf;

          counter++;
        }

        ONCE = 0;
        if (xs.size() != Nx)
          Error("Check Nx = " + to_string(Nx) + " against the lines in the text file lines = " + to_string(xs.size()));
      }

      for (auto result : results)
      {
        string f = result + "/PDFGrids/" + fl + ".dat";
        fstream reader;
        stringstream input("");
        input << f;
        reader.open(input.str().c_str(), ios::in);
        string line;
        double x;
        double pdf;
        getline(reader, line); //skip first line
        int counter = 0;
        while (getline(reader, line))
        {
          istringstream iss(line);
          iss >> x;
          iss >> pdf;

          sds.at(counter) += pow(pdf - cvs.at(counter) / Npdf, 2);

          counter++;
        }
      }
      int Nx = xs.size();
      for (int i = 0; i < Nx; i++)
      {
        double cv = cvs.at(i) / Npdf;
        double sd = sqrt(sds.at(i) / Npdf);
        PDFGridtxt << xs.at(i) << " " << cv << " " << sd << endl;
      }
    }

  //======== Case of Sigma + 1/4 T8

    vector<double> cvs(Nx, 0);
    vector<double> sds(Nx, 0);

    vector<double> cvs_sigma(Nx, 0);
    vector<double> cvs_t8(Nx, 0);
    vector<double> sds_sigma(Nx, 0);
    vector<double> sds_t8(Nx, 0);
    vector<double> covs_sigmat8(Nx, 0);

    ofstream PDFGridtxt((OutputFile + "/SigmaT8.dat").c_str());
    for (auto result : results)
    {
      string f1 = result + "/PDFGrids/Sigma.dat";
      string f2 = result + "/PDFGrids/T8.dat";
      fstream reader1, reader2;
      stringstream input1("");
      stringstream input2("");
      input1 << f1;
      reader1.open(input1.str().c_str(), ios::in);
      input2 << f2;
      reader2.open(input2.str().c_str(), ios::in);

      string line1;
      string line2;

      double x;
      double sigma, t8;
      getline(reader1, line1); //skip first line
      getline(reader2, line2); //skip first line
      int counter = 0;

      while (getline(reader1, line1))
      {
        getline(reader2, line2);

        istringstream iss1(line1);
        iss1 >> x;
        iss1 >> sigma;
        istringstream iss2(line2);
        iss2 >> x;
        iss2 >> t8;

        cvs.at(counter) += sigma + 0.25 * t8;
        cvs_sigma.at(counter) += sigma;
        cvs_t8.at(counter) += t8;

        counter++;
      }
      if (xs.size() != Nx)
        Error("Check Nx = " + to_string(Nx) + " against the lines in the text file lines = " + to_string(xs.size()));
    }

    for (auto result : results)
    {
      string f1 = result + "/PDFGrids/Sigma.dat";
      string f2 = result + "/PDFGrids/T8.dat";
      fstream reader1, reader2;
      stringstream input1("");
      stringstream input2("");
      input1 << f1;
      reader1.open(input1.str().c_str(), ios::in);
      input2 << f2;
      reader2.open(input2.str().c_str(), ios::in);

      string line1;
      string line2;

      double x;
      double sigma, t8;
      getline(reader1, line1); //skip first line
      getline(reader2, line2); //skip first line
      int counter = 0;

      while (getline(reader1, line1))
      {
        getline(reader2, line2);

        istringstream iss1(line1);
        iss1 >> x;
        iss1 >> sigma;
        istringstream iss2(line2);
        iss2 >> x;
        iss2 >> t8;

        sds.at(counter) += pow(sigma + 0.25 * t8 - cvs.at(counter) / Npdf, 2);
        covs_sigmat8.at(counter) += (sigma - cvs_sigma.at(counter) / Npdf) * (t8 - cvs_t8.at(counter) / Npdf);
        sds_sigma.at(counter) += pow(sigma - cvs.at(counter) / Npdf, 2);
        sds_t8.at(counter) += pow(t8 - cvs.at(counter) / Npdf, 2);
        counter++;
      }
    }
    for (int i = 0; i < Nx; i++)
    {
      double cv = cvs.at(i) / Npdf;
      double sd = sqrt(sds.at(i) / Npdf);
      double sd_sigma = sqrt(sds_sigma.at(i) / Npdf);
      double sd_t8 = sqrt(sds_t8.at(i) / Npdf);
      double cov_sigmat8 = covs_sigmat8.at(i) / Npdf;

      double rho = cov_sigmat8 / (sd_sigma * sd_t8);

      PDFGridtxt << xs.at(i) << " " << cv << " " << sd << " " << rho << endl;
    }
  
  //system(("./dump_reps " + ResultsFolder + " " + to_string(chi2_max)).c_str());
  cout << "Dumping reps grids in 'Plotting/' is done. " << endl;
  cout << "Accepted reps [chi2_max= " << chi2_max << ", Nbest_replicas="<<Nbest_replicas<<"]: " << rep_counter << "/" << total_rep_counter << endl;

  //dumping into plotting folder for gnuplot plotting
  if(output)
  {
    string Results_avg = "results/" + s_temp;
    ifstream f2((Results_avg).c_str());
    if (!(f2.good()))
      Error(Results_avg + " folder doesn't exist, make sure you used ./grids_avg <results_list.dat>");

    //cleanup
    system(("rm -r Plotting/reps/" + s_temp).c_str());

    vector<string> commands0;
    commands0.push_back("mkdir Plotting/reps/" + s_temp);
    commands0.push_back("mkdir Plotting/reps/" + s_temp + "/" + to_string(0));
    commands0.push_back("cp " + Results_avg + "/*.dat Plotting/reps/" + s_temp + "/" + to_string(0) + "/.");
    for (int j = 0; j < commands0.size(); j++)
      system((commands0.at(j)).c_str());

    for (int i = 0; i < results.size(); i++)
    {
      vector<string> commands;
      commands.push_back("mkdir Plotting/reps/" + s_temp + "/" + to_string(i + 1));
      commands.push_back("cp " + results.at(i) + "/PDFGrids/*.dat Plotting/reps/" + s_temp + "/" + to_string(i + 1) + "/.");

      for (int j = 0; j < commands.size(); j++)
        system((commands.at(j)).c_str());
    }
  }
  
  //outputing LHAPDF format
  if(!output)
  {

  }

  return 0;
}
