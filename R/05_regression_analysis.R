# 05_regression_analysis.R -----------------------------------------------
# Purpose: Model the relationship between minimum annual private income and GAINS.

source("R/01_data_cleaning.R")

model_gains <- lm(gains ~ annual_private_min, data = income_data)
print(summary(model_gains))
print(broom::tidy(model_gains, conf.int = TRUE))
print(broom::glance(model_gains))

p <- ggplot(income_data, aes(x = annual_private_min, y = gains)) +
  geom_point(alpha = 0.35) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Linear Relationship Between Private Income and GAINS",
    subtitle = "Simple OLS model",
    x = "Minimum Annual Private Income ($)",
    y = "GAINS / RRAG"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/regression_private_income_gains.png", p, width = 8, height = 5, dpi = 300)
