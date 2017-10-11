library(testthat)
library(comevizz)

context("zscore_metrics")

test_that("TestConstructor", {
  # setup
  name <- "MetricsName"
  arg <- 1
  
  # when
  target <- ZscoreMetrics$new(name, function(i){ return(i) })
  
  # then
  expect_equal(target$name, name)
  expect_equal(class(target$func), "function")
  expect_equal(target$func(arg), arg)
})

test_that("FailedConstructByInvalidArgType", {
  # when
  expect_error(ZscoreMetrics$new(1, function(i){ return(i) }))
  expect_error(Zscoreetrics$new("character", "should be function type"))
})
