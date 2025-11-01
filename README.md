# Health Insurance Fraud Detection

A comprehensive machine learning project for detecting and preventing health insurance fraud using advanced classification models and domain-specific heuristic triggers.

## 📋 Project Overview

This project develops a fraud detection system that uses machine learning models to identify potentially fraudulent health insurance claims. The system combines traditional ML algorithms with domain-specific fraud detection triggers to provide a robust, comprehensive fraud detection solution.

### Key Objectives
- Red flag claims for possible fraud and further investigation
- Reduce losses and increase profitability for insurers/reinsurers
- Reduce premiums for customers' insurance coverage
- Provide competitive advantage for insurers/reinsurers

### Key Features
- Multiple ML models: Decision Tree, Random Forest, XGBoost, GLM, Naive Bayes, GBM
- Imbalanced dataset handling: ADASYN, SMOTE, MWMOTE, ROSE
- Domain-specific fraud triggers (8 types)
- Comprehensive performance evaluation with ROC-AUC, PR-AUC, and classification metrics

## 📁 Project Structure

```
CAS-Project-Health-Insurance-Fraud-Detection/
├── data/
│   ├── raw/              # Original, unprocessed data
│   ├── interim/          # Intermediate transformed data
│   └── external/         # External data sources (triggers, hospital lists)
├── src/
│   ├── features/         # Feature engineering & trigger functions
├── results/              # Model outputs and results
├── docs/                 # Additional documentation
├── main.Rmd              # Main markdown file which contains the code
└── README.md
```

## 🚀 Getting Started

### Prerequisites

**R Version**: 4.0 or higher

**Required R Packages**:
```r
# Data manipulation
library(readxl)
library(janitor)
library(dplyr)
library(tidyverse)
library(lubridate)

# Machine Learning
library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)
library(xgboost)
library(gbm)
library(e1071)
library(naivebayes)
library(glmnet)

# Imbalanced data handling
library(smotefamily)
library(imbalance)
library(ROSE)

# Evaluation & Visualization
library(pROC)
library(PRROC)
library(ROCR)
library(ggplot2)
library(kableExtra)

# Utilities
library(psych)
library(bruceR)
library(caTools)
library(mlbench)
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/RohanYashraj/CAS-Project-Health-Insurance-Fraud-Detection.git
cd CAS-Project-Health-Insurance-Fraud-Detection
```

2. Install R dependencies:
```r
# Run this in R console
install.packages(c("readxl", "janitor", "dplyr", "tidyverse", "lubridate",
                   "caret", "rpart", "rpart.plot", "randomForest", "xgboost",
                   "gbm", "e1071", "naivebayes", "glmnet", "smotefamily",
                   "imbalance", "ROSE", "pROC", "PRROC", "ROCR", "ggplot2",
                   "kableExtra", "psych", "bruceR", "caTools", "mlbench"))
```

### Usage

1. **Prepare Data**: Place your cleaned input data in `data/raw/cleaned_input_data.rds`
2. **Run Main Analysis**: Open and knit `notebooks/02-modeling/final_code.Rmd`
3. **Review Results**: Check `results/` folder for outputs

Main analysis workflow:
- Data preprocessing and feature engineering
- Application of fraud detection triggers
- Dataset balancing using multiple techniques
- Model training across 6 algorithms
- Performance evaluation and comparison

## 🔍 Fraud Detection Triggers

The project implements 8 domain-specific fraud triggers:

1. **Claim Amount Trigger**: Flags claims exceeding expected package amounts
2. **Hospital Days Trigger**: Identifies excessive length of stay
3. **Age Trigger**: Flags procedures inappropriate for patient's age group
4. **Gender Trigger**: Detects gender-specific procedure mismatches
5. **Claim Count Trigger**: Identifies excessive claim frequency
6. **Close Proximity Trigger**: Flags claims filed too soon after policy commencement
7. **Treatment Date Validity**: Ensures treatments within policy coverage periods
8. **Claim Reported Delay**: Identifies unusual reporting delays

## 🤖 Machine Learning Models

### Algorithms Evaluated
- **Decision Tree**: Interpretable rule-based classifier
- **Random Forest**: Ensemble of decision trees
- **XGBoost**: Gradient boosting framework
- **GLM**: Generalized Linear Model (Logistic Regression)
- **Naive Bayes**: Probabilistic classifier
- **GBM**: Generalized Boosted Regression Model

### Imbalanced Data Handling
Each model is evaluated with and without four different balancing techniques:
- **ADASYN**: Adaptive Synthetic Sampling
- **SMOTE**: Synthetic Minority Oversampling Technique
- **MWMOTE**: Majority Weighted Minority Oversampling Technique
- **ROSE**: Random Over-Sampling Examples

## 📊 Performance Metrics

Models are evaluated using:
- **Accuracy**: Overall classification accuracy
- **Sensitivity (Recall)**: True positive rate
- **Specificity**: True negative rate
- **Precision**: Positive predictive value
- **F1-Score**: Harmonic mean of precision and recall
- **F2-Score**: Weighted F-score prioritizing recall
- **ROC-AUC**: Area under ROC curve
- **PR-AUC**: Area under Precision-Recall curve

## 📈 Results

Comprehensive results comparing all model configurations are available in:
- `results/final_output.xlsx`: Detailed performance metrics
- `results/results.rds`: R data format

## 👥 Authors

SSSIHL-CAS Project Team

## 📝 License

This project is proprietary. To access, please send request to Authors of the article.

## 🙏 Acknowledgments

- SSSIHL for institutional support
- Insurance industry partners for data and domain expertise

## 📧 Contact

For questions or access requests, please contact the project authors.

---

**Note**: Due to the sensitive nature of fraud detection data, the data has been masked.
