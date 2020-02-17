//
// Author: Rabah Abdul Khalek - rabah.khalek@gmail.com
//

#include "AutoDiffCostFunction.h"
#include "Globals.h"

AutoDiffCostFunction::AutoDiffCostFunction(int const &Seed,
                                           std::string const &InputCardName,
                                           int const &Np,
                                           vectdata const &Data) : _Seed(Seed),
                                                                      _InputCardName(InputCardName),
                                                                      _Np(Np),
                                                                      _Data(Data)
{
}

template <typename T>
bool AutoDiffCostFunction::operator()(T const *const *parameters, T *residuals) const
{
    static Compute<T> Comp(_Seed, _InputCardName);

    std::vector<T> pars;
    for (int i = 0; i < _Np; i++)
    {
        pars.push_back(parameters[i][0]);
    }
    Comp.SetParameters(pars);

    //std::vector<T> v = std::get<Compute<T>>(_computers).Predictions();
    std::vector<T> v = Comp.Predictions();

    for (int id = 0; id < _Data.size(); id++)
    {
        residuals[id] = (v[id] - std::get<0>(_Data[id])) / std::get<1>(_Data[id]);
    }

    return true;
    }

// template fixed types
template bool AutoDiffCostFunction::operator()(double const *const *parameters, double *residuals) const;
template bool AutoDiffCostFunction::operator()(ceres::Jet<double, GLOBALS::kStride> const *const *parameters, ceres::Jet<double, GLOBALS::kStride> *residuals) const;