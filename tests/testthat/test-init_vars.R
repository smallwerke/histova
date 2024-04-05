# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("init_vars loads some default data", {
  init_vars()
  expect_equal(fig$Y.Min, 0)
  expect_equal(stats$Outlier, "TWO")
  expect_equal(fig$Axis.X.Tick.Size, 0.6)
  expect_equal(fig$Facet.Split, TRUE)
  expect_equal(fig$Plot.Labels, "")
})
