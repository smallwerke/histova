# turn off ALL printing from histova_msg for the test process
the$MUTE = TRUE
test_that("testing the ability to build a labels from the general flow", {
    the$Location.File <- "test-1_group-ANOVA_scatter_outlier.txt"
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

    if (stats$Transform == "ToverC") {

        run_transform()
        # run the stats prep again to set the summary tables to the new values
        run_stats_prep()

        # remove the treatment group (it will be indicated by a line at 1)
        stats$Group1.Mute = stats$Transform.Treatment[1]
        fig$Plot.HLine = data.frame(y=c(1),size=c(1),color=c("black"))
    }

    # if the Y-values were adjusted (eg all divided by 1,000 - in run_stats_prep()) this will append the modification
    # to the end of your y-axis label - you can select one or two lines...
    if (is.numeric(fig$Y.Rig)) {
        if (fig$Y.Rig.Newline) {
            # Two Lines
            #Fig.Y = bquote(bold(atop(.(Fig.Y), "(" * .(Fig.Y.Supp[[1]]) * ")")))
            fig$Y = bquote(atop(.(fig$Y), "(" * .(fig$Y.Supp[[1]]) * ")"))
        } else {
            # Single Line
            fig$Y = bquote(.(fig$Y)~"("*.(fig$Y.Supp[[1]])*")")
        }
    }

    # this may not be 100% necessary if the
    # the t-tests should be run on the remaining groups POST transformation
    # but BEFORE removal of the control group
    if (stats$Transform == "ToverC") {
        if ("STTest" %in% stats$Test) { run_sttest() }
    }

    # remove a group from being displayed (eg for treatment / control figures)
    if ((stats$Group1.Mute != FALSE) && (stats$Anova.Group2 == FALSE)) {

        histova_msg(sprintf("group1Mute is set to %s, attempting to remove this group! (file: %s)", stats$Group1.Mute, the$Location.File), type="warn", tabs=2)

        # convenient function but causes notes in packages...
        raw$base = raw$base[raw$base$Group1 != stats$Group1.Mute, ]
        raw$base[] = lapply(raw$base, function(x) if(is.factor(x)) factor(x) else x)

        raw$summary = raw$summary[raw$summary$Group1 != stats$Group1.Mute, ]
        raw$summary[] = lapply(raw$summary, function(x) if(is.factor(x)) factor(x) else x)

        raw$summary.multi = raw$summary.multi[raw$summary.multi$Group1 != stats$Group1.Mute, ]
        raw$summary.multi[] = lapply(raw$summary.multi, function(x) if(is.factor(x)) factor(x) else x)
    }

    # the ANOVA test should be run on the remaining groups POST transformation
    if (stats$Transform == "ToverC") {
        if ("ANOVA" %in% stats$Test) { run_anova() }
        # following vars are set in run_anova() (raw.anova.multi, raw.aov.multi, raw.aov.tukey.multi)
    }

    histova_msg("Build Histogram", type="head")
    set_aesthetics()
    # the generate_label_df function is called from within build_histo()...
    build_histo()

    expect_equal(sprintf("%.10f", stats$Tukey.Levels[[10]]), "0.1040190269")
    expect_equal(sprintf("%.10f", stats$Tukey.Levels[[15]]), "0.0000083847")
})

test_that("testing the ability to build a labels from a direct call to generate_label_df", {
    the$Location.File <- "test-1_group-ANOVA_scatter_outlier.txt"
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

    if (stats$Transform == "ToverC") {

        run_transform()
        # run the stats prep again to set the summary tables to the new values
        run_stats_prep()

        # remove the treatment group (it will be indicated by a line at 1)
        stats$Group1.Mute = stats$Transform.Treatment[1]
        fig$Plot.HLine = data.frame(y=c(1),size=c(1),color=c("black"))
    }

    # if the Y-values were adjusted (eg all divided by 1,000 - in run_stats_prep()) this will append the modification
    # to the end of your y-axis label - you can select one or two lines...
    if (is.numeric(fig$Y.Rig)) {
        if (fig$Y.Rig.Newline) {
            # Two Lines
            #Fig.Y = bquote(bold(atop(.(Fig.Y), "(" * .(Fig.Y.Supp[[1]]) * ")")))
            fig$Y = bquote(atop(.(fig$Y), "(" * .(fig$Y.Supp[[1]]) * ")"))
        } else {
            # Single Line
            fig$Y = bquote(.(fig$Y)~"("*.(fig$Y.Supp[[1]])*")")
        }
    }

    # this may not be 100% necessary if the
    # the t-tests should be run on the remaining groups POST transformation
    # but BEFORE removal of the control group
    if (stats$Transform == "ToverC") {
        if ("STTest" %in% stats$Test) { run_sttest() }
    }

    # remove a group from being displayed (eg for treatment / control figures)
    if ((stats$Group1.Mute != FALSE) && (stats$Anova.Group2 == FALSE)) {

        histova_msg(sprintf("group1Mute is set to %s, attempting to remove this group! (file: %s)", stats$Group1.Mute, the$Location.File), type="warn", tabs=2)

        # convenient function but causes notes in packages...
        raw$base = raw$base[raw$base$Group1 != stats$Group1.Mute, ]
        raw$base[] = lapply(raw$base, function(x) if(is.factor(x)) factor(x) else x)

        raw$summary = raw$summary[raw$summary$Group1 != stats$Group1.Mute, ]
        raw$summary[] = lapply(raw$summary, function(x) if(is.factor(x)) factor(x) else x)

        raw$summary.multi = raw$summary.multi[raw$summary.multi$Group1 != stats$Group1.Mute, ]
        raw$summary.multi[] = lapply(raw$summary.multi, function(x) if(is.factor(x)) factor(x) else x)
    }

    # the ANOVA test should be run on the remaining groups POST transformation
    if (stats$Transform == "ToverC") {
        if ("ANOVA" %in% stats$Test) { run_anova() }
        # following vars are set in run_anova() (raw.anova.multi, raw.aov.multi, raw.aov.tukey.multi)
    }

    histova_msg("Build Histogram", type="head")
    set_aesthetics()
    # the generate_label_df function is called from within build_histo()...
    # for this file (since there is only a G1 call generate_label_df passing in 0)
    labels = generate_label_df(0)
    #build_histo()

    expect_equal(sprintf("%.10f", labels$V1[[1]]), "4.8877384262")
    expect_equal(sprintf("%.10f", labels$se[[6]]), "0.4529836103")
    expect_equal(sprintf("%.10f", labels$IQR25[[5]]), "9.1134018020")
    expect_equal(labels$labels[[3]], "BC")

})
