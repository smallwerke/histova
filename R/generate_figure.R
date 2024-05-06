#' Generate Figure
#'
#' @description
#' This is the main function that builds a plot based on the specified configuration file. Pass in
#' the desired directory and file name in string format. By default the function does not print the
#' resulting plot but does save the plot and a log file in the same directory where the configuration
#' file is located.
#'
#' The configuration file must end in .txt and follow a specific format. The resulting plot and log
#' files both take the same name as the config file and simply changes the file extension. The plot
#' type is specified in the config file (default is .jpg) and the log file is set as .histova.
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#' @param printPlot Should the finished plot be printed
#' @param savePlot Should the finished plot & log be saved to disk
#'
#' @export
#'
#' @examples
#' generate_figure("/Users/Shared/HISTOVA_DATA", "test.txt", savePlot = FALSE)
#'
generate_figure <- function(location.dir, location.file, printPlot = FALSE, savePlot = TRUE) {

    ##########################################
    # Plans for the next steps of this package
    # - setup tests using the saved *.rda files within the package strucutre
    #       appears to work loading test scripts into int/extdata and then calling the location with:
    #       generate_figure(str_remove(histova_example("test.txt"), "/test.txt"), "test.txt")
    #           depends on stringr package!
    #           one note is that every call / modification of a gplot will impact the gplot OBJECT and thus the data in the saved rda (must follow the same process)
    #           the gplot object - for some strange reason - contains copies of the local environment ON EACH MODIFICATION?!
    # - run the ugly tests behind the scenes for functionality testing, where in the structure should the .txt files be saved?
    #       - actually reformat these to look good and include them in the examples directory, maybe have a funky one remain to show the width options...
    #       - another OPTION is to built thorough R data files, load them into the appropriate environment for the test at hand and just run that function on the engineered environment
    # - check the results of these tests against the pre-generated & saved rda files
    # - resolve all of the current min / max and other errors that are appearing
    #       Some are occasionally appearing in combination with y-axis break & HLines... Overall not often though
    #       appears to address it: https://cran.r-project.org/web/packages/ggplot2/vignettes/ggplot2-in-packages.html
    #       *** have changed the subset calls in build_histo to use R's base & more traditional subset method, should work but... ***
    # - include nice / well designed versions of the current test designs in the readme.rmd page
    # - have the color assignments have an actual group1/group2 name to them to assign them based on name not simply order
    #       this is largely being handled in set_aesthetics
    #       1: potentially allow a user to specify the order of the display in the config (run this before setting Colors) BUT probably best
    #           to not have a order check running as default since with facet off and unique G1 names they might want to intermix them?
    #       2: go through all of the test files and make sure they are still functioning with the new COLORS UNIQUE setting
    # - after getting the colors fixed build:
    #       - review how the raw data is being stored and then calculated / analyzed... look into making sure a copy of the raw data remain stored somewhere
    #           - check through all the options in histova and map out the best way to have a data summary / overview for the figure generation
    #               - eg final group names even when displayed as G1 for both G2s (currenlty using raw$summary)
    #       - function to display statistical settings in environment
    #       - function to display aesthetic settings in environment
    #           - check to make sure that after running through standard 'generate_figure' that all of the original variables are STILL in the env (eg you can generate the SAME figure stats, transformations & all just from the env)
    #               - document all calls to init_vars...
    #       - function to build figure from variables loaded into environment
    #       - function to run stats on data based on environment settings (always go back to raw loaded data)
    #       - functions to edit stats & aesthetic settings in the environment
    #       - function to write config&data file from environment variables
    # - potentially have a config option to order the display of groups? currently having G2 data in G1 causes issues...
    # - add a function for generating the config file header section (have R run through a series of prompts and spit out a file header!)
    #       include option to generate a batch version where you can load the generated config file and all you would be editing are
    #       the Labels, Groups (opt?), Stats tests run and it would all be reusing the 'batch' file's style settings (similar to override)
    # - DONE: add ability to not have all G1 in each G2... should be able to have distinct G1 per G2...
    #       this is an issue in ggplot2 on build_histo lines 244 & 258... easy enough to drop unused G1 with scales=free_x but this breaks coord_fixed...
    #       currently have the ability to only display the active G2 & G1 combinations BUT have turned off the coord_fixed option
    #       active in init_vars(), load_file_head() & build_hist()
    # - Having a y-break active the plot fills the width of the set area better, switching to ymin or nothing set and the plot suddenly becomes square -
    #       could this be an issue with coord_ratio? ** this appears to be fixed when running with the latest code **

    # check for existence of file before moving on
    if (!file.exists(paste0(location.dir, "/", location.file)) ) {
        message("FAIL - file could not be found")
        stop()
    }
    # check for the existence of the environments
    if ((!exists('the', mode='environment')) || (!exists('fig', mode='environment')) ||
        (!exists('notes', mode='environment')) || (!exists('raw', mode='environment')) ||
        (!exists('stats', mode='environment')) ) {

        message("FAIL - environments not available")
        stop()
    }

    # file & environments exist! let's get started
    the$Location.File = location.file
    the$Location.Dir = location.dir
    the$savePlot = savePlot

    # setup the connection needed for the logfile (if in use)
    if (savePlot) {
        the$Location.Log = paste0(the$Location.Dir, "/", sub("txt", "histova", the$Location.File))
        the$LOG = file(the$Location.Log, open = "w")
    }

    histova_msg(sprintf("histova %s", utils::packageVersion("histova")), type="title", breaker = "above")
    histova_msg(sprintf("run on %s", date()), type="title", breaker = "below")
    histova_msg("Prep & Load config settings and data", type = "head")
    histova_msg("file found and environments loaded successfully", tabs=2)

    # prep & load config info / data
    load_file_head()
    load_data()

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


    histova_msg("Build Histogram", type="head")
    set_aesthetics()
    build_histo()

    # add a line to the figure...
    if (is.na(fig$Plot.HLine$y[1]) != TRUE) {
        for (HL in 1:nrow(fig$Plot.HLine)) {
            histova_msg(sprintf("adding a horizontal line to the figure at: \'%s\'", fig$Plot.HLine$y[HL]))
            the$gplot = the$gplot + ggplot2::geom_hline(yintercept=fig$Plot.HLine$y[HL], linetype="solid", color=fig$Plot.HLine$color[HL], linewidth=fig$Plot.HLine$size[HL])
        }
    }

    # print out the plot for viewing in RStudio - probably good idea to make this an optional setting...
    if (printPlot) { print(the$gplot) }

    # save the image to the working directory using the modified txt filename - this WILL
    # overwrite an existing image...
    if (savePlot) {
        the$Location.Image = paste0(the$Location.Dir, "/", sub("txt", fig$Save.Type, the$Location.File))
        histova_msg("SAVE Histogram", type="head")
        histova_msg(sprintf("saving your new figure to: \'%s\'", the$Location.Image), tabs=1)

        # implement cairo package to better embed fonts into the output
        if (fig$Save.Type %in% c("tex", "svg")) {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, limitsize = FALSE)
        } else if (fig$Save.Type == "pdf") {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = grDevices::cairo_pdf, limitsize = FALSE)
        } else if (fig$Save.Type %in% c("jpg", "jpeg", "png", "tiff")) {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, limitsize = FALSE)
        } else {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, type="cairo", limitsize = FALSE)
        }
    }
    histova_msg(sprintf("finihsed on %s", date()), type="title", breaker = "both")
    if (savePlot) { close(the$LOG) }
}
