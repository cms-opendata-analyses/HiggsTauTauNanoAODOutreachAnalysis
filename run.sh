#!/bin/bash

# Build and run skimming
g++ -g -O3 -Wall -Wextra -Wpedantic -o skim skim.cxx $(root-config --cflags --libs)
time ./skim

# Produce histograms for plotting
time python histograms.py

# Make plots
time python plot.py
