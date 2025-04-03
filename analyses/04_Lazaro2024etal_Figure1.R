
# Script used to do the Figure 1. Maps of Mexico with the geographical distribution of participants by state

#Project: Assessment of frequency of genetic variants previously associated to PD in the Mexican PD Cohort
#Version: R/4.3.0
#Last Updated: 3-FEB-2025


#Packages necessary

install.packages("sf") #Paquete necesario para generar el mapa por rangos

#Load the necessary packeges
library(dplyr)
library(sf)  
library(ggplot2)

#Also it is necessary download the next files from GitHub

https://github.com/R-LadiesGDL/MEETUP-Creacion_mapas

#After that, we upload to our environment the shapefile with the geometry to create the Maps of Mexico

ent_shp <- st_read("D:/Scripts_Paper_GP2/00ent.shp")

st_geometry(ent_shp)

head(ent_shp) #See the names and geometry to each state 

#Upload the Database with the information of the state of residence of our sample

# "Datos" is the name of the data frame 

Datos <- Data_base


# Map of controls distribution --------------------------------------------

#Subset only with the info of controls transform into a table with the frequencys
state_freq_ctr <- Datos %>%
  select(status,estadoderecidencia_p,state_name)  %>% #We only keep the column of status, residence state and official name of the states
  filter(!is.na(estadoderecidencia_p)) %>%
  filter(status %in% c("1")) %>%
  count(state_name, name = "Freq")

head(state_freq_ctr)

# Join the info of the frecuencys of control's residence with the shapefile geometry in a new data frame

MAPA_UMC <- merge(ent_shp, state_freq_ctr, by.x = "NOMGEO", by.y = "state_name", all.x = TRUE)

head(MAPA_UMC)

#Change the NAs to zeros in the Freq column

MAPA_UMC$Freq[is.na(MAPA_UMC$Freq)] <- 0

head(MAPA_UMC$Freq)

#Division of the frequencies of the place of residence of the controls into ranges in a new column

MAPA_UMC <- MAPA_UMC %>% 
  mutate(Rango=case_when(Freq < 1  ~ "No registries", #The name of the new column is "Rango"
                         between(Freq, 1, 15) ~ "1-15",
                         between(Freq, 16, 30) ~ "16-30",
                         between(Freq, 31, 45) ~ "31-45",
                         between(Freq, 46, 60) ~ "46-60",
                         Freq > 60 ~ "61 or more"))

#Verify
MAPA_UMC$Rango

#Change the into levels 

MAPA_UMC <- MAPA_UMC %>% 
  mutate(Rango=factor(Rango, 
                      levels = c("61 or more", "46-60", 
                                 "31-45","16-30", "1-15", "No registries")))
levels(MAPA_UMC$Rango)

#Make the Figure

Mapa_Ctr <- ggplot(data = MAPA_UMC, aes(fill = as.factor(Rango), geometry = geometry)) +
  geom_sf() +
  scale_fill_manual(values=c("#391946", "#73338d","#ac4dd3", "#cc77ef","#dfaaf5", "#f6edff"))+
  labs(title = "Controls by state",
       subtitle = "",
       caption = "",
       fill="Number of registries")+
  theme_minimal()+ 
  theme(
    legend.position = "right", 
    panel.background = element_blank(), 
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    plot.title = element_text(size = 20, face = "bold"),     
    plot.subtitle = element_text(size = 16, face = "italic"),
    plot.caption = element_text(size = 12, face = "italic"), 
    legend.title = element_text(size = 14),                  
    legend.text = element_text(size = 12))

#Watch the figure
Mapa_Ctr

#Save the figure

ggsave("Mapa_Ctr.png", plot = Mapa_Ctr, width = 10, height = 6, dpi = 300)



# Map of PD patients distribution --------------------------------------------

#Subset only with the info of controls transform into a table with the frequencys

state_freq_pacientes <- Datos %>%
  select(status,estadoderecidencia_p,state_name)  %>% #We only keep the column of status, residence state and official name of the states
  filter(!is.na(estadoderecidencia_p)) %>%
  filter(status %in% c("2")) %>%
  count(state_name, name = "Freq")

head(state_freq_pacientes)

# Join the info of the frecuencys of control's residence with the shapefile geometry in a new data frame

MAPA_UMP <- merge(ent_shp, state_freq_pacientes, by.x = "NOMGEO", by.y = "state_name", all.x = TRUE)

head(MAPA_UMP)

#Change the NAs to zeros in the Freq column

MAPA_UMP$Freq[is.na(MAPA_UMP$Freq)] <- 0

head(MAPA_UMP$Freq)

#Division of the frequencies of the place of residence of the controls into ranges in a new column

MAPA_UMP <- MAPA_UMP %>% 
  mutate(Rango=case_when(Freq < 1  ~ "No registries", #The name of the new column is "Rango"
                         between(Freq, 1, 15) ~ "1-15",
                         between(Freq, 16, 30) ~ "16-30",
                         between(Freq, 31, 45) ~ "31-45",
                         between(Freq, 46, 60) ~ "46-60",
                         Freq > 60 ~ "61 or more"))

#Verify
MAPA_UMP$Rango

#Change the into levels 

MAPA_UMP <- MAPA_UMP %>% 
  mutate(Rango=factor(Rango, 
                      levels = c("61 or more", "46-60", 
                                 "31-45","16-30", "1-15", "No registries")))
levels(MAPA_UMP$Rango)

#Make the Figure

Mapa_PD <- ggplot(data = MAPA_UMP, aes(fill = as.factor(Rango), geometry = geometry)) +
  geom_sf()+
  scale_fill_manual(values=c("#011f4b","#03396c","#005b96","#6497b1","#b3cde0","#f6f6f6"))+
  labs(title = "Patients by state",
       subtitle = "",
       caption = "",
       fill="Number of registries")+
  theme_minimal()+ 
  theme(
    legend.position = "right", 
    panel.background = element_blank(), 
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    plot.title = element_text(size = 20, face = "bold"),     # Tamaño y estilo del título
    plot.subtitle = element_text(size = 16, face = "italic"),# Tamaño y estilo del subtítulo
    plot.caption = element_text(size = 12, face = "italic"), # Tamaño y estilo del pie de página
    legend.title = element_text(size = 14),                  # Tamaño del título de la leyenda
    legend.text = element_text(size = 12))

#Watch the figure
Mapa_PD

#Save the figure

ggsave("Mapa_PD.png", plot = Mapa_PD, width = 10, height = 6, dpi = 300)


