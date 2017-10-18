
### 1. 난수 생성 및 분포 함수

# 이항분포(Binomial)            : rbinom
# F 분포(F)                     : rf
# 기하분포(Geometric)           : rgeom
# 초기하분포(Hypergeometric)    : rhyper
# 음이항분포(Negative Binomial) : rnbinom
# 정규 분포(Normal)             : rnorm
# 포아송 분포(Poisson)          : rpois
# t 분포(Student t)             : rt
# 연속 균등 분포(Uniform)       : runif

rnorm(100, 0, 10) # 정규분포
plot(density(rt(1000, 5, 0))) # degrees of freedom 5, non-centrality parameter = 0 인 t분포

plot(density(rnorm(1000000,0,10)))
plot(density(rnorm(100, 0, 10)))

# 난수(random)          : r
# 확률밀도(density)     : d 
# 누적분포(probability) : p
# 분위수(quantile)      : q (p의 역함수) 

plot(density(rnorm(10000, 0, 1)))

dnorm(-1,0,1) # 평균이 0이고 표준편차가 1인 정규분포의 x는 -1일때 y값
pnorm(-1,0,1) # 평균이 0이고 표준편차가 1일때 -1지점의 확률밀도
qnorm(pnorm(-1,0,1),0,1) # pnorm의 역함수 0.1586553 확률밀도값에 x지점

# 포아송 확률질량함수 검증

dpois(3,1)
(1^3 * exp ( -1) ) / ( factorial (3) )

# N(0, 1)의 정규 분포에서 누적 분포 F(0), 그리고 50%에 대한 분위수 F−1(0)
pnorm(0)
qnorm(0.5)

### 2.기초통계량

# 2.1 평균, 표본 분산, 표본 표준편차
mean(1:5) # 평균
var (1:5) # 분산
sum ((1:5 - mean (1:5) ) ^2) / (5 -1) # 분산검증
sd(1:5) # 표준편차 ( 분산^(1/2) )

# 2.2 다섯 수치 요약
# 최소값, 제1사분위수, 중앙값, 제3사분위수, 최대값
fivenum(1:11)
summary(1:11) # fivenum + 평균

# 데이터 수가 짝수 일경우 1/3분위수 값이 다름
fivenum(1:4) # 1.75가 1과 2사이 값이므로 중간값인 1.5
summary(1:4) # 1.75값 그대로...

# boxplot의 IQR값도 fivenum과 같은 방식.. 검증해보자..

x <- 1:10
c(min(x),quantile(x,1/4),median(x),quantile(x,3/4),max(x))

# IQR(Inter-Quartile Range. ‘제3사분위수 - 제1사분위수’의 값)

qt1 <- quantile(1:10,c(1/4,3/4))
qt1[2] - qt1[1]

boxp <- boxplot(1:10)
boxp

summary(1:10)
fivenum(1:10)

# 2.3 최빈값(mode)

x <- factor(c("a","b","c","c","c","d","d"))
x

table(x)
which.max(table(x))

names(table(x))[3]

### 3.표본추출
# 3.1 단순 임의 추출(Random Sampling)

sample(1:10,5)
sample(1:10,5,replace = T) # 복원추출
sample(1:10,5,replace = T,prob = 1:10) # 복원추출  + 가중치

sample(1:10) # 데이터 셔플

# 3.2 층화 임의 추출(Stratified Random Sampling)
# 남녀 평균키 구할 경우 남녀비율유지하며 샘플링 수
# sampling::strata()

#install.packages("sampling")
library(sampling)

# srswor = Simple Random Sampling Without Replacement
x <- strata(iris, c("Species"), size=c(3,3,3), method="srswor")
x

getdata(iris,x)

# 층별로 다른 개수의 샘플 추출
x <- strata(iris, c("Species"), size=c(3,1,1), method="srswor")
x

# 한층이 아닌 다수층으로 추출
iris$Species2 <- rep(1:2,75)

strata(c("Species","Species2"),size=c(1,1,1,1,1,1),method="srswr",data=iris)

# 각층마다 동일한 개수의 샘플링 할 경우 doBy::sampleBy() 사용 가능
# sampleBy(Formula, 표본비율, 복원추출여부(기본값 FALSE), 데이터)
library(doBy)

sampleBy(~Species, frac=.06, data=iris)

# 3.3 계통 추출(Systematic Sampling)
# 모집단의 임의 위치에서 시작해 매 k 번째 항목을 표본으로 추출하는 방법
# 주기성이 없는 데이터에 유

x <- data.frame(x=1:10)
x

sampleBy( ~1 , frac = .3 , data=x , systematic = TRUE )

### 4.분할표(Contingency Table)

# 4.1 분할표의 작성
# table() : 분할표

table(c("a","b","b","b","c","c","d"))

d <- data.frame ( x = c ( "1" , "2" , "2" , "1" ) ,
                  y = c ( "A" , "B" , "A" , "B" ) ,
                  num = c (3 , 5 , 8 , 7) )

table(d$x)

# xtabs() : 2속성이상 적용 분할표
xt <- xtabs(num ~ x + y, data=d)
xt

# margin.table() : 행과 열의합
margin.table(xt,1) # 행
margin.table(xt,2) # 열
margin.table(xt) # all

# prop.table() : 분할표로부터 각 셀 비율계산
xt

prop.table(xt,1)
prop.table(xt,2)
prop.table(xt)

# 4.2 독립성 검정(Independence Test)
# Chi-Squared Test

library(MASS)
data(survey)
str(survey)

head(survey[c("Sex","Exer")]) # 성별, 운동여부

xtabs(~Sex+Exer, data = survey )

chisq.test(xtabs(~Sex+Exer, data = survey ))

# p값이 0.05731이므로 0.05보다 커서 ‘H0: 성별과 운동은 독립이다’ 라는 
# 귀무가설을 기각할수 없는 것으로 나타났다. 
# 통계량 χ2 는 5.7184이었으며 자유도(Degree of Freedom)는 2였다.
# 이 값은 식 8.3에서 보인 (r − 1)(c − 1) = (2 − 1)(3 − 1) = 2와 같다.

# 4.3 피셔의 정확 검정(Fisher’s Exact Test)
# Sample수가 적다면~~ 피셔의 정확 검정

xtabs(~W.Hnd + Clap , data = survey )

chisq.test( xtabs (~ W.Hnd + Clap , data = survey ) )

fisher.test ( xtabs (~ W.Hnd + Clap , data = survey ) )

# 맥니마 검정(McNemar Test)
# 벌금을 부과하기 시작한 후 안전 벨트 착용자의 수, 유세를 하고난 뒤 지지율의 변화와 같이
# 응답자의 성향이 사건 전후에 어떻게 달라지는지를 알아보는 경우 맥니마 검정을 수행

Performance <-
  matrix ( c (794 , 86 , 150 , 570) ,
             nrow = 2 ,
             dimnames = list (
             "1 st Survey" = c ( "Approve" , "Disapprove" ) ,
             "2 nd Survey" = c ( "Approve" , "Disapprove" ) ) )

mcnemar.test(Performance)

# 결과에서 p-value < 0.05 가 나타나 사건 전후에 
# Approve, Disapprove에 차이가 없다는 귀무가설이 기각
# 즉, 사건 전후에 Approve, Disapprove 비율에 차이가 발생

# mcnear.test()는 이항분포로부터 나옴

binom.test (86 , 86 + 150 , .5 )
# 여기에서도 p-value < 0.05로 86이 86 + 150의 절반이라는 귀무가설이 기각


### 5 적합도 검정(Goodness of Fit)
# 정규성 검정

# 5.1 Chi Square Test

table(survey$W.Hnd)

chisq.test(table(survey$W.Hnd),p=c(.3,.7))
# p-value < 0.05 이므로 
# 글씨를 왼손으로 쓰는 사람과 오른손으로 쓰는 사람의 비가 30% : 70%라는 귀무 가설을 기각

# 5.2 Shapiro-Wilk Test
# 표본이 정규분포로 부터 추출된 것인지 테스트하기 위한 방법
# H0 = 주어진 데이터가 정규분포로부터의 표본
shapiro.test(rnorm(1000))

# p-value > 0.05 이므로 데이터가 정규 분포를 따른다는 귀무가설을 기각할 수 없다.

# 5.3 Kolmogorov-Smirnov Test
# 비모수 검정(Nonparameteric Test) : 정규분포 여부와 상관없이..
# 두 데이타 셋이 명확히 차이가 있는지 
# H0 = ‘주어진 두 데이터가 동일한 분포로부터 추출된 표본이다’

ks.test ( rnorm (100) , rnorm (100) )
# 귀무가설 기각 할 수 없다. 동일분포

ks.test ( rnorm (100) , runif (100) )
# 귀무가설 기각 한다. 다른분포

# H0 = ‘주어진 데이터가 평균 0, 분산 1인 정규분포로 부터 뽑은 표본이다’
ks.test ( rnorm (1000) , "pnorm" , 0 , 1)
# 귀무가설 기각 할 수 없다. 동일분포


# 5.4 Q-Q Plot (Quantile-Quantile Plot)

x <- rnorm (1000 , mean =10 , sd =1)
qqnorm(x) # 정규확률플롯(Normal Q-Q Plot)
qqline(x, lty=2) 

x <- runif (1000)
qqnorm(x)
qqline(x, lty=2)

x <- rcauchy (1000)
qqnorm ( x )
qqline (x , lty =2)


### 6 상관계수 
# 두 확률 변수 사이의 관계를 파악, 피어슨 상관계수

# 6.1 피어슨 상관계수(Pearson Correlation Coefficient)
# 피어슨 상관계수는 [-1, 1] 사이의 값
# 1차 선형관계 판별

cor(iris$Sepal.Width, iris$Sepal.Length)

cor(iris[ ,1:4])

symnum(cor(iris[,1:4])) # 특정 범위의 값을 문자로 치환

# corrgram : 상관계수를 시각화하는데 유용한 패키지
install.packages("corrgram")
library(corrgram)
corrgram(cor(iris[,1:4]),type="corr",upper.panel = panel.conf)

# y=x, y=2x 모두 피어슨 상관계수는 1
cor(1:10 , 1:10)
cor(1:10 , 1:10 * 2)


# 6.2 스피어만 상관계수(Spearman’s Rank Correlation Coefficient)
# 상관계수를 계산할 두 데이터의 실제값 대신 두 값의 순위를 사용
# 국어 점수와 영어 점수간의 상관계수는 피어슨 상관계수로 계산할 수 있고
# 국어 성적 석차와 영어 성적 석차의 상관계수는 스피어만 상관계수로 계산 가능

x <- c (3 , 4 , 5 , 3 , 2 , 1 , 7 , 5)
rank(sort(x))

# Hmisc::rcorr() : 피어슨 / 스피어만 상관계수 모두 가능한 패키지
# install.packages("Hmisc")
library(Hmisc)

m <- matrix ( c (1:10 , (1:10) ^2) , ncol =2)
m

rcorr(m , type="pearson")$r
rcorr(m , type="spearman")$r

x <- -5:5
y <- (-5:5) ^2
x
y

m <- matrix (c(x,y), nrow=11)
m

rcorr(m , type="pearson")$r
rcorr(m , type="spearman")$r

# 6.3 켄달의 순위 상관 계수(Kendal’s Rank Correlation Coefficient)
# 켄달의 순위 상관 계수는 (X, Y ) 형태의 순서쌍으로 데이터가 있을 때 xi < xj, yi < yj 가성립하면 concordant, xi < xj 이지만 yi > yj 이면 discordant라고 정의

install.packages("Kendall")
library(Kendall)

# concordant가 discordant에 비해 얼마나 많은지 그 비율
Kendall(c(1,2,3,4,5),c(1,0,3,4,5))

# 6.4 상관 계수 검정(Correlation Test)

# ‘H0:상관 계수가 0이다.’
cor.test(c(1,2,3,4,5), c(1,0,3,4,5), method = "pearson")
cor.test(c(1,2,3,4,5), c(1,0,3,4,5), method = "spearman")
cor.test(c(1,2,3,4,5), c(1,0,3,4,5), method = "kendall")


### 7 추정 및 검정
# 7.1 일표본 평균

# 정규분포 30개표본 대상 모평균 구간 추정
x <- rnorm (30)
x

t.test(x)
# 실행 결과 모평균은 -0.07950135, 모평균의 95% 신뢰 구간은 (-0.3872198, 0.2282171)로 추정
# ‘H0: 모평균이 0이다
# p-value > 0.05 따라서 모평균은 0

x <- rnorm (300 , mean =10)
t.test(x, mu=10)


