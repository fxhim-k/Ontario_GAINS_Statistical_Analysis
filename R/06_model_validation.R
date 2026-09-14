# 06_model_validation.R --------------------------------------------------
# Purpose: Validate the GAINS ~ annual private income model with 10-fold CV.
#
# The original assignment predicted total monthly income from all columns,
# including variables that are components/transformations of the target. That
# produced R^2 = 1 and near-zero error, consistent with target leakage.

source("R/01_data_cleaning.R")

set.seed(123)
cv_control <- trainControl(method = "cv", number = 10)

cv_model <- train(
  gains ~ annual_private_min,
  data = income_data,
  method = "lm",
  trControl = cv_control,
  metric = "RMSE"
)

print(cv_model)
print(cv_model$results)

predictions <- predict(cv_model, newdata = income_data)
validation_df <- income_data %>%
  transmute(actual_gains = gains, predicted_gains = predictions)

p <- ggplot(validation_df, aes(x = actual_gains, y = predicted_gains)) +
  geom_point(alpha = 0.35) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    title = "Actual vs. Predicted GAINS",
    subtitle = "10-fold cross-validated linear regression",
    x = "Actual GAINS",
    y = "Predicted GAINS"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/cv_actual_vs_predicted_gains.png", p, width = 7, height = 6, dpi = 300)
