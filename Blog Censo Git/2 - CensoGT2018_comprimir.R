
# Comprimir datos del Censo 2018 
# Javier Brolo
# Agosto 2022

# Datos descargados de:
# https://www.censopoblacion.gt/descarga 

# Definir directorio de trabajo y vaciar área de trabajo
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rm(list = ls())

# Cargar datos 
load("data/PersonaHogarVivienda.Rdata")

# Identificar variables de interés (ejemplo PCP12 y PCH10)
# Revisar definiciones en diccionarios
names(personasHogaresVivienda)

    # PCP12	
    # 1	Maya
    # 2	Garífuna
    # 3	Xinka
    # 4	Afrodescendiente/Creole/Afromestizo
    # 5	Ladina (o)
    # 6	Extranjera (o)
    
    # ANEDUCA	
    # 0	0 años de estudio
    # 1	1 año de estudio
    # 2	2 años de  estudio
    # 3	3 años de estudio
    # 4	4 años de estudio
    # 5	5 años de estudio
    # 6	6 años de estudio
    # 7	7 años de estudio
    # 8	8 años de estudio
    # 9	9 años de estudio
    # 10	10 años de estudio
    # 11	11 años de estudio
    # 12	12 años de estudio
    # 13	13 años de estudio
    # 14	14 años de estudio
    # 15	15 años de estudio
    # 16	16 años de estudio
    # 17	17 años de estudio
    # 18	18 años de estudio
    # 19	19 años de estuido
    # 20	20 años de estudio
    # 21	21 años de estudio
    
    # PCH10	
    # 1	Servicio municipal
    # 2	Servicio privado
    # 3	La queman
    # 4	La entierran
    # 5	La tiran en un río, quebrada o mar
    # 6	La tiran en cualquier lugar
    # 7	Abonera / reciclaje
    # 8	Otro

# Comprimir base de datos creando variables de análisis
# https://datacarpentry.org/R-genomics/04-dplyr.html
library(dplyr)

municipio <- personasHogaresVivienda %>% 
  group_by(DEPARTAMENTO, MUNICIPIO) %>% 
  summarize(n(), # total de personas 
            PCP12.maya   = sum(PCP12 == 1, na.rm = T), # total maya
            PCP12.ladin  = sum(PCP12 == 5, na.rm = T), # total ladin
            ANEDUCA.mean = mean(ANEDUCA, na.rm = T), # promedio años de educación
            PCH10.serv   = sum(PCH10 %in% c(1,2), na.rm = T), # total con acceso a servicio
            serv.maya    = sum(PCP12 == 1 & PCH10 %in% c(1,2), na.rm = T), # maya con servicio
            serv.maya.n  = sum(PCP12 == 1 & PCH10 %in% c(3:8), na.rm = T), # maya sin servicio
            serv.ladin   = sum(PCP12 == 5 & PCH10 %in% c(1,2), na.rm = T), # ladin con servicio
            serv.ladin.n = sum(PCP12 == 5 & PCH10 %in% c(3:8), na.rm = T), # ladin sin servicio
            edu.maya     = mean(ANEDUCA[PCP12 == 1], na.rm = T),
            edu.ladin    = mean(ANEDUCA[PCP12 == 5], na.rm = T),
            edu.maya.sd  = sd(ANEDUCA[PCP12 == 1], na.rm = T),
            edu.ladin.sd = sd(ANEDUCA[PCP12 == 5], na.rm = T)) %>%
  as.data.frame()
colnames(municipio)[3] <- "total.personas"

# Guardar información comprimida
save(municipio, file = "data/censoMunicipios.Rdata")
