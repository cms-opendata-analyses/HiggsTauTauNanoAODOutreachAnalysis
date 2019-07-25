# Analysis of Higgs boson decays to two tau leptons using data and simulation from the CMS detector

This repository contains an analysis using reduced NanoAOD files created from CMS open data studying the decay of a Higgs boson into two tau leptons. The code produces plots such as shown below which can be used to study the physics in the CMS datasets.

Note that the analysis is not validated and should be used only for educational purposes, in particular since no systematic uncertainties are included.

![](plots/npv.png)

![](plots/eta_2.png)

![](plots/m_vis.png)

# How to run this?

## Get the software stack

The analysis needs solely a ROOT installation (6.16 or greater). You can get the software easily using the CMS Open Data VM and CVMFS. Just run the following command in the terminal to source an appropriate software stack:

```bash
source /cvmfs/sft.cern.ch/lcg/views/LCG_95/x86_64-slc6-gcc8-opt/setup.sh
```

## Skim the dataset

The skimming reduces the inital dataset to only the events needed for the analysis. This part is written in C++ in the file `skim.cxx`. To compile and run the program, use the following commands.

```bash
g++ -g -std=c++11 -O3 -Wall -Wextra -Wpedantic -o skim skim.cxx $(root-config --cflags --libs)
./skim
```

## Produce histograms

Next, we want to produce histograms for most of the variables in the dataset. To make a comparison from simulation to data, we have to produce a histogram for each simulated process and the actual data events recorded at CMS. The histograms are produced in a Python script implemented in `histograms.py` and can be run with following command.

```bash
python histograms.py
```

## Make plots

The last step of this analysis is the combination of the previously produced histograms to figures showing the simulated events and the data recorded at CMS on top of each other. This allows us to draw conclusions about the agreement between simulation and data and gives insights into the recorded data regarding the composition of the physical processes and their properties. Run the following Python script to make plots from the output of the previous step.

```bash
python plot.py
```
