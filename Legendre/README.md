## Conda Installation

```
cd NNAD-Interface/Legendre
conda install -c conda-forge gsl gflags yaml-cpp glog ceres-solver 
conda install pkg-config cmake
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX
make
```
