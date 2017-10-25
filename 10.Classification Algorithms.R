### 1 데이터 탐색

# 1.1 기술 통계

# 데이터 간략 분포정보
summary ( iris )

# 데이터 간략 분포정보 + NA + unique
library ( Hmisc )
describe ( iris )

# 1.2 데이터 시각화
plot ( iris )
plot ( iris$Sepal.Length )
plot ( iris$Species )

#  데이터가 붓꽃의 어느 종별인지를 표현
plot ( iris $ Species ~ iris $ Sepal.Length , data = iris )

# Factor 타입의 Species를 숫자로 변환해 점의 색상(col)에 지정
plot ( iris $ Sepal.Length , col = as.numeric ( iris $ Species ) )

library ( caret )

# 종별 그림 유용한 패키지
# ellipse, strip, box, pairs
featurePlot(iris[,1:4] , iris$Species, "pairs")


### 2 전처리(Preprocessing)
# 2.1 데이터 변환
# 데이터 정규화(Feature Scaling)

# iris 데이터의 값을 정규화한 예
cbind ( as.data.frame ( scale ( iris [1:4]) ) , iris $ Species )
# scale()이 행렬을 반환, 데이터 프레임으로 변환 위해 as.data.frame() 사용
# Species는 정규화 제외후 cbind()로 통합

cbind ( as.data.frame ( scale ( iris [1:4]) ) , iris $ Species )

# PCA(Principal Componenet Analysis)

p <- princomp ( iris [ , 1:4] , cor = TRUE )
p 

summary ( p )
plot (p, type = "l"  )
predict (p , iris [ , 1:4])

# 범주형 변수의 재표현

( all <- factor ( c ( paste0 ( LETTERS , "0" ) , paste0 ( LETTERS , "1" ) ) ) )
( data <- data.frame ( lvl = all , value = rnorm ( length ( all ) ) ) )

# 이 데이터를 Random Forest에 입력으로 주면 32개 이상의 수준은 처리할 수 없다는 에러 메시지가 출력
# 32개 이상의 수준을 한번의 가지치기로 나누는 경우의 수가 약 2^32에 달하기때문에 지나치게 계산량이 많다고 본 때문

library ( randomForest )
m <- randomForest ( value ~ lvl , data = data )
m

plot(m)

# 해결법
# 1. 빈도가 적은 수준들을 하나로 묶기
# 2. 범주형 변수의 수준을 숫자로 취급
# 3. One Hot Encoding : 여러개의 가변수(dummy variables)를 사용해 범주형 변수를 재표현

# One Hot Encoding은 model.matrix()를 사용

( x <- data.frame ( lvl = factor ( c ( "A" , "B" , "A" , "A" , "C" ) ) ,
                    value = c (1 , 3 , 2 , 4 , 5) ) )

model.matrix (~ lvl , data = x ) [ , -1]


# 2.2 결측값(NA)의 처리

# complete.cases() : 결측치 존재 확인
# 각 행에 저장된 모든 값이 NA가 아닐때에만 TRUE

iris_na <- iris
iris_na [ c (10 , 20 , 25 , 40 , 32) , 3] <- NA
iris_na [ c (33 , 100 , 123) , 1] <- NA
iris_na [ ! complete.cases ( iris_na ) ,]

# 한 열에 대해서만 조사
iris_na [ is.na ( iris_na $ Sepal.Length ) , ]

# na처리 중앙값 대치
# 중앙값 구하기, na 처리 포함
mapply ( median , iris_na [1:4] , na.rm = TRUE )

# NA값 대치 가능한 패키지
# install.packages("DMwR")
library(DMwR)
iris_na [ ! complete.cases ( iris_na ) , ]

centralImputation ( iris_na [1:4]) [
  c (10 , 20 , 25 , 32 , 33 , 40 , 100 , 123) , ]

# 중앙값대신 knn 이용 (k개 근접 이웃의 가중 평균)
knnImputation( iris_na[1:4]) [ c (10 , 20 , 25 , 32 , 33 , 40 , 100 , 123) , ]


# 2.3 변수 선택(Feature Selection)

# 1. 데이터의 통계적 특성2)으로부터 변수를 택하는 Filter Method
# 2. 변수의 일부만을 모델링에 사용하고 그 결과를 확인하는 작업을 반복하면서 변수를 택해나가는 Wrapper Method
# 3. 모델 자체에 변수 선택이 포함된 Embedded methods로 분류

# 0에 가까운 분산(Near Zero Variance)

# 0에 가까운 분산은 효과 없음, 분산이 작은 변수 식

library ( caret )
library ( mlbench )
data ( Soybean )
nearZeroVar ( Soybean , saveMetrics = TRUE )

Soybean[,c("leaf.mild","mycelium","sclerotia")]

nearZeroVar(Soybean)

mySoybean <- Soybean [ , -nearZeroVar( Soybean ) ]


# 상관 계수(Correlation)

# caret의 findCorrelation()
# 상관계수 행렬을 입력으로 받아 임의의 변수와 다른 모든 변수간의 상관계수의 평균을 계산한 뒤
# 이 값이 주어진 threshold를 넘을 경우 해당 변수를 제거 가능한 변수로 나열
# findCorrelation()의 threshold 기본값은 0.90이다.


library ( mlbench )
data ( Vehicle )

str(Vehicle)

cor(subset(Vehicle,select=-c(Class)))
# 같은 결과 : cor(Vehicle[,-19])

findCorrelation ( cor ( subset ( Vehicle , select = -c( Class ) ) ) )
findCorrelation ( cor(Vehicle[,-19]) )

# 상관계수 높은 컬럼 제외
myVehicle <- Vehicle [ , -c (3 , 8 , 11 , 7 , 9 , 2) ]

library ( mlbench )
data ( Ozone )
( v <- linear.correlation ( V4 ~ . , data = subset ( Ozone , select = -c ( V1 , V2 , V3 ) ) ) ) 

plot(subset ( Ozone , select = -c ( V1 , V2 , V3 ) ) )




