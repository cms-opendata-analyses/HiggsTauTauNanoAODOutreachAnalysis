# Tests for the expected workflow log messages

Feature: Log messages

    As a researcher,
    I want to be able to see the log messages of my workflow execution,
    So that I can verify that the workflow ran correctly.

    Scenario: The compiling step has produced the expected messages
        When the workflow is finished
        Then the engine logs should contain
            """
            Publishing step:0, cmd: g++ -g -O3 -Wall -Wextra -Wpedantic -o skim skim.cxx `root-config --cflags --libs`, total steps 4 to MQ
            """

    Scenario: The skimming step has produced the expected messages
        When the workflow is finished
        Then the engine logs should contain "Publishing step:1, cmd: ./skim"
        And the job logs for the "skimming" step should contain
            """
            >>> Process sample VBF_HToTauTau:
            Number of events: 491653
            Passes trigger: pass=49109      all=491653     -- eff=9.99 % cumulative eff=9.99 %
            nMuon > 0 : pass=49096      all=49109      -- eff=99.97 % cumulative eff=9.99 %
            nTau > 0  : pass=49096      all=49096      -- eff=100.00 % cumulative eff=9.99 %
            Event has good taus: pass=10856      all=49096      -- eff=22.11 % cumulative eff=2.21 %
            Event has good muons: pass=10493      all=10856      -- eff=96.66 % cumulative eff=2.13 %
            Valid muon in selected pair: pass=10492      all=10493      -- eff=99.99 % cumulative eff=2.13 %
            Valid tau in selected pair: pass=10492      all=10492      -- eff=100.00 % cumulative eff=2.13 %
            """

    Scenario: The histogramming step has produced the expected messages
        When the workflow is finished
        Then the engine logs should contain "Publishing step:2, cmd: python histograms.py"
        And the job logs for the "histogramming" step should contain
            """
            >>> Process skimmed sample W1JetsToLNu for process W1J
            """
        And the job logs for the "histogramming" step should contain
            """
            >>> Process skimmed sample W2JetsToLNu for process W2J
            """
        And the job logs for the "histogramming" step should contain
            """
            >>> Process skimmed sample VBF_HToTauTau for process qqH
            """
        And the job logs for the "histogramming" step should contain
            """
            >>> Process skimmed sample TTbar for process TT
            """

    Scenario: The plotting step has produced the expected messages
        When the workflow is finished
        Then the engine logs should contain "Publishing step:3, cmd: python plot.py"
        And the job logs for the "plotting" step should contain
            """
            Info in <TCanvas::Print>: png file jphi_1.png has been created
            Info in <TCanvas::Print>: pdf file jphi_2.pdf has been created
            Info in <TCanvas::Print>: png file jphi_2.png has been created
            Info in <TCanvas::Print>: pdf file jeta_2.pdf has been created
            Info in <TCanvas::Print>: png file jeta_2.png has been created
            Info in <TCanvas::Print>: pdf file pt_vis.pdf has been created
            Info in <TCanvas::Print>: png file pt_vis.png has been created
            Info in <TCanvas::Print>: pdf file jm_1.pdf has been created
            Info in <TCanvas::Print>: png file jm_1.png has been created
            Info in <TCanvas::Print>: pdf file jbtag_2.pdf has been created
            Info in <TCanvas::Print>: png file jbtag_2.png has been created
            Info in <TCanvas::Print>: pdf file jm_2.pdf has been created
            Info in <TCanvas::Print>: png file jm_2.png has been created
            Info in <TCanvas::Print>: pdf file phi_met.pdf has been created
            Info in <TCanvas::Print>: png file phi_met.png has been created
            Info in <TCanvas::Print>: pdf file m_vis.pdf has been created
            Info in <TCanvas::Print>: png file m_vis.png has been created
            Info in <TCanvas::Print>: pdf file q_2.pdf has been created
            Info in <TCanvas::Print>: png file q_2.png has been created
            Info in <TCanvas::Print>: pdf file q_1.pdf has been created
            Info in <TCanvas::Print>: png file q_1.png has been created
            Info in <TCanvas::Print>: pdf file pt_met.pdf has been created
            Info in <TCanvas::Print>: png file pt_met.png has been created
            Info in <TCanvas::Print>: pdf file eta_1.pdf has been created
            Info in <TCanvas::Print>: png file eta_1.png has been created
            Info in <TCanvas::Print>: pdf file eta_2.pdf has been created
            Info in <TCanvas::Print>: png file eta_2.png has been created
            Info in <TCanvas::Print>: pdf file jbtag_1.pdf has been created
            Info in <TCanvas::Print>: png file jbtag_1.png has been created
            Info in <TCanvas::Print>: pdf file njets.pdf has been created
            Info in <TCanvas::Print>: png file njets.png has been created
            Info in <TCanvas::Print>: pdf file iso_1.pdf has been created
            Info in <TCanvas::Print>: png file iso_1.png has been created
            Info in <TCanvas::Print>: pdf file phi_1.pdf has been created
            Info in <TCanvas::Print>: png file phi_1.png has been created
            Info in <TCanvas::Print>: pdf file dm_2.pdf has been created
            Info in <TCanvas::Print>: png file dm_2.png has been created
            Info in <TCanvas::Print>: pdf file phi_2.pdf has been created
            Info in <TCanvas::Print>: png file phi_2.png has been created
            Info in <TCanvas::Print>: pdf file mt_2.pdf has been created
            Info in <TCanvas::Print>: png file mt_2.png has been created
            Info in <TCanvas::Print>: pdf file mt_1.pdf has been created
            Info in <TCanvas::Print>: png file mt_1.png has been created
            Info in <TCanvas::Print>: pdf file jeta_1.pdf has been created
            Info in <TCanvas::Print>: png file jeta_1.png has been created
            Info in <TCanvas::Print>: pdf file jpt_1.pdf has been created
            Info in <TCanvas::Print>: png file jpt_1.png has been created
            Info in <TCanvas::Print>: pdf file pt_1.pdf has been created
            Info in <TCanvas::Print>: png file pt_1.png has been created
            Info in <TCanvas::Print>: pdf file mjj.pdf has been created
            Info in <TCanvas::Print>: png file mjj.png has been created
            Info in <TCanvas::Print>: pdf file pt_2.pdf has been created
            Info in <TCanvas::Print>: png file pt_2.png has been created
            Info in <TCanvas::Print>: pdf file npv.pdf has been created
            Info in <TCanvas::Print>: png file npv.png has been created
            Info in <TCanvas::Print>: pdf file jpt_2.pdf has been created
            Info in <TCanvas::Print>: png file jpt_2.png has been created
            Info in <TCanvas::Print>: pdf file m_2.pdf has been created
            Info in <TCanvas::Print>: png file m_2.png has been created
            Info in <TCanvas::Print>: pdf file m_1.pdf has been created
            Info in <TCanvas::Print>: png file m_1.png has been created
            Info in <TCanvas::Print>: pdf file jdeta.pdf has been created
            Info in <TCanvas::Print>: png file jdeta.png has been created
            Info in <TCanvas::Print>: pdf file ptjj.pdf has been created
            Info in <TCanvas::Print>: png file ptjj.png has been created
            Info in <TCanvas::Print>: pdf file iso_2.pdf has been created
            Info in <TCanvas::Print>: png file iso_2.png has been created
            """