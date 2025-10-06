# Column Comparison Tool (R)

**Author:** Daniel Balogh  
**Description:**  
This R script allows users to load a CSV file, select two columns, and test whether they differ significantly using either a t-test or a Wilcoxon rank-sum test.  
It also provides a boxplot visualization of the comparison.

---

## Features
- Loads any CSV file interactively
- Lets you choose two columns to compare
- Automatically checks normality (Shapiro–Wilk test)
- Chooses appropriate test:
  - t-test (if both columns normal)
  - Wilcoxon test (otherwise)
- Displays results and generates a `ggplot2` boxplot

---

## How to Run

### Option 1: Interactively
Open R or RStudio and run:

```r
source("ColumnComparisonTool.R")