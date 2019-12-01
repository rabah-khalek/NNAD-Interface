//
// Author: Rabah Abdul Khalek: rabah.khalek@gmail.com
//

#include "Compute.h"

//Constructors
template <class T>
Compute<T>::Compute(){}

template <class T>
Compute<T>::Compute(int const &Seed, std::string const &InputCardName) : _Seed(Seed), _InputCardName(InputCardName), _pdfs(PDFs<T>(Seed, _InputCardName))
{
    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());

    _nd=0;
    for (auto Dataset : InputCard["Datasets"])
    {
        const std::string FK_path = InputCard["MainDir"].as<std::string>()+"/FK/FK_"+Dataset.as<string>()+".dat";
        
        NNPDF_APFELgrid::FKTable<double> FK(FK_path);

        _FKs.push_back(FK);
        _nd +=FK.GetNData();
    }

    _np = _pdfs.GetParameterNumber();

    _reference_MSR = 1;//integration_result[0] + integration_result[1];
}

template <class T>
int Compute<T>::GetNData()
{
    return _nd;
}

template <class T>
int Compute<T>::GetNParameters()
{
    return _np;
}

template <class T>
double Compute<T>::Getreference_MSR()
{
    return _reference_MSR;
}

//Functions

template <class T>
void Compute<T>::SetInputCardName(std::string const &name)
{
    _InputCardName = name;
}

template <class T>
void Compute<T>::SetParameters(vector<T> const &Parameters)
{
    _pdfs.SetParameters(Parameters);
}

template <class T>
vector<T> Compute<T>::Predictions()
{
    std::vector<T> output;
    output.reserve(_nd);
    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());

    T *pdf;
    T *res;

    int pos = 0;

    for (auto Dataset : InputCard["Datasets"])
    {
        int Nx = _FKs.at(pos).GetNx();
        int NonZero = _FKs.at(pos).GetNonZero();
        double *Xgrid = _FKs.at(pos).GetXGrid();
        int DSz = _FKs.at(pos).GetDSz();

        pdf = new T[NonZero * Nx];

        for (int i = 0; i < Nx; i++)
        {
            T x = T{Xgrid[i]};
            for (int fl = 0; fl < NonZero; fl++)
                pdf[fl * Nx + i] = T{0};
            std::vector<T> vpdfs = _pdfs.Evaluate({x, log(x)});

            pdf[i] = vpdfs.at(0); //Singlet
            pdf[Nx + i] = vpdfs.at(1); //Gluon
            /////pdf[3 * Nx + i] = vpdfs.at(2);   //T8
        }

        // Allocate an array for results and perform the convolution.
        int nd = _FKs.at(pos).GetNData();

        res = new T[nd];

        double *dpdf = nullptr;
        double *dres = nullptr;
        int NPDF;
        if (typeid(T) == typeid(double))
            NPDF = 1; //double
        else
            NPDF = GLOBALS::kStride + 1; //jet 1 for a and N stride for v where jet=a+v*epsilon

        dpdf = new double[NonZero * Nx * NPDF];
        dres = new double[nd * NPDF];

        dconvert(pdf, Nx, NonZero, DSz, dpdf);
        _FKs.at(pos).Convolute(dpdf, NPDF, dres);
        convertd(dres, nd, res);

        for (int id = 0; id < nd; id++)
            output.push_back(res[id]);

        pos++;
        // delete[] dpdf;
        delete[] pdf;
        //delete[] dres;
        delete[] res;
    }

    return output;
}

template <>
std::vector<std::vector<double>> Compute<double>::dDerivatives()
{
    std::vector<std::vector<double>> output;
    output.reserve(_nd);

    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());

    const int NPDF = 1 + _np;

    double *pdf;
    double *res;

    int pos = 0;

    for (auto Dataset : InputCard["Datasets"])
    {
        int Nx = _FKs.at(pos).GetNx();
        int NonZero = _FKs.at(pos).GetNonZero();
        double *Xgrid = _FKs.at(pos).GetXGrid();
        int DSz = _FKs.at(pos).GetDSz();

        pdf = new double[NPDF * NonZero * Nx];


        for (int i = 0; i < Nx; i++)
        {
            std::vector<double> vpdfs = _pdfs.Derive({Xgrid[i], log(Xgrid[i])});

            for (int n = 0; n < NPDF; n++)
            {
                for (int fl = 0; fl < NonZero; fl++)
                    pdf[n * DSz + fl * Nx + i] = 0;

                    pdf[n * DSz + i] = vpdfs[2 * n];                  // Singlet (fl = 0)
                    pdf[n * DSz + Nx + i] =vpdfs[2 * n + 1];     // Gluon (fl = 1)
                    /////pdf[n * DSz + 3 * Nx + i] = vpdfs[3 * n + 2]; // T8 (fl = 5)
                
            }
        }
        int nd = _FKs.at(pos).GetNData();
        res = new double[nd * NPDF];
        _FKs.at(pos).Convolute(pdf, NPDF, res);
        for (int id = 0; id < nd; id++)
        {
            std::vector<double> resid(NPDF);
            for (int ip = 0; ip < NPDF; ip++)
                resid[ip] = res[id * NPDF + ip];
            output.push_back(resid);
        }

        delete[] pdf;
        delete[] res;
        pos++;
    }
    return output;
}

template <>
std::vector<std::pair<double, double>> Compute<double>::PseudoData()
{
    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());
    int pos = 0;
    double *pdf;
    double *results;
    std::vector<double> temp_output;
    for (auto Dataset : InputCard["Datasets"])
    {
        int Nx = _FKs.at(pos).GetNx();
        int NonZero = _FKs.at(pos).GetNonZero();
        double *Xgrid = _FKs.at(pos).GetXGrid();
        //int DSz = _FKs.at(pos).GetDSz();
        const double Q0 = sqrt(_FKs.at(pos).GetQ20());

        LHAPDF::PDFSet PDFSet((InputCard["CT0_PDF"].as<std::string>()).c_str());
        LHAPDF::PDF *PDF = PDFSet.mkPDF(0);
        //const size_t nmem = PDFSet.size() - 1;
        pdf = new double[NonZero * Nx];
        for (int i = 0; i < Nx; i++)
        {
            vector<double> xfAll;

            // Singlet distribution
            xfAll.push_back(PDF->xfxQ(1, Xgrid[i], Q0) + PDF->xfxQ(-1, Xgrid[i], Q0)     //d+dbar
                            + PDF->xfxQ(2, Xgrid[i], Q0) + PDF->xfxQ(-2, Xgrid[i], Q0)   //u+ubar
                            + PDF->xfxQ(3, Xgrid[i], Q0) + PDF->xfxQ(-3, Xgrid[i], Q0)); //s+sbar
            //+ PDF->xfxQ(4, Xgrid[i], Q0) + PDF->xfxQ(-4, Xgrid[i], Q0));//c+cbar

            // gluon distribution
            xfAll.push_back(PDF->xfxQ(0, Xgrid[i], Q0));

            if (InputCard["ForceT3toBeZero"].as<string>() == "on")
                xfAll.push_back(0);
            else
                exit(1); //Error("Assign T3 in lhapdfPredictions()");

            xfAll.push_back(0);
            // T8 distribution
            /////xfAll.push_back(PDF->xfxQ(2, Xgrid[i], Q0) + PDF->xfxQ(-2, Xgrid[i], Q0)           //u+ubar
            /////                + PDF->xfxQ(1, Xgrid[i], Q0) + PDF->xfxQ(-1, Xgrid[i], Q0)         //d+dbar
            /////                - 2 * (PDF->xfxQ(3, Xgrid[i], Q0) + PDF->xfxQ(-3, Xgrid[i], Q0))); //s+sbar

            for (int fl = 0; fl < NonZero; fl++)
            {
                pdf[fl * Nx + i] = xfAll.at(fl);
            }
        }

        // Allocate an array for results and perform the convolution.
        results = new double[_FKs.at(pos).GetNData()];
        _FKs.at(pos).Convolute(pdf, 1, results);

        // Save results in a vector.
        const int nd = _FKs.at(pos).GetNData();
        for (int id = 0; id < nd; id++)
            temp_output.push_back(results[id]);

        delete[] pdf;
        delete[] results;
        pos++;
    }
    std::vector<std::pair<double, double>> output;
    srand(12345);
    for(int i=0;i<temp_output.size();i++)
    {
        std::pair<double, double> entry;
        entry.first = temp_output.at(i);
        double min = InputCard["min_sigma"].as<double>();
        double max = InputCard["max_sigma"].as<double>();
        double r = 1e-2 * (rand() % 100);
        double sd = abs((entry.first) * (max+min) * r - min);
        while(!sd)
        {
            r = 1e-2 * (rand() % 100);
            sd = abs((entry.first) * (max + min) * r - min);
        }
        entry.second =sd;
        //std::cout<<"CV = "<<entry.first<<", SD = "<<entry.second<<std::endl;
        output.push_back(entry);
    }
    return output;
}
/*
template <>
double Compute<double>::reference_MSR()
{

    YAML::Node InputCard = YAML::LoadFile((_InputCardName).c_str());
    const auto MomDens = [=](double const &x) -> std::vector<double> 
    {
        vector<double> xfAll;
        int pos = 0;
        for (auto Dataset : InputCard["Datasets"])
        {
            const double Q0 = sqrt(_FKs.at(pos).GetQ20());

            LHAPDF::PDFSet PDFSet((InputCard["CT0_PDF"].as<std::string>()).c_str());
            LHAPDF::PDF *PDF = PDFSet.mkPDF(0);

            // Singlet distribution
            xfAll.push_back(PDF->xfxQ(1, x, Q0) + PDF->xfxQ(-1, x, Q0)     //d+dbar
                            + PDF->xfxQ(2, x, Q0) + PDF->xfxQ(-2, x, Q0)   //u+ubar
                            + PDF->xfxQ(3, x, Q0) + PDF->xfxQ(-3, x, Q0)); //s+sbar
                                                                           //+ PDF->xfxQ(4, x, Q0) + PDF->xfxQ(-4, x, Q0)); //c+cbar
            // gluon distribution
            xfAll.push_back(PDF->xfxQ(0, x, Q0));
            pos++;
        }
        return xfAll;
    };
    Rosetta::GaussLegendreQuadrature<double, 100> gl;

    std::vector<double> integration_result = gl.integrate_v(0, 1, MomDens);

    return integration_result[0] + integration_result[1];
}
*/
// template fixed types
template class Compute<double>;                               //<! for numeric and analytic
template class Compute<ceres::Jet<double, GLOBALS::kStride>>; //<! for automatic