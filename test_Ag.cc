
// Standard libs
#include <iostream>
#include <math.h>
#include <cstdlib>
#include <fstream>
#include <string>

#include "yaml-cpp/yaml.h"

#include "rosetta.h"
#include <LHAPDF/LHAPDF.h>
using namespace std;

int main(int argc, char *argv[])
{

    YAML::Node InputCard = YAML::LoadFile("InputCard.yaml");
    int pos = 0;
    const auto MomDens = [=](double const &x) -> std::vector<double> {
        vector<double> xfAll;

        for (auto Dataset : InputCard["Datasets"])
        {

            const double Q0 = 1.3;

            LHAPDF::PDFSet PDFSet((InputCard["CT0_PDF"].as<std::string>()).c_str());
            LHAPDF::PDF *PDF = PDFSet.mkPDF(0);

            // Singlet distribution
            xfAll.push_back(PDF->xfxQ(1, x, Q0) + PDF->xfxQ(-1, x, Q0)                   //d+dbar
                            + PDF->xfxQ(2, x, Q0) + PDF->xfxQ(-2, x, Q0)                 //u+ubar
                            + PDF->xfxQ(3, x, Q0) + PDF->xfxQ(-3, x, Q0));            //s+sbar
                            //+ PDF->xfxQ(4, x, Q0) + PDF->xfxQ(-4, x, Q0)); //c+cbar
            // gluon distribution
            xfAll.push_back(PDF->xfxQ(0, x, Q0));
            
        }
        return xfAll;
    };
    Rosetta::GaussLegendreQuadrature<double, 100> gl;

    std::vector<double> integration_result = gl.integrate_v(0, 1, MomDens);

    cout<<"MSR = "<<integration_result[0] + integration_result[1]<<endl;

    return 0;
}
