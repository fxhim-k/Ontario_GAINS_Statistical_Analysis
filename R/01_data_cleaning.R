# 01_data_cleaning.R -------------------------------------------------------
# Purpose: Import the GAINS rate table and create clean analysis variables.

source("R/00_setup.R")

raw_path <- "data/gains_rate_tables_75_apr_1_to_june_30_2024_1.csv"
if (!file.exists(raw_path)) {
  stop("Dataset not found. Add the GAINS CSV to the data/ folder.")
}

income_raw <- read.csv(raw_path, check.names = FALSE, stringsAsFactors = FALSE)

# Helper: remove thousands separators and convert safely to numeric.
to_numeric <- function(x) as.numeric(gsub(",", "", trimws(x)))

# Position-based selection keeps the workflow robust to bilingual punctuation
# and minor changes in R's automatic column-name conversion.
income_data <- tibble(
  annual_private_min = to_numeric(income_raw[[1]]),
  annual_private_max = to_numeric(income_raw[[2]]),
  gains = to_numeric(income_raw[[3]]),
  oas_gis_total = to_numeric(income_raw[[4]]),
  oas = to_numeric(income_raw[[5]]),
  gis = to_numeric(income_raw[[6]]),
  total_monthly_min = to_numeric(income_raw[[7]]),
  total_monthly_max = to_numeric(income_raw[[8]]),
  monthly_private_min = to_numeric(income_raw[[9]]),
  monthly_private_max = to_numeric(income_raw[[10]])
) %>%
  filter(if_all(everything(), ~ !is.na(.x)))

cat("Rows after cleaning:", nrow(income_data), "\n")
print(summary(income_data))
