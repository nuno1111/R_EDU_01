context("fibonacci series")

test_that("base case",{
  expect_equal(1, fib(0))
  expect_equal(1, fib(1))           
})

test_that("recursion case",{
  expect_equal(2, fib(2))           
  expect_equal(3, fib(3))           
  expect_equal(4, fib(4))           
})
