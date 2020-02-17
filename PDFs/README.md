# NNAGD-Interface
An interface to NNAGD(Neural Network library for Analytical Gradient Descent)

## Installation
```
mkdir build
cd build
cmake ..
make -j
./../scripts/SetupPlotting
```

## Running
```
cd build/run
# For one replica:
./main ../../cards/InputCard.yaml
# For many replicas, edit EXECUTE_rand and:
./EXECUTE_rand
```

## Plotting
### Replica
```
cd Plotting
./replica results/dd.mm.yyyy-hh.mm.ss
```

### Fit
```
cp results/name_of_the_fit.dat
./grids_avg -r <name_of_the_fit.dat> -c <minimum_chi2> -b <number_of_replicas>
cd Plotting
./fit <name_of_the_fit>
```
