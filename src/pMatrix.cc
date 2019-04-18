#include "pMatrix.h"
#include "Globals.h"

//TODO: You are here, result(l,c) should be provided for some operators, the question is, we need to provide a destructor for temp matrices 
//TODO: but not use it for the parameters.
//TODO: Add a boolean flag that turns true if it's parameters and not if it's temp matrix, and delete only if it's temp.

template <class T>
pMatrix<T>::~pMatrix()
{
  if(_TEMPFLAG)
  {
  for (auto pObj = _pMatrix.begin(); pObj != _pMatrix.end(); ++pObj)
  {
    delete *pObj; // Note that this is deleting what pObj points to,
                  // which is a pointer
  }

  _pMatrix.clear(); // Purge the contents so no one tries to delete them
  }
}

template <class T>
pMatrix<T>::pMatrix(int const &Lines, int const &Columns, int const &RandomSeed, bool const &tempflag) : _Lines(Lines),
                                                                                                         _Columns(Columns),
                                                                                                         _TEMPFLAG(tempflag)
{
  _pMatrix.reserve(_Lines*_Columns);
  // Initialise random number generator.
  if (RandomSeed != 0)
  {
    srand(RandomSeed);
    // Fill in the matrix with random numbers distributed in [-1:1].
    for (int i = 0; i < _Lines * _Columns; i++)
      _pMatrix.push_back(new T(2e-2 * (rand() % 100) - 1));
  }
  else
  {
    // Fill in the matrix with random numbers distributed in [-1:1].
    for (int i = 0; i < _Lines * _Columns; i++)
      _pMatrix.push_back(new T(0));
  }
}

  template <class T>
  pMatrix<T>::pMatrix(int const &Lines, int const &Columns, std::vector<T*> const &Entries, bool const & tempflag) : _Lines(Lines),
                                                                                        _Columns(Columns),
                                                                                        _pMatrix(Entries),
                                                                                        _TEMPFLAG(tempflag)
  {
    if(Entries.size()==0)
      Error("the std::vector<T*> passed to pMatrix() is empty!");
    // Check that the size of the Entries match the size of the pMatrix
    if (_Lines * _Columns != (int)Entries.size())
      Error("pMatrix: the size of the input vector does not match the size of the pMatrix.");
  }

  template <class T>
  pMatrix<T>::pMatrix(int const &Lines, int const &Columns, std::vector<T> const &Entries, bool const &tempflag) : _Lines(Lines),
                                                                                                                     _Columns(Columns),
                                                                                                                     _TEMPFLAG(tempflag)
  {
    int size = Entries.size();
    if (size == 0)
      Error("the std::vector<T*> passed to pMatrix() is empty!");
    // Check that the size of the Entries match the size of the pMatrix
    if (_Lines * _Columns != (int)size)
      Error("pMatrix: the size of the input vector does not match the size of the pMatrix.");
    
    _pMatrix.reserve(size);
    for(int i=0;i<size;i++)
      _pMatrix.push_back(new T(Entries.at(i)));
  }

  template <class T>
  pMatrix<T>::pMatrix(pMatrix const &x, std::function<T(T const &)> f, bool const & tempflag) : _Lines(x.GetLines()),
                                                                                                       _Columns(x.GetColumns()),
                                                                                                       _TEMPFLAG(tempflag)
  {

    _pMatrix.reserve(_Lines * _Columns);
     std::vector<T *> _pMatrix = x.GetVector();
     //_pMatrix=pMatrix;

    const int n = (int)_pMatrix.size();
    if (n == 0)
      Error("the Matrix passed to pMatrix() is empty!");
    for (int i = 0; i < n; i++)
      _pMatrix[i][0]=f(_pMatrix[i][0]);

  }

  // Setter
  template <class T>
  void pMatrix<T>::SetElement(int const &i, int const &j, T const &value)
  {
    if (i < 0 || i > _Lines)
      Error("SetElement: line index out of range.");

    if (j < 0 || j > _Columns)
      Error("SetElement: column index out of range.");

    _pMatrix[i * _Columns + j][0] = value;
  }

  // Getters
  template <class T>
  T pMatrix<T>::GetElement(int const &i, int const &j) const
  {
    if (i < 0 || i > _Lines)
      Error("GetElement: line index out of range.");

    if (j < 0 || j > _Columns)
      Error("GetElement: column index out of range.");

    return _pMatrix[i * _Columns + j][0];
  }

  // Setter
  template <class T>
  void pMatrix<T>::SetAddress(int const &i, int const &j, T *const &value)
  {
    if (i < 0 || i > _Lines)
      Error("SetAddress: line index out of range.");

    if (j < 0 || j > _Columns)
      Error("SetAddress: column index out of range.");

    _pMatrix[i * _Columns + j] = value;
  }

  // Getters
  template <class T>
  T* pMatrix<T>::GetAddress(int const &i, int const &j) const
  {
    if (i < 0 || i > _Lines)
      Error("GetAddress: line index out of range.");

    if (j < 0 || j > _Columns)
      Error("GetAddress: column index out of range.");

    return _pMatrix[i * _Columns + j];
  }
  //TODO: you are here
  // Operators
  template <class T>
  void pMatrix<T>::operator=(pMatrix const &term)
  {
    _Lines = term.GetLines();
    _Columns = term.GetColumns();
    std::vector<T *> temp= term.GetVector();
    for(int i=0;i<temp.size();i++)
      _pMatrix[i][0]=temp[i][0];
    _TEMPFLAG= term.GetTEMPFLAG();
  }

  template <class T>
  pMatrix<T> pMatrix<T>::operator+(pMatrix const &term)
  {
    const int l = term.GetLines();
    const int c = term.GetColumns();
    if (_Lines != l || _Columns != c)
      Error("Lines or Columns don't match adding the two matrices.");


    pMatrix result(l, c);
    for (int i = 0; i < l; i++)
      for (int j = 0; j < c; j++)
        result.SetElement(i, j, _pMatrix[i * _Columns + j][0] + term.GetElement(i, j));

    return result;
  }

  template <class T>
  pMatrix<T> pMatrix<T>::operator-(pMatrix const &term)
  {
    const int l = term.GetLines();
    const int c = term.GetColumns();
    if (_Lines != l || _Columns != c)
      Error("Lines or Columns don't match adding the two matrices.");

    pMatrix result(l, c);
    for (int i = 0; i < l; i++)
      for (int j = 0; j < c; j++)
        result.SetElement(i, j, _pMatrix[i * _Columns + j][0] - term.GetElement(i, j));

    return result;
  }

  template <class T>
  void pMatrix<T>::operator+=(pMatrix const &term)
  {
    const int l = term.GetLines();
    const int c = term.GetColumns();
    if (_Lines != l || _Columns != c)
      Error("Lines or Columns don't match adding the two matrices.");

    for (int i = 0; i < l; i++)
      for (int j = 0; j < c; j++)
        _pMatrix[i * _Columns + j][0] += term.GetElement(i, j);
  }

  template <class T>
  void pMatrix<T>::operator-=(pMatrix const &term)
  {
    const int l = term.GetLines();
    const int c = term.GetColumns();
    if (_Lines != l || _Columns != c)
      Error("Lines or Columns don't match adding the two matrices.");

    for (int i = 0; i < l; i++)
      for (int j = 0; j < c; j++)
        _pMatrix[i * _Columns + j][0] -= term.GetElement(i, j);
  }

  template <class T>
  pMatrix<T> pMatrix<T>::operator*(pMatrix const &term) const
  {

    const int l1 = _Lines;
    const int c1 = _Columns;
    const int l2 = term.GetLines();
    const int c2 = term.GetColumns();
    //const bool tempflag=term.GetTEMPFLAG();
    if (c1 != l2)
      Error("Lines or Columns don't match multiplying the two matrices.");

    pMatrix result(l1, c2);

    for (int i = 0; i < c2; i++)
      for (int j = 0; j < l1; j++)
      {
        T value=T(0);
        for (int k = 0; k < c1; k++)
          value += _pMatrix[j * _Columns + k][0] * term.GetElement(k, i);

        result.SetElement(j, i, value);

      }

    return result;
  }

  template <class T>
  void pMatrix<T>::operator*=(pMatrix const &term)
  {
    const int l1 = _Lines;
    const int c1 = _Columns;
    const int l2 = term.GetLines();
    const int c2 = term.GetColumns();
    if (c1 != l2)
      Error("Lines or Columns don't match multiplying the two matrices.");

    for (int i = 0; i < c2; i++)
      for (int j = 0; j < l1; j++)
      {
        T value = T(0);
        for (int k = 0; k < c1; k++)
          value += _pMatrix[j * _Columns + k][0] * term.GetElement(k, i);

        _pMatrix[i * _Columns + j][0] = value;
      }
  }

  template <class T>
  pMatrix<T> pMatrix<T>::operator*(T const &coef)
  {
    pMatrix result(_Lines, _Columns);
    for (int i = 0; i < _Lines; i++)
      for (int j = 0; j < _Columns; j++)
        result.SetElement(i, j, coef * _pMatrix[i * _Columns + j][0]);

    return result;
  }

  // template fixed types
  template class pMatrix<double>; //<! for numeric and analytic
  template class pMatrix<ceres::Jet<double, GLOBALS::kStride>>; //<! for automatic
