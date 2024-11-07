library(shiny)
library(shinyjs)
library(bslib)


#id,name,host_id,host_name,neighbourhood_group,neighbourhood,latitude,longitude,room_type,price,minimum_nights,number_of_reviews,last_review,reviews_per_month,calculated_host_listings_count,availability_365,number_of_reviews_ltm,
ui <- page_navbar(
  title = "AirBnB House Price Prédiction : HPP",
  bg = "#2D89C8",
  inverse = TRUE,
  useShinyjs(), 
  nav_spacer(),
  nav_item(input_dark_mode()),
  nav_panel(title = "Home",id="home", 
    card(
      card_header('Simulateur du prix de votre Logement :'),
      p("Localisation :"),
      layout_columns(
        selectInput("select1",label="Ville",choices=c("Region"= 1,"Paris, Île-de-France"= 2,"Lyon, Auvergne-Rhone-Alpes" = 3,"Bordeaux, Nouvelle-Aquitaine" = 4)),
        selectInput("select2",label="Quartier",choices=NULL),
        col_widths = c(-1,3,6,-3),
        row_heights = c(1,1)
      ),
      selectInput("room_type",label="Type de Logement", choices=NULL),
      selectInput("room_type",label="Type de Logement", choices=NULL),
      # numericInput("nbPiece",label="Nombre de Chambres :",min=1,max=100,value=1),
      # numericInput("nbPieceEau",label="Nombre de Piece d'eau :",min=1,max=100,value=1),
        # numericInput("nbWC",label="Nombre de WC :",min=1,max=100,value=1),
        # checkboxGroupInput(
          # "caract",
          # "Information complémentaire :",
          # choices = list("Cuisine"=1,"Lave vaisselle"=2,"Machine a lavé"=3,"Jardin" = 4, "Piscine" = 5, "Jaccuzi" = 6, "Fibre" = 7,"Vélos"= 8),
        # ),
    )
  ),
  nav_panel(title = "Statistique",id="prediction", 
      card(
          card_header("Prédiction du prix de mon logement"),
          "TEST",
          value_box(
              title = "Value box",
              value = 100
          )
      )),
)
# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
        # Masquer ou activer le second selectInput au départ
  observe({
    if (input$select1 == "") {
      # Cacher et désactiver le second selectInput quand rien n'est sélectionné
      hide("select2")
      disable("select2")
    } else {
      # Afficher et activer le second selectInput dès qu'une option est choisie
      show("select2")
      enable("select2")
    }
  })

  # Mise à jour dynamique des options du second selectInput
  observeEvent(input$select1, {
    print(input$select1)
    if (input$select1 == "2") {
      updateSelectInput(session, "select2",
                        choices = c("Observatoire",
                                    "Hôtel-de-Ville",
                                    "Opéra",
                                    "Buttes-Chaumont",
                                    "Élysée",
                                    "Entrepôt",
                                    "Louvre",
                                    "Popincourt",
                                    "Buttes-Montmartre",
                                    "Gobelins",
                                    "Bourse",
                                    "Ménilmontant",
                                    "Passy",
                                    "Reuilly",
                                    "Vaugirard",
                                    "Temple",
                                    "Panthéon",
                                    "Batignolles-Monceau",
                                    "Luxembourg",
                                    "Palais-Bourbon"
                                  ))  
      show("select2")
      enable("select2")
    } else if (input$select1 == "3") {
      updateSelectInput(session, "select2", 
                        choices = c("5e Arrondissement",
                                    "2e Arrondissement",
                                    "3e Arrondissement",
                                    "6e Arrondissement",
                                    "7e Arrondissement",
                                    "1er Arrondissement",
                                    "8e Arrondissement",
                                    "4e Arrondissement",
                                    "9e Arrondissement"
                                  ))
      show("select2")
      enable("select2")
    } else if (input$select1 == "4") {
      updateSelectInput(session, "select2", 
                        choices = c("Bordeaux Sud",
"Saint-Mdard-en-Jalles",
"Chartrons - Grand Parc - Jardin Public",
"Centre ville (Bordeaux)",
"Bgles",
"Talence",
"Le Bouscat",
"Saint Augustin - Tauzin - Alphonse Dupeux",
"Caudran",
"Nansouty - Saint Gens",
"Magonty",
"Palmer-Gravires-Cavailles",
"Carbon-Blanc",
"La Glacire",
"France Alouette",
"Gradignan",
"Le Bourg",
"Bouliac",
"Lormont",
"Saint-Aubin-de-Mdoc",
"La Bastide",
"Verthamon",
"Chiquet-Fontaudin",
"Bordeaux Maritime",
"Floirac",
"Bruges",
"Villenave-d'Ornon",
"Les Eyquems",
"Eysines",
"Blanquefort",
"Bourran",
"Parempuyre",
"Gambetta-Mairie-Lissandre",
"Capeyron",
"Arlac",
"Chemin Long",
"Ambars-et-Lagrave",
"La Paillre-Compostelle",
"Martignas-sur-Jalle",
"Bassens",
"Le Haillan",
"Le Monteil",
"Saige",
"Beaudsert",
"Sardine",
"Le Taillan-Mdoc",
"Centre ville (Merignac)",
"Cap de Bos",
"Casino",
"Beutre",
"3M-Bourgailh",
"Plaisance-Loret-Maregue",
"Nos",
"Artigues-Prs-Bordeaux",
"Saint-Louis-de-Montferrand",
"Brivazac-Candau",
"Arago-La Chataigneraie",
"Toctoucau",
"Le Vallon-Les Echoppes",
"Le Burck",
"Ambs",
"Saint-Vincent-de-Paul"))
      show("select2")
      enable("select2")
    }else if(input$select1 == "5"){
       updateSelectInput(session, "select2", 
                        choices = c(
                            "Hendaye",
                            "Biarritz",
                            "Urrugne",
                            "Bayonne",
                            "Anglet",
                            "Bidart",
                            "Guéthary",
                            "Saint-Jean-de-Luz",
                            "Lahonce",
                            "Saint-Pierre-d'Irube",
                            "Saint-Pée-sur-Nivelle",
                            "Ciboure",
                            "Arbonne",
                            "Cambo-les-Bains",
                            "Itxassou",
                            "Saint-Étienne-de-Baïgorry",
                            "Ascain",
                            "Uhart-Cize",
                            "Bidache",
                            "Jatxou",
                            "Larressore",
                            "Hasparren",
                            "Mouguerre",
                            "Ascarat",
                            "Villefranque",
                            "Boucau",
                            "Louhossoa",
                            "Sare",
                            "Arcangues",
                            "Sauguis-Saint-Étienne",
                            "Bardos",
                            "Ainhoa",
                            "Ustaritz",
                            "Sames",
                            "Barcus",
                            "Urt",
                            "Bassussarry",
                            "Arrast-Larrebieu",
                            "Ahetze",
                            "Irissarry",
                            "Saint-Esteben",
                            "Halsou",
                            "Souraïde",
                            "Irouléguy",
                            "Saint-Martin-d'Arrossa",
                            "Saint-Jean-le-Vieux",
                            "Briscous",
                            "Saint-Palais",
                            "Ossès",
                            "Bonloc",
                            "Saint-Jean-Pied-de-Port",
                            "Aldudes",
                            "Isturits",
                            "Larceveau-Arros-Cibits",
                            "Anhaux",
                            "Armendarits",
                            "Mauléon-Licharre",
                            "Trois-Villes",
                            "Suhescun",
                            "Osserain-Rivareyte",
                            "Bunus",
                            "Ispoure",
                            "Came",
                            "Biriatou",
                            "La Bastide-Clairence",
                            "Macaye",
                            "Saint-Martin-d'Arberoue",
                            "Espelette",
                            "Caro",
                            "Amendeuix-Oneix",
                            "Laguinge-Restoue",
                            "Arnéguy",
                            "Gabat",
                            "Estérençuby",
                            "Ahaxe-Alciette-Bascassan",
                            "Lecumberry",
                            "Alçay-Alçabéhéty-Sunharette",
                            "Ayherre",
                            "Guiche",
                            "Larribar-Sorhapuru",
                            "Urcuit",
                            "Aincille",
                            "Mendionde",
                            "Aroue-Ithorots-Olhaïby",
                            "Orègue",
                            "Iholdy",
                            "Domezain-Berraute",
                            "Montory",
                            "Beyrie-sur-Joyeuse",
                            "Roquiague",
                            "Jaxu",
                            "Charritte-de-Bas",
                            "Chéraute",
                            "Ainhice-Mongelos",
                            "Lichos",
                            "Banca",
                            "Uhart-Mixe",
                            "Sainte-Engrâce",
                            "Licq-Athérey",
                            "Aïcirits-Camou-Suhast",
                            "Arraute-Charritte",
                            "Hosta",
                            "L'Hôpital-Saint-Blaise",
                            "Saint-Just-Ibarre",
                            "Gotein-Libarrenx",
                            "Ordiarp",
                            "Béguios",
                            "Béhasque-Lapiste",
                            "Lasse",
                            "Viodos-Abense-de-Bas",
                            "Bidarray",
                            "Béhorléguy",
                            "Hélette",
                            "Lantabat",
                            "Menditte",
                            "Tardets-Sorholus",
                            "Masparraute",
                            "Ilharre",
                            "Camou-Cihigue",
                            "Haux",
                            "Urepel",
                            "Lacarre",
                            "Gamarthe",
                            "Pagolle",
                            "Aussurucq",
                            "Arbérats-Sillègue",
                            "Alos-Sibas-Abense",
                            "Larrau",
                            "Musculdy",
                            "Amorots-Succos",
                            "Espès-Undurein",
                            "Mendive",
                            "Berrogain-Laruns",
                            "Ostabat-Asme",
                            "Garris",
                            "Ainharp",
                            "Arhansus",
                            "Saint-Michel",
                            "Ossas-Suhare",
                            "Lichans-Sunhar",
                            "Etcharry"))

    }else{
        hide("select2")
        disable("select2")
    }
  })
  
  # Afficher la sélection des deux menus
  output$result <- renderText({
    paste("Vous avez sélectionné", input$select1, "et", input$select2)
  })
  
}

shinyApp(ui = ui, server = server)