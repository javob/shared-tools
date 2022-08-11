
# Analizar datos preparados del Censo 2018 
# Javier Brolo
# Agosto 2022

# Datos descargados de:
# https://www.censopoblacion.gt/descarga 

# Definir directorio de trabajo y vaciar área de trabajo
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())

# Cargar datos 
load("data/censoMunicipios.Rdata")

# Agregar nombres de municipios
nombres <- read.csv("data/municipios.csv", stringsAsFactors = F)
municipio <- merge(municipio, nombres, 
                   by.x = "MUNICIPIO", by.y = "codigo_mun", 
                   all = T)
rm(nombres)


# Descripción: diferencia en acceso a servicio de recolección 
# entre población maya y ladina 
# 
municipio$serv.maya.p <- municipio$serv.maya / municipio$PCP12.maya
municipio$serv.ladin.p <- municipio$serv.ladin / municipio$PCP12.ladin
# 
summary(municipio$serv.maya.p)
summary(municipio$serv.ladin.p)
#
par(mar = c(5,5,1,1))
boxplot(municipio[, c("serv.maya.p", "serv.ladin.p")],
        ylab = "Porcentaje de personas en municipio\ncon acceso a servicio de recolección (%)",
        xlab = "Etnia",
        names = c("Maya", "Ladina(o)"),
        las = 1)
# 
municipio[order(-(municipio$serv.ladin.p - municipio$serv.maya.p)),
          c("MUNICIPIO", "municipio", "departamento",
            "total.personas", "PCP12.maya", "PCP12.ladin",
            "serv.maya", "serv.ladin", "serv.maya.p", "serv.ladin.p")][c(1:10), ]

# Descripción: diferencia en años de escolaridad 
#
summary(municipio$edu.maya)
summary(municipio$edu.ladin)
#
boxplot(municipio[, c("edu.maya", "edu.ladin")],
        ylab = "Promedio de escolaridad (Años)",
        xlab = "Etnia",
        names = c("Maya", "Ladina(o)"),
        las = 1)
#
municipio[order(-(municipio$edu.ladin - municipio$edu.maya)),
          c("MUNICIPIO", "municipio", "departamento",
            "total.personas", "PCP12.maya", "PCP12.ladin",
            "edu.maya", "edu.ladin")][c(1:10), ]
