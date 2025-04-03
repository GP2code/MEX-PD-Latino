
# Script used to report Table 1 Information.
# Descriptive and lifestyle data of the sample

#Project: Assessment of frequency of genetic variants previously associated to PD in the Mexican PD Cohort
#Version: R/4.3.0
#Last Updated: 3-FEB-2025

#Load librarys

library(ggplot2)
library(dplyr)
library(stringr)
library(scales)


# "Datos" is the name of the data frame 

Datos <- Base_datos_analisis


# #N controls vs PD patients ----------------------------------------------


Datos %>%  
  filter(status == "1") %>% 
  count()

Datos %>%  
  filter(status == "2") %>% 
  count()



# #N controls vs PD patients by sex ---------------------------------------

  #N controls by sex
Ctr <- Datos %>% 
  select(sex, status) %>% 
  filter(status == "1") %>% 
  count(sex)

  #N patients by sex
PDP <- Datos %>% 
  select(sex, status) %>% 
  filter(status == "2") %>% 
  count(sex)

  #Contigency table to Chi square analysis 

Chi_status_sex <- data.frame(
  Control = c(Ctr$n),
Paciente = c(PDP$n))

 #Chi-square analysis of frequencies between controls and PD patients by sex

chisq.test(Chi_status_sex)


# Age of the sample by status ---------------------------------------------

  #Mean and SD of the age of controls
  summary(Datos %>% 
          select(status,age_today) %>%
          filter(status %in% c("1"))) #Mean

  Datos %>% 
    filter(status %in% c("1")) %>%  
    pull(age_today) %>%                    
    sd(na.rm = TRUE) #SD

  #Mean and SD of the age of PD patients
  
  summary(Datos %>% 
            select(status,age_today) %>%
            filter(status %in% c("2"))) #Mean
  
  Datos %>% 
    filter(status %in% c("2")) %>%  
    pull(age_today) %>%                    
    sd(na.rm = TRUE) #SD

  #Independent samples t-test 
  t.test(age_today ~ status, data = Datos)


# Years of education by status------------------------------------------------------

  #Mean and SD of controls
  summary(Datos %>% 
            select(status,total_years_education) %>%
            filter(status %in% c("1"))) #Mean
  
  Datos %>%
    filter(status %in% c("2")) %>% 
    pull(total_years_education) %>% 
    sd(na.rm = TRUE) #SD
  
  #Mean and SD of PD Patients
  
  summary(Datos %>% 
            select(status,total_years_education) %>%
            filter(status %in% c("2")))   #Mean
  
  Datos %>% 
    filter(status %in% c("2")) %>%  
    pull(total_years_education) %>%                    
    sd(na.rm = TRUE)  #SD

  #Independent samples t-test 
  t.test(total_years_education ~ status, data = Datos)


# Head injury or concussion by status -------------------------------------
  #Explicar que nos quedamos sólo con los que tenían certeza de haber tenido un TC 
  #Explicar que los pacientes se redujeron debido a que algunos reportaron el TC después de la EP
  
  #The question assessing whether you have had a head injury or concussion had four response options,
  #due to the objective of this work we only used the Yes and No answers.

 #Frequency of Head injury or concussion in controls
  Ctr_HI <- Datos %>% 
    filter(status %in% c("1")) %>%
    filter(have_you_ever_had_a_head_i %in% c("1","3"))%>%
    count(have_you_ever_had_a_head_i)
  
  #To determine the frequency of head trauma or concussion in PD patients, 
  #we first filtered the data to ensure that we only counted PD patients who had 
  #a concussion before the PD diagnosis and excluded those who had a concussion after 
  #the diagnosis, thereby avoiding this confounding factor.
  
  
  #Frequency of Head injury or concussion in PD patients
  
PD_HI_yes<-  Datos %>% 
    filter(status %in% c("2")) %>%
    filter(have_you_ever_had_a_head_i %in% c("1"))%>%
    filter(at_what_age_HI < age_at_first_diagnosis) %>% # Filter only those who suffered injuries before diagnosis
    count(have_you_ever_had_a_head_i)

#Frequency of absence of Head injury or concussion in PD patients
  #We first checked and saved the frequency of those who answered No.
  
 PD_HI_no_r <- Datos %>% 
    filter(status %in% c("2")) %>%
    filter(have_you_ever_had_a_head_i %in% c("3"))%>%
    count(have_you_ever_had_a_head_i)
  
  #Then we sum the number of people who answer Yes, but have the concussion after 
  #the diagnosis, because they did not have a concussion before the PD diagnosis
  
  
  PD_HI_no <- Datos %>%  
    filter(status %in% c("2")) %>%
    filter(have_you_ever_had_a_head_i %in% c("1"))%>%
    count(have_you_ever_had_a_head_i) %>%   
    - PD_HI_yes$n %>%  # Subtract the number of those who answered yes before the PD diagnosis from the total number of those who answered yes.
    + PD_HI_no_r$n #Sum the number of people that did not have the HI before the PD diagnosis, It give us the final number 
     
  #Contigency table to Chi square analysis 
  
  Chi_HI <- data.frame(
    Control = c(Ctr_HI$n),
    Patient = c(PD_HI_yes$n,PD_HI_no$n))
  
  Chi_HI  
  
  #Chi-square analysis of frequencies between controls and PD patients by Head injury presence
  
  chisq.test(Chi_HI)
  
     
     