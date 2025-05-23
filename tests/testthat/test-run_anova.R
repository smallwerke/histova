# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the generation of ANOVA results", {
    the$Location.File <- "test-1_group-ANOVA_scatter_outlier.txt"
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

    expect_equal(sprintf("%.10f", raw$anova.multi['residuals'][[1]][2]), "-0.3801165388")
    expect_equal(sprintf("%.10f", raw$aov.multi['residuals'][[1]][18]), "-0.8578429163")
    expect_equal(sprintf("%.10f", raw$aov.tukey.multi['statGroups'][[1]][1,4]), "0.9971636011")
    expect_equal(sprintf("%.10f", raw$aov.tukey.multi['statGroups'][[1]][10,4]), "0.1040190269")

})
