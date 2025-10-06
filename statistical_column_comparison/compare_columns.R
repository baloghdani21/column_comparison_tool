# =====================================================
# Project: Column Comparison Tool
# Author: Daniel Balogh
# Description:
#   This R script allows you to load a CSV file, choose two
#   columns interactively, and test whether they differ
#   significantly using a t-test or Wilcoxon test.
# =====================================================

# --- 1. Load required packages ---
# (Base R is enough, but 'ggplot2' is nice for visualization)
if (!require(ggplot2)) install.packages("ggplot2", dependencies = TRUE)
library(ggplot2)

# --- 2. Load CSV file ---
cat("Welcome to the Column Comparison Tool!\n\n")
file_path <- readline(prompt = "Enter the path to your CSV file: ")

# Read CSV file
data <- tryCatch(
  {
    read.csv(file_path, stringsAsFactors = FALSE)
  },
  error = function(e) {
    stop("Error reading file. Please check the path and try again.")
  }
)

cat("\nFile loaded successfully.\n")
cat("Available columns:\n")
print(names(data))

# --- 3. Select columns to compare ---
col1 <- readline(prompt = "\nEnter the name of the first column: ")
col2 <- readline(prompt = "Enter the name of the second column: ")

# Validate input
if (!(col1 %in% names(data)) | !(col2 %in% names(data))) {
  stop("One or both column names are invalid.")
}

x <- as.numeric(data[[col1]])
y <- as.numeric(data[[col2]])

# --- 4. Check for missing values ---
x <- x[!is.na(x)]
y <- y[!is.na(y)]

# --- 5. Normality check ---
shapiro_x <- shapiro.test(x)
shapiro_y <- shapiro.test(y)

cat("\n--- Normality Test (Shapiro-Wilk) ---\n")
cat(col1, ": p =", shapiro_x$p.value, "\n")
cat(col2, ": p =", shapiro_y$p.value, "\n")

# --- 6. Choose appropriate test ---
if (shapiro_x$p.value > 0.05 & shapiro_y$p.value > 0.05) {
  test_result <- t.test(x, y)
  test_used <- "t-test (parametric)"
} else {
  test_result <- wilcox.test(x, y)
  test_used <- "Wilcoxon rank-sum test (non-parametric)"
}

# --- 7. Print results ---
cat("\n--- Statistical Test Result ---\n")
cat("Test used:", test_used, "\n")
print(test_result)

if (test_result$p.value < 0.05) {
  cat("\nThe difference between", col1, "and", col2, "is statistically significant (p < 0.05)\n")
} else {
  cat("\nNo statistically significant difference found (p ≥ 0.05)\n")
}

# --- 8. Visualization ---
plot_data <- data.frame(
  value = c(x, y),
  group = c(rep(col1, length(x)), rep(col2, length(y)))
)

cat("\nGenerating boxplot...\n")

# Create plot object
p <- ggplot(plot_data, aes(x = group, y = value, fill = group)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.2, alpha = 0.5, color = "black") +
  labs(
    title = paste("Comparison of", col1, "and", col2),
    subtitle = paste("Test used:", test_used),
    x = "Column",
    y = "Value"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold")
  )

# Display plot
print(p)

cat("\nDone.\n")