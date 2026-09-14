# 04_bootstrap_analysis.R -------------------------------------------------
# Purpose: Estimate uncertainty in the mean minimum total monthly income using
# non-parametric bootstrap resampling of observed rows.

source("R/01_data_cleaning.R")

B <- 5000
n_obs <- nrow(income_data)

bootstrap_means <- replicate(B, {
  sample_rows <- sample.int(n_obs, size = n_obs, replace = TRUE)
  mean(income_data$total_monthly_min[sample_rows], na.rm = TRUE)
})

bootstrap_ci <- quantile(bootstrap_means, probs = c(0.025, 0.975), na.rm = TRUE)
cat("Bootstrap mean estimate:", mean(bootstrap_means), "\n")
cat("95% percentile bootstrap CI:", bootstrap_ci[1], "to", bootstrap_ci[2], "\n")

bootstrap_df <- tibble(bootstrap_mean = bootstrap_means)

p <- ggplot(bootstrap_df, aes(x = bootstrap_mean)) +
  geom_histogram(bins = 40) +
  geom_vline(xintercept = bootstrap_ci, linetype = "dashed") +
  labs(
    title = "Bootstrap Distribution of Mean Total Monthly Income",
    x = "Bootstrapped Mean: Minimum Total Monthly Income ($)",
    y = "Frequency"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/bootstrap_monthly_income.png", p, width = 8, height = 5, dpi = 300)
