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


opar <- par(mfrow=c(1,2)) # 이전 설정된 par 설정 반환

plot(
  Ozone$V8,
  Ozone$V9, 
  xlab = "Sandburg Temperature", 
  ylab = "El Monte Temperature", 
  main="Ozone1"
)

plot(
  Ozone$V8,
  Ozone$V9, 
  xlab = "Sandburg Temperature", 
  ylab = "El Monte Temperature", 
  main="Ozone2"
)

par(opar) # 이전설정으로 되돌림

### 4. 지터(jitter)
# 한 점으로 겹쳐 표시되는 중복된 데이터를 조금씩 움직이는 옵션


plot(
  jitter(Ozone$V6),
  jitter(Ozone$V7), 
  xlab = "Wind speed", 
  ylab = "Humidity", 
  main="Ozone2",
  pch=20,
  cex=.5
)

# 5.점
# points() : 이미 생성된 plot위에 점을 추가로 그림

plot(
  iris$Sepal.Width,
  iris$Sepal.Length,
  cex=.5,
  pch=20,
  xlab="width",
  ylab="length",
  main="iris"
)

points(
  iris$Petal.Width,
  iris$Petal.Length,
  cex=.5,
  pch="+",
  col="#FF0000"
)

# attach 사용
attach(iris)
plot(Sepal.Width , Sepal.Length , cex = .5 , pch =20 ,
         xlab = "width" , ylab = "length" , main = "iris" )
points ( Petal.Width , Petal.Length , cex = .5 ,
           pch = "+" , col = "#FF0000" )

# with 사용
with(iris , {
  plot ( Sepal.Width , Sepal.Length , cex = .5 , pch =20 ,
           xlab = "width" , ylab = "length" , main = "iris" )
  points ( Petal.Width , Petal.Length , cex = .5 ,
           pch = "+" , col = "#FF0000" )
  })

# plot을 우선 준비 한 후 point 그리기
# type="n" 이용
# xlim & yilm 사전 정의 필요

with ( iris , {
  plot ( NULL , xlim = c (0 , 5) , ylim = c (0 , 10) ,
           xlab = "width" , ylab = "length" , main = "iris" , type = "n" )
  points ( Sepal.Width , Sepal.Length , cex = .5 , pch =20)
  points ( Petal.Width , Petal.Length , cex = .5 , pch = "+" , col = "#FF0000" )
  })


### 6.lines
# plot위 덮어쓰는 목적

x <- seq(0,2*pi,0.1)
y <- sin( x )
plot (x, y, cex = .5 , col = "red" )
lines (x, y )

example(lines) # cars 데이터에 LOWESS적용

# cars 데이터에 LOWESS적용 직접구현
library(mlbench)

data(cars)
head(cars)

plot(cars)
lines(lowess(cars))
# lines(loess(cars))
# lines(ksmooth(cars))
lines(smooth.spline(cars))
# lines(earth(cars))

### 7.직선(abline)
# y=a+bx, 형태 선 그리기
# y=h 가로선
# x=v 세로선

plot(cars,xlim=c(0,25))
abline(a=-5,b=3.5,col="red")
abline(h=mean(cars$dist), lty=2, col="blue")    # 평균선
abline(v=mean(cars$speed), lty =2, col="green") # 평균선

lm(cars$dist ~ cars$speed, cars)
abline(lm(cars$dist ~ cars$speed, cars)) # 선형회귀 그리기

plot(cars,xlim=c(0,25))
abline(a=-17.579,b=3.932,col="red")
abline(h=mean(cars$dist), lty=2, col="blue")    # 평균선
abline(v=mean(cars$speed), lty =2, col="green") # 평균선

### 8.곡선(curve)
curve(sin,0,2*pi) # 함수, x시작점, x끝점
curve(x^2,-10,10) # 함수표현식

### 9.다각형(polygon)
plot(cars,xlim=c(0,25))
m <- lm(dist ~ speed, data = cars )
abline(m)

p <-  predict(m,interval="confidence") # matrix 반환 # 신뢰구간 interval 포함
head(p)

# 다각형 그리기
# 1. 좌 -> 우 하한선
# 2. 우측 상한 값
# 3. 우 <- 좌 상한선
# 4. 좌측 하한 값(시작점)
x <- c ( cars$speed ,
         tail ( cars$speed , 1) ,
         rev ( cars$speed ) ,
         cars$speed[1])
y <- c ( p [ , "lwr" ] ,
           tail ( p [ , "upr" ] , 1) ,
           rev ( p [ , "upr" ]) ,
           p [ , "lwr" ][1])

polygon(x,y,col=rgb(.7,.7,.7,.5))

# ggplot2도 유용

### 10.문자열(text)
# text 기본값은 seq along(x)

plot(cars,cex=.5)
text(cars$speed,cars$dist,pos=4,cex=.5) 

### 11. 그래프상에 그려진 데이터의 식별

plot(cars,cex=.5)
identify(cars$speed,cars$dist) # 실행 후 그래프 상의 점을 클릭

### 12. 범례(legend)
plot ( iris $ Sepal.Width , iris $ Sepal.Length , cex = .5 , pch =20 ,
        xlab = "width" , ylab = "length" )
points ( iris $ Petal.Width , iris $ Petal.Length , cex = .5 ,
        pch = "+" , col = "#FF0000" )
legend ( "topright" 
         , legend = c("Sepal","Petal")
         , pch = c(20,43) 
         , cex = .8 
         , col = c ("black", "red" ) 
         , bg = "gray
         " 
         )

### 13. 행령에 저장된 데이터 그리기
# matplot, matlines, matpoints

x <- seq(-2*pi, 2*pi, 0.01)
x
y <- matrix(c(cos(x),sin(x)),ncol=2)
y

matplot(x,y,col=c("red","black"),cex=.2)
abline(h =0,v=0)

### 14. boxplot

# 1. 가운데 상자는 제1사분위수, 중앙값, 제3사분위수
# 2. 상자의 좌우 또는 상하로 뻗어나간 선(whisker 라고 부름)은 
#  중앙값 - 1.5 * IQR 보다 큰 데이터 중 가장 작은 값(lower whisker라고 부름), 
#  중앙값 + 1.5 * IQR 보다 작은 데이터 중 가장 큰 값(upper whisker)
#  IQR은 Inter Quartile Range의 약자로 ‘제3사분위수 - 제1사분위수’로 계산
# 3. 그래프에 보여지는 점들은 outlier에 해당하는데 
#  lower whisker 보다 작은 데이터 또는 upper whisker 보다 큰 데이터

boxstats <- boxplot(iris$Sepal.Width, horizontal=TRUE) # 결과 통계 값

text(
  boxstats$out,
  rep(1,NROW(boxstats$out)), # 텍스트의 위치 = (outlier 값, 1)
  labels=boxstats$out,
  pos=1, # 점의 하단
  cex=.5 # 글자 크기
)

# notch
sv <- subset(iris,Species=="setosa"|Species=="versicolor")
sv$Species <- factor(sv$Species) # 실제 존재하는 벡터 2개만 남기기 위해
boxplot(Sepal.Width~Species, data=sv , notch=TRUE )

# 오목한 부분이 신뢰구간
# 결론 : 신뢰구간이 겹치치 않으므로 두 그룹의 중앙 값은 다르다고 결론

### 15. 히스토그램(hist)
hist(iris$Sepal.Width)

x <- hist(iris$Sepal.Width, freq=FALSE) # y값 기본은 count, freq=False 이면 확률밀도
x

### 16. 밀도그림(density)
# 경계에서 분포과 확인혀 달라지지 않는 경우 유용
plot(density(iris$Sepal.Width)) 

# 히스토그램과 같이
hist(iris$Sepal.Width, freq=FALSE)
lines(density(iris$Sepal.Width))

# rug() : 실제 데이터 위치 표시 추가 
plot(density(iris$Sepal.Width))
rug(jitter(iris$Sepal.Width))

### 17. 막대그림(barplot)
barplot(tapply(iris$Sepal.Width,iris$Species,mean))

### 18. 파이그래프(pie)

# cut() : 구간을 나누는 함수
cut(1:10, breaks=c(0,5,10))
cut(1:10, breaks=3)

cut(iris$Sepal.Width,breaks=10)

# table() : 각 구간에 데이터를 세는 용도
# factor 값을 받아 분할표(Contingency Table. Cross Tabulation 또는 Cross Tab이라고도 부름) 생성

rep(c("a","b","c"), 1:3)
table(rep(c("a","b","c"),1:3))

table(cut(iris$Sepal.Width, breaks=10))

pie(table(cut(iris$Sepal.Width,breaks=10)),cex=.7)

### 19. 모자이크 플롯(mosaicplot)
# mosaicplot() : 범주형 다변량 데이터를 표현하는데 적합한 그래프

str(Titanic)
Titanic

mosaicplot(Titanic,color=TRUE)

# 일부 속성에 대해서만..
mosaicplot(~Class+Survived,data=Titanic,color=TRUE)

### 20. 산점도 행렬(pairs)

pairs(~Sepal.Width+Sepal.Length+Petal.Width+Petal.Length,
        data=iris,
        col=c("red","green","blue")[iris$Species])

# c("red","green","blue")[iris$Species] : factor 정보를

levels(iris$Species)
as.numeric(iris$Species)

c(1,2,3)[factor(c('a','b','c','b','c'), levels = c('a','b','c'))]


### 21 투시도(persp), 등고선 그래프(contour)
# outer(X,Y,FUN)

outer(1:5,1:3,"+")
outer(1:5,1:3,function(x,y){ x + y })

# dmvnorm() : 다변량 정규분포(multivariate normal distribution)의 확률밀도
# diag(2) : 2x2 단위행

library(mvtnorm)

# x=0, y=0 에 대해 x, y 의 평균이 각각 0이고 공분산
# 행렬(covariance matrix)이 2x2 크기의 단위행렬(identity matrix)일 때 확률 밀도
dmvnorm(c(0,0),rep(0,2),diag(2))

x <- seq (-3,3,.1)
y <- x
f <- function(x,y){dmvnorm(cbind(x,y))}
outer(x, y, f)

# theta와 phi는 그림의 기울어진 각도를 지정하는 인자
persp(x,y,outer(x, y, f), theta=30, phi=30)

# 등고선
contour(x, y, outer(x, y, f))
