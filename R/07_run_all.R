# 07_run_all.R -----------------------------------------------------------
# Purpose: Run the complete analysis in order.

source("R/00_setup.R")
source("R/01_data_cleaning.R")
source("R/02_exploratory_analysis.R")
source("R/03_hypothesis_testing.R")
source("R/04_bootstrap_analysis.R")
source("R/05_regression_analysis.R")
source("R/06_model_validation.R")

cat("\nAnalysis complete. Review console output and the figures/ directory.\n")
