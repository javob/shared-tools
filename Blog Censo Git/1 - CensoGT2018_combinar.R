
# Combinar datos del Censo 2018 
# Javier Brolo
# Agosto 2022

# Datos descargados de:
# https://www.censopoblacion.gt/descarga 

# Definir directorio de trabajo y vaciar área de trabajo
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())

# Cargar datos 
personas  <- read.csv("db_csv_/PERSONA_BDP.csv", stringsAsFactors = F)
hogares   <- read.csv("db_csv_/HOGAR_BDP.csv", stringsAsFactors = F)
vivienda  <- read.csv("db_csv_/VIVIENDA_BDP.csv", stringsAsFactors = F)

# Primera combinación: personas y hogares 
# La combinación de numero de vivienda y número de hogar es única para los hogares
# La información de cada hogar se agrega a las personas del mismo hogar
personasHogares <- merge(personas, hogares,
                         by = c("NUM_VIVIENDA", "NUM_HOGAR"), 
                         all.x = T)

# Segunda combinación: personas y hogares con vivienda
# La información de cada vivienda se agrega a las personas de la misma vivienda
personasHogaresVivienda <- merge(personasHogares, vivienda,
                                 by = c("NUM_VIVIENDA"), 
                                 all.x = T)

# Guardar información combinada 
save(personasHogaresVivienda, file = "data/PersonaHogarVivienda.Rdata")

# -----------------------------------------------------------------------------
# Nota: es posible que se requiera incrementar el RAM disponible
# Mac > Terminal
# cd ~ 
# touch .Renviron
# open .Renviron
# R_MAX_VSIZE = 100Gb (incluir texto en archivo)
