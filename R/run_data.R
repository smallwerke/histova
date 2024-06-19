#' Run Data
#'
#' This function is a wrapper to run through all of the statistical operations
#' typically carried out on a set of data. This includes any tests as well as
#' modifications and transformations of the data itself.
#'
#' All relevant data and settings should be stored in the environment variables
#' that are accessed by this function.
#'
#' @export
#'
run_data <- function() {
    histova_msg("Statistical Analysis", type = "head")

    # move onto stats analysis
    if (stats$Outlier != FALSE) { run_outlier() }
    run_stats_prep()

    histova_msg(sprintf("%s final Group1_Group2 (statGroups - should be unique!) ids:", length(levels(raw$base$statGroups)) ), tabs=2)
    histova_msg(sprintf("%s", paste("", levels(raw$base$statGroups), collapse="")), tabs=3)

    # run actual tests
    if ("ANOVA" %in% stats$Test) { run_anova() }
    if ("STTest" %in% stats$Test) { run_sttest() }
    #if ("PTTest" %in% Stats.Test) { run_ttest(TRUE) } # NOT YET IMPLEMENTED!

    # if a transformation is being conducted (eg treatment over control)
    # ** After a group is removed the ANOVA stats (if requested) are run again for ToverC **
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
        # general math expression:
        #Fig.Y = bquote(.(Fig.Y)~"He"~r[xy]==~B^2)

        # following will successfully store the expression...
        #r = do.call(substitute, as.list(str2expression("r[xy]")))
        # error prone BUT it will parse a expression stored in a string...
        #Fig.Y = bquote(.(parse(text=Fig.Y)))
        # FULL list of current html4
        #"&Alpha;~&Beta;~&Gamma;~&Delta;~&Epsilon;~&Pi;~&Sigma;~&Tau;~&Phi;~&Omega;~&alpha;~&beta;~&gamma;~&delta;~&epsilon;~&pi;~&sigma;~&tau;~&phi;~&omega;~&bull;~&isin;~&notin;~&radic;~&infin;~&asymp;~&micro;"

        #assign("Fig.Y", Fig.Y, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }

    # this may not be 100% necessary if the
    # the t-tests should be run on the remaining groups POST transformation
    # but BEFORE removal of the control group
    if (stats$Transform == "ToverC") {
        if ("STTest" %in% stats$Test) { run_sttest() }
        #if ("PTTest" %in% Stats.Test) { run_ttest(TRUE) }
    }

    # remove a group from being displayed (eg for treatment / control figures)
    if ((stats$Group1.Mute != FALSE) && (stats$Anova.Group2 == FALSE)) {

        histova_msg(sprintf("group1Mute is set to %s, attempting to remove this group! (file: %s)", stats$Group1.Mute, the$Location.File), type="warn", tabs=2)


        # convenient function but causes notes in packages...
        #raw$base = subset(raw$base, Group1!=stats$Group1.Mute) ### CHANGED - to address Group1 not being in NAMESPACE ###
        # traditional and 'more reliable'
        raw$base = raw$base[raw$base$Group1 != stats$Group1.Mute, ]
        raw$base[] = lapply(raw$base, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw", raw, envir = .GlobalEnv) ### CHANGED - no longer needed ###

        #raw$summary = subset(raw$summary, Group1!=stats$Group1.Mute)
        raw$summary = raw$summary[raw$summary$Group1 != stats$Group1.Mute, ]
        raw$summary[] = lapply(raw$summary, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw.summary", raw.summary, envir = .GlobalEnv) ### CHANGED - no longer needed ###

        #raw$summary.multi = subset(raw$summary.multi, Group1!=stats$Group1.Mute)
        raw$summary.multi = raw$summary.multi[raw$summary.multi$Group1 != stats$Group1.Mute, ]
        raw$summary.multi[] = lapply(raw$summary.multi, function(x) if(is.factor(x)) factor(x) else x)
        #assign("raw.summary.multi", raw.summary.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }

    # the ANOVA test should be run on the remaining groups POST transformation
    if (stats$Transform == "ToverC") {
        if ("ANOVA" %in% stats$Test) { run_anova() }
        # following vars are set in run_anova() (raw.anova.multi, raw.aov.multi, raw.aov.tukey.multi)
    }
    histova_msg(sprintf("%s final Group1_Group2 (statGroups - should be unique!) ids:", length(levels(raw$base$statGroups)) ), tabs=2)
    histova_msg(sprintf("%s", paste("", levels(raw$base$statGroups), collapse="")), tabs=3)
}
