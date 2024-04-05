# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("init_vars loads some default data", {
    the$Location.File <- "test-1_group-basic_no_stats.txt"
    the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
    the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

    load_data()
    expect_equal(raw$base['Value'][[1]][1], 3.250392)
    expect_equal(raw$base['Value'][[1]][20], 11.09730178)
    expect_equal(toString(raw$base['Group1'][14,]), "G3")
})
