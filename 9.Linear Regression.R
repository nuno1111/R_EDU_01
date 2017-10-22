### 1 단순 선형 회귀(Simple Linear Regression)

# 1.1 모델 생성

data(cars)
head(cars)

m <- lm ( dist ~ speed , cars )
m

# 1.2 선형회귀 결과 추출

# 회귀 계수
coef(m)

# 예측 값(Fitted Values)
fitted ( m ) [1:4]

# 잔차(Residuals)
residuals ( m ) [1:4]

fitted ( m ) [1:4] + residuals ( m ) [1:4] # 예측값 + 잔차 = 원본데이터
cars $ dist [1:4]

# 계수의 신뢰구간
confint ( m )

# 잔차 제곱 합
deviance ( m )

sum (( cars $ dist - predict (m , newdata = cars ) ) ^2)


# 1.3 예측과 신뢰구간
# 예측값
predict (m , newdata = data.frame ( speed =3) )

# 예측값 확인
coef ( m )
-17.579095 + 3.932409 * 3

# 1.3 예측값 + 신뢰구간
predict (m , newdata = data.frame ( speed = c (3) ) , interval = "confidence" )

# 오차항을 고려한 신뢰구간
predict (m , newdata = data.frame ( speed = c (3) ) , interval = "prediction" )

# 1.4 모형 평가
summary ( m )

# 설명 변수 평가

# Estimate 열은 절편과 계수의 추정치
# Pr(> |t|)열은 t 분포를 사용하여 각 변수가 얼마나 유의한지
# Pr(> |t|)열 바로 뒤에 * 또는 ***로 표시된 문자열은 p value의 범위

# 결정계수와 F 통계량

# R-squared(R2 와 Adjusted R-squared)
# R2 는 설명 변수가 늘어나면 그 값이 커지는 성질이 있으므로
# R2를 자유도로 나눈 Adjusted R-suqared가 더 많이 사용


# 1.5 ANOVA 및 모델간의 비교
anova(m) # summary가 보여주는 F통계량과 동일

# anova() 함수를 사용해 완전 모형과 축소 모형을 직접 비교
full <- lm ( dist ~ speed , data = cars )
reduced <- lm ( dist ~ 1 , data = cars )

full
reduced

# 두 모델 비교
anova ( reduced , full )

# 모델을 비교한 결과 F 통계량은 89.567이며 p 값은 아주 작게 나타났다.
# 따라서 reduced 모델과 full 모델간에는 유의한 차이가 있다. 
# speed 열이 유의미한 설명변수임을 뜻한다.

# 1.6 모델 평가 차트
plot(m)

# ‘Residuals vs Fitted’ : X축에 선형회귀로 적합된 값, Y축에 적합된 값과 실 데이터의 차이인 잔차를 보여준다. 
# ‘Noraml Q-Q’ : 잔차가 정규분포를 따르는지 확인하기 위한 목적
# ‘Scale-Location’ : X축에 선형회귀로 적합된 값, Y축에 표준화 잔차
# ’Residuals vs Leverage’는 X축에 Leverage, Y축에 표준화 잔차


# 관찰값별 Cook’s Distance
plot ( m , which = 4 )

# 각 관찰값에 대한 Leverage와 Cook’s Distance
plot ( m , which = 6 )

# 1.7 회귀 직선의 시각화

plot ( cars $ speed , cars $ dist )
abline ( coef ( m ) )

# 추정값의 신뢰구간 포함

summary ( cars $ speed )

predict (m ,
         newdata = data.frame ( speed = seq (4.0 , 25.0 , .2 ) ) ,
         interval = "confidence" )

speed <- seq ( min ( cars $ speed ) , max ( cars $ speed ) , .1 )

ys <- predict (m , newdata = data.frame ( speed = speed ) ,
               interval = "confidence" )


matplot ( speed , ys , type = 'n')
matlines ( speed , ys )



### 2 중선형회귀(Multiple Linear Regression)
# 2.1 모델 생성 및 평가

m <- lm ( Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width ,
          data = iris )
m

summary ( m )

# 중선형회귀에서의 귀무가설은 ‘H0: 모든 계수가 0 (즉 β0 = β1 = · · · = 0)’
# 하나의 설명변수라도 0이 아닌 계수를 갖게되면 모델이 유의한것으로 판단

# 2.2 범주형변수

m <- lm ( Sepal.Length ~ . , data = iris )
m
summary(m)

# 가변수를 사용한 범주형 변수의 표현
# setosa     0 0
# versicolor 1 0
# virginica  0 1

# 데이터가 어떻게 코딩되어 모델에 사용되는지 확인
model.matrix ( m ) [ c (1 , 51 , 101) ,]

# 명목형 변수 P-value 확인
anova(m)


# 2.3 중선형회귀모형의 시각화
with ( iris , plot ( Sepal.Width , Sepal.Length ,
                     cex = .7 ,
                     pch = as.numeric ( Species ) ) )

# pch : 점모양.. 1,2,3
as.numeric ( iris $ Species )

#범례
legend ( "topright" , levels ( iris $ Species ) , pch =1:3 , bg = "white" )
levels ( iris $ Species )

m <- lm ( Sepal.Length ~ Sepal.Width + Species , data = iris )
m
coef(m)
anova(m)

abline (2.25 , 0.80 , lty =1)
abline (2.25 + 1.45 , 0.80 , lty =2)
abline (2.25 + 1.94 , 0.80 , lty =3)

# 2.4 표현식을 위한 I()의 사용
x <- 1:1000
y <- x ^2 + 3 * x + 5 + rnorm (1000)
lm ( y ~ I (x^2) + x )

# lm ( y ~ x^2) # 이렇게 쓰면 안됨.. 상호작용으로 해석

# 난 이렇게 할래...
x2 = x ^ 2
lm ( y ~ x2 + x )

# Y = 3 × (X1 + X2) + ϵ의 예

x1 <- 1:1000
x2 <- 3 * x1
y <- 3 * ( x1 + x2 ) + rnorm (1000)
lm ( y ~ I ( x1 + x2 ) )

# x,y 별개
lm ( y ~ x1 + x2 )

# 2.5 변수의 변환

# ex1
x <- 101:200
y <- exp (3 * x + rnorm (100) )
lm ( log ( y ) ~ x )

plot(x,log ( y ))
abline(lm ( log ( y ) ~ x ))

# ex2
x <- 101:200
y <- log ( x ) + rnorm (100)
lm ( y ~ log ( x ) )

plot(log ( x ),y)
abline(lm ( y ~ log ( x ) ))

# I()와 같이 X∧2나 X∧3 등만의 표현 피하자

## 2.6 상호 작용
head(iris)
lm(Sepal.Length ~ Sepal.Width, iris)
lm(Sepal.Length ~ Sepal.Width + Species, iris)

# 상호작용 표현 
lm(Sepal.Length ~ Sepal.Width + Species + Sepal.Width:Species, iris) 

# 또 다른 상호작용
lm(Sepal.Length ~ Sepal.Width * Species, iris) 

# 만약 3개이상 변수면..
# 3개가 동시에 상호작용한다면 *
lm(Sepal.Length ~ Sepal.Width * Petal.Length * Species, iris)

# 3개중 2개만 상호작용한다면 ^2
lm(Sepal.Length ~ (Sepal.Width + Petal.Length + Species)^2, iris) 

# ex) Orange
data(Orange)
head(Orange)

with ( Orange ,
       plot ( Tree , circumference , xlab = "tree" , ylab = "circumference" ) )

# interaction.plot() : 상호작용 plot  
with ( Orange , interaction.plot ( age , Tree , circumference ) )

# 순서가 없는 범주형 변수로 변환
Orange [ , "fTree" ] <- factor ( Orange [ , "Tree" ] , ordered = FALSE )

m <- lm ( circumference ~ fTree * age , data = Orange )
anova ( m )

mm <- model.matrix ( m )
head ( mm )

mm[ , grep( "age" , colnames ( mm ) ) ]

### 3 이상치(outlier)

data ( Orange )
m <- lm ( circumference ~ age + I ( age ) , data = Orange )
rstudent ( m )


library ( car )
outlierTest ( m )
# 21이 가장 크지만 이상치는 아니다

data ( Orange )

# 이상치 강제 추가
Orange <- rbind ( Orange ,
                    data.frame ( Tree = as.factor ( c (6 , 6 , 6) ) ,
                                   age = c (118 , 484 , 664) ,
                                   circumference = c (177 , 50 , 30) ) )
tail ( Orange )



m <- lm ( circumference ~ age + I ( age ^2) , data = Orange )
outlierTest ( m )
# 36이 이상치 데이터로 검출


### 4 변수 선택

# 4.1 단계적 변수 선택
library ( mlbench )
data ( BostonHousing )
m <- lm ( medv ~ . , data = BostonHousing )
summary(m)

m2 <- step ( m , direction = "both" )

formula ( m2 )

# 4.2 모든 경우에 대한 비교
# install.packages("leaps")
library ( leaps )
m <- regsubsets ( medv ~ . , data = BostonHousing )
summary ( m )

summary(m)$bic
summary(m)$adjr2

plot(m)




















