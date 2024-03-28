test_that("init_vars loads some default data", {
  init_vars()
  expect_equal(fig$Y.Min, 0)
})
