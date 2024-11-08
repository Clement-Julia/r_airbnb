if(!require(xgboost)) install.packages("xgboost")
if(!require(shiny)) install.packages("shiny")
if(!require(shinyjs)) install.packages("shinyjs")
if(!require(bslib)) install.packages("bslib")
library(shiny)
library(shinyjs)
library(bslib)
library(xgboost)

room_type <- c("entire home/apt","hotel room","private room","shared room")
property_type <- c(
  "logement entier" = "entire rental unit",
  "chambre privée dans un chalet" = "private room in chalet",
  "loft entier" = "entire loft",
  "chambre privée dans une chambre d'hôtes" = "private room in bed and breakfast",
  "chambre privée dans un condo" = "private room in condo",
  "maison entière" = "entire home",
  "condo entier" = "entire condo",
  "chambre privée dans une maison" = "private room in home",
  "chambre privée dans un logement" = "private room in rental unit",
  "maison de ville entière" = "entire townhouse",
  "maison de vacances entière" = "entire vacation home",
  "chambre privée dans une maison de ville" = "private room in townhouse",
  "chambre privée dans une villa" = "private room in villa",
  "maison d'hôtes entière" = "entire guesthouse",
  "suite entière" = "entire guest suite",
  "chambre privée dans une suite d'hôtes" = "private room in guest suite",
  "casa particular" = "casa particular",
  "chalet entier" = "entire chalet",
  "villa entière" = "entire villa",
  "chambre privée dans un lodge en nature" = "private room in nature lodge",
  "cottage entier" = "entire cottage",
  "bungalow entier" = "entire bungalow",
  "séjour à la ferme" = "farm stay",
  "chambre privée dans un cabane" = "private room in cabin",
  "chambre privée dans un loft" = "private room in loft",
  "chambre privée" = "private room",
  "tiny home" = "tiny home", 
  "chambre privée dans une maison d'hôtes" = "private room in guesthouse",
  "logement entier" = "entire place",
  "chambre privée dans un séjour à la ferme" = "private room in farm stay",
  "chambre partagée dans un lodge en nature" = "shared room in nature lodge",
  "chambre partagée dans une maison d'hôtes" = "shared room in guesthouse",
  "chambre privée dans une auberge de jeunesse" = "private room in hostel",
  "chambre partagée dans une maison de ville" = "shared room in townhouse",
  "appartement entier avec services" = "entire serviced apartment",
  "chambre dans un aparthotel" = "room in aparthotel",
  "chambre partagée dans un condo" = "shared room in condo",
  "grange" = "barn",
  "chambre partagée dans une chambre d'hôtes" = "shared room in bed and breakfast",
  "chambre dans un hôtel" = "room in hotel",
  "chambre partagée dans un tiny home" = "shared room in tiny home",
  "cabane de berger" = "shepherd’s hut",
  "chambre privée dans une maison en terre" = "private room in earthen home",
  "chambre privée dans un tiny home" = "private room in tiny home",
  "maison en terre" = "earthen home",
  "camper/caravane" = "camper/rv",
  "chambre privée dans un château" = "private room in castle",
  "bateau" = "boat",
  "chambre partagée dans une auberge de jeunesse" = "shared room in hostel",
  "cabine entière" = "entire cabin",
  "tente" = "tent",
  "chambre privée dans une casa particular" = "private room in casa particular",
  "chambre partagée dans un tipi" = "shared room in tipi",
  "chambre dans un hôtel boutique" = "room in boutique hotel",
  "chambre privée dans une maison de vacances" = "private room in vacation home",
  "camping" = "campsite",
  "parc de vacances" = "holiday park",
  "chambre partagée dans un resort" = "shared room in resort",
  "chambre partagée dans un logement" = "shared room in rental unit",
  "chambre privée dans un bateau" = "private room in boat",
  "yourte" = "yurt",
  "chambre d'hôtes entière" = "entire bed and breakfast",
  "maison flottante" = "houseboat",
  "chambre privée dans un bungalow" = "private room in bungalow",
  "château" = "castle",
  "chambre partagée dans une maison" = "shared room in home",
  "chambre dans une chambre d'hôtes" = "room in bed and breakfast",
  "chambre dans une auberge de jeunesse" = "room in hostel",
  "chambre partagée dans un appartement avec services" = "shared room in serviced apartment",
  "chambre partagée dans un hôtel" = "shared room in hotel",
  "chambre partagée dans un loft" = "shared room in loft",
  "chambre privée dans un appartement avec services" = "private room in serviced apartment",
  "conteneur d'expédition" = "shipping container",
  "chambre privée dans une maison flottante" = "private room in houseboat",
  "chambre partagée dans un hôtel boutique" = "shared room in boutique hotel"
)
equipement <- c(
  "bain à remous" = "hot tub",
  "climatisation" = "air conditioning",
  "wifi" = "wifi",
  "cuisine" = "kitchen",
  "lave-linge" = "washer",
  "parking gratuit sur place" = "free parking on premises",
  "piscine" = "pool",
  "salle de sport" = "gym",
  "chauffage" = "heating",
  "petit déjeuner" = "breakfast",
  "animaux acceptés" = "pet-friendly",
  "enregistrement autonome" = "self check-in",
  "sèche-linge" = "dryer",
  "alarme incendie" = "smoke alarm",
  "lit bébé" = "crib",
  "espace de travail dédié" = "dedicated workspace",
  "télévision" = "tv",
  "lave-vaisselle" = "dishwasher",
  "cheminée" = "fireplace",
  "alarme au monoxyde de carbone" = "carbon monoxide alarm"
)

ui <- page_navbar(
  title = "Simulacool: House Price Prédiction",
  bg = "#2D89C8",
  inverse = TRUE,
  useShinyjs(), 
  nav_spacer(),
  nav_item(input_dark_mode()),
  nav_panel(title = "Home",id="home", 
    card(
      card_header('Simulateur du prix de votre Logement :'),
      layout_columns(
        selectInput("select1",label="Ville/Region",choices=c(" "= 1,"Paris, Île-de-France"= "IDF","Lyon, Auvergne-Rhone-Alpes" = "ARA","Bordeaux, Nouvelle-Aquitaine" = "NAQ","Pays Basque" = "64")),
        selectInput("select2",label="Quartier",choices=NULL),
        col_widths = c(-1,5,5,-3),
        row_heights = c(1,1)
      ),
      layout_columns(
        # selectInput("room_type",label="Type de Logement", choices=room_type),
        selectInput("property_type",label="Type de Propriété", choices=property_type),
        numericInput("nb_client_max", label = "Nombre max d'hôtes :", min = 1, max = 100, value = 1),
        col_widths = c(-1,5,5,-3),
        row_heights = c(1)
      ),
      br(),
      numericInput("nb_bedrooms", label = "Nombre de Chambre :", min = 1, max = 20, value = 1),
      numericInput("nb_sdb", label = "Nombre de salles de bain :", min = 1, max = 20, value = 1),
      selectInput(
        "select",
        "Equipements :",
        choices = equipement,
        multiple = TRUE
      ),
      actionButton("predict", "Predict", icon("paper-plane"), 
    style="color: #fff; background-color: #2D89C8; border-color: #2D89C8"),
      value_box( 
          title = "Prediction Result :", 
          showcase = icon("hand-holding-dollar"), 
          value = uiOutput("prediction"),  
          theme = "bg-gradient-blue-purple",
          style = "min-height: 100px; max-height: 200px; overflow-y: auto; width: 100%;"
      )
    )
  )
)
server <- function(input, output, session) {
  model <- xgb.load("../xgboost_model.bin")
  observeEvent(input$predict, {
    ville <- input$select1
    quartier <- input$select2
    # room_type <- input$room_type
    property_type <- input$property_type
    equipements <- input$select
    nb_clientmax <- input$nb_client_max
    # nb_lits <- input$nb_lits
    nb_sdb <- input$nb_sdb
    nb_bedroom <- input$nb_bedrooms
    data <- data.frame(
      region = as.numeric(factor(ville)),
      neighbourhood_cleansed = as.numeric(factor(quartier)),
      # room_type = as.numeric(factor(room_type)),
      property_type = as.numeric(factor(property_type)),
      amenities = as.numeric(factor(paste(equipements, collapse = ","))),
      # beds = nb_lits,
      bedrooms = nb_bedroom,
      bathrooms = nb_sdb,
      beds_and_baths = nb_bedroom + nb_sdb,
      accomodates = nb_clientmax,
      stringsAsFactors = FALSE
    )
    data_matrix <- as.matrix(data)
    dmatrix <- xgb.DMatrix(data = data_matrix)
    prediction <- predict(model, dmatrix)
    output$prediction <- renderText({
      glue::glue("${round(prediction, 2)}")
    })

  })
  observe({
    if (input$select1 == "") {
      hide("select2")
      disable("select2")
    } else {
      show("select2")
      enable("select2")
    }
  })
  observeEvent(input$select1, {
    if (input$select1 == "IDF") {
      updateSelectInput(session, "select2",
                        choices = c("Observatoire","Hôtel-de-Ville","Opéra","Buttes-Chaumont","Élysée","Entrepôt","Louvre","Popincourt","Buttes-Montmartre",
                                    "Gobelins","Bourse","Ménilmontant","Passy","Reuilly","Vaugirard","Temple","Panthéon","Batignolles-Monceau","Luxembourg",
                                    "Palais-Bourbon"))
      show("select2")
      enable("select2")  
    } else if (input$select1 == "ARA") {
      updateSelectInput(session, "select2", 
                        choices = c("5e Arrondissement","2e Arrondissement","3e Arrondissement","6e Arrondissement","7e Arrondissement","1er Arrondissement","8e Arrondissement",
                          "4e Arrondissement","9e Arrondissement"))
      show("select2")
      enable("select2") 
    } else if (input$select1 == "NAQ") {
      updateSelectInput(session, "select2", 
                        choices = c("Bordeaux Sud","Saint-Mdard-en-Jalles","Chartrons - Grand Parc - Jardin Public","Centre ville (Bordeaux)","Bgles","Talence","Le Bouscat",
"Saint Augustin - Tauzin - Alphonse Dupeux","Caudran","Nansouty - Saint Gens","Magonty","Palmer-Gravires-Cavailles","Carbon-Blanc","La Glacire","France Alouette","Gradignan",
"Le Bourg","Bouliac","Lormont","Saint-Aubin-de-Mdoc","La Bastide","Verthamon","Chiquet-Fontaudin","Bordeaux Maritime","Floirac","Bruges","Villenave-d'Ornon","Les Eyquems","Eysines","Blanquefort",
"Bourran","Parempuyre","Gambetta-Mairie-Lissandre","Capeyron","Arlac","Chemin Long","Ambars-et-Lagrave","La Paillre-Compostelle","Martignas-sur-Jalle","Bassens","Le Haillan","Le Monteil",
"Saige","Beaudsert","Sardine","Le Taillan-Mdoc","Centre ville (Merignac)","Cap de Bos","Casino","Beutre","3M-Bourgailh","Plaisance-Loret-Maregue","Nos","Artigues-Prs-Bordeaux","Saint-Louis-de-Montferrand",
"Brivazac-Candau","Arago-La Chataigneraie","Toctoucau","Le Vallon-Les Echoppes","Le Burck","Ambs","Saint-Vincent-de-Paul"))
      show("select2")
      enable("select2")
    }else if(input$select1 == "64"){
       updateSelectInput(session, "select2", 
                        choices = c("Hendaye","Biarritz","Urrugne","Bayonne","Anglet","Bidart","Guéthary","Saint-Jean-de-Luz","Lahonce","Saint-Pierre-d'Irube","Saint-Pée-sur-Nivelle",
                            "Ciboure","Arbonne","Cambo-les-Bains","Itxassou","Saint-Étienne-de-Baïgorry","Ascain","Uhart-Cize","Bidache","Jatxou","Larressore","Hasparren",
                            "Mouguerre","Ascarat","Villefranque", "Boucau","Louhossoa","Sare","Arcangues","Sauguis-Saint-Étienne","Bardos","Ainhoa","Ustaritz","Sames",
                            "Barcus","Urt","Bassussarry","Arrast-Larrebieu","Ahetze","Irissarry","Saint-Esteben","Halsou","Souraïde","Irouléguy","Saint-Martin-d'Arrossa",
                            "Saint-Jean-le-Vieux","Briscous","Saint-Palais","Ossès","Bonloc","Saint-Jean-Pied-de-Port","Aldudes","Isturits","Larceveau-Arros-Cibits","Anhaux",
                            "Armendarits","Mauléon-Licharre","Trois-Villes","Suhescun","Osserain-Rivareyte","Bunus","Ispoure","Came","Biriatou","La Bastide-Clairence","Macaye",
                            "Saint-Martin-d'Arberoue","Espelette","Caro","Amendeuix-Oneix","Laguinge-Restoue","Arnéguy","Gabat","Estérençuby","Ahaxe-Alciette-Bascassan",
                            "Lecumberry","Alçay-Alçabéhéty-Sunharette","Ayherre","Guiche","Larribar-Sorhapuru","Urcuit","Aincille","Mendionde","Aroue-Ithorots-Olhaïby",
                            "Orègue","Iholdy","Domezain-Berraute","Montory","Beyrie-sur-Joyeuse","Roquiague","Jaxu","Charritte-de-Bas","Chéraute","Ainhice-Mongelos",
                            "Lichos","Banca","Uhart-Mixe","Sainte-Engrâce","Licq-Athérey","Aïcirits-Camou-Suhast","Arraute-Charritte","Hosta","L'Hôpital-Saint-Blaise",
                            "Saint-Just-Ibarre","Gotein-Libarrenx","Ordiarp","Béguios","Béhasque-Lapiste","Lasse","Viodos-Abense-de-Bas","Bidarray","Béhorléguy","Hélette",
                            "Lantabat","Menditte","Tardets-Sorholus","Masparraute","Ilharre","Camou-Cihigue","Haux","Urepel","Lacarre","Gamarthe","Pagolle","Aussurucq",
                            "Arbérats-Sillègue","Alos-Sibas-Abense","Larrau","Musculdy","Amorots-Succos","Espès-Undurein","Mendive","Berrogain-Laruns","Ostabat-Asme",
                            "Garris","Ainharp","Arhansus","Saint-Michel","Ossas-Suhare","Lichans-Sunhar","Etcharry"))
    }else{
        hide("select2")
        disable("select2")
    }
  })
}

shinyApp(ui = ui, server = server)