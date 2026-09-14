# 00_setup.R ---------------------------------------------------------------
# Purpose: Install/load packages and define project-wide options.

required_packages <- c("tidyverse", "caret", "broom")

missing_packages <- required_packages[!required_packages %in% rownames(installed.packages())]
if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

invisible(lapply(required_packages, library, character.only = TRUE))

set.seed(123)
options(scipen = 999)
