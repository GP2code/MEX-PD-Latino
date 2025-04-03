
#Script used to make the Figure 2. 

#Project: Assessment of frequency of genetic variants previously associated to PD in the Mexican PD Cohort
#Version: R/4.3.0
#Last Updated: 3-FEB-2025

#Load the librarys 

library(tidyverse)
library(scales)

# "Datos" is the name of the data frame 

Datos <- Base_datos_analisis_TodoModificado

# Figure 2.A Treatment (Dopaminergic agonists, levodopa, and other) as a function of age group --------

TratamientoFarm <- Datos %>% 
  filter(status=="2") %>% 
  select(Grupos_edad, Treatment) %>% 
  filter(Treatment != "" & !is.na(Treatment)) %>% 
  filter(Grupos_edad != "" & !is.na(Grupos_edad)) %>% 
  ggplot(aes(x = Grupos_edad, fill = Treatment)) +
  labs(x = "", y = "") +
  geom_bar(position = "fill", width = 0.7) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#011f4b","#03396c","#005b96","#6497b1")) +
  theme(panel.background = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 17))

#Watch the figure
TratamientoFarm

#Save the figure
ggsave("TratamientoFarm.png", plot = TratamientoFarm, width = 10, height = 6, dpi = 300)

#Figure 2.B Treatment as a function of Hoehn & Yahr stage -------

TratamientoSeveridad <- Datos %>% 
  filter(status=="2") %>% 
  select(Severity, Treatment) %>% 
  filter(Treatment != "" & !is.na(Treatment)) %>% 
  filter(Severity != "" & !is.na(Severity)) %>% 
  ggplot(aes(x = Severity, fill = Treatment)) +
  labs(x = "Hoehn and Yahr stage", y = "") +
  geom_bar(position = "fill", width = 0.7) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("#011f4b","#03396c","#005b96","#6497b1")) +
  theme(panel.background = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text = element_text(size = 17))

#Watch the figure
TratamientoSeveridad

#Save the figure
ggsave("TratamientoSeveridad.png", plot = TratamientoSeveridad, width = 10, height = 6, dpi = 300)


# Figure 2.C  Percentage of patients by the location of the initial symptoms --------

#First we upload the data of the localization of the symptoms 

#The database is called "Loc#
Loc <- read.csv("D:/scripts/Localizacion_sint.csv")

Sympt_Loc <- Loc %>% 
  filter(!is.na(Localization)) %>% 
ggplot(aes(x= Localization))+
  labs(x=" ", y= "")+
  geom_bar(aes(y = (..count..)/sum(..count..)), width = 0.7, fill= "#03B0FF")+
  scale_y_continuous(labels=scales::percent) +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..)),
                y= ((..count..)/sum(..count..))), stat="count",
            vjust = -.25)+
  theme(panel.background = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())+
  theme(axis.text = element_text(size=17))

#Watch the figure
Sympt_Loc

#Save the figure
ggsave("Sympt_Loc.png", plot = Sympt_Loc, width = 10, height = 6, dpi = 300)



# Figure 2.D Years of delay in the diagnosis ------------------------------

DelayFig <- Datos %>% 
  filter(!is.na(Delay_Diagn)) %>% 
  filter(Delay_Diagn != "NA") %>% 
  ggplot(aes(x=(Delay_Diagn)))+ 
  labs(x=" ", y= "")+
  geom_bar(aes(y = (..count..)/sum(..count..)), width = 0.7, fill= "#03B0FF")+
  scale_y_continuous(labels=scales::percent) +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..)),
                y= ((..count..)/sum(..count..))), stat="count",
            vjust = -.25)+
  theme(panel.background = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())+
  theme(axis.text = element_text(size=15))

#Watch the figure
DelayFig

#Save the figure
ggsave("DelayFig.png", plot = DelayFig, width = 10, height = 6, dpi = 300)




