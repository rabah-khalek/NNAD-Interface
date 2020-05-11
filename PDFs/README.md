# NNAD-Interface/PDFs

## Conda Installation

1. Install `root`:
```
conda install -c conda-forge root
```

2. Install `LHAPDF`:
```
wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.2.2.tar.gz -O LHAPDF-6.2.2.tar.gz
tar xf LHAPDF-6.2.2.tar.gz
cd LHAPDF-6.2.2
./configure --prefix=$CONDA_PREFIX
make
make install
```

3. Install `APFEL`:
```
git clone https://github.com/scarrazza/apfel.git
cd apfel
git checkout tags/2.7.1 -b new_branch
./configure --prefix=$CONDA_PREFIX
make && make install
```

4. Install `applgrid`:
```
wget http://applgrid.hepforge.org/downloads/applgrid-1.5.46.tgz
tar xf applgrid-1.5.46.tgz
./configure --prefix=$CONDA_PREFIX
make && make install
```

5. Install `APFELgrid`:
```
git clone git@github.com:nhartland/APFELgrid.git
git checkout namespace_change
autoreconf -i
./configure --prefix=$CONDA_PREFIX
make && make install
```

6. Position yourself in `PDFs/`:
```
cd NNAD-Interface/PDFs
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX
make
```
