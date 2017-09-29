### 제어문/연산/함수

## R만의 특징 
# 1. 저장된 데이터를 한번에 다루는 벡터연산 수행
# 2. 결측치(NA) 다루기



# 1. IF,FOR.WHILE

if(TRUE){
  print('TRUE')
  print('hello')
}else{
  print('FALSE')
  print('world')
}

for(i in 1:10){
  print(i)
}

i <- 0
while( i < 10){
  print(i)
  i <- i + 1
}

# 2. 행렬연산
x = matrix(c(1,2,3,4),nrow = 2, byrow = T)
x
x+x      # 합
x %*% x  # 행렬곱
t(x)     # 전치행렬
solve(x) # 역행렬

# 3.NA의 처리
NA & TRUE # 결측치가 데이터에 포함되어 있으면 연산결과가 NA로 바뀜
NA + 1

sum(c(1,2,3,NA))
sum(c(1,2,3,NA), na.rm = T) #NA값 제거여부

# caret: Classification and Regression Training
# caret에서 na처리 패키지
# na.omit, na.pass, na.fail -> na.action

x <- data.frame(a=c(1,2,3), b=c("a", NA, "C"), c=c("a", "b", NA))
x 
na.omit(x) # NA가 포함된 행 제외
na.pass(x) # NA가 포함여부 무시
na.fail(x) # NA 포함시 에러
# na.action으로 데이터 정제

# 4. 함수의 정의

# 함수명 <- function(인자,인자, ...){ 함수본문 }
# return 형태 : return() or 마지막 값
fibo <- function(n){
  if(n==1 || n==2){
    # return(1)
    1
  }else{
    # return( fibo(n-1) + fibo(n-2))
    fibo(n-1) + fibo(n-2)
  }
}

fibo(1)
fibo(6)

# 함수호출시 
# 1. 인자의 위치를 맞춰서 넘겨주는방식
# 2. 이름 명명해서 넘겨주는 방식

f <- function(x,y){
  print(x)
  print(y)
}

f(1,2)
f(y=1, x=2)

# ... 임의의 인자들을 받아서 다른함수에 넘겨주는 용도

g <- function(z, ...){
  print(z)
  f(...)
}

g(1,2,3)

# 함수안에 함수 : 중첩함수(Nested Function)
f <- function(x,y){
  print(x)
  
  g <- function(y){
    print(y)
  }
  
  g(y)
}

f(5,6)

# 5. 스코프(Scope)

# lexial (or static) scope : 전역변수

n <- 1          # 모든 곳에서 사용가능 : 전역변수
f <- function(){
  print(n)
}
f()

n <- 2
f()

# 지역변수
n <- 100
f <- function(){
  n <- 1    # 함수내부에서만 사용가능 : 지역변수
  print(n)
}
f()

# 전역/지역 모두 변수가 없으면 에러..
rm(list = ls())
f <- function(){
  print(x)  
}
f() 

# 함수안의 변수 먼저 찾기
n <- 100
f <- function(n){
  print(n)
}
f(1)

# 중첩함수도 같은 규칙
f <- function(x){
  a <- 2
  g <- function(y){
    print(y+a)
  }
  g(x)
}
f(1)

# 함수내 변수가 없다면 전역변수 사용
a <- 100
f <- function(x){
  g <- function(y) {
    print(y + a)
  }
  g(x)
}
f(1)

# 전역변수/부모변수 변경의도.. but
f <- function(){
  a <- 1
  g <- function(){
    a <- 2     # 부모변수 바꿀의도...
    print(a)
  }
  g()
  print(a)
}
f()

# 부모/전역 바꾸려면... <<- 사용
b <- 0
f <- function(){
  a <- 1
  g <- function(){
    a <<- 2
    b <<- 2
    print(a)
    print(b)
  }
  g()
  print(a)
  print(b)
}
f()

# 6.벡터연산
# 벡터 or 리스트를 한번에 연산 (for대신)

x <- c(1,2,3,4,5)
x + 1 
x + x

x == x
x == c(1,2,3,4,5)
c(T,T,T) & c(T,F,T)
c(T,T,T) && c(T,F,T)

# sum,mean,median
x <- c(1,2,3,4,5)
sum(x)
mean(x)
median(x)
ifelse(x %% 2 ==0, "even", "odd")

# 특정행 정보만 가져오기
(d <- data.frame(x=c(1,2,3,4,5), y=c("a","b","c","d","e")))
d[c(TRUE,TRUE,FALSE,TRUE,TRUE),]
d[ d$x %% 2 == 0,]

# 7. 값에 의한 전달(Pass By Value)

# java/c는... 참조에 의한 전달로 전달함수가 변경..
# R은 값의 의한 전달로...  함수내부변경은 원래객체 미반영
# 즉, 값을 복사해서 전달

f <- function(df2){
  df2$a <- c(1,2,3) # df2는 복사된 새로운 객체
}
df <- data.frame(a=c(4,5,6))
f(df) # 값의 의한 전달 ( df값이 복사되어 전달)
df    # 원래 객체 변경없음

f <- function(df){
  df$a <- c(1,2,3) # copy on write -> 이때 복사.. 실제로 복사가 필요할때
  return(df)
}
df <- data.frame(a=c(4,5,6))
df <- f(df) # <- 이때 복사가 아님
df

# 8. 객체의 불변성(immutable)
# R의 모든 객체는 불변

a <- list()
a$b <- c(1,2,3) # 이전 객체 a 변경이 아니라 새로운 객체 생성후 a에 할당

v = 1:1000
for( i in 1:1000 ){
  v[i] <- v[i] + 1
} # 1000 개의 수정된 벡터를 만들어 비효율적.. 벡터연산으로 하면..

v <- 1:1000
v <- v + 1 # 1개 객체 만든 후 v에 할당
v

rm(list=ls())     # 모든 선언된 변수 삭제
gc()              # 현재 사용하지 않는 변수들 메모리에서 삭제
v <- 1:9999999
for( i in 1:9999999 ){
  v[i] <- v[i] + 1
}
v <- v+1 #속도가 10배이상 빠름..빠름...
v

# 9. 모듈(Module) 패턴
# 모듈 = 
#  1. 외부에서 접근할 수 없는 데이터와 
#  2. 그 데이터를 제어하기 위한 함수
# 객체 지향에서.. 캡슐화와 비슷한 개념..인듯..

# 9.1 큐(Queue)
# Enqueue : 줄 맨 뒤 데이터 추가
# Dequeue : 줄 맨 앞 데이터 추출
# Size    : 줄의 길이

q <- c()
q_size <- 0

enqueue <- function(data) {
  q <<- c(q, data)
  q_size <<- q_size + 1
}

dequeue <- function(data) {
  first <- q[1]
  q <<- q[-1]
  q_size <<- q_size -1
  return(first)
}

size <- function(){
  return(q_size)
}

enqueue(1)
enqueue(3)
enqueue(5)

print(size())
print(dequeue())
print(dequeue())
print(dequeue())
print(size())

# 9.2 Queue 모듈 작성
rm(list = ls())
gc()

queue <- function(){
  q <- c()
  q_size <- 0
  
  enqueue <- function(data) {
    q <<- c(q, data)
    q_size <<- q_size + 1
  }
  
  dequeue <- function(data) {
    first <- q[1]
    q <<- q[-1]
    q_size <<- q_size -1
    return(first)
  }
  
  size <- function(){
    return(q_size)
  }
  
  return(list(enqueue=enqueue, dequeue=dequeue, size=size))
}

q <- queue()
q$enqueue(1)
q$enqueue(3)
q$size()

q$dequeue()
q$dequeue()
q$size()

# 10. 객체의 삭제
x <- c(1,2,3,4,5)
ls()

rm("x")
ls()

rm(list=ls())





















































