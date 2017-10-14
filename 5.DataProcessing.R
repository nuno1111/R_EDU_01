
### 1. iris 데이터

head(iris)
str(iris)

iris    # data.frame 형태
iris3   # array 3차원 배열형태

library(help=datasets) # 데이터 셋 목록

data(mtcars) # 데이터 사용방법
mtcars

### 2. 파일 입출력

# 2.1 CSV파일 입출력

x <- read.csv("a.csv") 
str(x)
names(x)

x <- read.csv("b.csv",header = F)  # header 없는 csv
x
names(x) <- c("id","name","score") # Column 입력
x
str(x)

x$name = as.character(x$name) # Factor를 문자열로 변환
str(x)

x <- read.csv("a.csv",stringsAsFactors = F) # 처음부터 문자열로 로딩
str(x)

x <- read.csv("c.csv",na.strings = c("NIL")) # 결측치(NA) 타입 지정
x
str(x)
is.na(x$score) # NA 확인

help(read.csv) # Document 확인

write.csv(x, "d.csv",row.names = F) # row name 없이 저장

# 3 save(), load()

# R객체 저장/로딩
x <- 1:5
y <- 6:10
save(x, y, file = "xy.RData")

rm(list=ls())
load("xy.RData") 

# 4.rbind(), cbind()
# rbind = row방향으로 합치기
# cbind = column방향으로 합치기

rbind(c(1,2,3),c(4,5,6)) # matrix
x <- data.frame(id=c(1,2), name=c("a","b"), stringsAsFactors = F)
x
str(x)

y <- rbind(x, c(3,"c"))
y

cbind(c(1,2,3),c(4,5,6))

y <- cbind(x, greek=c('a','b')) # 새로운 열 추가
y
str(y)

y <- cbind(x, greek=c('a','b'), stringsAsFactors=F) 
y
str(y)

x$newCoumns = c(11,22) # 열추가 다른 방법
x

# 5. apply
# 함수형 언어스타일
# 데이터 처리 함수를 인자로 넘김

# 5.1 apply
# 행렬의 행 또는 열방향으로 특정함수 적용
# apply(행렬,방향,함수)
# 방향은 1=행, 2=열
# 결과값은 벡터!! or 배열 or 리스트

sum(1:10)

d = matrix( 1:9, nrow = 3)
d
apply(d,1,sum)
apply(d,2,sum)

head(iris)
apply(iris[,1:4],2,sum) # Species 제외 모든 열 합

# rowSums(), comSums() 함수 사전정의 되어 있음
colSums(iris[,1:4])

# rowMeans(), comMeans() 
colMeans(iris[,1:4])

# 5.2 lapply
# 리턴값이 list

result <- lapply(1:3, function(x){x * 2})
result 
result[[1]] 

unlist(result) # list to vector

x <- list(a=1:3, b=4:6)
x
lapply(x,mean)

lapply(iris[,1:4], mean)

colMeans(iris[,1:4])

# list to dataframe 

t1 <- lapply(iris[,1:4], mean) # list
t2 <- unlist(t1) # vector
t3 <- matrix(t2, ncol = 4, byrow = T) # matrix
t4 <- as.data.frame(t3) # data.frame
names(t4) <- names(iris[,1:4]) # 이름부여
t4

# list to dataframe by do.call
t5 <- do.call(cbind, t1) # matrix
data.frame(t5)
## !! 그러나.. do.call은 너무 느림....

# 5.3 sapply
# return vector,matrix

lapply(iris[,1:4], mean) # list
x <- sapply(iris[,1:4], mean) # vector or matrix
as.data.frame(x)
as.data.frame(t(x)) # Matrix Transpose 필요

sapply(iris, class) # 각 열에 저장된 데이터의 클래스..

y <- sapply(iris[,1:4], function(x){x>3}) 
class(y) # matrix .. sapply는 한 가지 타입(vector or matrix)만 저장가능
head(y)

# 5.4 tapply
# 그룹별 처리를 위한 apply 함수
# tapply(데이터,색인,함수)
# 색인은 factor, 어느 그룹에 속하는지..

tapply(1:10, rep(1,10), sum)
tapply(1:10, 1:10 %% 2 == 1, sum)
tapply(iris$Sepal.Length, iris$Species, mean)

m <- matrix(
  1:8,
  ncol = 2,
  dimnames = list(c("spring","summer","fall","winter"),
                  c("male","female")
                  )
)

tapply(
  m,
  list(c(1,1,2,2,1,1,2,2),
       c(1,1,1,1,2,2,2,2)
       ),
  sum
)

# 5.5 mapply
# sapply와 유사하지만 다수의 인자 넘김
mapply(
  function(i,s){
    sprintf("%d%s",i,s) #데이터를 문자열로 변환
  },
  1:3,
  c("a","b","c")
)

mapply(
  mean,
  iris[1:4]
)

apply(
  iris[1:4]
  ,2
  ,mean
)

lapply(
  iris[1:4]
  ,mean
)

sapply(
  iris[1:4]
  ,mean
)

# 6.doBy 패키지
# install.packages('doBy')
library(doBy)

# bas:summary() - generic function
# 주어진 인자에 따라 다른 동작 수행

summary(iris) # 통계자료요약
quantile(iris$Sepal.Length,seq(0,1,by=0.1)) # 수치형 자료분포

# summaryBy : 원하는 컬럼의 값을 특정조건에 따라 요약
# iris데이터의 Sepal.Witdh와 Sepal.Length를 Species 따라 요약

summaryBy(Sepal.Width+Sepal.Length~Species,iris) # fomula 표현식

# orderBy
orderBy( ~ Sepal.Length,iris)
orderBy( ~ Species + Sepal.Length ,iris)

order(iris$Sepal.Width) # base 패키지 order가 더 많이 쓰이긴 함..
iris[order(iris$Sepal.Width),] 

# sampleBy

# base:sample

sample(1:10,5)
sample(1:10,5,replace = T) # 중복허용
sample(1:10,5,replace = F) # 중복미허용

sample(1:10,10) # 랜덤 셔플
iris[sample(1:NROW[iris],NROW[iris])]

iris[sample(NROW(iris),NROW(iris)),]

# Species마다 10%씩 샘플추출
sampleBy(~Species, frac=0.1, data=iris)

# 7.split()
# 데이터를 분리하는데 사용

l = split(iris,iris$Species) # return list
lapply(split(iris$Sepal.Length,iris$Species),mean)

tapply(iris$Sepal.Length,iris$Species,mean) # 비교


# 8.subset
# 특정부분 취하기
subset(iris, Species == "setosa")
subset(iris, Species == "setosa" & Sepal.Length > 5.0)
subset(iris, Species == "setosa" & Sepal.Length > 5.0)

subset(iris, select = c(Sepal.Length, Species))
subset(iris, Species == "setosa" & Sepal.Length > 5.0, c(Sepal.Length, Species))
subset(iris, select = -c(Sepal.Length, Species))

# 9.merge : rdb의 join과 동일
x <- data.frame(name=c("a","b","c"),math=c(1,2,3))
y <- data.frame(name=c("b","c","a"),english=c(4,5,7))
merge(x,y)

x <- data.frame(name=c("a","b","d"),math=c(1,2,3))
y <- data.frame(name=c("b","c","a"),english=c(4,5,7))
merge(x,y) # inner join
merge(x,y,all = T) # full outer join
merge(x,y,all.x = T) # left outer join
merge(x,y,all.y = T) # right outer join

# 10. sort(), order()
# 데이터 정렬

x <- c(20,11,33,50,47)
sort(x) # 정렬된 결과 반환
sort(x, decreasing = TRUE) 

order(x) # 정렬위한 각 요소의 색인 반환
x[order(x)] # asc
x[order(-x)] # desc

iris[order(iris$Sepal.Length,iris$Petal.Length),] 

# 11. with(), within()
with(iris,{
  print(mean(Sepal.Length))
  print(mean(Sepal.Width))
}) # 데이터 간편 이용

x <- data.frame(val=c(1,2,3,4,NA,5,NA))

x <- within(x,{
  val <- ifelse(is.na(val), median(val, na.rm = TRUE), val)  
}) # 데이터 수정/결측치처리
# na.rm = TRUE <- 결측치는 제외하고 평균 

x$val[is.na(x$val)] <- median(x$val, na.rm = TRUE)


# iris내 일부데이터가 NA일경우 

iris[1,1] = NA
head(iris)

median_per_species <- sapply(split(iris$Sepal.Length, iris$Species),median, na.rm=TRUE)

iris <- within(iris, {
  Sepal.Length <- ifelse(is.na(Sepal.Length), median_per_species[Species], Sepal.Length)  
})

head(iris)

# 12.attach, dettach
# with와 유사

Sepal.Width

attach(iris)
head(Sepal.Width)

detach(iris)
Sepal.Width 

# 주의 attach의 결과는 detach후 반영 안됨

attach(iris)
Sepal.Width[1] = -1
head(Sepal.Width)
detach(iris)

head(iris)

# 13 which(), which.max(), which.min()
# which 주어진 조건을 만족하는 값의 색인을 찾는다.

x <- c(2,4,6,7,10)

x %% 2
which(x %% 2 == 0)
x[which(x %% 2 == 0)]

# which.min() & max() 주어진벡터에서 최소/최대값 저장 색인 찾음
x <- c(2,4,6,7,10)
which.min(x)
x[which.min(x)]

which.max(x)
x[which.max(x)]

# 14 aggregate
# aggregate(데이터,그룹조건,함수)
# aggregate(formula,데이터,함수)

aggregate(Sepal.Width ~ Species, iris, mean)

# 15 stack(), unstack() : pivot 느낌.. 형태 변호
x <- data.frame(
  medicine=c("a","b","c"),
  ctrl=c(5,3,2),
  exp=c(4,5,7)
)
x

stacked_x <- stack(x)
stacked_x

# install.packages("doBy")
library(doBy)

summaryBy(values ~ ind, stacked_x)

unstack(stacked_x, values ~ ind)






 












