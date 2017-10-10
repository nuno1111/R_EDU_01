fibo <- function(n){
  if(n < 2 ){
    return(1)
  }
  if(2 <= n ){
    return(fib(n-1) + fib(n-2))
  }
}