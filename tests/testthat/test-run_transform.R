# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the ability to transform the dataset", {
    the$Location.File <- "test-1_group-STTtest_ToverC_scatter.txt"
    the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
    the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

    # populate the environment variables
    load_file_head()
    load_data()
    run_data()
    if (stats$Outlier != FALSE) { run_outlier() }
    run_stats_prep()

    # run actual tests
    if ("ANOVA" %in% stats$Test) { run_anova() }
    if ("STTest" %in% stats$Test) { run_sttest() }

    if (stats$Transform == "ToverC") { run_transform() }

    expect_equal(sprintf("%.10f", raw$base['Value'][[1]][3]), "1.0000000000")
    expect_equal(sprintf("%.10f", raw$base['Value'][[1]][8]), "1.0692089602")
    expect_equal(sprintf("%.10f", raw$base['Value'][[1]][35]), "1.3130299967")

})
