# Ontario Senior Income & GAINS Benefits - Statistical Analysis

## Project Overview
This project analyzes Ontario Guaranteed Annual Income System (GAINS) benefit-rate data for seniors aged 75 and older. The goal is to examine how private income relates to GAINS and total monthly income, while demonstrating a reproducible statistical-analysis workflow in R.

The repository is a professional portfolio adaptation of an academic project. The original assignment was reviewed, the source CSV was restored, the analysis logic was corrected, and the main results were independently verified.

## Analytical Question
**How does minimum annual private income relate to Ontario GAINS support and minimum total monthly income across the published benefit-rate schedule?**

Supporting questions:
- How do minimum total monthly income levels differ below vs. at/above a $7,500 minimum annual private-income threshold?
- Is minimum annual private income associated with the GAINS amount?
- How much predictive performance does a simple income-to-GAINS model retain under 10-fold cross-validation?
- What methodological issues arise when total monthly income is predicted from variables that directly compose that total?

## Dataset
The project uses the Ontario GAINS benefit-rate table for age 75+ for the April 1-June 30, 2024 period.

**Rows:** 1,067  
**Variables:** 10

Key fields include annual and monthly private-income ranges, GAINS, OAS, GIS, and minimum/maximum total monthly income.

> Important: this is a **benefit-rate table**, not a random sample of 1,067 individual seniors. Statistical tests in this project are therefore best treated as an analytical demonstration of differences across schedule rows rather than population inference from a sampled population.

## Tools & Methods
- **R**
- `tidyverse`, `dplyr`, `ggplot2`, `caret`, `broom`
- Data cleaning and descriptive statistics
- Welch two-sample t-test and 95% confidence interval
- Non-parametric bootstrap resampling
- Simple linear regression
- 10-fold cross-validation
- Target-leakage review

## Verified Results
### 1. Corrected $7,500 group comparison
The corrected test consistently uses **minimum annual private income** to define both groups and **minimum total monthly income** as the outcome.

| Group | n | Mean minimum monthly income | SD |
|---|---:|---:|---:|
| Below $7,500 | 427 | $1,979.91 | $37.60 |
| $7,500 or above | 640 | $2,278.02 | $167.95 |

Welch's t-test:
- **t = -43.31**
- **df = 732.43**
- **p ≈ 3.66 × 10^-204**
- Mean difference (lower - higher): **-$298.11**
- 95% CI: **[-$311.62, -$284.59]**

This differs slightly from the original assignment because the original code mixed minimum variables for the lower-income group with maximum variables for the higher-income group.

### 2. Regression: private income vs. GAINS
Simple OLS model:

`GAINS = 11.6693 - 0.0008357 × minimum annual private income`

- Slope: **-0.0008357**
- **R² = 0.1499**
- **p ≈ 1.76 × 10^-39**

The coefficient is statistically distinguishable from zero across the rate-table rows, but the model explains only about **15%** of the variation in GAINS. This is a useful example of why statistical significance and predictive strength are different concepts.

### 3. Bootstrap estimate
Using 5,000 bootstrap resamples of the rate-table rows, the mean minimum total monthly income is approximately **$2,158.72**, with a percentile interval of roughly **$2,147-$2,170**. Because the dataset is a deterministic benefit schedule rather than a random sample, this interval should be interpreted as a resampling stability exercise rather than a population confidence interval.

### 4. Revised 10-fold cross-validation
The original assignment produced near-perfect prediction of total monthly income because the predictor set included variables that directly reconstruct the target. In the data:

`total_monthly_min = OAS/GIS total + GAINS + monthly_private_min`

The revised validation evaluates only the simple `GAINS ~ annual_private_min` model.

Independent verification of the revised design produced approximately:
- **CV RMSE = 12.09**
- **CV MAE = 6.86**
- **CV R² = 0.146**

Exact fold-level values may vary slightly by software implementation and fold assignment, but they are consistent with the model's in-sample R² of about 0.15.

## Methodological Improvements
1. **Consistent group definitions** - both t-test groups now use minimum annual private income and minimum total monthly income.
2. **Target leakage removed** - cross-validation no longer predicts a constructed target from its own components.
3. **Rate-table limitation documented** - rows are schedule entries, not observed individuals.
4. **Reproducible structure** - analysis is split into modular R scripts, with generated figures and result tables separated from source data.

## Repository Structure
```text
Ontario_GAINS_Statistical_Analysis/
├── README.md
├── Ontario_GAINS_Statistical_Analysis.Rproj
├── analysis_report.Rmd
├── data/
│   └── gains_rate_tables_75_apr_1_to_june_30_2024_1.csv
├── R/
│   ├── 00_setup.R
│   ├── 01_data_cleaning.R
│   ├── 02_exploratory_analysis.R
│   ├── 03_hypothesis_testing.R
│   ├── 04_bootstrap_analysis.R
│   ├── 05_regression_analysis.R
│   ├── 06_model_validation.R
│   └── 07_run_all.R
├── figures/
├── results/
│   ├── verified_results.csv
│   ├── income_group_summary.csv
│   └── data_dictionary.csv
└── report/
    ├── Ontario_GAINS_Statistical_Analysis_Report.docx
    └── Ontario_GAINS_Statistical_Analysis_Report.pdf
```

## How to Run
1. Open `Ontario_GAINS_Statistical_Analysis.Rproj` in RStudio.
2. Run:

```r
source("R/07_run_all.R")
```

3. Review generated figures in `figures/` and console output from each stage.

## Portfolio Takeaway
This project demonstrates data cleaning, exploratory analysis, statistical inference, regression, resampling, model validation, and - importantly - critical review of model design. The strongest professional takeaway is the ability to identify why a mathematically perfect model can actually indicate **data leakage rather than superior predictive performance**.
