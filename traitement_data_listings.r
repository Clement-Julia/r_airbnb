# Spécifiez le chemin du fichier d'origine
file_path <- "C:/Users/david/Documents/M2/Langage R/TP_GROUPE/data/listings_combined.csv"

# Charger le fichier CSV dans un dataframe
df <- read.csv(file_path, stringsAsFactors = FALSE, fileEncoding = "UTF-8")


# Suppression des NULL
df <- df[!is.na(df$price) & !is.na(df$accommodates) & !is.na(df$availability_365), ]


# Convertir en NUM
df$price <- as.numeric(gsub("[$,]", "", df$price))
df$accommodates <- as.integer(df$accommodates)
df$bathrooms <- as.numeric(df$bathrooms)
df$bedrooms <- as.integer(df$bedrooms)
df$beds <- as.integer(df$beds)
df$review_scores_rating <- as.numeric(df$review_scores_rating)
df$review_scores_accuracy <- as.numeric(df$review_scores_accuracy)
df$review_scores_cleanliness <- as.numeric(df$review_scores_cleanliness)
df$review_scores_checkin <- as.numeric(df$review_scores_checkin)
df$review_scores_communication <- as.numeric(df$review_scores_communication)
df$review_scores_location <- as.numeric(df$review_scores_location)
df$review_scores_value <- as.numeric(df$review_scores_value)
df$reviews_per_month <- as.numeric(df$reviews_per_month)


df$amenities <- gsub("[\\[\\]\"]", "", df$amenities)

df$property_type <- tolower(df$property_type)
df$room_type <- tolower(df$room_type)
df$amenities <- tolower(df$amenities)


df <- df[df$price >= 20 & df$price <= 10000, ]

# Filtrer les lignes avec la région "IDF"

# Fonction de remplacement des caractères corrompus
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

# Appliquer la fonction de remplacement aux noms de quartiers
df$neighbourhood_cleansed <- replace_special_characters(df$neighbourhood_cleansed)

write.csv(df, "C:/Users/david/Documents/M2/Langage R/TP_GROUPE/listings_cleaned.csv", row.names = FALSE)