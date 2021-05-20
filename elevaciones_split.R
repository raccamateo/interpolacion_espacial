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

# filtramos solo los puntos de elevación correspondientes a edificios
elevaciones_NY_b <- elevaciones_NY %>%
  filter(FEAT_CODE == 3020)

# vamos a crear un nuevo dataframe con menos puntos para trabajar de manera más sencilla 
sample_size = floor(0.01*nrow(elevaciones_NY_b))
# floor 0.01 significa que vamos a seleccionar el 1% del total de puntos, es decir 10.849

#usamos set.seed para que en caso de querer replicar el muestreo esto sea posible
set.seed(777)
picked = sample(seq_len(nrow(elevaciones_NY)),size = sample_size)

#creamos el nuevo dataset
elevaciones_NY_muestra = elevaciones_NY[picked,]

#para poder calcular semivariogramas eliminamos los valores de elevaciones negativos
elevaciones_NY_muestra <- elevaciones_NY_muestra %>%
  filter(ELEVATION > 0) 
  
#guardamos los datos como csv
write.csv2(elevaciones_NY_muestra, file = "elevaciones_NY_muestra.csv")

#guardamos los datos como geojson
st_write(elevaciones_NY_muestra, "elevaciones_NY_muestra.geojson")

#transformamos los datos para poder almacenarlos como shapefile
elevaciones_NY_muestra <- st_zm(elevaciones_NY_muestra, drop=T, what='ZM')

#guardamos el dataframe elevaciones_NY_muestra
st_write(elevaciones_NY_muestra,
         "elevaciones_NY_muestra.shp")

#intentamos leer el shapefile para ver si todo funcionó correctamente
elevaciones_NY_ready <- st_read("elevaciones_NY_muestra.shp") %>%
  st_as_sf()
