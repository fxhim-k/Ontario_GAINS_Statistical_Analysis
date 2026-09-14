# 03_hypothesis_testing.R -------------------------------------------------
# Question: Is mean minimum total monthly income different for recipients
# below vs. at/above $7,500 in minimum annual private income?
#
# This intentionally fixes an inconsistency in the original assignment code,
# which mixed minimum variables for one group with maximum variables for the other.

source("R/01_data_cleaning.R")

analysis_data <- income_data %>%
  mutate(
    income_group = if_else(
      annual_private_min < 7500,
      "Below $7,500",
      "$7,500 or above"
    )
  )

group_summary <- analysis_data %>%
  group_by(income_group) %>%
  summarise(
    n = n(),
    mean_monthly_income = mean(total_monthly_min, na.rm = TRUE),
    sd_monthly_income = sd(total_monthly_min, na.rm = TRUE),
    .groups = "drop"
  )
print(group_summary)

welch_test <- t.test(
  total_monthly_min ~ income_group,
  data = analysis_data,
  var.equal = FALSE,
  conf.level = 0.95
)
print(welch_test)

# Tidy result for reporting.
print(broom::tidy(welch_test))
