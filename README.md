# Clinical and Genetic Insights of Parkinson's Disease in a Mexican Cohort (MEX-PD): Highlighting Latino's Diversity

`GP2 ❤️ Open Science 😍`

[DOI pending]

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Last Updated:** April 2025

## Summary
This repository contains the code and data analysis pipelines used in our manuscript **"Clinical and Genetic Insights of Parkinson's Disease in a Mexican Cohort: Highlighting Latino's Diversity"**. Our study provides a comprehensive look at both clinical and genetic factors contributing to Parkinson's Disease (PD) in a diverse Latino population

## Citation
If you use this repository or find it helpful for your research, please cite the corresponding manuscript:

> Clinical and Genetic Insights of Parkinson's Disease in a Mexican Cohort: Highlighting Latino's Diversity
Lázaro-Figueroa A., Reyes-Pérez P., Morelos-Figaredo E., Guerra-Galicia C.M., Estrada-Bellmanne I., Salinas-Barboza K., Matuk-Pérez Y.,Gandarilla-Martínez N.A., Oropeza D., Caballero-Sánchez U.,Montés-Alcántara P., López-Pintor A., Angulo-Arrieta A.P., Flores-Ocampo V., Espinosa-Méndez I.M., Zayas-Del Moral A., Gaspar-Martínez E., Vazquez-Guevara D., Rodríguez-Violante M., Waldor E., Leal T., Inca-Martinez M., Mata I., Alcauter S.*, Renteríal M.E., Medina-Rivera A., Ruiz-Contrerasa A.E. and on behalf of the Mexican Parkinson’s Research Network (MEX-PD) and the Latin American Research Consortium on the Genetics of Parkinson’s Disease (LARGE-PD)



>> Manuscript DOI: coming soon
>> 
>> GitHub DOI: DOI coming soon

### Data Statement 
* All GP2 data are hosted in collaboration with the Accelerating Medicines Partnership in Parkinson's Disease (AMP-PD) and are available via application on the website. The GP2 PD case and control data are available via the GP2 analysis platform (https://gp2.org; release 9: 10.5281/zenodo.14510099). 
* Genotyping imputation, quality control, ancestry prediction, and processing were performed using GenoTools (v1.0.0), publicly available on GitHub


## Workflow

1. Quality control (QC) pipeline: https://github.com/MataLabCCF/GWASQC
* 1.1 Sample Missing Data: Samples with more than 5% missing data was excluded
* 1.2  Variant Missing Data: Variants with more than 5% missing data were excluded
* 1.3 Heterozygosity Deviation: Samples deviating from the expected heterozygosity by more than 3 standard
* 1.4 HWE in Controls: Variants in control samples with p-values below 1e-6 for HWE were excluded
* 1.5 HWE in Cases: Variants in case samples with p-values below 1e-10 for HWE will be excluded.
* 1.6 Relationship Control: Related samples with a kinship coefficient > 0.0884 (equivalent to second-degree relatives) were removed.
* 1.7 Sex-Check:
    * Females should have F-statistic < 0.5
    * Males should have F-statistic > 0.8
* 1.8 Removal of Redundant Variants: Variants that are A/T or C/G were removed due to the risk of strand bias
* 1.9 Duplicate Variants: Duplicate variants are identified, and the one with the least missing data is retained.
2. xx
3. xx
4. xx

# Repository Orientation 
- The `analyses/` directory includes all analyses discussed in the manuscript

```
analyses/
├── 00_Lazaro2024etal_GP2examplenotebook.ipynb
├── 01_Lazaro2024_create_freq_plots.R
├── 02_Lazaro2024etal_Table1.R
├── 03_Lazaro2024etal_Table2.R
├── 04_Lazaro2024etal_Figure1.R
└── 05_Lazaro2024etal_Figure2.R
```

---
### Analysis Notebooks
* Languages: Python, bash, and R

| **Notebooks  / Scripts**            | **Description**                                                                            |
|:-----------------------------------:|:------------------------------------------------------------:|
| `00_Lazaro2024etal_GP2examplenotebook.ipynb`       | Jupyter Notebook demonstrating the genetic analysis of the AMR population from GP2 data (also applies to other ancestries and the MEX-PD cohort) |
| `01_Lazaro2024_create_freq_plots.R`       | Creates bar plots showing the frequency of selected SNPs across different cohorts and populations |
| `02_Lazaro2024etal_Table1.R`        | Contains data manipulation, as well as descriptive and inferential analysis for Table 1                  |
| `03_Lazaro2024etal_Table2.R`        | Contains data manipulation, as well as descriptive and inferential analysis for Table 2 |
| `04_Lazaro2024etal_Figure1.R`       | Manipulates data and creates maps of Mexico showing registry frequencies |
| `05_Lazaro2024etal_Figure2.R`       | Manipulates data and creates figures for clinical assessments |

---

## Software

| **Software**                             | **Version(s)** | **Resource URL**                                    | **RRID**         | **Notes**                                                                                                                                                                                    |
|:----------------------------------------:|:--------------:|:---------------------------------------------------:|:----------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| R Project for Statistical Computing      | 4.3.0          | [http://www.r-project.org/](http://www.r-project.org/) | RRID:SCR_001905  | **Packages used:**<br/>- tidyverse; dplyr; tidyr; ggplot; sf (for maps)<br/>- stringr (general data)<br/>- scales (bar plots)                                                              |
| PLINK                                    | 1.9 and 2.0    | [http://www.nitrc.org/projects/plink](http://www.nitrc.org/projects/plink) | RRID:SCR_001757  | Used for genetic analyses     
