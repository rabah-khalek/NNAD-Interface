//
// Author: Rabah Abdul Khalek - rabah.khalek@gmail.com
//

#pragma once

// Ceres solver
#include <ceres/ceres.h>
#include "Compute.h"

// Typedef for the data
typedef std::vector<std::pair<double, double>> vectdata;

class AutoDiffCostFunction
{
  public:
    AutoDiffCostFunction(int const &,
                         std::string const &,
                         int const &,
                         vectdata const &);

    template <typename T>
    bool operator()(T const *const *, T *) const;
    
  private:
    int _Seed;
    std::string _InputCardName;
    int _Np;
    vectdata _Data;
};

