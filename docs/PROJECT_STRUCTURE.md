# Project Structure Documentation

## Overview

This document describes the organization and purpose of directories in the Health Insurance Fraud Detection project.

## Directory Structure

### `/data/` - Data Storage

All data files are organized by their processing stage:

- **`raw/`**: Original, unprocessed datasets. These files are immutable and should never be modified.
  - Example: `cleaned_input_data.rds` - Initial pre-processed insurance claims data
  
- **`interim/`**: Intermediate data files created during the analysis. These are transformed versions of raw data.
  - Balanced datasets (ADASYN, SMOTE, MWMOTE, ROSE)
  - Feature-engineered datasets
  
- **`processed/`**: Final, canonical datasets ready for modeling. These are the "gold standard" versions.
  - Currently empty, reserved for final processed datasets
  
- **`external/`**: External data sources that the project depends on but doesn't control.
  - Trigger configuration files
  - Hospital lists
  - Distance matrices

### `/src/` - Source Code

Reusable code organized by functionality:

- **`data/`**: Data processing and loading scripts
  - Data cleaning utilities
  - Data validation functions
  
- **`features/`**: Feature engineering code
  - `triggers for package.R` - Fraud detection trigger functions
  - Feature transformation functions
  
- **`models/`**: Model definitions and wrappers
  - Model training functions
  - Model evaluation utilities
  
- **`visualization/`**: Plotting and visualization code
  - Custom plotting functions
  - Report generation utilities

### `/notebooks/` - Analysis Notebooks

R Markdown notebooks organized by analysis phase:

- **`01-data-exploration/`**: Exploratory Data Analysis
  - Data quality checks
  - Initial visualizations
  - Data understanding
  
- **`02-modeling/`**: Model development and evaluation
  - `final_code.Rmd` - Main analysis workflow
  - Model training and comparison
  - Performance evaluation
  
- **`03-results/`**: Results analysis and interpretation
  - Model performance deep-dives
  - Business insights
  - Recommendations

### `/config/` - Configuration Files

Project configuration and parameters:
- Model hyperparameters
- Data paths
- Experiment settings

### `/results/` - Output Files

All outputs from model training and evaluation:
- Performance metrics: `results.rds`, `final_output.xlsx`
- Model comparisons
- Figures and tables

### `/models/` - Saved Models

Trained model artifacts:
- Serialized model objects
- Model checkpoints
- Pre-trained models

### `/docs/` - Documentation

Additional project documentation:
- This file
- Methodology documentation
- User guides

## File Naming Conventions

### Data Files
- **Balanced datasets**: `{method}_{triggers}_train.rds` / `_test.rds`
  - Example: `smote_wo_triggers_train.rds`
  - Methods: adasyn, smote, mwmote, rose
  - Triggers: w_triggers, wo_triggers
  
### Source Files
- Use descriptive names in lowercase with underscores
- Example: `triggers for package.R`

### Notebook Files
- Use descriptive prefixes with numbers for ordering
- Example: `01-data-exploration.Rmd`, `02-modeling.Rmd`

## Path References

When working in the project, always use relative paths from the notebook's location:

- **From notebooks**: `./data/raw/file.rds`
- **From src**: `./data/raw/file.rds`

## Best Practices

1. **Never edit raw data** - All transformations should create new files in interim or processed
2. **Document all data transformations** - Include comments explaining what was done
3. **Version control outputs** - Commit important results after major changes
4. **Keep notebooks focused** - Each notebook should have a single, clear purpose
5. **Use gitignore** - Sensitive data files should be ignored by git
6. **Document dependencies** - List all required packages in README

## Data Flow

```
raw data → interim (transformations) → processed (final) → models → results
```

1. Start with data in `raw/`
2. Apply transformations, save to `interim/`
3. Create final cleaned datasets in `processed/`
4. Train models, save to `models/`
5. Generate outputs in `results/`

## Questions?

For questions about project structure or organization, refer to the main README.md or contact the project team.

