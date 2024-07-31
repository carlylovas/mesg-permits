# Access and Adaptation in Maine's Marine Fisheries

This is the public repository containing the necessary data and code for network analysis of Maine state fisheries and federally managed fisheries license holdings.

## Reports
### Maine state licenses
1.  [Species-level network analysis](https://carlylovas.github.io/mesg-permits/R/maine/species_networks.html)
2.  [License network analysis](https://carlylovas.github.io/mesg-permits/R/maine/license_networks.html)
3.  [License network plots](https://carlylovas.github.io/mesg-permits/R/maine/license_network_plots.html)
4.  [Anomalies](https://carlylovas.github.io/mesg-permits/R/maine/anomalies.html)
5.  [Stoll 2016 grouping](https://carlylovas.github.io/mesg-permits/R/maine/license_divisions.html)
6.  [Clustering](https://carlylovas.github.io/mesg-permits/R/maine/clustering.html)
7.  [Shrimp](https://carlylovas.github.io/mesg-permits/R/maine/shrimp_split.html) 

### Federal licenses
1.  [GARFO Summaries](https://carlylovas.github.io/mesg-permits/R/garfo/garfo_sum_stats.html)
2.  [GARFO License Movement](https://carlylovas.github.io/mesg-permits/R/garfo/license_movement.html)
3.  [GINI coefficient](https://carlylovas.github.io/mesg-permits/R/garfo/gini.html)

### Species-specific case studies
1.  [Black sea bass](https://carlylovas.github.io/mesg-permits/R/blackseabass.html)

## Replication

The non-confidential data needed to recreate these three reports is contained within this repository. `Data` contains the files necessary to rerun the scripts contained in `R`. The order of species and network level scripts does not matter but **network analysis must be run prior to network plots** as it outputs an .rds file required for plotting.
