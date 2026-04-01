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

# All commercial lobster harvesters ----
portfolio |>
  filter(lc1 == 1 | lc2 == 1 | lc3 == 1 | lco == 1 | lc2o == 1 | lc3o == 1) |>
  select(license_year, landings_number, lc1, lco, lc2, lc2o, lc3, lc3o) |>
  pivot_longer(lc1:lc3o, names_to = "lobster_class", values_to = "count") |>
  filter(!count == 0) |>
  mutate(class = case_when(
    lobster_class %in% c("lco", "lc1")  ~ 1,
    lobster_class %in% c("lc2", "lc2o") ~ 2,
    lobster_class %in% c("lc3", "lc3o") ~ 3
  )) |>
  
  ## Ensure population of lobsterers had license in the year before and after the closure
  filter(license_year %in% c(2014,2016)) |>
  
  ## Remove instances of mulitple license types issued in a year...
  mutate(n = n(), .by = c(landings_number, license_year)) |>
  filter(!n > 1L) |>
  select(!n) |>
  group_by(landings_number) |>
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
  select(landings_number, license_year, class) |>
  filter(license_year %in% c(2014,2016)) |>
  pivot_wider(names_from = license_year, values_from = class) |>
  mutate(switch = ifelse(`2014` < `2016`, 1, 0)) -> switch 

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


# Categorical dependent variable ----
## Did the lobster class type switch after the closure of the shrimp fishery? 
summary(MASS::polr(factor(class) ~ shrimp_w_lobster+closure+did, data = lob_did))


# Category 1 --> 2 ----




