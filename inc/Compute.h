//
// Author: Rabah Abdul Khalek: rabah.khalek@gmail.com
//

#pragma once

#include "FeedForwardNN.h"
#include "PDFs.h"
#include "Globals.h"

#include <iostream>
#include <vector>
#include <typeinfo>
#include "yaml-cpp/yaml.h"

#include "ceres/jet.h"

// APFELgrid
#include <APFELgrid/fastkernel.h>
#include <APFELgrid/transform.h>

// LHAPDF
#include <LHAPDF/LHAPDF.h>

using namespace std;

template <class T, int N>
inline void dconvert(ceres::Jet<T, N> *input_jets, int Nx, int NonZero, int DSz, double *output)
{
    int NPDF = N + 1;
    for (int n = 0; n < NPDF; n++)
    {
        for (int fl = 0; fl < NonZero; fl++)
        {

            for (int i = 0; i < Nx; i++)
            {
                if (n == 0)
                    output[n * DSz + fl * Nx + i] = input_jets[fl * Nx + i].a;
                else
                    output[n * DSz + fl * Nx + i] = input_jets[fl * Nx + i].v[n - 1];
            }
        }
    }
}

template <class T, int N>
inline void convertd(double *input_res, int nd, ceres::Jet<T, N> *output_res)
{
    int NPDF = N + 1;
    for (int id = 0; id < nd; id++)
    {
        for (int ip = 0; ip < NPDF; ip++)
        {
            if (ip == 0)
                output_res[id].a = input_res[id * NPDF + ip];
            else
                output_res[id].v[ip - 1] = input_res[id * NPDF + ip];
        }
    }
}

inline void dconvert(double *input, int Nx, int NonZero, int DSz, double *output) 
{
    for(int i=0;i<Nx*NonZero;i++)
        output[i]=input[i];
}
inline void convertd(double *input_res, int nd, double *output_res) 
{
    for(int i=0;i<nd;i++)
        output_res[i]=input_res[i];
}

template <class T>
class Compute
{
  public:
    ~Compute()
    {
        //delete _pdfs;
    }
    //Constructors
    Compute();
    Compute(int const &Seed, std::string const & InputCardName);

    void SetInputCardName(std::string const &);
    void SetParameters(vector<T> const &);

    vector<T> Predictions();

    int GetNData();
    int GetNParameters();

    std::vector<std::vector<double>> dDerivatives();

    std::vector<std::pair<double, double>> PseudoData();

  private:
    std::string _InputCardName;
    vector<NNPDF_APFELgrid::FKTable<double>> _FKs;
    PDFs<T> _pdfs;
    int _np;
    int _nd;
    vector<string> _chosen_sets;
    std::map<T, T> _m_As;
    };
