# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the generation of statistical summaries", {
    the$Location.File <- "test-1_group-basic_no_stats.txt"
    the$Location.Dir <- system.file("extdata", the$Location.File, package="histova")
    the$Location.Dir <- substring(the$Location.Dir, 1, nchar(the$Location.Dir) - nchar(the$Location.File) -1 )

    # populate the environment variables
    load_file_head()
    load_data()
    if (stats$Outlier != FALSE) { run_outlier() }
    run_stats_prep()

    expect_equal(sprintf("%.10f", raw$summary['mean'][[1]][3]), '6.5184735827')
    expect_equal(raw$multi, "")
    expect_equal(sprintf("%.10f", raw$summary.multi['se'][[1]][5]), "1.0578800902")
    expect_equal(sprintf("%.10f", raw$summary.multi['IQR25'][[1]][2]), "4.6101896282")
    expect_equal(sprintf("%.10f", raw$summary.multi['IQR75'][[1]][6]), "5.5870814383")
    expect_equal(sprintf("%.10f", raw$summary.multi['upper'][[1]][4]), "9.7612703854")
})
