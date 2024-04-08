# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the determination of outliers", {
    the$Location.File <- "test-1_group-ANOVA_scatter_outlier.txt"
    the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
    the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

    # populate the environment variables
    load_file_head()
    load_data()
    expect_equal(sum(raw$base['Group1'] == "G1"), 6)
    if (stats$Outlier != FALSE) { run_outlier() }
    expect_equal(sum(raw$base['Group1'] == "G1"), 5)
    expect_equal(sprintf("%.10f", raw$outlier['pVal'][[1]][1]), '0.0023390267')
})
