//
// Author: Valerio Bertone: valerio.bertone@cern.ch
//

#include "AnalyticCostFunction.h"

AnalyticCostFunction::AnalyticCostFunction(int const &Np, int const &Seed,
                                           vectdata const &expData,
                                           std::string const &InputCardName) : _Np(Np), _Seed(Seed),
                                                                               _Data(expData),
                                                                               _InputCardName(InputCardName)
{
    _compute = new Compute<double>(_Seed, _InputCardName);

    // Set number of residuals (i.e. number of data points)
    set_num_residuals(_Data.size());

    // Set sizes of the parameter blocks. There are as many parameter
    // blocks as free parameters and each block has size 1.
    for (int ip = 0; ip < _Np; ip++)
        mutable_parameter_block_sizes()->push_back(1);
}

bool AnalyticCostFunction::Evaluate(double const *const *parameters,
                                            double *residuals,
                                            double **jacobians) const
{
    std::vector<double> vpar(_Np);
    for (int ip = 0; ip < _Np; ip++)
        vpar[ip] = parameters[ip][0];

    // Number of residuals
    const int nd = num_residuals();

    _compute->SetParameters(vpar);

    // Residuals and Jacobian
    if (jacobians != NULL)
    {
        std::vector<std::vector<double>> v = _compute->dDerivatives();
        for (int id = 0; id < nd; id++)
        {
            residuals[id] = (v[id][0] - std::get<0>(_Data[id])) / std::get<1>(_Data[id]);
            for (int ip = 0; ip < _Np; ip++)
            {
                if (jacobians[ip] == nullptr)
                    continue;
                jacobians[ip][id] = (v[id][ip + 1]) / std::get<1>(_Data[id]);
            }
        }
    }
    // Only residuals
    else
    {
        std::vector<double> v = _compute->Predictions();
        for (int id = 0; id < nd; id++)
            residuals[id] = (v[id] - std::get<0>(_Data[id])) / std::get<1>(_Data[id]);
    }
    return true;
}

AnalyticCostFunction::~AnalyticCostFunction(){};