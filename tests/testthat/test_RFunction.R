test_data <- test_data("input3.rds")

test_that("happy path", {
  actual <- rFunction(data = test_data, sdk = "unit test", year = 2005)
  expect_equal(unique(lubridate::year(actual@timestamps)), 2005)
})

test_that("year not included", {
  actual <- rFunction(data = test_data, sdk = "unit test", year = 2023)
  expect_null(actual)
})