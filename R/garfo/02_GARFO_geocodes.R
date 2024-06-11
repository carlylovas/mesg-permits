# GARFO spell correcting and geocoding 

library(here)
library(tidyverse)
library(gmRi)
# install.packages("tidygeocoder")
library(tidygeocoder)

garfo_portfolio_all <- read.csv(here("Data", "all_GARFO_data.csv"))

## geocode by state and group back together (slow)
garfo_portfolio_all %>%
  filter(PPST == "ME") %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_me

garfo_portfolio_all %>%
  filter(PPST == "NH") %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_nh

garfo_portfolio_all %>%
  filter(PPST == "MA") %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_ma

garfo_portfolio_all %>%
  filter(PPST %in%  c("CT", "RI")) %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_ct_ri

##### Run independently (I forgot they existed), join to later dataframes 

# garfo_portfolio_all %>%
#   filter(PPST %in%  c("NY", "NJ")) %>%
#   ungroup() %>%
#   select(PPORT, PPST) %>%
#   distinct()  %>%
#   arrange(PPST) %>%
#   geocode(., city = PPORT, state = PPST)-> geo_ny_nj

######
garfo_portfolio_all %>%
  filter(PPST %in%  c("MD", "DE")) %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_md_de

garfo_portfolio_all %>%
  filter(PPST == "VA") %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_va

garfo_portfolio_all %>%
  filter(PPST == "NC") %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> geo_nc

geo_codes <- geo_me %>%
  full_join(geo_nh) %>%
  full_join(geo_ma) %>%
  full_join(geo_ct_ri) %>%
  full_join(geo_md_de) %>%
  full_join(geo_va) %>%
  full_join(geo_nc)

# Save out 
write_csv(geo_codes, file = here("Data", "geo_code_v1.csv"))