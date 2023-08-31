# Tests for the workflow execution duration time

Feature: Run duration

    As a researcher,
    I want to verify that my workflow finishes in a reasonable amount of time,
    so that I can stay assured that there are no unusual problems with computing resources.

    Scenario: The workflow terminates in a reasonable amount of time
        When the workflow execution completes
        Then the workflow run duration should be less than 25 minutes

    Scenario: The compiling step terminates in a reasonable amount of time
        When the workflow execution completes
        Then the duration of the step "compiling" should be less than 5 minutes

    Scenario: Skimming the data takes a reasonable amount of time
        When the workflow execution completes
        Then the duration of the step "skimming" should be less than 15 minutes

    Scenario: The histograms are created in a reasonable amount of time
        When the workflow execution completes
        Then the duration of the step "histogramming" should be less than 15 minutes

    Scenario: Combining the histograms into plot takes a reasonable amount of time
        When the workflow execution completes
        Then the duration of the step "plotting" should be less than 5 minutes
