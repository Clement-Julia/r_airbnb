regions <- c("64", "NAQ", "ARA", "IDF")
listings_data <- list()
cols_to_keep <- c('id', 'name', 'description', 'property_type', 'room_type', 'accommodates', 
                  'bathrooms', 'bedrooms', 'beds', 'amenities', 'price', 
                  'latitude', 'longitude', 'neighbourhood_cleansed', 'neighbourhood_group_cleansed', 
                  'minimum_nights', 'maximum_nights', 'availability_30', 'availability_60', 
                  'availability_90', 'availability_365', 'number_of_reviews', 
                  'review_scores_rating', 'review_scores_accuracy', 'review_scores_cleanliness', 
                  'review_scores_checkin', 'review_scores_communication', 'review_scores_location', 
                  'review_scores_value', 'reviews_per_month', 'region')

for (region in regions) {
  file_path <- paste0("data/", region, "/listings.csv")
  data <- read.csv(file_path)
  
  # Ajout d'une colonne 'region' avec le code ISO de la région du logement
  data$region <- region
  
  # Colonnes pertinentes
  data <- data[, cols_to_keep]
  data <- data[!duplicated(data), ]
  cols_na_fill <- c('review_scores_value', 'review_scores_checkin', 'review_scores_location', 
                    'review_scores_accuracy', 'review_scores_communication', 
                    'review_scores_cleanliness', 'reviews_per_month', 'review_scores_rating', 
                    'beds', 'number_of_reviews')

  for (col in cols_na_fill) {
    if (col %in% names(data)) {
      data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
    }
  }
  
  # Extraction de la valeur numérique de 'price' (sans le $)
  if ("price" %in% names(data)) {
    data$price <- as.numeric(gsub("[^0-9]", "", data$price))
  }
  listings_data[[region]] <- data
}

# Fusion des listings pour toutes les régions
listings_combined <- do.call(rbind, listings_data)

write.csv(listings_combined, "data/listings_combined.csv", row.names = FALSE)
print("Terminé !")
