# NNAD-Interface

This repository includes a collection of applications of the [`NNAD`](https://github.com/rabah-khalek/NNAD) library for the computation of analytic derivatives of a feed-forward neural network to minimisation problems. The examples relie on the [`ceres-solver`](http://ceres-solver.org) solver minimiser that also provides *numerical* and *automatic* differentiations.

## Prerequisites

The basic dependencies to run the example codes are:

 - `cmake`
 - `pkg-config`
 - `ceres-solver`
 - `glog`
 - `gflags`
 - `eigen3`
 - `yaml-cpp`
 
Additional external libraries may be required depending on the specific examples. More details are found in the README files in the single example folders.

## Examples

The following example codes are available so far:

- [Legendre](/Legendre): a direct fit of a NN to pseudodata generated using an oscillating Legendre polynomial as an underlying law.
- [PDFs](/PDFs): a *realistic* minimisation problem in which the functions to be determined appear inside a convolution integral. This problem closely resembles the extraction of collinear parton-distribution functions (PDFs) from experimental data.
 
 ## Reference

- Rabah Abdul Khalek, Valerio Bertone, *On the derivatives of feed-forward neural networks*, arXiv:2005.07039

## Contacts

- Rabah Abdul Khalek: rabah.khalek@gmail.com
- Valerio Bertone: valerio.bertone@cern.ch
