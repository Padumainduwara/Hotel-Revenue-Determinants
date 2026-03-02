# ==============================================================================
# Statistical Analysis of Hotel Revenue
# ==============================================================================

# Load Required Libraries
install.packages(c("ggplot2", "dplyr", "corrplot", "car", "psych", "caTools"))
library(ggplot2)
library(dplyr)
library(corrplot)
library(car)
library(psych)
library(caTools)

# Ensure numbers are displayed fully (e.g., 500,000 instead of 5e+05)
options(scipen = 999)

# Load the data set
data <- read.csv("HOTELS_2025.csv", stringsAsFactors = FALSE)

# Check initial structure
str(data)
summary(data)

# Check for Duplicates
sum(duplicated(data))
data <- data[!duplicated(data), ]

# Remove Duplicates
if(sum(duplicated(data)) > 0) {
  print("Duplicates removed.")
}

# Check for Missing Values
sum(is.na(data))
data <- na.omit(data)

# Remove Missing Values
if(sum(is.na(data)) > 0) {
  print("Missing values removed.")
}

# Convert 'HotelQualityRank' to an ordered factor for analysis
data$HotelQualityRank <- factor(data$HotelQualityRank, 
                                levels = c("Low", "Medium", "High"), 
                                ordered = TRUE)

# Summary statistics for numeric variables (Mean, SD, Skewness, etc.)
print(describe(data %>% select_if(is.numeric)))

# Count of hotels by Quality Rank
print(table(data$HotelQualityRank))

# Revenue Distribution with Density Curve
p1 <- ggplot(data, aes(x = Revenue)) +
  geom_histogram(aes(y = ..density..), binwidth = 50000, fill = "#48C9B0", color = "black", alpha = 0.7) +
  geom_density(color = "red", size = 1) +
  geom_vline(aes(xintercept = mean(Revenue)), color="blue", linetype="dashed", size=1) +
  labs(title = "Distribution of Hotel Revenue", 
       x = "Revenue (USD)", y = "Density") +
  theme_minimal()
print(p1)

# Boxplot for Revenue
p_out1 <- ggplot(data, aes(y = Revenue)) + 
  geom_boxplot(fill = "orange", outlier.colour = "red", outlier.shape = 8) + 
  labs(title = "Revenue Outliers", y = "Revenue (USD)") + theme_light()
print(p_out1)

# Boxplot for ADR
p_out2 <- ggplot(data, aes(y = ADR)) + 
  geom_boxplot(fill = "lightgreen", outlier.colour = "red", outlier.shape = 8) + 
  labs(title = "ADR Outliers", y = "ADR (USD)") + theme_light()
print(p_out2)

# Boxplot for Rooms Available
p_out3 <- ggplot(data, aes(y = RoomsAvailable)) + 
  geom_boxplot(fill = "lightblue", outlier.colour = "red", outlier.shape = 8) + 
  labs(title = "Room Count Outliers", y = "Rooms") + theme_light()
print(p_out3)

# Calculate Correlation Matrix
numeric_data <- data %>% select_if(is.numeric)
cor_matrix <- cor(numeric_data)
print(cor_matrix)

# Print Strongest Predictors for Revenue
print("Correlation with Revenue")
print(sort(cor_matrix[,"Revenue"], decreasing = TRUE))

# Plot Correlation Heatmap
corrplot(cor_matrix, method = "color", type = "upper", 
         addCoef.col = "black", tl.col = "black", tl.srt = 45, 
         title = "Correlation Matrix", mar=c(0,0,2,0))

# Rooms vs Revenue
p_scatter <- ggplot(data, aes(x = RoomsAvailable, y = Revenue)) +
  geom_point(alpha = 0.6, color = "darkblue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Relationship: Rooms vs Revenue", x = "Rooms Available", y = "Revenue") +
  theme_bw()
print(p_scatter)

# Quality Rank vs Revenue
p_violin <- ggplot(data, aes(x = HotelQualityRank, y = Revenue, fill = HotelQualityRank)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width=0.1, fill="white") +
  labs(title = "Revenue by Hotel Quality", x = "Quality", y = "Revenue") +
  theme_minimal()
print(p_violin)

# Pairwise Plot for Key Variables
pairs(~ Revenue + RoomsAvailable + ADR + MarketingSpend, data = data,
      main = "Scatter Matrix of Key Variables", col = "blue")

# Shapiro-Wilk Test for Normality
safe_shapiro <- function(x) {
  test_res <- if (length(x) > 5000) shapiro.test(sample(x, 5000)) else shapiro.test(x)
  return(c(W = test_res$statistic, p_value = test_res$p.value))
}
results_matrix <- sapply(numeric_data, safe_shapiro)
results_df <- data.frame(t(results_matrix))
results_df$Conclusion <- ifelse(results_df$p_value > 0.05, "Normal Distribution", "Not Normal")
print(">> Normality Test Summary Table:")
print(results_df)

# Q-Q Plot for Revenue
qqnorm(data$Revenue, main = "Normal Q-Q Plot for Revenue", pch = 19, col = "blue")
qqline(data$Revenue, col = "red", lwd = 2)

# Pearson Correlation Test (Revenue vs ADR)
print("Pearson Correlation Test (Revenue vs ADR):")
print(cor.test(data$Revenue, data$ADR))

# Split Data: 70% Training, 30% Testing
set.seed(123)
split <- sample.split(data$Revenue, SplitRatio = 0.7)
train_set <- subset(data, split == TRUE)
test_set <- subset(data, split == FALSE)

# Simple Linear Regression
slr_model <- lm(Revenue ~ RoomsAvailable, data = train_set)
print(summary(slr_model))

# Multiple Linear Regression
mlr_model <- lm(Revenue ~ ., data = train_set)
print(summary(mlr_model))

# Check for Multicollinearity (VIF Scores)
print("VIF Scores:")
print(vif(mlr_model))

# Residual Plots
plot(mlr_model, which = 1, main = "Residuals vs Fitted")
plot(mlr_model, which = 2, main = "Normal Q-Q Plot")
plot(mlr_model, which = 3, main = "Scale-Location Plot")
plot(mlr_model, which = 5, main = "Residuals vs Leverage")

# Predictions on Test Data
predictions <- predict(mlr_model, newdata = test_set)
# Calculate RMSE and R-Squared
rmse <- sqrt(mean((test_set$Revenue - predictions)^2))
r2 <- summary(mlr_model)$r.squared
print(paste("Final RMSE:", round(rmse, 2)))
print(paste("Final R-Squared:", round(r2, 4)))

# Plot Actual vs Predicted Revenue
results_df <- data.frame(Actual = test_set$Revenue, Predicted = predictions)
p_final <- ggplot(results_df, aes(x = Actual, y = Predicted)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed", size = 1) +
  labs(title = "Actual vs Predicted Revenue", 
       subtitle = "Points along the red line indicate accurate predictions",
       x = "Actual Revenue", y = "Predicted Revenue") +
  theme_bw()
print(p_final)