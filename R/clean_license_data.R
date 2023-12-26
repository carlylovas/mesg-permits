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


# Before I create the portfolio, I need to combine license types with multiple codes 
# making plot labels
license_types %>% 
  mutate(description = tolower(description)) %>%
  group_by(description) %>% 
  nest() %>%
  mutate(count = map_dbl(data, function(x){nrow(x)})) -> plot_labels

plot_labels %>%
  filter(!description %in% c("scallop diver", "scallop dragger")) %>%
  filter(count == "2") %>%
  mutate(recent = map(data, function(df){df %>% rowid_to_column() %>% filter(rowid == "2") %>% select(license_type)})) %>% 
  unnest(recent) %>%
  select(description, license_type) -> dup_codes

plot_labels %>%
  select(description) %>% 
  filter(description == "scallop diver") %>%
  mutate(license_type = "sdi") %>%
  full_join(plot_labels %>%
              select(description) %>% 
              filter(description == "scallop dragger") %>%
              mutate(license_type = "sb")) -> scallop_labels 

plot_labels %>% 
  filter(!count == "2") %>% 
  unnest(data) %>% 
  select(description, license_type) %>%
  full_join(dup_codes) %>%
  full_join(scallop_labels) %>%
  arrange(description) %>%
  drop_na()-> plot_labels

write_csv(plot_labels, file = here("Data", "cleaned_data_labels.csv"))

# created group portfolio
grouped_license_portfolio <- clean_license_data %>%
  mutate(licensed =1 , 
         row = row_number())%>% 
  ungroup(license_type) %>%
  select(landings_number,license_year,description,licensed,row)%>%
  left_join(plot_labels) %>%
  pivot_wider(names_from=license_type,values_from=licensed,names_expand=TRUE,values_fill = list(licensed=0))%>%
  select(-row) %>%
  select(-description) %>%
  group_by(landings_number,license_year)%>%
  summarise(across(everything(),sum))

# save out as rds 
write_rds(grouped_license_portfolio, file = paste(here("Data", "portfolio_by_lic_description.rds")))
