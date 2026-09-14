# 02_exploratory_analysis.R ----------------------------------------------
# Purpose: Summarize the actual GAINS rate-table data and create visuals.
# Note: the source CSV does not include a recipient-type field, so this script
# intentionally avoids the original assignment's hard-coded Single/Couple table.

source("R/01_data_cleaning.R")

dir.create("figures", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)

eda_summary <- income_data %>%
  summarise(
    rows = n(),
    mean_annual_private_min = mean(annual_private_min),
    mean_gains = mean(gains),
    mean_gis = mean(gis),
    mean_total_monthly_min = mean(total_monthly_min),
    sd_total_monthly_min = sd(total_monthly_min)
  )
print(eda_summary)
write.csv(eda_summary, "results/eda_summary_r.csv", row.names = FALSE)

p1 <- ggplot(income_data, aes(x = total_monthly_min)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Distribution of Minimum Total Monthly Income",
    x = "Minimum Total Monthly Income ($)",
    y = "Rate-table Rows"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/total_monthly_income_distribution_r.png", p1,
       width = 8, height = 5, dpi = 300)

p2 <- ggplot(income_data, aes(x = annual_private_min, y = gains)) +
  geom_point(alpha = 0.35) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Annual Private Income vs. GAINS",
    x = "Minimum Annual Private Income ($)",
    y = "GAINS / RRAG ($ per month)"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/private_income_vs_gains_r.png", p2,
       width = 8, height = 5, dpi = 300)
