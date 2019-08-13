# Implementation of the histogramming step of the analysis
#
# The histogramming step produces histograms for each variable in the dataset
# and for each physics process resulting into the final state with a muon and a
# tau. Then, the resulting histograms are passed to the plotting step, which
# combines the histograms so that we can study the physics of the decay.


import ROOT
ROOT.gROOT.SetBatch(True)


# Declare the range of the histogram for each variable
#
# Each entry in the dictionary contains of the variable name as key and a tuple
# specifying the histogram layout as value. The tuple sets the number of bins,
# the lower edge and the upper edge of the histogram.
default_nbins = 30
ranges = {
        "pt_1": (default_nbins, 17, 70),
        "pt_2": (default_nbins, 20, 70),
        "eta_1": (default_nbins, -2.1, 2.1),
        "eta_2": (default_nbins, -2.3, 2.3),
        "phi_1": (default_nbins, -3.14, 3.14),
        "phi_2": (default_nbins, -3.14, 3.14),
        "iso_1": (default_nbins, 0, 0.10),
        "iso_2": (default_nbins, 0, 0.10),
        "q_1": (2, -2, 2),
        "q_2": (2, -2, 2),
        "pt_met": (default_nbins, 0, 60),
        "phi_met": (default_nbins, -3.14, 3.14),
        "m_1": (default_nbins, 0, 0.2),
        "m_2": (default_nbins, 0, 2),
        "mt_1": (default_nbins, 0, 100),
        "mt_2": (default_nbins, 0, 100),
        "dm_2": (11, 0, 11),
        "m_vis": (default_nbins, 20, 140),
        "pt_vis": (default_nbins, 0, 60),
        "jpt_1": (default_nbins, 30, 70),
        "jpt_2": (default_nbins, 30, 70),
        "jeta_1": (default_nbins, -4.7, 4.7),
        "jeta_2": (default_nbins, -4.7, 4.7),
        "jphi_1": (default_nbins, -3.14, 3.14),
        "jphi_2": (default_nbins, -3.14, 3.14),
        "jm_1": (default_nbins, 0, 20),
        "jm_2": (default_nbins, 0, 20),
        "jbtag_1": (default_nbins, 0, 1.0),
        "jbtag_2": (default_nbins, 0, 1.0),
        "npv": (25, 5, 30),
        "njets": (5, 0, 5),
        "mjj": (default_nbins, 0, 400),
        "ptjj": (default_nbins, 0, 200),
        "jdeta": (default_nbins, -9.4, 9.4),
        }


# Book a histogram for a specific variable
def bookHistogram(df, variable, range_):
    return df.Histo1D(ROOT.ROOT.RDF.TH1DModel(variable, variable, range_[0], range_[1], range_[2]),\
                      variable, "weight")


# Write a histogram with a given name to the output ROOT file
def writeHistogram(h, name):
    h.SetName(name)
    h.Write()


# Apply a selection based on generator information about the tau
#
# See the skimming step for further details about this variable.
def filterGenMatch(df, label):
    if label is "ZTT":
        return df.Filter("gen_match == true")
    elif label is "ZLL":
        return df.Filter("gen_match == false")
    else:
        return df


# Main function of the histogramming step
#
# The function loops over the outputs from the skimming step and produces the
# required histograms for the final plotting.
# Note that we perform a set of secondary selections on the skimmed dataset. First,
# we perform a second reduction with the baseline selection to a signal-enriched
# part of the dataset. Second, we select besides the signal region a control region
# which is used to estimate the contribution of QCD events producing the muon-tau
# pair in the final state.
def main():
    # Set up multi-threading capability of ROOT
    ROOT.ROOT.EnableImplicitMT()
    poolSize = ROOT.ROOT.GetImplicitMTPoolSize()
    print("Pool size: {}".format(poolSize))

    # Create output file
    tfile = ROOT.TFile("histograms.root", "RECREATE")
    variables = ranges.keys()

    # Loop through skimmed datasets and produce histograms of variables
    for name, label in [
            ("GluGluToHToTauTau", "ggH"),
            ("VBF_HToTauTau", "qqH"),
            ("W1JetsToLNu", "W1J"),
            ("W2JetsToLNu", "W2J"),
            ("W3JetsToLNu", "W3J"),
            ("TTbar", "TT"),
            ("DYJetsToLL", "ZLL"),
            ("DYJetsToLL", "ZTT"),
            ("Run2012B_TauPlusX", "dataRunB"),
            ("Run2012C_TauPlusX", "dataRunC"),
        ]:
        print(">>> Process skim {}".format(name))

        # Load skimmed dataset and apply baseline selection
        df = ROOT.ROOT.RDataFrame("Events", name + "Skim.root")\
                      .Filter("mt_1<30", "Muon transverse mass cut for W+jets suppression")\
                      .Filter("iso_1<0.1", "Require isolated muon for signal region")

        # Book histograms for the signal region
        df1 = df.Filter("q_1*q_2<0", "Require opposited charge for signal region")
        df1 = filterGenMatch(df1, label)
        hists = {}
        for variable in variables:
            hists[variable] = bookHistogram(df1, variable, ranges[variable])
        report1 = df1.Report()

        # Book histograms for the control region used to estimate the QCD contribution
        df2 = df.Filter("q_1*q_2>0", "Control region for QCD estimation")
        df2 = filterGenMatch(df2, label)
        hists_cr = {}
        for variable in variables:
            hists_cr[variable] = bookHistogram(df2, variable, ranges[variable])
        report2 = df2.Report()

        # Write histograms to output file
        for variable in variables:
            writeHistogram(hists[variable], "{}_{}".format(label, variable))
        for variable in variables:
            writeHistogram(hists_cr[variable], "{}_{}_cr".format(label, variable))

        # Print cut-flow report
        print("Cut-flow report (signal region):")
        report1.Print()
        print("Cut-flow report (control region):")
        report2.Print()

    tfile.Close()


if __name__ == "__main__":
    main()
