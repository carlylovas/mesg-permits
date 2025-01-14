# Access and Adaptation in the Northeast Marine Fisheries

This is the public repository containing the necessary data and code for network analysis of Maine state fisheries and federally managed fisheries license holdings. A number of these analyses are dependent on previously run scripts. In order to recreate the license network plots (**Maine #4**), the license network analysis must be run prior. Similarly, **Maine #1-4** must be run and the outputs saved in order to create all figures in **Manuscript development**. Federal license analyses follow a similar protocol.

All analyses requiring trawl data will need to install the most recent **gmRi** package by running `devtools::install_github("https://github.com/gulfofmaine/gmRi)`

## Reports

### Maine state licenses

1.  [Species-level network analysis](https://carlylovas.github.io/mesg-permits/R/maine/species_networks.html)
2.  [License network analysis](https://carlylovas.github.io/mesg-permits/R/maine/license_networks.html)
3.  [License network plots](https://carlylovas.github.io/mesg-permits/R/maine/license_network_plots.html)
4.  [Stoll 2016 grouping](https://carlylovas.github.io/mesg-permits/R/maine/license_divisions.html)
5.  [Clustering](https://carlylovas.github.io/mesg-permits/R/maine/clustering.html)
6.  [Shrimp](https://carlylovas.github.io/mesg-permits/R/maine/shrimp_split.html) (*disaggregated*)
7.  [Shrimp](https://carlylovas.github.io/mesg-permits/R/maine/shrimp_aggregated.html) (*aggregated*)
8.  [Manuscript development](https://carlylovas.github.io/mesg-permits/R/maine/fig_development.html)

### Federal licenses

1.  [GARFO Summaries](https://carlylovas.github.io/mesg-permits/R/garfo/garfo_sum_stats.html)
2.  [GARFO License Movement](https://carlylovas.github.io/mesg-permits/R/garfo/license_movement.html)
3.  [Black sea bass](https://carlylovas.github.io/mesg-permits/R/garfo/blackseabass.html)
4.  [z-scores](https://carlylovas.github.io/mesg-permits/R/garfo/z_score.html)
