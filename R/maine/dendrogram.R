library(ggraph)
library(igraph)
library(tidyverse)
library(dplyr)
library(dendextend)
install.packages("colormap")
library(colormap)
install.packages("kableExtra")
library(kableExtra)
options(knitr.table.format = "html")

# Dendrogram ####

## Load the data
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/13_AdjacencyUndirecterWeighted.csv", header=T, sep=",") %>% as.matrix
#data <- read.table("../Example_dataset/13_AdjacencyUndirecterWeighted.csv", header=T, sep=",") %>% as.matrix
colnames(data) <- gsub("\\.", " ", colnames(data))
data <- data %>%
  as.data.frame() %>%
  mutate_all(~ gsub(" ", "", .)) %>%
  as.matrix()
data <- apply(data, 2, as.numeric)
data <- data[,-1] # remove the first column (city names)

## show data
tmp <- data %>% as.data.frame() %>% select(1,3,6) %>% .[c(1,3,6),]
tmp[is.na(tmp)] <- "-"
tmp %>% kable() %>%
  kable_styling(bootstrap_options = "striped", full_width = F)

## Perform hierarchical cluster analysis.
dend <- as.dist(data) %>%
  hclust(method="ward.D") %>%
  as.dendrogram()

## Plot with Color in function of the cluster
leafcolor <- colormap(colormap = colormaps$viridis, nshades = 5, format = "hex", alpha = 1, reverse = FALSE)
par(mar=c(1,1,1,7))
dend %>%
  set("labels_col", value = leafcolor, k=5) %>%
  set("branches_k_color", value = leafcolor, k = 5) %>%
  plot(horiz=TRUE, axes=FALSE)

# Circular dendrogram ######
# Libraries
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer)
set.seed(1)

# create a data frame giving the hierarchical structure of your individuals
d1=data.frame(from="origin", to=paste("group", seq(1,10), sep=""))
d2=data.frame(from=rep(d1$to, each=10), to=paste("group", seq(1,100), sep="_"))
edges=rbind(d1, d2)

# create a vertices data.frame. One line per object of our hierarchy
vertices = data.frame(
  name = unique(c(as.character(edges$from), as.character(edges$to))) ,
  value = runif(111)
)
# Let's add a column with the group of each name. It will be useful later to color points
vertices$group = edges$from[ match( vertices$name, edges$to ) ]


#Let's add information concerning the label we are going to add: angle, horizontal adjustement and potential flip
#calculate the ANGLE of the labels
vertices$id=NA
myleaves=which(is.na( match(vertices$name, edges$from) ))
nleaves=length(myleaves)
vertices$id[ myleaves ] = seq(1:nleaves)
vertices$angle= 90 - 360 * vertices$id / nleaves

# calculate the alignment of labels: right or left
# If I am on the left part of the plot, my labels have currently an angle < -90
vertices$hjust<-ifelse( vertices$angle < -90, 1, 0)

# flip angle BY to make them readable
vertices$angle<-ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# Create a graph object
mygraph <- graph_from_data_frame( edges, vertices=vertices )

# prepare color
mycolor <- colormap(colormap = colormaps$viridis, nshades = 6, format = "hex", alpha = 1, reverse = FALSE)[sample(c(1:6), 10, replace=TRUE)]

# Make the plot
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_edge_diagonal(colour="grey") +
  scale_edge_colour_distiller(palette = "RdPu") +
  # geom_node_text(aes(x = x*1.15, y=y*1.15, filter = leaf, label=name, angle = angle, hjust=hjust, colour=group), size=2.7, alpha=1) +
  geom_node_point(aes(filter = leaf, x = x*1.07, y=y*1.07, colour=group)) + #size=value, alpha=0.2)) +
  scale_colour_manual(values= pal) +
  scale_size_continuous( range = c(0.1,7) ) +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3))


# License dendrogram ####
temp <- species_portfolio %>%
  ungroup() %>%
  select(!c(landings_number, license_year))

temp <- crossprod(as.matrix(temp))
diag(temp) <- NA

dend <- as.dist(temp) %>%
  hclust(method="ward.D") %>%
  as.dendrogram()

## Plot with Color in function of the cluster
pal <- colormap(colormap= c("#38431d", "#773891", "#057872", "#363b45", "#b94a40", 
                            "#004966","#ea4f12", "#00608a","#ebcb27","#abb400", "#07a3b7"),format = "hex", nshade = 11, reverse = TRUE)
dend %>%
  set("labels_col", value = pal, k= 11) %>%
  set("branches_k_color", value = pal, k = 11) %>%
  plot(horiz=T, axes=F)

# Hierarchical edge bundling ####


## license network 
graph <- graph_from_adjacency_matrix(temp, mode = "undirected", weighted = TRUE)

x <- as_tbl_graph(graph)

x %>% 
  activate(nodes) %>%
  mutate(community = as.character(group_louvain())) -> x

ggraph(x, layout = "fr") + 
  geom_edge_link(aes(width = (weight*.5)), alpha = 1, show.legend = FALSE) + 
  geom_node_point(aes(color = community), size = 7, alpha = .8, show.legend = FALSE) +
  scale_edge_width(range = c(0.2, 2)) +
  scale_color_gmri() +
  coord_fixed() +
  # ggtitle(license_year) +
  geom_node_text(aes(label = name), repel = TRUE, color = "black", max.overlaps = 100) +
  theme_graph() 

# Remove edges with NA weights
network <- delete_edges(graph, E(graph)[is.na(E(graph)$weight)])

# Make the graph
ggraph(network) +
  geom_edge_link(aes(width = (weight*0.25)), alpha=0.3) +
  geom_node_point(color="#69b3a2", size=1) +
  # geom_node_text(aes(label=name), repel = TRUE, size=5, color="#69b3a2") +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(rep(1,4), "cm")
  )


# Bundled 
bundle <- graph_from_adjacency_matrix(temp, mode = "directed", weighted = TRUE)

temp %>%
  as.dendrogram()


ggraph(bundle, layout = "dendrogram", circular = TRUE) + 
  geom_edge_link(aes(width = weight), alpha = 0.25, show.legend = FALSE) + 
  geom_node_point(aes(color = community), size = 7, alpha = .8, show.legend = FALSE) +
  geom_conn_bundle(data = get_con(from = from, to = to), alpha = 0.1, colour="#69b3a2") +
  scale_edge_width(range = c(0.2, 2)) +
  scale_color_gmri() +
  coord_fixed() +
  # ggtitle(license_year) +
  geom_node_text(aes(label = name), repel = TRUE, color = "black", max.overlaps = 100) +
  theme_graph() 









