
#include <iostream>
#include <cmath>
#include <iomanip>
#include <algorithm>
#include <cctype>
#include <vector>
#include <functional>
//https://rosettacode.org/wiki/Numerical_integration/Gauss-Legendre_Quadrature#C.2B.2B
namespace Rosetta {
 
    /*! Implementation of Gauss-Legendre quadrature
    *  http://en.wikipedia.org/wiki/Gaussian_quadrature
    *  http://rosettacode.org/wiki/Numerical_integration/Gauss-Legendre_Quadrature
    * 
    */
    template <class T, int N>
    class GaussLegendreQuadrature {
    public:
        enum {eDEGREE = N};
 
        /*! Compute the integral of a functor
        *
        *   @param a    lower limit of integration
        *   @param b    upper limit of integration
        *   @param f    the function to integrate
        *   @param err  callback in case of problems
        */
        template <typename Function>
        T integrate(T a, T b, Function f) {
            T p = (b - a) / T(2);
            T q = (b + a) / T(2);
            const LegendrePolynomial<T>& legpoly = s_LegendrePolynomial;
 
            T sum = 0;
            for (int i = 1; i <= eDEGREE; ++i) {
                sum += legpoly.weight(i) * f(p * legpoly.root(i) + q);
            }

            return p * sum;
        }

        std::vector<T> integrate_v(T a, T b, std::function<std::vector<T>(T const &)> const &f) const
        {
            T p = (b - a) / T(2);
            T q = (b + a) / T(2);
            const LegendrePolynomial<T> &legpoly = s_LegendrePolynomial;

            int n_v = f(T(0)).size();
            std::vector<T> sums(n_v, T(0));
            //for (int n = 0; n < n_v; n++)
            //{
            for (int i = 1; i <= eDEGREE; ++i)
            {
                std::vector<T> v = f(p * legpoly.root(i) + q);

                std::transform(v.begin(), v.end(), v.begin(),
                               std::bind(std::multiplies<T>(), std::placeholders::_1, legpoly.weight(i)));

                std::transform(sums.begin(), sums.end(), v.begin(), sums.begin(), std::plus<T>());
                //sums.at(n) += legpoly.weight(i) * (f(p * legpoly.root(i) + q)).at(n);
            }
            //sums.at(n) *= p;
            //}
            std::transform(sums.begin(), sums.end(), sums.begin(),
                           std::bind(std::multiplies<T>(), std::placeholders::_1, p));
            return sums;
        }

        /*! Print out roots and weights for information
        */
        void print_roots_and_weights(std::ostream& out) const {
            const LegendrePolynomial<T>& legpoly = s_LegendrePolynomial;
            out << "Roots:  ";
            for (int i = 0; i <= eDEGREE; ++i) {
                out << ' ' << legpoly.root(i);
            }
            out << '\n';
            out << "Weights:";
            for (int i = 0; i <= eDEGREE; ++i) {
                out << ' ' << legpoly.weight(i);
            }
            out << '\n';
        }
    private:
        /*! Implementation of the Legendre polynomials that form
        *   the basis of this quadrature
        */
      template <class TT>
      class LegendrePolynomial
      {
        public:
            LegendrePolynomial () {
                // Solve roots and weights
                for (int i = 0; i <= eDEGREE; ++i) {
                    TT dr = TT(1);
 
                    // Find zero
                    TT argu = TT(cos(M_PI * (i - 0.25) / (eDEGREE + 0.5)));
                    Evaluation<TT> eval(argu);
                    do {
                        dr = eval.v() / eval.d();
                        eval.evaluate(eval.x() - dr);
                    } while (abs (dr) > 2e-16);
 
                    this->_r[i] = eval.x();
                    this->_w[i] = T(2) / ((T(1) - eval.x() * eval.x()) * eval.d() * eval.d());
                }
            }
 
            TT root(int i) const { return this->_r[i]; }
            TT weight(int i) const { return this->_w[i]; }
        private:
            TT _r[eDEGREE + 1];
            TT _w[eDEGREE + 1];
 
            /*! Evaluate the value *and* derivative of the
            *   Legendre polynomial
            */
            template <class TTT> 
            class Evaluation
            {
              public:
                explicit Evaluation (TTT x) : _x(x), _v(1), _d(0) {
                    this->evaluate(x);
                }
 
                void evaluate(TT x) {
                    this->_x = x;
 
                    TTT vsub1 = x;
                    TTT vsub2 = T(1);
                    TTT f     = TTT(1) / (x * x - TTT(1));
 
                    for (int i = 2; i <= eDEGREE; ++i) {
                        this->_v = (TTT(2 * i - 1) * x * vsub1 - TTT(i - 1) * vsub2) / TTT(i);
                        this->_d = TTT(i) * f * (x * this->_v - vsub1);
 
                        vsub2 = vsub1;
                        vsub1 = this->_v;
                    }
                }
 
                TTT v() const { return this->_v; }
                TTT d() const { return this->_d; }
                TTT x() const { return this->_x; }
 
            private:
                TTT _x;
                TTT _v;
                TTT _d;
            };
        };
 
        /*! Pre-compute the weights and abscissae of the Legendre polynomials
        */
        static LegendrePolynomial<T> s_LegendrePolynomial;
    };
 
    template <class T,int N>
    typename GaussLegendreQuadrature<T,N>::template LegendrePolynomial<T> GaussLegendreQuadrature<T,N>::s_LegendrePolynomial;
}