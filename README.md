# Access and Adaptation in Maine's Marine Fisheries

This is the public repository containing the necessary data and code for network analysis of Maine state fisheries license holdings.

## Reports

1.  [Species-level network analysis](https://carlylovas.github.io/mesg-permits/R/species_networks.html)
2.  [License network analysis](https://carlylovas.github.io/mesg-permits/R/license_networks.html)
3.  [License network plots](https://carlylovas.github.io/mesg-permits/R/license_network_plots.html)
4.  [Anomalies](https://carlylovas.github.io/mesg-permits/R/anomalies.html)
5.  [Stoll 2016 grouping](https://carlylovas.github.io/mesg-permits/R/license_divisions.html)
6.  [GARFO Summaries](hhtps://carlylovas.github.io/mesg-permits/R/garfo_sum_stats.html)

## Replication

The non-confidential data needed to recreate these three reports is contained within this repository. `Data` contains the files necessary to rerun the scripts contained in `R`. The order of species and network level scripts does not matter but **network analysis must be run prior to network plots** as it outputs an .rds file required for plotting.
