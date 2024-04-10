# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the generation of STTest results", {
    the$Location.File <- "test-1_group-STTtest_ToverC_scatter.txt"
    the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
    the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

    # populate the environment variables
    load_file_head()
    load_data()
    if (stats$Outlier != FALSE) { run_outlier() }
    run_stats_prep()

    # run actual tests
    if ("ANOVA" %in% stats$Test) { run_anova() }
    if ("STTest" %in% stats$Test) { run_sttest() }

    expect_equal(sprintf("%.10f", stats$STTest.Pairs$sttest[[1]]$p.value), "0.6304585696")
    expect_equal(sprintf("%.10f", stats$STTest.Pairs$sttest[[3]]$conf.int[[2]]), "-2.2889765614")
    expect_equal(stats$STTest.Pairs$g2[4], "G5")

})
