# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("init_vars loads some default data", {
  init_vars()
  expect_equal(fig$Y.Min, 0)
})

test_that("init_vars loads some default data", {
  init_vars()
  expect_equal(stats$Outlier, "TWO")
})
