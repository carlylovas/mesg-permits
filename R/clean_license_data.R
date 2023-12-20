## Cleaning the license data 
# load libraries
library(tidyverse)
library(gmRi)
library(here)

# set path
path <- here()

# read in data  
license_types <- read.csv(paste0(path, "/Data/updated_license_codes.csv")) %>% rename("license_type" = "code") %>%
  mutate(description = tolower(description))
me_all_lics_1990_2022_tidy <- read_csv((paste0(path, "/Data/me_all_lics_1990_2022_tidy.csv")))

# combine update license types with all license data
me_all_lics_1990_2022_tidy %>%
  group_by(license_type) %>% 
  nest() %>% 
  left_join(license_types) -> clean_license_data

# remove indigenous and non-harvester license
clean_license_data %>% 
  filter(!group %in% c("Demo", "Post-Harvest", "Non-resident")) %>%
  filter(!(str_starts(license_type, "ma"))) %>%
  filter(!(str_starts(license_type, "mi"))) %>%
  filter(!(str_starts(license_type, "nb"))) %>%
  filter(!(str_starts(license_type, "p")))  %>% 
  filter(!(str_starts(description, "recreational")))  %>%
  drop_na() %>% 
  # filter(!license_type %in% c("car", "dl", "r", "re", "sdt", "suwt", "swr", "swrs", "swro", 
  #                     "ten", "w", "wl", "wls", "ws", "lpl", "lpto", "lt", "lts",
  #                     "ed", "eds", "lmp", "mw", "mws", "st","sts", "sut", "vh")) %>%
  # filter(!group %in% c("Demo", "Post-Harvest", "Non-resident")) %>%
  #select(license_type, description) %>%
  unnest(data) -> clean_license_data
# 
# # Make binary matrix using descriptions instead of code names 
# me_all_lics_1990_2022_tidy %>%
#   #filter(license_type %in% clean_license_data$license_type) %>%
#   full_join(clean_license_data) %>%
#   #relocate(group, .after = license_type) %>% 
#   relocate(description, .after = license_type) -> license_by_description

grouped_license_portfolio <- clean_license_data %>%
  mutate(licensed =1 , 
         row = row_number())%>% 
  ungroup(license_type) %>%
  select(landings_number,license_year,description,licensed,row)%>% 
  pivot_wider(names_from=description,values_from=licensed,names_expand=TRUE,values_fill = list(licensed=0))%>%
  select(-row)%>%
  group_by(landings_number,license_year)%>%
  summarise(across(everything(),sum))

# save out as rds 
write_rds(grouped_license_portfolio, file = paste(here("Data", "portfolio_by_lic_description.rds")))
