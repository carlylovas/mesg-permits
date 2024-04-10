# Compiling GARFO data
## load libraries
library(here)
library(tidyverse)
library(gmRi)
library(readxl)

## Data was sent as excel files 
box_path <- "/Users/clovas/Library/CloudStorage/Box-Box/Mills Lab/Projects/MESG-permits/"
garfo_data_path <- paste0(box_path, "Git/Permits_MESG/GARFO/")

read_xl_files <- function(file_name){
  out <- read_excel(paste0(file_name))
  return(out)
}

all_garfo_data <- tibble("File_Path" = list.files(garfo_data_path, pattern = ".xlsx", full.names = TRUE)) %>% 
  mutate(., "Data" = map(File_Path, read_xl_files)) %>% 
  unnest(Data) %>% 
  select(!File_Path)

## Breaking up license types into individual columns
garfo <- all_garfo_data %>%
  select(AP_NUM, VP_NUM, AP_YEAR, PPORT, PPST, BLACK_SEA_BASS:TILEFISH)

garfo %>%
  pivot_longer(cols = BLACK_SEA_BASS:TILEFISH, names_to = "TARGET_SPECIES", values_to = "PERMIT_CATEGORY", values_drop_na = TRUE) %>%
  separate(PERMIT_CATEGORY, c("a","b", "c", "d", "e", "f", "g", "h", "i", "j"), sep = ",") %>%
  pivot_longer(cols = a:j, names_to = "cols", values_to = "CATEGORY", values_drop_na = TRUE) %>%
  select(!cols) %>%
  mutate(COUNT = 1,
         LICENSE = paste(TARGET_SPECIES, CATEGORY, sep = "_"),
         ROW = row_number()) %>%
  select(!c(TARGET_SPECIES, CATEGORY)) %>%
  arrange(LICENSE) %>%
  group_by(AP_NUM) %>%
  pivot_wider(names_from = LICENSE, values_from = COUNT, names_expand=TRUE,values_fill = list(COUNT = 0)) %>%
  select(!ROW) %>%
  arrange(AP_YEAR) %>%
  group_by(AP_NUM, AP_YEAR, VP_NUM, PPORT, PPST)%>%
  summarise(across(everything(),sum)) -> garfo_portfolio_all


## Save out 
write.csv(garfo_portfolio_all, file = "Data/all_GARFO_data.csv")
