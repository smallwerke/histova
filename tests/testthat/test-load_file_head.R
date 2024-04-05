# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("init_vars loads some default data", {
  the$Location.File <- "test-1_group-basic_no_stats.txt"
  the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
  the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

  load_file_head()
  expect_equal(fig$Scatter.Disp, FALSE)
  expect_equal(fig$Y.Max, 20)
  expect_equal(fig$Y.Interval, 5)
  expect_equal(fig$Y, "µ values")
  expect_equal(the$Override, FALSE)
  expect_equal(stats$Letters.Size, 18)


})
