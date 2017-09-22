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
n <- 1
f <- function(){
  print(n)
}
f()






































