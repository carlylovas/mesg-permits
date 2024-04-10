# Cleaning data to final stage for use
## Load libraries and data
library(here) 
library(tidyverse)
library(gmRi)

geo_codes  <- read.csv(here("Data", " geo_code_v1.csv"))
garfo_all  <- read.csv(here("Data", "all_GARFO_data.csv")) %>% select(!X)
typos      <- read_csv(file = here("Data", "port_typos.csv"))
port_codes <- read_csv(file = here("Data", "ports.geocoded.csv")) %>% 
  select(PORT, STATE, QUERY, lon, lat)


## filter out available geo-coded ports (spelled correctly)
geo_codes %>% 
  filter(!is.na(lat)) %>%
  select(!X) %>% 
  left_join(garfo_all) %>%
  arrange(AP_YEAR) -> clean_ports

## filter out typos
### by city typos first
typos %>% 
  filter(!is.na(PPORT_CORRECTED)) %>%
  filter(!PPORT_CORRECTED %in% c("MENEMSHA", "DENNIS", "WELLFLEET")) %>%
  select(!PPST_CORRECTED) %>% 
  left_join(garfo_all) %>% 
  select(!PPORT) %>% 
  rename("PPORT" = "PPORT_CORRECTED") %>%
  relocate("PPORT", .before = "PPST") -> x

### then by state
typos %>% 
  filter(!is.na(PPST_CORRECTED)) %>% 
  filter(!PPORT_CORRECTED %in% c("MENEMSHA", "DENNIS", "WELLFLEET")) %>%
  select(!PPORT_CORRECTED) %>%
  left_join(garfo_all) %>% 
  select(!PPST) %>% 
  rename("PPST" = "PPST_CORRECTED") -> y 

### grab menemsha & dennis (pport_corrected)
typos %>% 
  filter(PPORT_CORRECTED %in% c("MENEMSHA", "DENNIS", "WELLFLEET")) %>% 
  drop_na() %>%
  left_join(garfo_all) %>% 
  select(!c(PPORT, PPST)) %>% 
  rename("PPORT" = "PPORT_CORRECTED",
         "PPST"  = "PPST_CORRECTED") -> z

## combine
corrected_ports <- x %>% full_join(y) %>% full_join(z) # need to be geocoded 
corrected_ports <- geocode(corrected_ports, city = PPORT, state = PPST)

corrected_ports %>% 
  filter(is.na(lat)) %>% 
  select(PPORT, PPST) %>% 
  distinct() -> missing
  
## Combine clean with corrected
clean_ports %>% 
  full_join(corrected_ports %>% relocate("lat", .after = "PPST") %>% relocate("long", .after = "lat")) -> all_geocodes # still missing some (garfo_all = 146787 rows, this has 118360 rows)

# Save out for geospatial analyses
write.csv(all_geocodes, file = here("Outputs", "GARFO_geocoded.csv"))
