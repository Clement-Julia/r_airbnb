regions <- c("64", "NAQ", "ARA", "IDF")
listings_data <- list()
calendar_data <- list()
cols_keep <- c("id", "name", "description", "property_type", "room_type", "accommodates", 
               "bathrooms", "bedrooms", "beds", "amenities", "price", 
               "latitude", "longitude", "neighbourhood_cleansed", "neighbourhood_group_cleansed", 
               "minimum_nights", "maximum_nights", "availability_30", "availability_60", 
               "availability_90", "availability_365", "number_of_reviews", 
               "review_scores_rating", "review_scores_accuracy", "review_scores_cleanliness", 
               "review_scores_checkin", "review_scores_communication", "review_scores_location", 
               "review_scores_value", "reviews_per_month", "region")

# Barre de chargement
pb <- txtProgressBar(min = 0, max = length(regions) * 2, style = 3)
progress <- 0

for (region in regions) {
  cat("\nTraitement du fichier LISTINGS pour la région :", region, "\n")
  
  file_path <- paste0("data/", region, "/listings.csv")
  data <- read.csv(file_path, fileEncoding = "UTF-8")
  
  # Ajout d'une colonne 'region' avec le code ISO de la région du logement
  data$region <- region
  
  # Uniformiser les colonnes : ajouter les colonnes manquantes avec NA
  missing_cols <- setdiff(cols_keep, names(data))
  data[missing_cols] <- NA
  
  # Sélection des colonnes pertinentes et dans le bon ordre
  data <- data[, cols_keep]
  
  # Suppression des doublons
  data <- data[!duplicated(data), ]
  
  # Remplacement des valeurs manquantes pour certaines colonnes numériques
  cols_na_fill <- c("review_scores_value", "review_scores_checkin", "review_scores_location", 
                    "review_scores_accuracy", "review_scores_communication", 
                    "review_scores_cleanliness", "reviews_per_month", "review_scores_rating", 
                    "beds", "number_of_reviews")
  
  for (col in cols_na_fill) {
    if (col %in% names(data)) {
      data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
    }
  }
  
  # Nettoyage et conversion des types
  data$price <- as.numeric(gsub("[^0-9]", "", data$price))
  data$accommodates <- as.integer(data$accommodates)
  data$bathrooms <- as.numeric(data$bathrooms)
  data$bedrooms <- as.integer(data$bedrooms)
  data$beds <- as.integer(data$beds)
  data$review_scores_rating <- as.numeric(data$review_scores_rating)
  data$review_scores_accuracy <- as.numeric(data$review_scores_accuracy)
  data$review_scores_cleanliness <- as.numeric(data$review_scores_cleanliness)
  data$review_scores_checkin <- as.numeric(data$review_scores_checkin)
  data$review_scores_communication <- as.numeric(data$review_scores_communication)
  data$review_scores_location <- as.numeric(data$review_scores_location)
  data$review_scores_value <- as.numeric(data$review_scores_value)
  data$reviews_per_month <- as.numeric(data$reviews_per_month)
  
  # Nettoyage des colonnes textuelles
  data$amenities <- gsub("[\\[\\]\"]", "", data$amenities)
  data$property_type <- tolower(data$property_type)
  data$room_type <- tolower(data$room_type)
  data$amenities <- tolower(data$amenities)
  
  # Filtrage des valeurs de prix
  data <- data[data$price >= 20 & data$price <= 10000, ]
  
  listings_data[[region]] <- data
  
  # Update barre de progression après listing
  progress <- progress + 1
  setTxtProgressBar(pb, progress)
}

close(pb)

# Fusion des données listings
listings_merged <- do.call(rbind, listings_data)

# Supprimer les lignes où toutes les valeurs sont NA après la fusion
listings_merged <- listings_merged[rowSums(is.na(listings_merged)) < ncol(listings_merged), ]

# Correction des caractères spéciaux pour neighbourhood_cleansed
replace_special_characters <- function(text) {
  text <- gsub("Ã©", "é", text)
  text <- gsub("Ã¨", "è", text)
  text <- gsub("Ãª", "ê", text)
  text <- gsub("Ã", "à", text)
  text <- gsub("Ã¢", "â", text)
  text <- gsub("Ã§", "ç", text)
  text <- gsub("Ã®", "î", text)
  text <- gsub("Ã´", "ô", text)
  text <- gsub("à¢", "â", text)
  text <- gsub("à§", "ç", text)
  text <- gsub("à©", "é", text)
  text <- gsub("à¨", "è", text)
  text <- gsub("àª", "ê", text)
  text <- gsub("à´", "ô", text)
  text <- gsub("à¯", "ï", text)
  text <- gsub("à¼", "ü", text)
  text <- gsub("à»", "û", text)
  text <- gsub("à\u0089", "É", text)
  return(text)
}

listings_merged$neighbourhood_cleansed <- replace_special_characters(listings_merged$neighbourhood_cleansed)

nrow(listings_merged)

# Sauvegarde des fichiers nettoyés
write.csv(listings_merged, "data/listings_merged.csv", row.names = FALSE)
print("Terminé !")
