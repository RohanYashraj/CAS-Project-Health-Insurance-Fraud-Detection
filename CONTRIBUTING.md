# Contributing to Health Insurance Fraud Detection Project

Thank you for your interest in contributing to this project!

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/RohanYashraj/CAS-Project-Health-Insurance-Fraud-Detection.git
cd CAS-Project-Health-Insurance-Fraud-Detection
```

### 2. Install R Dependencies

Run the following in R console or RStudio:

```r
# Define required packages
required_packages <- c(
  # Data manipulation
  "readxl", "janitor", "dplyr", "tidyverse", "lubridate",
  
  # Machine Learning
  "caret", "rpart", "rpart.plot", "randomForest", "xgboost",
  "gbm", "e1071", "naivebayes", "glmnet",
  
  # Imbalanced data
  "smotefamily", "imbalance", "ROSE",
  
  # Evaluation & Visualization
  "pROC", "PRROC", "ROCR", "ggplot2", "kableExtra",
  
  # Utilities
  "psych", "bruceR", "caTools", "mlbench"
)

# Install missing packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    install.packages(new_packages, dependencies = TRUE)
  }
}

install_if_missing(required_packages)

# Verify installation
all_installed <- all(required_packages %in% installed.packages()[,"Package"])
cat("All packages installed:", all_installed, "\n")
```

### 3. Verify Setup

Open and run the main notebook to verify everything works:

```r
# Open in RStudio
file.edit("notebooks/02-modeling/final_code.Rmd")

# Or knit from command line
rmarkdown::render("notebooks/02-modeling/final_code.Rmd")
```

## Project Workflow

### Running the Analysis

1. **Start with cleaned data** in `data/raw/cleaned_input_data.rds`
2. **Open the main notebook**: `notebooks/02-modeling/final_code.Rmd`
3. **Knit the notebook** to run the complete analysis
4. **Review results** in the `results/` folder

### Making Changes

1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes
3. Test that your changes work correctly
4. Commit with clear messages
5. Push and create a pull request

### Code Style Guidelines

- **Use descriptive variable names**: `total_fraud_amount` not `tfa`
- **Add comments** for complex logic
- **Follow existing patterns** in the codebase
- **Keep notebooks organized** with clear sections
- **Document functions** with purpose statements

## Data Management

### Adding New Data

1. Place raw data in `data/raw/`
2. Document the data source in the file metadata
3. Create a README in the data directory explaining the dataset
4. Update `.gitignore` if needed to protect sensitive files

### Creating New Features

1. Add feature engineering code to `src/features/`
2. Document your feature transformations
3. Test on sample data before running full pipeline
4. Update the main notebook to use new features

### Adding New Models

1. Add model code to `src/models/`
2. Include hyperparameter documentation
3. Add evaluation to the comparison framework
4. Update results documentation

## Testing

### Before Committing

- [ ] Code runs without errors
- [ ] All paths updated for new structure
- [ ] Results are reproducible
- [ ] Notebooks knit successfully
- [ ] No sensitive data committed

### Running Tests

```r
# Check that all required files exist
source_files <- c(
  "README.md",
  ".gitignore",
  "notebooks/02-modeling/final_code.Rmd",
  "src/features/triggers for package.R"
)

all_files_exist <- all(file.exists(source_files))
cat("All required files present:", all_files_exist, "\n")
```

## Reporting Issues

When reporting issues, please include:

1. Error messages (full traceback)
2. R version and package versions
3. Operating system
4. Steps to reproduce the issue
5. Expected vs actual behavior

## Code of Conduct

- Be respectful and considerate
- Welcome newcomers and help them get started
- Respect different viewpoints and experiences
- Give and gracefully accept constructive feedback

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Contact

For questions about contributing, please contact the project maintainers.

