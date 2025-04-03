#Select wd 
wd <- "/MEXPD_paper/"
setwd(wd)

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Load the data
freqs <- read.csv("all_freqs_results.csv", header = TRUE, sep = ",") #This contains the results from assoc in PLINK
selected_SNPs <- read.table("selected_SNPs.txt", header = FALSE, stringsAsFactors = FALSE) #Here is a list of SNPs you want to plot

# Rename the column to match the SNP column in freqs
colnames(selected_SNPs) <- c("SNP")
colnames(freqs)[colnames(freqs) == "F_A"] <- "PD_cases"
colnames(freqs)[colnames(freqs) == "F_U"] <- "Controls"

# Filter the freqs data to keep only those SNPs that are in the selected_SNPs list
filtered_freqs <- freqs %>% filter(SNP %in% selected_SNPs$SNP)

# Filter the data to include only specified populations
filtered_freqs <- filtered_freqs %>% filter(POPULATION %in% c("AMR", "EUR", "AFR", ""))

filtered_freqs$Controls <- as.numeric(filtered_freqs$Controls)


filtered_freqs$COH_POP <- paste(filtered_freqs$COHORT,filtered_freqs$POPULATION)

# Display the first few rows of the filtered data
head(filtered_freqs)

# Reshape the data for easier plotting
filtered_freqs_long <- filtered_freqs %>%
  pivot_longer(cols = c(PD_cases, Controls), names_to = "Type", values_to = "Frequency")

# Define color mapping
colors <- c('GP2 EUR' = 'red', 'GP2 AMR' = 'maroon3', 'GP2 AFR' = 'blue', "MEX-PD " = "#c7417b")

#FUNCTION TO PLOT EACH SNP 
plot_snp_frequencies <- function(snp_data) {
  snp <- unique(snp_data$SNP)
  ggplot(snp_data, aes(x = COHORT, y = Frequency, fill = COH_POP)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6, alpha = 0.5) +  
    labs(title = paste("", snp)) +
    facet_wrap(~ Type) +
    theme_minimal() +
    scale_fill_manual(values = colors) +
    ylim(0, 0.6) +
    theme (
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_blank(),  # Remove minor grid lines
      panel.background = element_blank(),  # Remove background
      plot.background = element_blank()    # Remove plot background
    )
  }


# Apply the function to each SNP and store the plots
snps <- unique(filtered_freqs_long$SNP)
plots <- lapply(snps, function(snp) {
  snp_data <- filtered_freqs_long %>% filter(SNP == snp)
  plot_snp_frequencies(snp_data)
})

# Combine all plots into one figure, with a shared legend
combined_plots <- do.call(grid.arrange, c(plots, ncol = 1, top = "SNP Frequencies Across Cohorts"))

# Extract the legend
get_legend <- function(myplot) {
  tmp <- ggplot_gtable(ggplot_build(myplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(plots[[1]])

# Remove legends from individual plots
plots <- lapply(plots, function(plot) plot + theme(legend.position = "none"))

# Create a dummy plot for the empty slot
empty_plot <- ggplot() + theme_void()

# Combine all plots into a 4x3 grid
combined_plots <- grid.arrange(
  grobs = plots,
  ncol = 4,
  nrow = 3,
  top = "SNP Frequencies Across Cohorts and Populations"
)

# Extract the legend from one of the plots
legend <- get_legend(plots[[1]])

# Remove legends from individual plots
plots <- lapply(plots, function(plot) plot + theme(legend.position = "none"))

# Combine plots without legends and add the shared legend
combined_with_legend <- arrangeGrob(
  combined_plots,
  legend,
  ncol = 4,
  heights = c(4, 3)  # Adjust heights as necessary
)