#pragma once

#include <iostream>
#include <string>

#include "NNAD/FeedForwardNN.h"
#include "rosetta.h"
#include "yaml-cpp/yaml.h"
#include "ceres/ceres.h"

template <class T>
class PDFs
{
public:
  PDFs();
  PDFs(int const &, std::string const &);
  ~PDFs();
  void SetParameters(std::vector<T>);
  std::vector<T> GetParameters();
  int GetParameterNumber();

  T MSR(double reference_MSR=1) const;
  std::vector<double> MSRDerive() const;

  std::vector<T> Evaluate(std::vector<T> const &) const;
  std::vector<double> Derive(std::vector<double> const &) const;

private:
  int _Seed;
  std::vector<T> _Parameters;
  std::string _InputCardName;
  nnad::FeedForwardNN<T> *_nn;
  Rosetta::GaussLegendreQuadrature<T, 100> _gl;
  int _nnp;
};