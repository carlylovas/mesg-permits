## Lobster DiD ####
###################


# Install & load the libraries ----
library(tidyverse) 
library(tidygraph)
library(ggraph)
library(igraph)
library(here)
library(gmRi)
library(grid)
library(gt)
library(gomfish)

# Read in cleaned portfolio (indigenous, non-commercial licenses removed) ----
portfolio <- read_rds(here("Data", "clean_portfolio.rds"))

# Filter to shrimpers with lobster licenses ----
portfolio |>
  filter(csc == 1 | css == 1) -> shrimpers

shrimpers |>
  filter(lc1 == 1 | lc2 == 1 | lc3 == 1 | lco == 1 | lc2o == 1 | lc3o == 1) -> shrimp_w_lobster

portfolio |>
  filter(landings_number %in% shrimp_w_lobster$landings_number) |> 
  select(license_year, landings_number, csc, css, lc1, lco, lc2, lc2o, lc3, lc3o) |>
  arrange(landings_number, license_year) |>
  filter(license_year >= 2009 & !license_year == 2015) -> cs_portfolio

portfolio |>
  filter(lc1 == 1 | lc2 == 1 | lc3 == 1 | lco == 1 | lc2o == 1 | lc3o == 1) |>
  select(license_year, landings_number, lc1, lco, lc2, lc2o, lc3, lc3o) |> ## we need to compare lobster class changes across all harvesters t
  pivot_longer(lc1:lc3o, names_to = "lobster_class", values_to = "count") |>
  filter(!count == 0) |>
  mutate(class = case_when(
    lobster_class %in% c("lco", "lc1")  ~ 1,
    lobster_class %in% c("lc2", "lc2o") ~ 2, 
    lobster_class %in% c("lc3", "lc3o") ~ 3
  )) |> 
  filter(license_year %in% c(2014,2016)) |>
  group_by(landings_number, lobster_class, class) |>
  summarise(years = n_distinct(license_year)) |>
  filter(years == 2) -> lobsterers
  
portfolio |>
  select(license_year, landings_number, lc1, lco, lc2, lc2o, lc3, lc3o) |> 
  filter(landings_number %in% lobsterers$landings_number) |> 
  pivot_longer(lc1:lc3o, names_to = "lobster_class", values_to = "count") |>
  filter(!count == 0) |>
  mutate(class = case_when(
    lobster_class %in% c("lco", "lc1")  ~ 1,
    lobster_class %in% c("lc2", "lc2o") ~ 2, 
    lobster_class %in% c("lc3", "lc3o") ~ 3
  )) |>
  filter(license_year %in% c(2014,2016)) |> 
  pivot_wider(names_from = license_year, values_from = class) |>
  mutate(switch = ifelse(`2014` < `2016`, 1, 0)) -> switch # come back to the NAs later, may represent exit

# portfolio |>
#   select(license_year, landings_number, csc, css, lc1, lco, lc2, lc2o, lc3, lc3o) |>
#   filter(license_year >= 2009 & !license_year == 2015) |>
#   left_join(switch |> select(landings_number, switch)) |>
#   drop_na() |>
#   mutate(shrimp_w_lobster = ifelse(landings_number %in% shrimp_w_lobster$landings_number, 1, 0),
#          closure = ifelse(license_year >= 2016, 1, 0),
#          did = shrimp_w_lobster*closure) |>
#   select(license_year, landings_number, switch, shrimp_w_lobster, closure, did) -> lob_did

# lm(shrimp_w_lobster+closure+did, data = lob_did) 

### Yeaaaaaah I don't think DiD is the right test here...


portfolio |>
  select(license_year, landings_number, lc1, lco, lc2, lc2o, lc3, lc3o) |> 
  filter(landings_number %in% lobsterers$landings_number) |> # lobsterers who had licenses in 2014 and 2016
  pivot_longer(lc1:lc3o, names_to = "lobster_class", values_to = "count") |>
  filter(!count == 0) |>
  mutate(class = case_when(
    lobster_class %in% c("lco", "lc1")  ~ 1,
    lobster_class %in% c("lc2", "lc2o") ~ 2, 
    lobster_class %in% c("lc3", "lc3o") ~ 3
  )) |>
  select(!count) |> 
  mutate(shrimp_w_lobster = ifelse(landings_number %in% shrimp_w_lobster$landings_number, 1, 0),
         closure = ifelse(license_year >= 2016, 1, 0),
         did = shrimp_w_lobster*closure) -> lob_did

lm(class ~ shrimp_w_lobster+closure+did, data = lob_did)

summary(lm(license_year ~ class+shrimp_w_lobster+closure+did, data = lob_did))

## Better but still not right...
## Maybe the regression should be proportion of license classes ~ shrimp-lobster coholders and license switch...?

