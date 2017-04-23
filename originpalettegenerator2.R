## ORIGIN palette generator

dec2hex = function(num, digits = 1){
  symb = c(as.character(0:9),'A','B','C','D','E','F')
  x = c()
  while (num > 0){
    sym = num %% 16
    x = c(x,symb[sym+1])
    num = num %/% 16
  }
  dif = digits - length(x)
  if (dif > 0){
    x = c(x,rep('0',dif))
  }
  return(paste0(x[length(x):1],collapse = ''))
}

lighter <- function(col,sat=0.5,val=1){
  col.rgb = col2rgb(col)
  col.hsv = rgb2hsv(col.rgb)
  col2.hsv = col.hsv*c(1,sat,val)
  col2.rgb = hsv(col2.hsv[1],col2.hsv[2],col2.hsv[3])
  return(col2.rgb)
}

library(RColorBrewer)
cols=c("#415354","#D0533D","#567539","#797ECB","#CEA953","#84D5A4","#CD5B89","#72422F","#A8B6C0","#5D3762","#91D44B","#C059CB")
cols = c('#1b9e77','#d95f02','#7570b3','#e7298a','#66a61e','#e6ab02','#a6761d','#666666')
#jet
cols <- c("#00007F", "#0000FF", "#007FFF", "#00FFFF", "#7FFF7F", "#FFFF00", "#FF7F00", "#FF0000", "#7F0000")
cols2 <- sapply(cols,lighter,mult=0.5)
#jet
cols <- c("#00007F", "#0000FF", "#007FFF", "#00FFFF", "#7FFF7F", "#FFFF00", "#FF7F00", "#FF0000", "#7F0000")
cols[1] <- "#FFFFFF"
cols = c(cols,'#3F0000')
cols <- c('#015EAE','#0499DB','#39BBEC','#8BD1EB','#CFE8EF','#F3EBBA','#F8D198','#F3A179','#EA6F67','#CB3B45','#9E1E37')
#leaves
cols <- c('#007F3F','#7FBF7F','#FFFF5F','#DF7F3F','#BF001F')
#matlab basic colors
cols <-  c('#7E2F8E','#0072BD','#4DBEEE','#77AC30','#EDB120','#D95319','#A2142F')
cols <- cols[c(7,1:6)]

palette.size = 253
cols = brewer.pal(9,'Set1')
cols <- c('#FFFFFF',cols[2],cols[3],cols[6],cols[1],'#0D070C')
cols <- sapply(cols,lighter)
cols <- c("#2D373C",cols[1:8])
cols = cols[11:1]
#manual positions from 1 to 256
pos = c(1,52,103,154,205,256)
#or
pos = 0 #for equally spaced colors
if (pos == 0){
  pos = seq(1,palette.size,length=length(cols))
  pos = round(pos)
}

cols = cols[-2]
pos = pos[-2]
#if (pos == -1){ #for qualitative
#  pos = 1:length(cols)
#}
  
#if last index is < 256, add white in the end
if (tail(pos,1) < palette.size){
  pos = c(pos,palette.size)
  cols = c(cols,'#ffffff')
}

#header
# RIFF                        52 49 46 46
# filesize - 8                10 04 00 00
#  PAL                        50 41 4C 20
# data                        64 61 74 61 
# filesize - 20               04 04 00 00
# version03 + palette.size    00 03 00 01
# data = palette.size * 4
# file size = data + 24
# bytes are in inv. order, i.e. filesize-8 = 1048-8 bytes = 1040 = 1024 + 16 = 4*256 + 16 = 0x0410 -> 1004
 
#header of pal file in hex
palette.size.hex = dec2hex(palette.size,4)
data.size = palette.size*4
file.size = data.size + 24
file.size.hex = dec2hex(file.size - 8,4)
data.size.hex = dec2hex(file.size - 20,4)
header = data.frame(
    r=c('52',substr(file.size.hex,3,4),'50','64',substr(data.size.hex,3,4),'00'),
    g=c('49',substr(file.size.hex,1,2),'41','61',substr(data.size.hex,1,2),'03'),
    b=c('46','00','4C','74','00',substr(palette.size.hex,3,4)),
    a=c('46','00','20','61','00',substr(palette.size.hex,1,2)),
stringsAsFactors=F)

tmp = '00'
data = data.frame(r=rep(tmp,palette.size),g=rep(tmp,palette.size),b = rep(tmp,palette.size), a = rep(tmp,palette.size),stringsAsFactors=F)
for (i in 1:palette.size){
  if (i %in% pos){ #if current is already in a list
    posX = sum(i >= pos) #get its number
    rgbx = col2rgb(cols[posX])
    #colx = rgb(t(rgbx/255)) #stupid useless conversion 
    data$r[i] = substring(cols[posX],2,3)
    data$g[i] = substring(cols[posX],4,5)
    data$b[i] = substring(cols[posX],6,7)
  } else {
    j = sum(i > pos)
    pos0 = pos[j]
    pos1 = pos[j + 1]
    col0 = cols[j]
    col1 = cols[j + 1]
    rgb0 = col2rgb(col0)
    rgb1 = col2rgb(col1)
    tmp = (i - pos0)/(pos1-pos0)
    rgbx = rgb1*tmp + rgb0*(1-tmp)
    colx = rgb(t(rgbx),maxColorValue = 255)
    data$r[i] = substring(colx,2,3)
    data$g[i] = substring(colx,4,5)
    data$b[i] = substring(colx,6,7)
  }
 
}
  
full = rbind(header,data)
write.table(full,file='matlab_cmap.pal',sep = '',row.names = F, col.names = F,quote = F,eol='')
#convert palette.pal from hex to ascii in notepad++

# data = outer(seq(-3,3,0.02),seq(-3,3,0.02),function(i,j) sin(i)*cos(j+0.2*i)*exp(-0.2*(i^2+j^2/3)))
# library(RColorBrewer)
# rdbu <- colorRampPalette(colors = cols)
# filled.contour(data,color.palette = rdbu)

# 
# 

cols = brewer.pal(9,'Set1')
colsredbu = brewer.pal(5,'RdBu')
cols = c(colsredbu[5:4],"#f2BFf2",colsredbu[2:1])
# 
# 
library(ggplot2)
fun = function(i,j) sin(i^2)*cos(j+0.4*i+0.6*i^2-0.3*j^2)*exp(-0.2*(i^2+j^2/3))
fun = function(i,j) round(5*sin(i))+round(4*cos(2*j))
data = data.frame(x=rep(seq(-5,5,0.02),501),y=rep(seq(-5,5,0.02),each=501))
# system.time(data$z <- mapply(fun,data$x,data$y))
system.time(data <- transform(data, z = fun(x,y)))
# 
ggplot(data=data,aes(x=x,y=y))+geom_tile(aes(fill=z)) + theme_bw() + scale_fill_gradientn(colours = cols) + guides(fill = guide_colorbar(barheight=20))# library(dplyr)
# data2 = as.tbl(data)
# system.time(mutate(data2,z = fun(x,y)))



cols <- brewer.pal(9,'Set1')
cols <- cols[1:8]
cols2 <- c()
for (col in cols){
  col.rgb = col2rgb(col)
  col.hsv = rgb2hsv(col.rgb)
  col2.hsv = col.hsv*c(1,0.67,1)
  #col2.rgb = hsv(col2.hsv[1],col2.hsv[2],col2.hsv[3])
  col2.rgb = hsv(col2.hsv[1],0.5,0.5)
  cols2 <- c(cols2,col2.rgb)
}
show_col(c(cols,cols2))
show_col(c(cols,sapply(cols,lighter)))
