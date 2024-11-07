regions <- c("64", "NAQ", "ARA", "IDF")
listings_data <- list()
calendar_data <- list()

cols_to_keep <- c("id", "name", "description", "property_type",
                  "room_type", "accommodates", "bathrooms", "bedrooms",
                  "beds", "amenities", "price", "latitude", "longitude",
                  "neighbourhood_cleansed", "neighbourhood_group_cleansed",
                  "minimum_nights", "maximum_nights", "availability_30",
                  "availability_60", "availability_90", "availability_365",
                  "number_of_reviews", "review_scores_rating",
                  "review_scores_accuracy", "review_scores_cleanliness",
                  "review_scores_checkin", "review_scores_communication",
                  "review_scores_location", "review_scores_value",
                  "reviews_per_month", "region")

# Barre de chargement
pb <- txtProgressBar(min = 0, max = length(regions) * 2, style = 3)
progress <- 0

# -----------------------------------------------------------------------
# ------------------------------ LISTINGS -------------------------------
# -----------------------------------------------------------------------

for (region in regions) {
  # Indication de début de traitement pour le fichier listings de la région
  cat("\nTraitement du fichier LISTINGS pour la région :", region, "\n")

  file_path <- paste0("data/", region, "/listings.csv")
  data <- read.csv(file_path, fileEncoding = "UTF-8")

  # Ajout d"une colonne "region" avec le code ISO de la région du logement
  data$region <- region

  # Colonnes pertinentes
  data <- data[, cols_to_keep]
  data <- data[!duplicated(data), ]
  cols_na_fill <- c("review_scores_value", "review_scores_checkin",
                    "review_scores_location", "review_scores_accuracy",
                    "review_scores_communication", "review_scores_cleanliness",
                    "reviews_per_month", "review_scores_rating",
                    "beds", "number_of_reviews")

  for (col in cols_na_fill) {
    if (col %in% names(data)) {
      data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
    }
  }

  # Extraction de la valeur numérique de "price" (sans le $)
  if ("price" %in% names(data)) {
    data$price <- as.numeric(gsub("[^0-9]", "", data$price))
  }
  listings_data[[region]] <- data

  # Update barre de progression après listing
  progress <- progress + 1
  setTxtProgressBar(pb, progress)

  # -----------------------------------------------------------------------
  # ------------------------------ CALENDAR -------------------------------
  # -----------------------------------------------------------------------

  # Indication de début de traitement pour le fichier calendar de la région
  cat("\nTraitement du fichier CALENDAR pour la région :", region, "\n")

  calendar_path <- paste0("data/", region, "/calendar.csv")
  calendar <- read.csv(calendar_path, fileEncoding = "UTF-8")

  calendar$price <- as.numeric(gsub("[^0-9]", "", calendar$price))
  calendar$adjusted_price <- as.numeric(gsub("[^0-9]", "", calendar$adjusted_price))
  calendar <- calendar[!duplicated(calendar), ]
  calendar_data[[region]] <- calendar

  # Update barre de progression après calendar
  progress <- progress + 1
  setTxtProgressBar(pb, progress)
}

close(pb)

# Fusion des listings pour toutes les régions
listings_combined <- do.call(rbind, listings_data)
calendar_combined <- do.call(rbind, calendar_data)

write.csv(listings_combined, "data/listings_combined.csv", row.names = FALSE)
write.csv(calendar_combined, "data/calendar_combined.csv", row.names = FALSE)
print("Terminé !")
