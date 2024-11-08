if(!require(xgboost)) install.packages("xgboost")
library(xgboost)

rm(list = ls())

model <- xgb.load("xgboost_model.bin")
df <- read.csv("Data/listings_merged.csv")

selected_columns <- c("property_type", "room_type", "accommodates", "amenities", "neighbourhood_cleansed", "review_scores_rating", "price", "beds", "bathrooms")
test_data <- df[sample(nrow(df), 3), selected_columns]
test_data$beds_and_baths <- test_data$beds + test_data$bathrooms
test_data$price_per_room <- test_data$price / test_data$beds_and_baths
View(test_data)

test_data <- subset(test_data, select = -c(price, beds, bathrooms))

test_data[] <- lapply(test_data, function(x) if(is.character(x)) as.numeric(as.factor(x)) else x)

data_matrix <- xgb.DMatrix(data = as.matrix(test_data))
predictions <- predict(model, data_matrix)
print(predictions)