# graphics, lattice, ggplot 패키지중
# graphics 이요


### 1.산점도
# plot 함수 : Generic 함수

# plot이 가능한 객체의 종류는?
methods("plot")

install.packages("mlbench")
library(mlbench)

data(Ozone)
plot(Ozone$V8, Ozone$V9)

library(help = "mlbench") # mlbench 전체 데이터 확

### 2.그래픽 옵션

# ?par : 그래픽 파라미터 확인

# 2.1 축이름(xlab, ylab)
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature")

# 2.2 그래프 제목(main)
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone")

# 2.3 점의 종류(pch)
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", pch=20)
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", pch="+")

# 2.4 점의 크기(cex)
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", cex=.5)

# 2.5 색상(col)
colors() # 색상목록
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", col="#FF0000")

plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", col="#FF0000")
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", col.axis="#FF0000")
plot(Ozone$V8,Ozone$V9, xlab = "Sandburg Temperature", ylab = "El Monte Temperature", main="Ozone", col.lab="#FF0000")

# 2.6 좌표축 값의 범위(xlim,ylim)
max(Ozone$V8)

max(Ozone$V8, na.rm=TRUE)
max(Ozone$V9, na.rm=TRUE)

plot(
    Ozone$V8,
    Ozone$V9, 
    xlab = "Sandburg Temperature", 
    ylab = "El Monte Temperature", 
    main="Ozone", 
    xlim = c(0,100),
    ylim = c(0,90)
)

# 2.7 type
data(cars)
str(cars)

head(cars)

plot(cars)
plot(cars, type="l") # type : l = line
plot(cars, type="o", cex =0.5) # type : o = overlapped

tapply(cars$dist, cars$speed, mean)

plot(
  tapply(cars$dist, cars$speed, mean), 
  type="o", 
  cex =0.5,
  xlab="speed",
  ylab="dist"
  ) 

### 3.그래프의 배열(mfrow)






































