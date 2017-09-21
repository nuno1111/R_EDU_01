# 정수, 부동소수, 문자열
# 벡터(vector), 행렬(matrix), 데이터 프레임(data frame), 리스트(list)

##### 1. 변수 #####
# R의 변수명은 알파벳, 숫자,‘.’ 로구성되며 첫글자는 문자 또는 ‘.’ 으로 시작해야한다. 
# 만약 ‘.’ 으로 시작한다면 ‘.’ 뒤에는 숫자가 올 수 없다

##### 2. 스칼라 #####
# 2.1 숫자

a <- 3
b <- 4.5
c <- a + b

print(c)

# 2.2 NA 
# 데이터 값이 존재하지 않는 경우
# 즉, 결측치

one <- 100
two <- 75
three <- 75
four <- NA
is.na(four) # NA 확인 

# 2.3 NULL 
# NULL 객체를 뜻함
# 변수가 초기화 되지 않은 경우 사용 NA와 다름
x <- NULL
is.null(x)
is.null(1)
is.null(NA)
is.na(NULL)

# 2.4 문자열
a <- "hello"
print(a)


# 2.5 진리값
# TRUE, T는 참값 FALSE, F는 거짓
# &, |, ! 연산자

TRUE & TRUE
TRUE & FALSE
TRUE | TRUE
TRUE | FALSE
!TRUE
!FALSE
# TRUE는 예약어, T는 전역변수

# &, | 는 벡터연산 &&, || 는 단항연산

c(TRUE,TRUE) & c(TRUE,FALSE)
c(TRUE,TRUE) && c(TRUE,FALSE)
c(TRUE,TRUE) && c(FALSE,TRUE)
c(TRUE,TRUE) && FALSE

# &&, || 는 숏컷 연산
TRUE && FALSE # TRUE만 계산 FALSE는 SKIP

# 2.6 요인(Factor)
# 범주형 변수를 위한 데이터 타입

sex <- factor("m",c("m","f"))
sex

nlevels ( sex )
levels ( sex )

levels ( sex )[1]
levels ( sex )[2]

levels(sex) <- c('male','female')
sex

# factor() 는 기본적으로 데이터에 순서가 없는 명목형 변수 (Norminal)
# 순서형 (Ordinal) 가능

ordered(c("a","b","c"))
factor(c("a","b","c"), ordered = TRUE)

##### 3. 벡터 #####
# 3.1 벡터의 정의 : 타 언어 배열과 유사

x <- c(1,2,3,4,5) # 벡터는 한가지 타입
x
x <- c("1",2,"3") # 다른 타입은 자동 변환
x
c(1,2,3,c(1,2,3)) # 벡터는 중첩불가 / 중첩은 List

# 숫자형 벡터 start:end 혹은 seq(from, to, by)
x <- 1:10
x
x <- 5:10
x
seq(1,10,2)

seq_along(c("a","b","c")) # 주어진 데이터의 길이만큼 1 ~ N으로 구성된 벡터
seq_len(3) # N값이 인자 / 1 ~ N으로 구성된 벡터 반환

# 벡터 각 셀 이름부여
x <- c(1,3,4)
names(x) <- c("kim","seo","park")
x

# 3.2 벡터내 데이터 접근
# [] 사용
x <- c("a","b","c")
x[1]
x[3]

# 음수사용 특정요소 제외
x <- c("a","b","c")
x[-1]
x[-2]

# 여러값 가져오기
x <- c ( " a " , " b " , " c " )
x[c(1,2)]
x[c(1,3)]
x[1:2]
x[1:3]

# names 이름 부여 / 이름을 사용해 데이터 접근
x <- c(1,3,4)
names(x) <- c("kim","seo","park")
x
x["seo"]
x[c("seo","park")]

# 벡터에 부여된 이름 조회
names(x)
names(x)[2]


# 벡터의 길이
# length() , NROW()
# cf) nrow()는 행렬의 행의수

x <- c("a","b","c")
length(x)
nrow(x) # 행렬(matrix용)
NROW(x) # 행렬,벡터 모두 가능

# 3.3 벡터연산
"a" %in% c("a","b","c") # 벡터내 데이터 포함여부 연산 %in%
"d" %in% c("a","b","c")


# 집합(set)연산가능
setdiff(c("a","b","c"),c("a","d")) # 차집합
union(c("a","b","c"),c("a","d"))   # 합집합
intersect(c("a","b","c"),c("a","d"))   # 교집합

# 집합간 비교
setequal(c("a","b","c"),c("a","d"))
setequal(c("a","b","c"),c("a","b","c","c"))

# 3.4 seq
# seq(시작값, 마지막값,증가치)
seq(1,5)
seq(1,5,2)
1:5

# 3.5 rep
# 특정값들의 반복된 벡터
rep(1:2,5) # 1,2를 총5회 반
rep(1:2,each=5) # 1이 5회, 2가 5회

##### 4.List ##### 
# 4.1 리스트 정의
# 타 언어의 Map 이나 Dictionary과유사
# Key-Value로 값 저장
x <- list(name="foo", height=70)
x 

x <- list(name="foo", height=c(1,3,4)) # 값은 스칼라 / 벡터 / 중첩 가능

list(a=list(val=c(1,2,3)), b=list(val=c(1,2,3,4)))

# 4.2 리스트내 데이터 접근
# 리스트변수명$키
# 리스트변수[[인덱스]]
x <- list(name="foo", height=c(1,3,4))
x$name
x$height

x[[1]]
x[[2]]
  
x[1] # 주의 / [인덱스] 는 값이 아니라 서브리스트 반환
x[2]

##### 5.행렬(Matrix) ######
# 5.1 행렬정의
# 벡터와 마찬가지로 한가지 유형의 스칼라만 저장

matrix(c(1,2,3,4,5,6,7,8,9), nrow=3) # 좌측열부터
matrix(c(1,2,3,4,5,6,7,8,9), ncol=3) 

matrix(c(1,2,3,4,5,6,7,8,9), nrow=3, byrow = T) # 상위행부터

matrix(c(1,2,3,4,5,6,7,8,9), nrow=3,
       dimnames = list ( 
         c("item1","item2","item3"),
         c("feature1","feature2","feature3")
       )) # 행과 열에 명칭 부여

# 5.2 행렬내 데이터 접근
# 행렬이름[행인덱스,열인덱스]
x <- matrix(c(1,2,3,4,5,6,7,8,9), ncol=3) 

x[1,1]
x[1,2]
x[2,1]
x[2,2]

x[1:2,] # 특정 여러 행 , 모든 열
x[-3,]  # 3행 제외
x[c(1,3),c(1,3)] # 3행 제외


x <- matrix(c(1,2,3,4,5,6,7,8,9), nrow=3,
       dimnames = list ( 
         c("item1","item2","item3"),
         c("feature1","feature2","feature3")
       )) 

x["item1",]

# 5.3 행렬의 연산

x <- matrix ( c (1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9) , nrow =3)

# 행렬 스칼라 연산
x * 2 
x / 2
x + x
x - x 

x %*% x # 행렬 곱

# 역행렬
x <- matrix ( c (1 , 2 , 3 , 4) , nrow =2)
solve(x) # 역행렬
x %*% solve(x)

# 전치행렬
x <- matrix ( c (1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9) , nrow =3)
x
t(x) # 전치행렬

# 행렬의 차원
x <- matrix ( c (1 , 2 , 3 , 4 , 5 , 6 ) , ncol =3)
x

ncol(x)
nrow(x)

##### 6.배열(array) ######

# 6.1 배열 정의
# matrix가 2차원 행렬이라면 배열은 n차원 행렬
matrix(1:12, ncol=4)
array(1:12, dim=c(3,4))
array(1:12, dim=c(2,2,3)) # 3차원

# 6.2 배열 데이터 접근
x <- array(1:12, dim=c(2,2,3)) # 3차원
x

x[1,1,1]
x[1,2,3]

##### 7.데이터프레임 (Data Frame) ######
# 7.1 데이터프레임 정의
# 가장 중요 행렬과 달리 다양한 타입을 컬럼(열)별로 저장
# 각 열은 타입이 

d <- data.frame(x=c(1,2,3,4,5),y=c(2,4,6,8,10))
d

d <- data.frame(x=c(1,2,3,4,5)
                ,y=c(2,4,6,8,10)
                ,z=c('M','F','M','F','M')
                )
# 새로운 열 추가
d$V <- c(3,6,9,12,15)
d

# 7.2 데이터 프레임 접근
d$x
d[1,]
d[1,2]
d[c(1,3),2]
d[-1,-c(2,3)] # 제외는 마이너스
d[,c("x","y")]
d[,c("x")] # 데이터프레임의 컬럼 차원 1이면 벡터로 값을 반환
d[,c("x"), drop=F] # 벡터를 피할경우

# str : 내부구조 확인
str(d)

# head : 데이터 앞부분
head(d)
 
# DF 행/열 이름
x <- data.frame(1:3)
colnames(x) <- c('val')
rownames(x) <- c('a','b','c')
x

# 특정열 열명으로 선택
(d <- data.frame(a=1:3, b=4:6, c=7:9))

d[,names(d) %in% c("b","c")]
d[,c(FALSE,TRUE,TRUE)]

d[,!names(d) %in% c("a")] # 특정열 제외

##### 8.타입 판별 ######
class(1)
class(c(1,2))
class(matrix(c(1,2)))
class(list(c(1,2)))
class(data.frame(x=c(1,2)))

# 데이터 타입 확인 : str()

str(c(1,2))
str(matrix(c(1,2)))
str(list(c(1,2)))
str(data.frame(x=c(1,2)))

# 데이터 타입 확인 : is.*
is.numeric(c(1,2,3))
is.numeric(c('a','b','c'))
is.matrix(matrix(c(1,2)))

##### 9.타입 변환 ######

# matrix to data.frame
x <- data.frame(matrix(c(1,2,3,4),ncol=2))
x
colnames(x) <- c("X","Y")
x

# list to data.frame
x <- data.frame(list(x=c(1,2),y=c(3,4)))
x

# as.*
x <- c("m","f")
as.factor(x)
as.numeric(as.factor(x)) # Level순서따라 f->m = 1->2

f <- factor(c("m","f"), levels = c("m","f"))# Level 순서 고정
as.numeric(f) 





