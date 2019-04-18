#pragma once

#include <iostream>
#include <vector>
#include <functional>
#include <random>
#include <stdlib.h>

#include "Utilities.h"
#include "ceres/jet.h"

template <class T>
class pMatrix
{
public:
  // Constructors
  ~pMatrix();
  pMatrix(int const &, int const &, int const &RandomSeed = 0, bool const &tempflag = true);
  pMatrix(int const &, int const &, std::vector<T *> const &, bool const & tempflag=true);
  pMatrix(int const &, int const &, std::vector<T> const &, bool const &tempflag = true);

  pMatrix(pMatrix const &x, std::function<T(T const &)> f, bool const & tempflag=true );

  // Setter
  void SetElement(int const &, int const &, T const &);
  void SetAddress(int const &, int const &, T * const &);

  // Getters
  T GetElement(int const &, int const &) const;
  T* GetAddress(int const &, int const &) const;

  int GetLines() const { return _Lines; };
  int GetColumns() const { return _Columns; };
  bool GetTEMPFLAG() const { return _TEMPFLAG;};

  std::vector<T*> GetVector() const { return _pMatrix; };

  // Operators
  void operator=(pMatrix const &);

  pMatrix operator+(pMatrix const &);

  pMatrix operator-(pMatrix const &);

  void operator+=(pMatrix const &);

  void operator-=(pMatrix const &);

  pMatrix operator*(pMatrix const &) const;

  void operator*=(pMatrix const &);

  pMatrix operator*(T const &);

private:
  int _Lines;
  int _Columns;
  std::vector<T*> _pMatrix;
  bool _TEMPFLAG;
};
