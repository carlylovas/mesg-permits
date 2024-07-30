# create a data frame giving the hierarchical structure of your individuals
d1=data.frame(from="Origin", to=paste(colnames(temp)), value = NA)
nrow(d1)
d2=data.frame(from=rep(d1$to, each=19) , to=rep(d1$to, each = 1))
edges=rbind(d1, d2)

#vertices = data.frame(name = unique(c(as.character(edges$from), as.character(edges$to)))) 

vertices <- as.data.frame(temp) %>% 
  mutate(from = paste(colnames(temp))) %>%
  pivot_longer(`Aquaculture`:`Surf clam`, names_to = "to", values_to = "value")  %>% 
  rbind(d1)

mygraph <- graph_from_data_frame(tmp)

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) +
  geom_edge_diagonal(colour="grey") +
  scale_edge_colour_distiller(palette = "RdPu") +
  # geom_node_text(aes(x = x*1.15, y=y*1.15, filter = leaf, label=name, angle = angle, hjust=hjust, colour=group), size=2.7, alpha=1) +
  geom_node_point() +
  scale_colour_manual(values= gmri_pal()) +
  scale_size_continuous( range = c(0.1,7) )
