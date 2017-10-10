### 1.sqldf 패키지
# 데이터처리를 SQL문으로 처리

install.packages("sqldf")
library(sqldf)

sqldf("select distinct Species from iris")

summary(iris)

# Query는 Single Quetes안에 작성
# 컬럼명에 dots이 포함되어 있으면 Double Quetes안에 작성
sqldf('select avg("Sepal.Length") `Sepal.Length` from iris where Species = "setosa"')

mean(subset(iris, Species == "setosa")$Sepal.Length)

sqldf(
  'select Species, avg("Sepal.Length") from iris group by Species'
)

sapply(split(iris$Sepal.Length, iris$Species), mean)

###  2. plyr 패키지

# 데이터를 분할(split) -> 함수적용(apply) -> 결과 재조합(combine)
# 입력 : 배열(a), 데이터프레임(d), 리스트(l) 
# 출력 : 배열(a), 데이터프레임(d), 리스트(l) , None(_)
# ex) adply() : 배열을 입력으로 받아 데이터프레임 출력

# 2.1 adply()
# 입력이 꼭 배열일 필요는 없고 숫자색인이 가능한 타입이면 가능
# dataframe도 숫자색인이 가능하므로 입력가능

# adply(data,margin,function
# margin == 1 : 행방향
# margin == 2 : 열방향

# apply는 한가지 타입만 처리
# 문자열이 포함된경우 모두 문자열로 바꿔 버리는 문제..
apply(iris[,1:4],1,function(row){print(row)})
apply(iris,1,function(row){print(row)}) 

apply(iris[,1:4],2,mean)
apply(iris,2,mean) # 오류 발생

# install.packages("plyr")
library(plyr)
adply(
      iris,
      1,
      function(row){
        row$Sepal.Length >= 5.0 & row$Species == "setosa"
      }
)

adply(
  iris,
  1,
  function(row){
    data.frame(
      sepal_ge_5_setosa = c(row$Sepal.Length >= 5.0 & row$Species == "setosa"),
      sepal_le_5_setosa = c(row$Sepal.Length < 5.0 & row$Species == "setosa")
    )
  }
)

# 2.2 ddply
# ddply(data, group condition, function)

ddply(
  iris,
  .(Species),
  function(sub){
    data.frame(sepeal.width.mean=mean(sub$Sepal.Width))
  }
)

ddply(
  iris,
  .(Species, Sepal.Length > 5.0),
  function(sub){
    data.frame(sepeal.width.mean=mean(sub$Sepal.Width))
  }
)

ddply(
  iris,
  .(Sepal.Width),
  function(sub){
    data.frame(sepeal.width.new=(sub$Sepal.Width + 1))
  }
)

head(baseball)

head(subset(baseball, id == "ansonca01"))

ddply(
  baseball,
  .(id),
  function(sub){
    mean(sub$g)
  }
)

# 2.3 transform(), summarise(), subset()

# transform() : 변수값에 대한 연산결과를 데이터 프레임의 다른 변수에 저장하는 함수
ddply(baseball, .(id), transform, cyear = year - min(year) + 1)

# mutate() : transformr과 유사, 앞서 생성한 변수 사용가능
ddply(baseball, .(id), mutate, cyear = year - min(year) + 1, log_cyear = log(cyear))

# summarise() : 요약정보 생성함수, 새로운 데이터프레임 생성
ddply(baseball, .(id), summarise
      ,minyear=min(year)
      ,maxyear=max(year)
      )

# subset() : 조건에 맞는 데이터 추출
ddply(baseball, .(id), subset
      ,g == max(g)
)

# 2.4 m*ply()
# maply(), mdply(), mlply(), m_ply()
# 데이터 프레임 또는 배열을 인자로 받아 각 컬럼을 주어진 함수에 적용한 뒤 그 실행 결과들을 조합

x <- data.frame(mean=1:5, sd=1:5)

mdply(x, rnorm, n=2)

### 3. reshape2 패키지
# melt, cast

library(reshape2)


# melt
m <- melt(id = 1:4, french_fries)
head(french_fries)
head(m)

smiths
melt(id=1:2, smiths)

melt(id=1:2, smiths, na.rm = TRUE)

french_fries[!complete.cases(french_fries),]

# dcast/acast
# dcast : melt 원상 복귀. 결과로 dataframe 리턴
# dcast(molten data, formula, 요약치 Function)

smiths
(m <- melt(id=1:2, smiths))
(x <- dcast(m, subject + time ~ ...))
identical(x,smiths) # 두 객체가 동일한지 알려주는 함수

(x <- dcast(melt(id=1:2, smiths, na.rm = TRUE), subject + time ~ ...))

head(french_fries)
ffm <- melt(id=1:4, french_fries)
head(ffm)

x <- dcast(ffm, time + treatment + subject + rep ~ variable)

rownames(french_fries) <- NULL # 이상한 rownames 삭제
rownames(x)
identical(x,french_fries) # 두 객체가 동일한지 알려주는 함수

# cast로 데이터 요약
ffm <- melt(id=1:4, french_fries)
dcast(ffm, time ~ variable) # default 값은 length
dcast(ffm, time ~ variable, length)

NROW(subset(ffm, time == 1 & variable == "potato")) # 검증1
ddply(ffm, .(time,variable), function(rows){NROW(rows)}) #검증2

dcast(ffm, time ~ variable, mean)

dcast(melt(id=1:4, french_fries, na.rm = TRUE), time ~ variable, mean ) # NA처리
dcast(melt(id=1:4, french_fries), time ~ variable, mean , na.rm = TRUE) # NA처리

dcast(ffm, treatment ~ rep + variable, mean, na.rm = TRUE)

### 4. data.table 패키지
# data.frame 대신 사용가능
# as.data.frame / as.data.table 로 상호 변환 가능
# install.packages("data.table")
library(data.table)

iris_table = as.data.table(iris)

iris_table[1:10,]

x <- data.table(x=c(1,2,3),y=c("a","b","c"))
class(data.table()) # data.table은 data.frame을 포함하고 있음
tables() # 테이블 목록 열람

# [행 or 행 표현식, 열 or 열 표현식,옵션]
DT <- as.data.table(iris)
DT[1,]
DT[DT$Species == "setosa",]

DT[1,Sepal.Length]
# cf) iris[1,"Sepal.Length"]

DT[1,list(Sepal.Length, Species)]
# cf) iris[1,c("Sepal.Length","Species")]

DT[, mean(Sepal.Length)]
DT[, mean(Sepal.Length - Sepal.Width)]

# 비교
iris[1,1]
DT[1,1]

iris[1,c("Sepal.Length")]
DT[1,c("Sepal.Length")]

# 세번째 인자 by : SQL의 GROUP BY와 동일, 그룹지을 기준
DT[,mean(Sepal.Length), by = "Species"]

DT <- data.table(
                  x = c(1,2,3,4,5),
                  y = c("a","a","a","b","b"),
                  z = c("c","c","d","d","d")
                )
DT[,mean(x),by="y,z"]

# 4.3 key를 사용한 탐색 
DF <- data.frame(x=runif(2600000), y=rep(LETTERS,100000))
str(DF)
head(DF)

system.time( x <- DF[DF$y == "C",])

# 색인(index) 생성
DT <- as.data.table(DF)
setkey(DT, y)

system.time(x <- DT[J("C"),]) # J로 키값 선택

DT[J("C"), list(mean=mean(x),sd=sd(x))]

# 4.4 key를 사용한 데이터 테이블 병
DT1 <- data.table(x=runif(260000), y=rep(LETTERS, each=10000))
DT2 <- data.table(y=c("A","B","C"), z=c("a","b","c"))

setkey(DT1, y)
DT1[DT2,]

setkey(DT2, y)
DT2[DT1,]

# DataTable의 key를 이용한 병합의 장점은 스피드..
system.time(DT1[DT2,])

DF1 <- as.data.frame(DT1)
DF2 <- as.data.frame(DT2)
system.time(merge(DF1,DF2))

# 4.5 참조를 사용한 데이터 수정
m = matrix(1, nrow = 1000, ncol = 100)
DF <- as.data.frame(m)
DT <- as.data.table(m)

system.time(
  {
    for(i in 1:1000){
      DF[i,1] <- i
    }
  }
)
DF[,1]

system.time(
  {
    for(i in 1:1000){
      DT[i, V1 := i]
    }
  }
)
DT[,1]

# 4.6 rbindlist
# list -> data.frame의 많은 시간 소요, 이것을 해결하는 함수
library(plyr)

system.time(
  x <- ldply(1:10000,function(x){
    data.frame(
      val=x,
      val2=2*x,
      val3=2/x,
      val4=4*x,
      val5=4/x
    )
  })
)

system.time(
  x <- llply(1:10000,function(x){
    data.frame(
      val=x,
      val2=2*x,
      val3=2/x,
      val4=4*x,
      val5=4/x
    )
  })
)

system.time(x<-rbindlist(x))

### 5 foreach
# 반환값이 존재
# %do%을 사용해 블럭을 지정

library(foreach)

foreach(i=1:5) %do% {
  i
} # list로 반환

foreach(i=1:5, .combine = c) %do% {
  i
} # vector로 반환

foreach(i=1:5, .combine = rbind) %do% {
  i
} # rbind - matrix로 반환

foreach(i=1:5, .combine = cbind) %do% {
  i
} # cbind - matrix로 반환

foreach(i=1:5, .combine = rbind) %do% {
  data.frame(val=i)
} # rbind - data.frame으로 반환

foreach(i=1:10, .combine="+") %do% {
  i
} # + 연산 -> 이것은.. 함수형언어에서 사용하는 Reduce연산..

### 6 doMC
# 멀티코어를 활용 프로그램 병렬 수행
install.packages("doMC")
library(doMC)

registerDoMC(cores =8)

big_data <- data.frame (
  value = runif(NROW(LETTERS)*2000000),
  group = rep(LETTERS,2000000))

dlply(big_data, .(group) , function(x) {
  mean(x$value)
} , .parallel = TRUE )

library ( doMC )
library ( foreach )

registerDoMC ( cores =8)

foreach(i=1:800000) %dopar% {
  mean(big_data$value + i )
}

foreach(ntree=c(10,20,30,100,1000)) %dopar% {
  build_model(big_data,ntree=ntree)
}

### 7 테스팅과 디버깅

# 7.1 testthat
# install.packages("testthat")
library(testthat)

fib <- function(n){
  if(n < 2 ){
    return(1)
  }
  if(2 <= n ){
    return(fib(n-1) + fib(n-2))
  }
}

expect_equal(8, fib(5))

# 7.2 test_that을 사용한 테스트 그룹화
test_that("base case",{
  expect_equal(1, fib(0))
  expect_equal(1, fib(1))           
})

test_that("recursion case",{
  expect_equal(2, fib(2))           
  expect_equal(3, fib(3))           
  expect_equal(5, fib(4))           
})

# 7.3 테스트파일 구조
# fibo.R - 테스트 대상 프로그램
# run_tests.R - 테스트 수행 코드
# /tests - 테스트 코드 집합폴더

source("run_tests.R")

# 7.4 디버깅

# print() : 주어진 객체 화면 출력

# paste() : 주어진 인자 하나의 문자열로 출력

paste('a',1,2,'b','c')
paste('a',1,2,'b','c', sep="") # 공백생략
paste0('a',1,2,'b','c') # 공백생략

fibo <- function ( n ) {
  if ( n == 1 || n == 2) {
    print ( " base case " )
    return (1)
    }
  print ( paste0 ( " fibo ( " , n - 1 , " ) + fibo ( " , n - 2 , " ) " ) )
  return ( fibo ( n - 1) + fibo ( n - 2) )
  }

fibo (1)
fibo (2)
fibo (3)
fibo (5)

# sprintf() : 주어진 인자를 특정 규칙에 맞게 문자열로 변환해 출력
# %d : 인자를 정수로 출력
# %f : 인자를 실수로 출력
# %s : 인자를 answk로 출력


sprintf("%d",123)
sprintf("Number : %d",123)
sprintf("Number : %d, String: %s",123,"hello")

# 5칸 맞춰 출력  (우측정렬)
sprintf("%5d",123)    
sprintf("%5d",2123)    

sprintf("%.2f",123.1245) # 소수점 2째자리까지 출력
sprintf("%7.2f",123.1245) # 소수점 2째자리에 전체 7칸 맞춰 우측정렬 

# cat() : 출력 후 행을 바꾸지 않는다
cat(1,2,3,4,5,"\n")














