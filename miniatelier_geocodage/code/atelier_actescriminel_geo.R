########################### Mini-atelier HNU6055/3055 Geocodage des crimes ################################
## Auteur·rice·s: Lisa Teichmann
## Date: 31 Janvier 2024

## Le script ci-dessous traite des données sur la criminalité à Montreal de 2015 à aujourd'hui.
## Liste des actes criminels enregistrés par le Service de police de la Ville de Montréal (SPVM).
## Source: https://www.donneesquebec.ca/recherche/dataset/vmtl-actes-criminels#
## SVP lisez les directions pour l'usage et la licence.

### Etape 1: Initialisation et importation des données.

## Définir le chemin vers votre répertoire de travail
setwd("/cloud/project/miniatelier_geocodage")

## Installer les extensions nécessaires pour l'exécution des tâches.
install.packages(c("data.table", "tidyverse", "dplyr", "tidygeocoder", "leaflet"))
library(tidyverse)
library(dplyr)
library(tidygeocoder)
library(leaflet)
library(data.table)

##Télécharger les données et sauvegarder dans le sous-dossier "donnees" (optionnel)

## Importer les données en format tsv à l'environnement de travail de R
actes_criminel <- read.csv("donnees/actes-criminels.csv")

## Défi 1: Regarder les données avec View()
View()

## Défi 2: Explorer les données avec la function summary() et faire une recherche sur les données dans les colonnes
summary()

## Regarder les variables spécifiques avec table() et $ pour la colonne
table(actes_criminel$CATEGORIE)

## Défi 3: Regarder la variable QUART avec table() et $


### Géocodage inversé = attribuer une adresse à des coordonnées géographiques
## Les coordonnées sont dans les colonnes LONGITUDE et LATITUDE

## Défi 4: Copier et coller les premières coordonnées des tables et trouver l'adresse
## dans https://www.gps-coordinates.net
actes_criminel[1,"LONGITUDE"]

##Défi 5: Trouver la première valeur de la colonne LATITUDE avec l'index
actes_criminel[]

## (Marche seulement localement) Géocodage avec tidygeocoder
## tidygeocoder fonctionne avec le open API de Nominatim et la limite de requêtes par jour est de 2000 adresses

# ## Géocodage inversé
# ## Pour l'informatin: https://cran.r-project.org/web/packages/tidygeocoder/vignettes/tidygeocoder.html
# 
# actes_100_geo <- actes_100 %>%
#   reverse_geocode(lat = LATITUDE, long = LONGITUDE, 
#                   address = addr, 
#                   method = "osm") ## osm=openstreetmaps
# 
# ## Regarder les donnees du géocodage inversé avec View()
# View()

### Visualiser avec leaflet

## Créer un sous-ensemble aléatoire de la table des données avec sample_n()
actes_100_geo <- sample_n(actes_criminel, 100)

### Option 1: Créer une carte de chaleur ("heatmap")

install.packages("leaflet.extras")
library(leaflet.extras)

leaflet(actes_100_geo) %>% ## utiliser leaflet
  addTiles() %>% ## ajouter une carte de base
  addHeatmap(lng = actes_100_geo$LONGITUDE, lat = actes_100_geo$LATITUDE, blur = 40, max = 0.05, radius = 15) %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 9) ##zoom sur l'île de Montréal

## Option 2: Utiliser les marqueurs ronds ("circlemarkers")

leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(data = actes_100_geo, ##ajouter les marqueurs ronds
                   popup=~addr) ##ajouter un popup de l'adresse

## Option 3: Personnaliser les marqueurs ("markers")
markers <- makeAwesomeIcon(
  icon = "info",
  iconColor = "black",
  markerColor = "blue",
  library = "fa"
)

leaflet(actes_100_geo) %>%
  addTiles() %>%
  addAwesomeMarkers(~LONGITUDE,
                    ~LATITUDE,
                    icon = markers,
                    popup = ~addr,
                    label = ~DATE)

## Défi 6: Faire un zoom sur l'île de Montréal avec
##Indice: ajoutez le code precedent ici 
%>% setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


# ## Défi 7: Créer un sous-ensemble de 50 adresses et faire un géocodage inversé
# actes_sub <- sample_n() ##Indice: regardez le code precedente et copier coller
# 
# actes_sub_geo <- actes_sub %>%
#   reverse_geocode()
# 
# View()
# 
# 
# leaflet() %>%
#   addTiles() %>%
#   addAwesomeMarkers() %>% 
#   setView()

## Défi 8: Personnaliser les icônes
## https://fontawesome.com/icons/marker?s=solid

markers <- makeAwesomeIcon(
  icon = "", ## pour les icons regardez https://fontawesome.com/icons/marker?s=solid
  iconColor = "", ## e.g. white, grey, black
  markerColor = "", ## e.g. red, blue, pink
  library = "fa"
)

## Re-executer la code pour creer la carte avec les nouvaux marqueurs
leaflet(actes_100_geo) %>%
  addTiles() %>%
  addAwesomeMarkers(~LONGITUDE,
                    ~LATITUDE,
                    icon = markers,
                    popup = ~addr,
                    label = ~DATE)

### Option 4: Visualiser selon les données catégoriques avec une palette des coleurs
pal <- colorFactor(
  palette = 'Dark2',
  domain = actes_100_geo$QUART
)

leaflet(actes_100_geo) %>%
  addTiles() %>%
  addCircles(lng = ~LONGITUDE, lat = ~LATITUDE, weight = 5,
             popup= ~QUART, 
             color = ~pal(QUART)) %>% 
  addLegend(pal = pal, values = ~QUART, group = "circles", position = "topright") %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


## Défi 9: Recréer la même carte avec la colonne CATEGORIE
## Indice: pour voir les categories regardez les colonnes dans la table des donnees
View(actes_100_geo)

pal <- colorFactor(
)

leaflet() %>%
  addTiles() %>%
  addCircles(
    
  ) %>% 
  addLegend() %>% 
  setView()


## Extra: Changer les paramètres 
## palette= pour les couleurs (Blues, Oranges, Reds),  position = pour la légende (topleft, topright, bottomleft, bottomright)
## Indice: Pour toutes les palettes executer: RColorBrewer::display.brewer.all()


## Option 5: Utiliser les marqueurs de grappe ("clustermarkers")

leaflet(actes_100_geo) %>% 
  addTiles() %>% 
  addAwesomeMarkers(~LONGITUDE,
                    ~LATITUDE,
                    icon=markers,
                    clusterOptions = markerClusterOptions(),
                    popup = ~addr,
                    label = ~DATE
  ) %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


## Défi 10: Interagissez avec la carte et identifier les endroits avec le plus de crimes

## Extra: Changer les paramètres "popup =" et "label =" selon une autre variable (nom de colonne)

## Option 6: Créer des couches catégoriques
## Pour créer ces couches, il faut créer un sous-ensemble selon les paramètres catégoriels.

## Créer un sous-ensemble des crimes nocturnes avec filter()
actes_100_geo_nuit <- filter(actes_100_geo, QUART == "nuit")

## Défi 11: Créer un sous-ensemble pour les crimes de jour avec filter()
actes_100_geo_jour <- filter()

## Créer une carte avec des couches différentes pour la nuit et le jour

leaflet(actes_100_geo) %>%
  addTiles() %>%
  # Overlay groups
  addCircleMarkers(data=actes_100_geo_nuit,lng = ~LONGITUDE, lat = ~LATITUDE, weight = 5,
                   group = "Nuit") %>%
  addCircleMarkers(data=actes_100_geo_jour, lng = ~LONGITUDE, lat = ~LATITUDE, weight = 5,
                   group = "Jour") %>%
  # Layers control: comment les couches sont organisées
  addLayersControl(
    overlayGroups = c("Nuit", "Jour"),
    position = c("topright")) %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


## Défi 12: Interagisez avec les couches individualement dans la carte

## On peut ajouter des couleurs pour les marqueurs et ajuster leur taille

leaflet(actes_100_geo) %>%
  addTiles() %>%
  # Overlay groups
  addCircleMarkers(data=actes_100_geo_nuit, ## les donnees des sous ensemble
                   lng = ~LONGITUDE, lat = ~LATITUDE, 
                   weight = 5, ## stroke width in pixels
                   radius = 2, ## largeur des markers
                   color = "blue", ## coleur des markers
                   group = "Nuit") %>% ## identificateur pour les couches
  addCircleMarkers(data=actes_100_geo_jour, 
                   lng = ~LONGITUDE, lat = ~LATITUDE, 
                   weight = 5,
                   radius = 2,
                   color = "yellow",
                   group = "Jour") %>%
  # Layers control: comment les couches sont organisées
  addLayersControl(
    overlayGroups = c("Nuit", "Jour"),
    position = c("topright")) %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


## Défi 13: Regardez toutes les options dans la menu d'aide et ajouster les marqueurs
help(addCircleMarkers) ## Regardez toutes les options
## Indice: Personnaliser la carte precedente en ajoutant des étiquettes et des "popups", personnaliser les marqueurs et changer le "radius=" ou "color=", ou remplacer des marqueurs avec awesomemarkers


## Option 7: Ajouter d'autres couches selon la variable CATEGORIE
## Regarder les catégories uniques
unique(actes_100_geo$CATEGORIE)
## Creer les sous-ensembles
actes_100_geo_intro <- filter(actes_100_geo, CATEGORIE == "Introduction")
actes_100_geo_mefait <- filter(actes_100_geo, CATEGORIE == "Méfait")
actes_100_geo_voldans <- filter(actes_100_geo, CATEGORIE == "Vol dans / sur véhicule à moteur")
actes_100_geo_volde <- filter(actes_100_geo, CATEGORIE == "Vol de véhicule à moteur")
actes_100_geo_vols <- filter(actes_100_geo, CATEGORIE == "Vols qualifiés")

## Défi 14: Ajouter les catégories à la carte précédente

leaflet(actes_100_geo) %>%
  addTiles() %>%
  # Overlay groups
  addCircleMarkers() %>% ##ajouter actes_100_geo_intro et les parametres de la carte precedente (data=, lng=, lat=, weight=, radius=, color=, group=)
  addCircleMarkers() %>% ##ajouter actes_100_geo_mefait et data=, lng=, lat=, weight=, radius=, color=, group=
  addCircleMarkers() %>% ##ajouter actes_100_geo_voldans et data=, lng=, lat=, weight=, radius=, color=, group=
  addCircleMarkers() %>% ##ajouter actes_100_geo_volde et data=, lng=, lat=, weight=, radius=, color=, group=
  addCircleMarkers() %>% ##ajouter actes_100_geo_vols et data=, lng=, lat=, weight=, radius=, color=, group=
  
  addLayersControl(
    overlayGroups = c(), ## ajouter le nom des groupes entre guillemets ("")
    position = c("topright")) %>% 
  setView(lng = -73.569806, lat = 45.5031824, zoom = 8)


###############FELICITATIONS!###############################################

##Défi extra: Créer une carte avec les incidents pour chaque année
## Créer un sous-ensemble pour les années
View(table(actes_100_geo$DATE))

actes_100_geo_2015 <- filter()
actes_100_geo_2016 <- filter()
actes_100_geo_2017 <- filter()
actes_100_geo_2018 <- filter()
actes_100_geo_2019 <- filter()
actes_100_geo_2020 <- filter()
actes_100_geo_2021 <- filter()
actes_100_geo_2022 <- filter()

## Créer la carte avec les couches pour les années



