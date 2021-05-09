# cargamos los paquetes que usamos normalmente
library(tidyverse)
library(sf)
library(sp)
library(osmdata)
library(leaflet)
library(tmap)
library(rgdal)

#pueden descargar los datos originales acá: https://data.cityofnewyork.us/api/geospatial/szwg-xci6?method=export&format=Shapefile

# cargamos el dataset original con los puntos de elevación de la ciudad de Nueva York
elevaciones_NY <- st_read("nyc_elevations_complete.shp") %>%
  st_as_sf()
# el dataset original cuenta con 1.473.788 puntos

# vamos a crear un nuevo dataframe con menos puntos para trabajar de manera más sencilla 
sample_size = floor(0.01*nrow(elevaciones_NY))
# floor 0.01 significa que vamos a seleccionar el 1% del total de puntos, es decir 14.737

#usamos set.seed para que en caso de querer replicar el muestreo esto sea posible
set.seed(777)
picked = sample(seq_len(nrow(elevaciones_NY)),size = sample_size)

# creamos el nuevo dataset
elevaciones_NY_muestra = elevaciones_NY[picked,]

#transformamos los datos para poder almacenarlos como datos espaciales
elevaciones_NY_muestra <- st_zm(elevaciones_NY_muestra, drop=T, what='ZM')

# guardamos el dataframe elevaciones_NY_muestra
st_write(elevaciones_NY_muestra,
         "elevaciones_NY_muestra.shp")

# intentamos leerlo para ver si todo funcionó correctamente
elevaciones_NY_ready <- st_read("elevaciones_NY_muestra.shp") %>%
  st_as_sf()