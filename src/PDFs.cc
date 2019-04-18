#include "PDFs.h"
#include "Globals.h"

template <class T>
PDFs<T>::PDFs() {}

template <class T>
PDFs<T>::~PDFs() { delete _nn; }

template <class T>
PDFs<T>::PDFs(int const &Seed, std::string const &InputCardName) : _Seed(Seed), _InputCardName(InputCardName)
{

    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());

    if (*(InputCard["NNarchitecture"].as<std::vector<int>>().end() - 1) != 3)
        Error("Outputing more/less than 3 PDFs needs to be implemeneted in PDFs.");

    _nn = new FeedForwardNN<T>(InputCard["NNarchitecture"].as<std::vector<int>>(), _Seed);
    _nnp = _nn->GetParameterNumber();

    _Parameters = _nn->GetParameters();
}

template <class T>
void PDFs<T>::SetParameters(std::vector<T> Parameters)
{
    _Parameters = Parameters;

    std::vector<T> NNparameters(Parameters.begin(), Parameters.begin() + _nnp);
    _nn->SetParameters(NNparameters);
}

template <class T>
std::vector<T> PDFs<T>::GetParameters()
{
    return _Parameters;
}

template <class T>
int PDFs<T>::GetParameterNumber()
{
    return _Parameters.size();
}

template <class T>
T PDFs<T>::MSR() const
{
    std::vector<T> vpdfs1 = _nn->Evaluate({T{1}, T{0}});
    const auto MomDens = [=](T const &x) -> std::vector<T> 
    {
        std::vector<T> integ_output = _nn->Evaluate({x, log(x)});
        integ_output.erase(integ_output.end() - 1);
        integ_output.at(0)-=vpdfs1.at(0);
        integ_output.at(1) -= vpdfs1.at(1);
        return integ_output;
    };

    std::vector<T> integration_result = _gl.integrate_v(T(0), T{1}, MomDens);

    return ((T{1.} - integration_result[0]) / integration_result[1]);
}

template <class T>
std::vector<T> PDFs<T>::Evaluate(std::vector<T> const &Input) const
{
    std::vector<T> vpdfs1 = _nn->Evaluate({T{1}, T{0}});
    std::vector<T> vpdfs = _nn->Evaluate(Input);
    for(int i=0;i<vpdfs1.size();i++)
        vpdfs.at(i)-=vpdfs1.at(i);

    return vpdfs;
}

template <>
std::vector<double> PDFs<double>::MSRDerive() const
{
    std::vector<double> output;

    const int NPDF = 1 + _nnp;

    std::vector<double> vpdfs1 = _nn->Derive({1, 0});
    const auto MomDens = [=](double const &x) -> std::vector<double> {
        std::vector<double> integ_output = _nn->Derive({x, log(x)});
        for(int i=0;i<integ_output.size();i++)
            integ_output.at(i)-=vpdfs1.at(i);

        return integ_output;
    };

    return _gl.integrate_v(0, 1, MomDens);
}

template <>
std::vector<double> PDFs<double>::Derive(std::vector<double> const &Input) const
{
    std::vector<double> NNderivatives1 = _nn->Derive({1,0});
    std::vector<double> NNderivatives = _nn->Derive(Input);

    std::vector<double> output;

    const int NPDF = 1 + _nnp;
    output.reserve(3 * (NPDF));

    for (int n = 0; n < NPDF; n++)
    {
        //Singlet
        output.push_back(NNderivatives[3 * n] - NNderivatives1[3 * n]); // Singlet (fl = 0)

        //Gluon
        output.push_back(NNderivatives[3 * n + 1] - NNderivatives1[3 * n + 1]);

        //T8
        output.push_back(NNderivatives[3 * n + 2] - NNderivatives1[3 * n + 2]); // T8 (fl = 5)
    }

    return output;
}

template class PDFs<double>;                               //<! for numeric and analytic
template class PDFs<ceres::Jet<double, GLOBALS::kStride>>; //<! for automatic