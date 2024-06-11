# GARFO spell correcting and geocoding for NY/NJ

library(here)
library(tidyverse)
library(gmRi)
# install.packages("tidygeocoder")
library(tidygeocoder)

garfo_portfolio_all <- read.csv(here("Data", "all_GARFO_data.csv"))

garfo_portfolio_all %>%
  filter(PPST %in%  c("NY", "NJ")) %>%
  ungroup() %>%
  select(PPORT, PPST) %>%
  distinct()  %>%
  arrange(PPST) %>%
  geocode(., city = PPORT, state = PPST)-> ny_nj

ny_nj %>%
  filter(is.na(lat)) -> geo_ny_nj

## Trying to streamline the manual revisions
geo_ny_nj %>%
  unite(PPORT, PPST, col = "PORT", sep = ", ") %>%
  select(!c(lat, long)) %>%
  mutate(PORT_Corrected = NA) %>%
  arrange(PORT) -> geo_ny_nj

geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "AQUEBOUQUE, NY"] = "AQUEBOGUE, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("ATALNTIC CITY, NJ", "ATLANTIC, NJ")] = "ATLANTIC CITY, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "AVALON POINTE, NJ"] = "AVALON, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("BARNAGET LIGHT, NJ", "BARNEGAT IGHT, NJ", "BRNEGAT LIGHT, NJ", "LIGHTHOUSE MARINA, NJ", "LIGHT HOUSE MARINA, NJ")] = "BARNEGAT LIGHT, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "BARNEGATE, NJ"] = "BARNEGAT, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "BAYSHORE, NY"] = "BAY SHORE, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "BAYSIDE QUEEN, NY"] = "QUEENS, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("BELMAR, NY", "BLEMAR, NJ")] = "BELMAR, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("BRIELLE, NY", "BREILLE, NJ")] = "BRIELLE, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "BRICK TWIN, NJ"] = "BRICKTOWN, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("CAPA MAY, NJ", "CAPETOWN, NJ", "CAPE, NJ", "SOUTH JERSEY MARINA, NJ")] = "CAPE MAY, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "CAPT REE, NY"] = "CAPTREE, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "CHADWICK BEACH ISLE, NJ"] = "TOMS RIVER, NJ" # may not run
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "COPAGUE, NY"] = "COPIAGUE, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "DELEWARE BAY, NJ"] = "DELAWARE BAY, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "ELIZABETH CITY, NJ"] = "ELIZABETH, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "FORKED RIVED, NJ"] = "FORKED RIVER, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "FREEPORT LONG ISLAND, NY"] = "FREEPORT, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "GREEENPORT, NY"] = "GREENPORT, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("HAMPOTON BAYS, NY", "HAMPTON BAY, NY", "HAMPTON BAYS  LI, NY", "HAMPTON BAYS - LI, NY")] = "HAMPTON BAYS, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "HARGATE, NJ"] = "MARGATE, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "HIGHBAR HARBOR, NJ"] = "HIGH BAR HARBOR, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "JONES INLET, NY"] = "JONES BEACH, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "LONG BEACH, NJ"] = "LONG BEACH TOWNSHIP, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "LONG PORT, NJ"] = "LONGPORT, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("MANASQUAM, NJ", "jMANASQUAN, NJ")] = "MANASQUAN, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("MATITUCK, NY", "MSTTITUCK, NY")] = "MATTITUCK, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("MATTSLANDING, NJ", "MATTS LANDING, NJ", "MUTTS LANDING, NJ")] = "HEISLERVILLE, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("MONTAUK/LONG ISLAND, NY", "MONTAUKT, NY", "MONTAWK, NY", "MONTUAK, NY", "MONTAULK, NY")] = "MONTAUK, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "MOTTS CREEK, NJ"] = "GALLOWAY, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "MOUNT SIANI, NY"] = "MOUNT SINAI, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("OCEAN CITY, NY", "OCEAN, NJ")] = "OCEAN CITY, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "OCEAN SIDE, NY"] = "OCEANSIDE, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "ORIENT MARINA, NY"] = "ORIENT, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "PENSVILLE, NJ"] = "PENNSVILLE, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("PLEASANT BEACH, NJ", "POINT JUDITH, NJ", "POINY PLEASANT, NJ")] = "POINT PLEASANT, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "PORT MANMOUTH, NJ"] = "PORT MONMOUTH, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "REED'S BEACH, NJ"] = "REEDS BEACH, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "SEAFORDEAD BAY, NY"] = "SEAFORD, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("SEAWARREN, NJ", "SEAWAREN, NJ")] = "SEWAREN, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "SHARKED RIVER, NJ"] = "SHARK RIVER, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "SHELLPILE, NJ"] = "SHELL PILE, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("SHINECOCK, NY", "SHINICOCK, NY", "SHINNECOCK, NJ", "SHINNICOCK, NY", "SHINNOCOCK, NY")] = "SHINNECOCK, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "SHIPSHEAD BAY, NY"] = "BROOKLYN, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("SOMERSPOINT, NJ", "SOMMERS POINT, NJ")] = "SOMERS POINT, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "STATE ISLAND, NY"] = "STATEN ISLAND, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "THREE MILE HARBOR, NY"] = "EAST HAMPTON, NY"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT %in% c("WARETOWR, NJ", "WATETOWN, NJ")] = "WARETOWN, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "WEST LONG BEACH, NJ"] = "WEST LONG BRANCH, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "WEST PORT, NJ"] = "WESTPORT, MA"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "WILWOOD, NJ"] = "WILDWOOD, NJ"
geo_ny_nj$PORT_Corrected[geo_ny_nj$PORT == "WACHAPREASQUE, NJ"] = "WACHAPREAGUE, VA"
                         
# that's as good as that's gonna get, let's see if they code

geo_ny_nj %>% 
  separate(PORT_Corrected, into = c("PPORT_Corrected", "PPST_Corrected"), sep = ", ") %>%
  geocode(., city = PPORT_Corrected, state = PPST_Corrected) -> geo_ny_nj

