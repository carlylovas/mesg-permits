# Libraries
library(tidyverse)
library(viridis)
library(patchwork)
install.packages("hrbrthemes")
library(hrbrthemes)
install.packages("circlize")
library(circlize)
devtools::install_github("mattflor/chorddiag")
library(chorddiag)  

# Load dataset from github
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/13_AdjacencyDirectedWeighted.csv", header=TRUE)

# short names
colnames(data) <- c("Africa", "East Asia", "Europe", "Latin Ame.",   "North Ame.",   "Oceania", "South Asia", "South East Asia", "Soviet Union", "West.Asia")
rownames(data) <- colnames(data)

# I need a long format
data_long <- data %>%
  rownames_to_column %>%
  gather(key = 'key', value = 'value', -rowname)

# parameters
circos.clear()
circos.par(start.degree = 90, gap.degree = 4, track.margin = c(-0.1, 0.1), points.overflow.warning = FALSE)
par(mar = rep(0, 4))

# color palette
# mycolor <- viridis(10, alpha = 1, begin = 0, end = 1, option = "D")
# mycolor <- mycolor[sample(1:20)]

# Base plot
chordDiagram(
  x = data_long, 
  # grid.col = pal,
  transparency = 0.25,
  directional = 1,
  direction.type = c("arrows", "diffHeight"), 
  diffHeight  = -0.04,
  annotationTrack = "grid", 
  annotationTrackHeight = c(0.05, 0.1),
  link.arr.type = "big.arrow", 
  link.sort = TRUE, 
  link.largest.ontop = TRUE)

# Add text and axis
circos.trackPlotRegion(
  track.index = 1, 
  bg.border = NA, 
  panel.fun = function(x, y) {
    
    xlim = get.cell.meta.data("xlim")
    sector.index = get.cell.meta.data("sector.index")
    
    # Add names to the sector. 
    circos.text(
      x = mean(xlim), 
      y = 3, 
      labels = sector.index, 
      facing = "bending", 
      cex = 0.8
    )
    
    # Add graduation on axis
    # circos.axis(
    #   h = "top", 
    #   major.at = seq(from = 0, to = xlim[2], by = ifelse(test = xlim[2]>10, yes = 2, no = 1)), 
    #   minor.ticks = 1, 
    #   major.tick.length = 0.5,
    #   labels.niceFacing = FALSE)
  }
)


## Interactive
palette_1 <- c("#38431d", "#773891", "#057872", "#363b45", "#b94a40", 
  "#004966","#ea4f12", "#00608a","#ebcb27","#abb400", "#07a3b7")

chorddiag(data = as.matrix(data),
          type = "directional",
          showTicks = FALSE, 
          groupColors = palette_1)
