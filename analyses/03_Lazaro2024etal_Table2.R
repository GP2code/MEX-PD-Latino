
# Script used to report Table 2 Information.
#Clinical characteristics of the whole PD patient’s sample and the comparison as a function of the age of onset of PD. 

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

# Categorization of Early Onset Parkinson Disease (EOPD) and Late Onset Parkinson Disease (LOPD)  ------------------------------------------
#If the age at diagnosis were less than 50 years were EOPD, if were 50 or more years were LOPD 

Datos <-  Datos %>%  
  mutate(Grupo_EdadInicio = case_when(mexico_code == "UMP" & (age_at_first_diagnosis <= 49) ~ "EOPD",
                                      mexico_code == "UMP" & (age_at_first_diagnosis >= 50) ~ "LOPD"))

unique(Datos$Grupo_EdadInicio)

Datos <- Datos %>%  
  mutate(status = case_when(status == "Control"  ~ "1",
                            status == "Paciente" ~ "2"))

#N EOPS vs LOPD

EOPD <- Datos %>% 
  filter(Grupo_EdadInicio %in% c("EOPD")) %>% #Keep only EOPD patients
  count(Grupo_EdadInicio) #N of EOPD and LOPD


LOPD <- Datos %>% 
  filter(Grupo_EdadInicio == "LOPD") %>% #Keep only LOPD patients
  count(Grupo_EdadInicio) #N of LOPD

#Contigency table to Chi square analysis 

PD_Onset <- data.frame(
  EOPD = c(EOPD$n),
  LOPD = c(LOPD$n))

PD_Onset

#Chi-square analysis of frequencies between EOPD and LOPD

chisq.test(PD_Onset)


# Age at PD onset -----------------------------------------------------

#Mean
mean(Datos$age_at_first_diagnosis, na.rm = TRUE)

#Standar deviation 
sd(Datos$age_at_first_diagnosis, na.rm = TRUE)

#Age at PD onset between EOPD and LOPD

  #EOPD
  #Mean
  Datos %>% 
   filter(Grupo_EdadInicio %in% c("EOPD")) %>% 
    pull(age_at_first_diagnosis) %>% 
    mean(na.rm = TRUE)

  #Standar deviation 
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("EOPD")) %>% 
   pull(age_at_first_diagnosis) %>% 
    sd(na.rm = TRUE)
  
  #LOPD
  #Mean
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("LOPD")) %>% 
    pull(age_at_first_diagnosis) %>% 
    mean(na.rm = TRUE)
  
  #Standar deviation 
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("LOPD")) %>% 
    pull(age_at_first_diagnosis) %>% 
    sd(na.rm = TRUE)
  

# Disease duration (years) ------------------------------------------------
  
  #All PD sample
  #Mean
  mean(Datos$Years_with_Diagnosis, na.rm = TRUE)
  
  #Standar deviation 
  sd(Datos$Years_with_Diagnosis,na.rm = TRUE)
  
  #EOPD vs LOPD
  
  library(car) #Library used for the Homogeneity of Variance test
  
  #Levene's Test for Homogeneity of Variance between EOPD vs LOPD
  leveneTest(Years_with_Diagnosis ~ Grupo_EdadInicio, data = Datos)
  
  # Shapiro-Wilk normality test
  shapiro.test(Datos$Years_with_Diagnosis[Datos$Grupo_EdadInicio == "EOPD"])
  shapiro.test(Datos$Years_with_Diagnosis[Datos$Grupo_EdadInicio == "LOPD"])
  
  #As the Homogenity of variance and normality were significant we made a Mann-Whitney U test
  
  #EOPD
  #Median and Min-Max
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("EOPD")) %>% 
    pull(Years_with_Diagnosis) %>% 
    summary(na.rm = TRUE)
  
  #LOPD
  #Median and Min-Max
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("LOPD")) %>% 
    pull(Years_with_Diagnosis) %>% 
    summary(na.rm = TRUE)
  
  #Mann-Whitney U test to compare disease duration by age at onset

  wilcox.test(Years_with_Diagnosis ~ Grupo_EdadInicio, data = Datos, exact = FALSE)
  

# Hoehn and Yahr stage ----------------------------------------------------
 
  #All sample 
   #Median 
  summary(Datos$hoehnyahr_scale, na.rm=TRUE)
  
  
  #EOPD
  #Median 
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("EOPD")) %>% 
    pull(hoehnyahr_scale) %>% 
    summary(na.rm = TRUE)
  
  #LOPD
  #Median 
  Datos %>% 
    filter(Grupo_EdadInicio %in% c("LOPD")) %>% 
    pull(hoehnyahr_scale) %>% 
    summary(na.rm = TRUE)
  
  #Correlation between years of diagnosis and Hoehn and Yahr stage 
  
  cor.test(Datos$Years_with_Diagnosis, Datos$hoehnyahr_scale,
           method = "spearman",exact=FALSE)


# Pharmacological treatment -----------------------------------------------

  #All PD sample 
  #N
    Datos %>% 
    filter(status == "2") %>% 
    filter(Treatment != "") %>% 
    count(Treatment)
  
  #Chi-square analysis of frequencies of pharmacological treatment in all PD sample
  chisq.test(table(na.omit(Datos$Treatment)))
  
  #Pharmacological treatment between EOPD and LOPD
  #N
  Datos %>% 
    filter(status == "2") %>% 
    select(Treatment, Grupo_EdadInicio) %>%
    filter(Treatment != "") %>% 
    filter( !is.na(Grupo_EdadInicio)) %>% 
    count(Treatment,Grupo_EdadInicio)

  #Chi-square analysis of frequencies of pharmacological treatment between EOPD and LOPD
  
  #Dopamine agonist therapy (DA)
    DA <- Datos%>% 
      filter(status == "2") %>% 
      select(Treatment, Grupo_EdadInicio) %>%
      filter(Treatment == "Dopaminergic Agonists") %>% 
      filter( !is.na(Grupo_EdadInicio))%>% 
      count(Grupo_EdadInicio)
  #Chi-square analysis
    chisq.test(DA$n)

  
  #Levodopa
    Levo <- Datos%>% 
      filter(status == "2") %>% 
      select(Treatment, Grupo_EdadInicio) %>%
      filter(Treatment == "Levodopa") %>% 
      filter(Grupo_EdadInicio!= "")%>% 
      count(Grupo_EdadInicio)
    
    #Chi-square analysis
    chisq.test(Levo$n)
    
    
    #Dopamine agonist and Levodopa
    DA_LEV <- Datos%>% 
      filter(status == "2") %>% 
      select(Treatment, Grupo_EdadInicio) %>%
      filter(Treatment == "DA & Levodopa") %>% 
      filter(Grupo_EdadInicio!= "")%>% 
      count(Grupo_EdadInicio)
    
    #Chi-square analysis
    chisq.test(DA_LEV$n)

    

# Initial Motor Symptoms  ---------------------------------------------------------

    #All PD sample 
    #N
    Datos %>% 
      filter(status == "2") %>% 
      filter(Sint_mot_n!= "")%>% 
      count(Sint_mot_n)    

    #Initial Motor Symptoms between EOPD and LOPD
    #N
    #EOPD
    Datos %>% 
      filter(status == "2") %>% 
      filter(Sint_mot_n!= "")%>%
      filter(Grupo_EdadInicio == "EOPD") %>% 
      count(Sint_mot_n)
    
    #LOPD
    Datos %>% 
      filter(status == "2") %>% 
      filter(Sint_mot_n!= "")%>%
      filter(Grupo_EdadInicio == "LOPD") %>% 
      count(Sint_mot_n)

  #Chi-square analysis of frequencies of Initial Motor Symptoms between EOPD and LOPD
    
    #Tremor
   Trem <- Datos %>% 
      filter(Sint_mot_n == "Tremor") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)

   #Chi-square analysis
    chisq.test(Trem$n)    
    
    #Rigidity
    Rig <- Datos %>% 
      filter(Sint_mot_n == "Rigidity") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)
    
    #Chi-square analysis
    chisq.test(Rig$n) 
    
    #Bradykinesia
    Brady <- Datos %>% 
      filter(Sint_mot_n == "Bradykinesia") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)
    
    #Chi-square analysis
    chisq.test(Brady$n)
    
    #Bradykinesia, rigidity and tremor 
    BRT <- Datos %>% 
      filter(Sint_mot_n == "Bradykinesia, rigidity and tremor") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)
    
    #Chi-square analysis
    chisq.test(BRT$n)
    
    #Bradykinesia, rigidity, postural inst and tremor 
    BRPT <- Datos %>% 
      filter(Sint_mot_n == "Bradykinesia, rigidity, postural inst and tremor") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)
    
    #Chi-square analysis
    chisq.test(BRPT$n)
    
    #Other 
    Other <- Datos %>% 
      filter(Sint_mot_n == "Other") %>% 
      filter(Grupo_EdadInicio != "")%>%
      count(Grupo_EdadInicio,Sint_mot_n)
    
    #Chi-square analysis
    chisq.test(Other$n)

    

# Association between pharma treatments and group age -----------------------------------------

    
    #There was an association between the most common pharmacological treatments in the sample (DA, DA+Levodopa and Levodopa alone) and etarian group (p=0.002; Figure 2.A). 

    #N of the samples to each group of age
    #46-55 years 
    g46_55 <- Datos %>% 
                 filter(Treatment != "")%>%
                 filter(Grupos_edad == "46-55") %>% 
                count(Treatment)
    g46_55
    
    #56-65 years 
    g56_65 <- Datos %>% 
      filter(Treatment != "")%>% 
      filter(Treatment != "")%>% 
                 filter(Grupos_edad == "56-65") %>% 
                 count(Treatment)
    
    g56_65
    
    
    #66-75 years
    g66_75 <- Datos %>% 
      filter(Treatment != "")%>%
                 filter(Grupos_edad == "66-75") %>% 
                 count(Treatment)
    
    g66_75
    
    #76 years or more
    mas76 <- Datos %>% 
      filter(Treatment != "")%>%
                filter(Grupos_edad == "76 or more") %>% 
                count(Treatment)
    
    mas76
    
    
    Treatm_age <- bind_cols("46-55" = g46_55$n, "56-65" =g56_65$n, "66-75"=g66_75$n, "76 or more" = mas76$n)
    Treatm_age
    
    #We remove the rows of the treatments that do not meet the minimum of 5 observations per group, 
    #(Dopaminergic Agonists and Other) in order to perform the Chi square analysis.
    
    Treatm_age <-  
      Treatm_age %>% slice(-c(2,4))
    
    chisq.test(Treatm_age)
    
    install.packages("rcompanion")
    
    # Load the package
    library(rcompanion)
    
    cramerV(Datos$Grupos_edad, Datos$Treatment)
    
  

# Pharmacological treatment and severity  ---------------------------------

      
    #Additionally, we analyzed the association between the type of pharmacological treatment and disease severity, but no significant association was found (p= 0.65; Figure 2.B).
    Datos$Severity
    
    Sev_low <- Datos %>% 
      filter(Treatment != "")%>%
      filter(Severity == "≤ 2") %>% 
      count(Treatment,Severity)
    
    Sev_low
    
    Sev_hi <- Datos %>% 
      filter(Treatment != "")%>%
      filter(Severity == "≥ 3") %>% 
      count(Treatment,Severity)
    
    Sev_hi

    
    Treat_sev <- data.frame(
      Low = c(Sev_hi$n),
      High = c(Sev_low$n))
    
    Treat_sev
    
    #We remove the rows of the treatments that do not meet the minimum of 5 observations per group, 
    #(Dopaminergic Agonists and Other) in order to perform the Chi square analysis.
    Treatm_sev <-  
      Treat_sev %>% slice(-c(2,4))
    
    chisq.test(Treatm_sev)
    
    

# Localization of motor symptoms  ----------------------------------------
    
    # "Loc" is the name of the data frame 
    
    Loc <- read.csv("D:/scripts/Localizacion_sint.csv")
    
    Loc <- na.omit(Loc)
    
   #N of Localization of each motor symptoms
    
    Loc <- Loc %>% 
      count(Localization)
    
    #Chi-square analysis between the frequency of the localization of motor symptoms 
     chisq.test(Loc$n)  
    
    #The majority (47.4%) of the patients were diagnosed the same year that the motor symptoms began (p<0.001), while 33.8% were diagnosed between the first and second year
    

# Delay in the diagnosis  -------------------------------------------------

     #To calculate the delay in the diagnosis we make other column called "Delay_Diagn"
     
     Datos <- Datos %>% 
       mutate(Delay_Diagn = age_at_first_diagnosis-age_at_onset_parkinsonian_motor_symptom)
  
     #Transform the years of delay in the diagnosis into a categorical variable 
     
     Datos <- Datos %>% 
       mutate(Delay_Diagn=case_when(Delay_Diagn < 0  ~ "NA",
                                    between(Delay_Diagn, 0,0) ~ "0",
                                    between(Delay_Diagn, 1, 2) ~ "1-2",
                                    between(Delay_Diagn, 3, 4) ~ "3-4",
                                    Delay_Diagn > 5 ~ "5 or more"))
     
     #Frequency 
     
     Delay <- Datos %>% 
       count(Delay_Diagn)
     
     Delay <- Delay %>% 
       filter(!is.na(Delay_Diagn)) %>% 
       filter(Delay_Diagn != "NA")
     
     Delay 
       
     #Chi-square analysis 
     chisq.test(Delay$n)
     
     
    
    
    
    
    