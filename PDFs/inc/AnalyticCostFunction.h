//
// Author: Valerio Bertone: valerio.bertone@cern.ch
//

#pragma once

// Ceres solver
#include <ceres/ceres.h>
#include "NNAD/FeedForwardNN.h"
#include "Compute.h"

// Typedef for the data
typedef std::vector<std::pair<double, double>> vectdata;

// A CostFunction implementing analytically derivatives for the chi2.
class AnalyticCostFunction : public ceres::CostFunction
{
  public:
    AnalyticCostFunction(int const &,
                         int const &,
                         vectdata const &,
                         std::string const &);

    virtual ~AnalyticCostFunction();

    virtual bool Evaluate(double const *const *,
                          double *,
                          double **) const;

  private:
    int _Np;
    int _Seed;
    Compute<double> *_compute;
    vectdata _Data;
    std::string _InputCardName;

};
