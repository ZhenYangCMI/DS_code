###
# Load Data
###

# Load gdata library to read xls file
library(xlsx)

# Read in xls file
dataSheet <- read.xlsx("/Users/zhen.yang/Documents/Zhen_CMI/WM/data/DigitSpan_SubList_ScanData.xls",sheetName="WM_master", header = TRUE, rowIndex = c(1:82), colIndex = c(1 : 113), as.data.frame = TRUE)

# copy over DS data and detect for outliers
ageGroup <- dataSheet$ageGroup
FT <- dataSheet$DS_FT
BT <- dataSheet$DS_BT

png(filename = "/Users/zhen.yang/Documents/Zhen_CMI/WM/figs/DSBoxplot.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")
boxplot(FT, BT, varwidth = TRUE, main="Digital Span", notch=TRUE,names=c("FT","BT"),ylab="Digital Span",ylim=c(0,25))
dev.off()

png(filename = "/Users/zhen.yang/Documents/Zhen_CMI/WM/figs/FTBoxplot.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")
boxplot(FT~ageGroup, varwidth=TRUE, main="Digital Span", notch=TRUE,names=c("FT_Child","FT_Adoles"),ylab="Digital Span",ylim=c(0,25))
dev.off()

png(filename = "/Users/zhen.yang/Documents/Zhen_CMI/WM/figs/BTBoxplot.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")
boxplot(BT~ageGroup, varwidth=TRUE, main="Digital Span", notch=TRUE,names=c("BT_Child","BT_Adoles"),ylab="Digital Span",ylim=c(0,25))
dev.off()

barplot

# plot and save the fig as a png file
png(filename = "/Users/zhen.yang/Documents/Zhen_CMI/WM/ageHistogram.png", width = 480, height = 480, units = "px", pointsize = 12,bg = "white")
hist(age, col = "light blue", border = NULL, plot = TRUE, xlim = c(7, 17), ylim = c(0, 12))
dev.off()


# copy over sex data and plot

subListSession1 <- dataSheet$ID.for.QC.Data
subListSession2 <- dataSheet$ID.for.QC.Data.visit2

write.table(subListSession1,file="/Users/zhen.yang/Documents/Zhen_CMI/WM/data/subListSession1.csv",row.names=FALSE,col.names=FALSE,qmethod="double")

write.table(subListSession2,file="/Users/zhen.yang/Documents/Zhen_CMI/WM/data/subListSession2.csv",row.names=FALSE,col.names=FALSE,qmethod="double")
