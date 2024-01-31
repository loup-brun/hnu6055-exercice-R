# Mini-atelier sur la geolocalisation des crimes sur le territoire montréalais
Cet atelier partira d’un cas particulier, la représentation spatiale de crimes sur le territoire montréalais. On verra comment importer un jeu de données depuis le site de Données Québec, puis on utilisera les extensions tidygeocoder et leaflet for R pour projeter ces données sur une carte de la Ville de Montréal.

## Source de donnees:
Actes criminels
Liste des actes criminels enregistrés par le Service de police de la Ville de Montréal (SPVM).
Service de police de la Ville de Montréal - Division des ressources informationnelles, Attribution (CC-BY 4.0)

https://www.donneesquebec.ca/recherche/dataset/vmtl-actes-criminels#

# Prétraitement des données

Par exemple, les valeurs manquantes, etc. ont été supprimées.

# Dossiers

## Données
contient des tableaux de données.

**actes-criminels.csv** contient une table avec les crimes et leurs les cornonnées geographiques.

## Scripts
contient le code pour le prétraitement et l'analyse des données.

**atelier_actescriminel_geo.R**
Ce script génère différentes cartes pour localiser les crimes à Montréal. Il comprend également plusieurs petits défis.

## Figures
inclut les figures générés.

## Resultats
comprend des tableaux de fréquence et des données d'entrée pour générer les chiffres.
