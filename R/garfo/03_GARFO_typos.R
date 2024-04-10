# Isolating and correcting principal port typos to properly geocode

library(here)
library(tidyverse)
library(gmRi)
# install.packages("tidygeocoder")
library(tidygeocoder)

## Read in currently geocoded ports
all_garfo_data <- read.csv(file = here("Data", "all_GARFO_data.csv"))
geo_codes <- read.csv(file = here("Data", " geo_code_v1.csv"))
all_ports <- read_csv(file = here("Data", "ports.geocoded.csv")) %>% 
  select(PORT, STATE, QUERY, lon, lat)

## pull out NA's (misspelled ports) from geo_codes
typos <- geo_codes %>%
  filter(is.na(lat)) %>%
  unite(PPORT, PPST, col = "PORT", sep = ", ")

all_garfo_data %>%
  ungroup() %>%
  unite(PPORT, PPST, col = "PORT", sep = ", ") %>%
  filter(PORT %in% typos$PORT) %>%
  arrange(PORT) %>%
  select(AP_NUM, PORT) %>%
  distinct() -> weirdos

weirdos %>% 
  select(PORT) %>% 
  rename("QUERY" = "PORT") %>%
  full_join(all_ports) %>% 
  drop_na() %>%
  distinct() -> geo_codes_corrected # dropping NA's removes misspelled ports, will need to revisit typos

geo_codes_corrected %>% 
  rename("PPORT" = "PORT",
         "PPST"  = "STATE",
         "long"  = "lon") %>%
  full_join(geo_codes %>% drop_na()) %>%
  select(PPORT, PPST, long, lat) -> geo_codes_corrected

all_garfo_data %>%
  filter(PPST %in% c("ME", "NH", "MA", "CT", "RI", "DE", "MD", "VA", "NC")) %>%
  pivot_longer(cols = BLACK_SEA_BASS_1:TILEFISH_D, names_to = "LICENSE", values_to = "COUNT") %>%
  filter(!COUNT == 0) %>%
  group_by(VP_NUM, LICENSE) %>%
  left_join(geo_codes_corrected) -> updated_vessel_geocodes

updated_vessel_geocodes %>%
  ungroup() %>%
  filter(is.na(lat)) %>%
  select(PPORT, PPST) %>%
  distinct() -> typos_v2

# write_csv(typos_v2, file = here("Data", "port_typos.csv")) # don't run, will overwrite manually corrected ports 

# read back in spell-corrected 
typos_v3 <- read_csv(file = here("Data", "port_typos.csv"))

