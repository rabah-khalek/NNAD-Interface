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

    /////if (*(InputCard["NNarchitecture"].as<std::vector<int>>().end() - 1) != 3)
    /////    nnad::Error("Outputing more/less than 3 PDFs needs to be implemeneted in PDFs.");

    _nn = new nnad::FeedForwardNN<T>(InputCard["NNarchitecture"].as<std::vector<int>>(), _Seed);
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
std::vector<T> PDFs<T>::Evaluate(std::vector<T> const &Input) const
{
    std::vector<T> vpdfs1 = _nn->Evaluate({T{1}, T{0}});
    std::vector<T> vpdfs = _nn->Evaluate(Input);
    for(int i=0;i<(int)vpdfs1.size();i++)
        vpdfs.at(i)-=vpdfs1.at(i);

    return vpdfs;
}

template <>
std::vector<double> PDFs<double>::Derive(std::vector<double> const &Input) const
{
    std::vector<double> NNderivatives1 = _nn->Derive({1, 0});
    std::vector<double> NNderivatives = _nn->Derive(Input);

    std::vector<double> output;

    const int NPDF = 1 + _nnp;
    output.reserve(2 * (NPDF));

    for (int n = 0; n < NPDF; n++)
    {
        //Singlet
        output.push_back(NNderivatives[2 * n] - NNderivatives1[2 * n]); // Singlet (fl = 0)

        //Gluon
        output.push_back(NNderivatives[2 * n + 1] - NNderivatives1[2 * n + 1]);

        //T8
        /////output.push_back(NNderivatives[3 * n + 2] - NNderivatives1[3 * n + 2]); // T8 (fl = 5)
    }

    return output;
}

template class PDFs<double>;                               //<! for numeric and analytic
template class PDFs<ceres::Jet<double, GLOBALS::kStride>>; //<! for automatic
