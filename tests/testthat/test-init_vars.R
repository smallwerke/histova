test_that("init_vars loads some default data", {
  init_vars()
  expect_equal(the$Fig.Y.Min, 0)
})
