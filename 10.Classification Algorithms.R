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

# install.packages("FSelector")
library ( FSelector )

( v <- linear.correlation ( V4 ~ . , data = subset ( Ozone , select = -c ( V1 , V2 , V3 ) ) ) ) 

plot(subset ( Ozone , select = -c ( V1 , V2 , V3 ) ) )

v [ order ( - v ) , , drop = FALSE ] # 정렬 # drop = FALSE : 벡터 변환여부

# Chi Square
# 예측대상이 되는 분류와 변수간에 수행하여 변수와 분류간의 독립성을 검정
# 둘간의 관계가 독립이라면 해당 변수는 모델링에 적합하지 않은 것

chi.squared ( Class ~. , data = Vehicle )

# 모델을 사용한 변수 중요도 평가
# caret::varImp() : 다양한 모델로부터 변수 중요도를 측정

library ( mlbench )
library ( rpart )
library ( caret )
data ( BreastCancer )
m <- rpart ( Class ~. , data = BreastCancer )
varImp ( m )


### 3 모델 평가 방법
# 3.1 평가 메트릭(metric)

predicted <- c (1 , 0 , 0 , 1 , 1 , 1 , 0 , 0 , 0 , 1 , 1 , 1)
actual <- c (1 , 0 , 0 , 1 , 1 , 0 , 1 , 1 , 0 , 1 , 1 , 1)

# 분할표(Contingency Table) 
xtabs ( ~ predicted + actual )

# Accuracy 계산
sum ( predicted == actual ) / NROW ( actual )

# caret의 confusionMatrix()
confusionMatrix ( predicted , actual )

cm <- confusionMatrix ( predicted , actual )
str ( cm )

cm $ overall[ "Accuracy" ]

# 3.2 ROC 커브

install.packages("ROCR")
library(ROCR)

probs <- runif (100)

labels <- as.factor ( ifelse ( probs > .5 & runif (100) < .4 , "A" , "B" ) )

pred <- prediction ( probs , labels )


plot ( performance ( pred, "tpr" , "fpr" ) )

plot ( performance ( pred , "acc" , "cutoff" ) )

performance ( pred , 'auc')

# 3.3 교차 검증(cross validation)

install.packages("cvTools")
library(cvTools)
set.seed (719)
( cv <- cvFolds ( NROW ( iris ) , K =10 , R =3) )

summary(cv)

head ( cv $ which , 20) #  Fold에 해당하는 부분
head ( cv $ subset ) # 실제 선택할 행을 저장한 부분

validation_idx <- cv$subset [ which ( cv$which == 1) , 1]
validation_idx

train <- iris [ -validation_idx , ]
validation <- iris [ validation_idx , ]

# 이를 사용해 K fold cross validation을 반복
library ( foreach )
set.seed (719)
R = 3
K = 10
cv <- cvFolds ( NROW ( iris ) , K =K , R = R )
foreach ( r =1: R ) %do% {
  foreach ( k =1: K , .combine = c ) %do% {
    validation_idx <- cv $ subsets [ which ( cv $ which == k ) , r ]
    train <- iris [ - validation_idx , ]
    validation <- iris [ validation_idx , ]
    # preprocessing
      
       # training
      
       # prediction
      
       # estimating performance
       # used runif for demonstration purpose
    return ( runif (1) )
  }
}

# label 을 고려한 데이터 분리

library ( caret )
( parts <- createDataPartition ( iris $ Species , p =0.8 ) )

# train data
table ( iris [ parts $ Resample1 , "Species" ])

# test data
table ( iris [ - parts $ Resample1 , "Species" ])



### 4 로지스틱 회귀모형(Logistic Regression)

data ( iris )
d <- subset ( iris , Species == "setosa" | Species == "versicolor" )
str ( d )

d $ Species <- factor ( d $ Species )
str ( d )

( m <- glm ( Species ~. , data =d , family = binomial ) )

fitted ( m ) [ c (1:5 , 51:55) ]

f <- fitted ( m )
f

as.numeric ( d $ Species )

is_correct <- ifelse ( f > .5 , 1 , 0) == as.numeric ( d $ Species ) - 1

sum ( is_correct )
sum ( is_correct ) / NROW( is_correct ) 

predict (m , newdata = d [ c (1 , 10 , 55) ,] , type = "response" )


### 5 다항 로지스틱 회귀분석(Multinomial Logistic Regression) 
library ( nnet )
( m <- multinom ( Species ~. , data = iris ) )

head ( fitted ( m ) )

predict (m , newdata = iris, type = "class" ) # class 예측
predict (m , newdata = iris , type = "probs" ) # 확률 예측


predicted <- predict (m , newdata = iris )
sum ( predicted == iris $ Species ) / NROW ( predicted )

xtabs (~ predicted + iris $ Species )


###  6 나무 모형(Tree Models)
# 6.1 rpart

( m <- rpart ( Species ~. , data = iris ) )

plot (m , compress = TRUE , margin = .2)
text (m , cex =1 )

library ( rpart.plot )
prp (m , type =4 , extra =2)

head ( predict (m , newdata = iris , type = "class" ) )


# 6.2 party::ctree
# ctree는 rpart의 의사 결정 나무가 가진 1) 과적합 문제, 2) 통계적 유의성을 보지 않는 문제를 해결하기위한 방식

library ( party )
( m <- ctree ( Species ~. , data = iris ) )
plot(m)


# 6.3 Random Forest
library ( randomForest )
m <- randomForest ( Species ~. , data = iris )
m

head ( predict (m , newdata = iris ) )

# X와 Y의 직접 지정
m <- randomForest ( iris [ ,1:4] , iris [ ,5])
m

# 변수 중요도 평가
m <- randomForest ( Species ~. , data = iris , importance = TRUE )
importance ( m )

varImpPlot (m , main = "varImpPlot of iris" )

# 파라미터 튜닝
# expand.grid() : 가능한 조합의 목록
( grid <- expand.grid ( ntree = c (10 , 100 , 200) , mtry = c (3 , 4) ) )

library ( cvTools )
library ( foreach )
library ( randomForest )
set.seed (719)
K = 10
R = 3
cv <- cvFolds ( NROW ( iris ) , K =K , R = R )
grid <- expand.grid ( ntree = c (10 , 100 , 200) , mtry = c (3 , 4) )
result <- foreach ( g =1: NROW ( grid ) , .combine = rbind ) %do% {
  foreach ( r =1: R , .combine = rbind ) %do% {
    foreach ( k =1: K , .combine = rbind ) %do% {
      validation_idx <- cv $ subsets [ which ( cv $ which == k ) , r ]
      train <- iris [ - validation_idx , ]
      validation <- iris [ validation_idx , ]
      # training
      m <- randomForest ( Species ~. ,
                          data = train ,
                          ntree = grid [g , "ntree" ] ,
                          mtry = grid [g , "mtry" ])
      # prediction
      predicted <- predict (m , newdata = validation )
      # estimating performance
      precision <- sum ( predicted == validation $ Species ) / NROW (
        predicted )
      return ( data.frame ( g =g , precision = precision ) )
    }
  }
}

result

library ( plyr )
ddply ( result , . ( g ) , summarize , mean_precision = mean ( precision ) )






### 7 신경망(Neural Networks)

# 7.1 Formula를 사용한 모델 생성
library ( nnet )
m <- nnet ( Species ~. , data = iris , size =3)

predict (m , newdata = iris )
pred = predict (m , newdata = iris , type = "class" )


# 7.2 X와 Y의 직접 지정

class.ind ( iris $ Species ) # Y(iris의 경우 Species)를 가변수(dummy variables)로 변환
m2 <- nnet ( iris [ , 1:4] , class.ind ( iris $ Species ) , size =3 , softmax = TRUE )

# 8 SVM(Support Vector Machine)
install.packages("kernlab")
library(kernlab)
( m <- ksvm ( Species ~ . , data = iris ) )

head ( predict (m , newdata = iris ) )

# kernel 목록
help(dots)
(m <- ksvm ( Species ~. , data = iris , kernel = "vanilladot" ))
head ( predict (m , newdata = iris ) )

# 커널에 사용하는 파라미터는 kpar에 리스트 형태로 값을 지정
( m <- ksvm ( Species ~. , data = iris , kernel = "polydot", kpar = list ( degree =3) ) )

# SVM 파라미터 튜닝
install.packages("e1071")
library ( e1071 )

result <- tune.svm ( Species ~ . , data = iris , gamma =2^( -1:1) , cost =2^(2:4) )

attributes ( result )




### 9 클래스 불균형(Class Imbalance)
library ( mlbench )
data ( BreastCancer )

table ( BreastCancer $ Class )
# 데이터를 무조건 benign으로만 예측해도 65.5%6)의 정확도
# 50:50 아니면 불균형 발생

# upSample, donwSample
library ( caret )
x <- upSample ( subset ( BreastCancer , select = - Class ) ,BreastCancer $ Class )
table ( BreastCancer $ Class )
table ( x $ Class )

# 작은쪽 중복 추출된 것 확인                
NROW ( x )
NROW ( unique ( x ) )


library ( party )
library ( rpart )
data <- subset ( BreastCancer , select = - Id )
parts <- createDataPartition ( data $ Class , p = .8 )
data.train <- data [ parts $ Resample1 ,]
data.validation <- data [ - parts $ Resample1 , ]
m <- rpart ( Class ~. , data = data.train )
confusionMatrix ( data.validation $ Class ,
                    predict (m , newdata = data.validation , type = "class" ) )

# upsample 비교
data.up.train <- upSample ( subset ( data.train , select = - Class ) , data.train $ Class )
m <- rpart ( Class ~ . , data = data.up.train )
confusionMatrix ( data.validation $ Class , predict (m , newdata = data.validation , type = "class" ) )

# SMOTE :  비율이 적은 분류의 데이터를 생성하는 방법

data ( iris )
data <- iris [ , c (1 , 2 , 5) ]
data $ Species <- factor ( ifelse ( data $ Species == "setosa" ,"rare" ,"common" ) )
table ( data $ Species )

library(DMwR)
newData <- SMOTE ( Species ~ . , data , perc.over = 600 , perc.under =100)
table ( newData $ Species )

# perc.over는 갯수가 적은 분류로부터 얼마나 많은 데이터를 생성해낼지(즉 over sampling)를 조정하는 변수
# perc.under는 갯수가 많은 분류의 데이터에서의 under sampling을 조정하는변수


### 10 문서 분류(Document Classification)

# 10.1 코퍼스와 문서
library ( tm )
data ( crude )
summary ( crude )

inspect(crude[1])

# 10.2 문서 변환

# 글자들을 모두 소문자로 바꾸고 문장 부호를 제거
inspect ( tm_map ( tm_map ( crude , tolower ) , removePunctuation ) [1])

# 함수목록
getTransformations()



# 10.3 문서의 행렬 표현
# TermDocumentMatrix(), DocumentTermMatrix()

( x <- TermDocumentMatrix ( crude ) )

inspect ( x [1:10 , 1:10])

# TF-IDF

x <- TermDocumentMatrix ( crude , control = list ( weighting = weightTfIdf ) )
inspect ( x [1:10 , 1:5])

# findFreqTerms(), findAssocs()
# 전체 20개 문서로 구성된 crude에서 10회 이상 출현한 단어

findFreqTerms ( TermDocumentMatrix ( crude ) , lowfreq =10)

# 전체 단어와 문서의 목록
x <- TermDocumentMatrix ( crude )
head ( rownames ( x ) )
head ( colnames ( x ) )

# findAssocs()는 term × document 행렬과 특정 term 이 주어졌을때 그 term과 상관계수가 높은 term들

findAssocs ( TermDocumentMatrix ( crude ) , "oil" , .7 )

# 10.4 문서 분류
# 데이터 준비

data ( crude )
data ( acq )
to_dtm <- function ( corpus , label ) {
  x <- tm_map ( corpus , tolower )
  x <- tm_map ( corpus , removePunctuation )
  return ( DocumentTermMatrix ( x ) )
}

crude_acq <- c ( to_dtm ( crude ) , to_dtm ( acq ) )
crude_acq_df <- cbind (
  as.data.frame ( as.matrix ( crude_acq ) ) ,
  LABEL = c ( rep ( "crude" , 20) , rep ( "acq" , 50) ) )

str ( crude_acq_df )

# 모델링
library ( caret )

# 8:2
train_idx <- createDataPartition (
  crude_acq_df $ LABEL , p =.8 ) $ Resample1
crude_acq.train <- crude_acq_df [ train_idx , ]
crude_acq.validation <- crude_acq_df [ - train_idx , ]

library ( rpart )
m <- rpart ( LABEL ~ . , data = crude_acq.train )

confusionMatrix (
  predict (m , newdata = crude_acq.validation , type = "class" ) ,
  crude_acq.validation $ LABEL )

# 10.5 파일로부터 Corpus 생성
# 문서를 읽는 소스
getSources()

docs <- read.csv ( "a.csv" , stringsAsFactors = FALSE )
docs
str ( docs )

# corpus 변환
corpus <- Corpus ( DataframeSource ( docs [ ,2:3]) )
inspect ( corpus )

# 10.6 메타 데이터
# corpus, local, indexed
# corpus : 전체
# local : 개별 포함
# indexed : 개별 별도

data ( crude )
meta ( crude , type = "corpus" )
meta ( crude , type = "local" )

meta ( crude [1] , type = "local" )

meta ( crude ) # indexed 타입은 기본값

meta ( corpus , "Label" ) <- docs[ , "name" ]
meta ( corpus ) # indexed 타입은 기본값

