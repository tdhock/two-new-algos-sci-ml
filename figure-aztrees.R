data(AZtrees,package="mlr3resampling")
library(data.table)
library(ggplot2)
AZdt <- data.table(AZtrees)
AZdt[1]
x.center <- -111.72
y.center <- 35.272
rect.size <- 0.01/2
x.min.max <- x.center+c(-1, 1)*rect.size
y.min.max <- y.center+c(-1, 1)*rect.size
rect.dt <- data.table(
  xmin=x.min.max[1], xmax=x.min.max[2],
  ymin=y.min.max[1], ymax=y.min.max[2])
tree.fill.scale <- scale_fill_manual(
  "label",
  values=c(Tree="black", "Not tree"="white"))
##dput(RColorBrewer::brewer.pal(3,"Dark2"))
region.colors <- c(NW="#1B9E77", NE="#D95F02", S="#7570B3")
gg <- ggplot()+
  ggtitle("Zoom out, three geographical SOAK subsets")+
  theme_bw()+
  theme(legend.position="bottom")+
  tree.fill.scale+
  geom_rect(aes(
    xmin=xmin, xmax=xmax, ymin=ymin,ymax=ymax),
    data=rect.dt,
    fill="grey50",
    size=3,
    color="grey50")+
  scale_color_manual(
    "SOAK subset",
    guide=FALSE,
    values=region.colors)+
  geom_point(aes(
    xcoord, ycoord, color=region3, fill=y),
    shape=21,
    data=AZdt)+
  ## directlabels::geom_dl(aes(
  ##   xcoord, ycoord,
  ##   color=region3,
  ##   label=region3),
  ##   data=AZdt,
  ##   method=list("smart.grid", "draw.rects"))+
  geom_label(aes(
    x, y, color=region3, label=region3),
    data=rbind(
      data.table(x=-111.88, y=35.2, region3="NW"),
      data.table(x=-111.53, y=35.2, region3="NE"),
      data.table(x=-111.6, y=35, region3="S")))+
  coord_equal()+
  scale_x_continuous(
    "West-East coordinate (longitude)")+
  scale_y_continuous(
    "South-North coordinate (latitude)")
png("figure-aztrees-zoom-out.png", width=4.5, height=4, units="in", res=200)
print(gg)
dev.off()

gg.in <- gg+
  ggtitle("Zoom in, details of polygons(groups)")+
  theme(legend.position="none")+
  scale_x_continuous(
    "West-East coordinate (longitude)",
    limits=x.min.max)+
  scale_y_continuous(
    "South-North coordinate (latitude)",
    limits=y.min.max)+
  directlabels::geom_dl(aes(
    xcoord, ycoord, label=sprintf("polygon(group)=%d",polygon)),
    data=AZdt,
    method="smart.grid")
png('figure-aztrees-zoom-in.png', width=4.5, height=4, units="in", res=200)
print(gg.in)
dev.off()

