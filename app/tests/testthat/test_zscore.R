library(testthat)
library(comevizz)

context("zscore")

test_that("Constructor set only numeric data", {
  # setup
  names <- c("pj1", "pj2", "pj3", "pj4", "pj5")
  m1 <- c(1, 2, 3, 4, 5)
  m2 <- c(10, 20, 30, 40, 50)
  m3 <- c("str1", "str2", "str3", "str4", "str5")
  all <- data.frame(
    names = names,
    metrics1 = m1,
    metrics2 = m2,
    metrics3 = m3
  )
  target <- data.frame(
    names = names[1],
    metrics1 = m1[1],
    metrics2 = m2[1],
    metrics3 = m3[1]
  )
  params <- list("metrics1", "metrics2")

  # when
  actual <- Zscore$new(all, target, params)

  # then
  # checking to be filtered non-numeric data
  expect_equal(
    actual$all_metrics,
    data.frame(metrics1 = m1, metrics2 = m2)
  )
  # checking to be filtered non-numeric data
  expect_equal(
    actual$target_metrics,
    data.frame(metrics1 = m1[1], metrics2 = m2[1])
  )

  expect_equal(actual$get_metrics_names(), unlist(params))
})

test_that("calculate_zscore_plot calculates the zscore of target", {
  # setup
  names <- c("pj1", "pj2", "pj3", "pj4", "pj5")
  m1 <- c(1, 2, 3, 4, 5)
  m2 <- c(10, 20, 30, 40, 50)
  m3 <- c("str1", "str2", "str3", "str4", "str5")
  all <- data.frame(names = names, metrics1 = m1, metrics2 = m2, metrics3 = m3)
  target <- data.frame(
    names = names[1],
    metrics1 = m1[1],
    metrics2 = m2[1],
    metrics3 = m3[1]
  )
  params <- list("metrics1", "metrics2")

  # when
  actual <- Zscore$new(all, target, params)

  # then
  zscore <- actual$calculate_zscore_plot()
  expect_equal(zscore[1, 1], 2) # static value
  expect_equal(zscore[2, 1], -2)  # static value
  expect_equal(round(zscore[3, 1], 5), 1.26491)
  expect_equal(zscore[1, 2], 2) # static value
  expect_equal(zscore[2, 2], -2)  # static value
  expect_equal(round(zscore[3, 2], 5), 1.26491)
})
