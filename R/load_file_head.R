#' Load File Head
#'
#' @description
#' Load the configuration from the head of the file specified in the$Location.file. Each
#' configuration file should begin with the settings section that details the aesthetics of
#' the desired figure as well as what kind of statistical tests to carry out. These settings
#' are all loaded into a few environments within the histova package and stored there
#' to be accessible between functions. The Override option is controlled in this function.
#'
#' @param hsa R6 histova object being worked on
#'
#' @export
#'
load_file_head = function(hsa) {

    # forced reset
    init_vars(hsa)

    histova_msg(sprintf("Load config (file: %s)", the$Location.File), type="subhead", hsa=hsa)

    fullPath <- paste0(hsa$get("file.location.dir"), "/", hsa$get("file.location.file"))

    # set the override placeholder to NULL
    Override.tmp <- NULL
    hsa$set("fig.y.tmp", NULL)

    # read in the comments and set any specified variables (title, legend, etc)
    CON = file(fullPath, open = "r")
    l <- readLines(CON, 1)
    while(substring(l, 1, 1) == '#') {
        #message(sprintf("---- Load data (line: %s)", l))

        # pull out the information
        lA <- strsplit(substring(l, 2), "\t");

        # if the line is a comment skip to the next iteration
        if (substring(l, 2, 2) == '#') {
            l <- readLines(CON, 1);
            next
        } else {
            l <- readLines(CON, 1);
        }

        ################ FILE NAME ################
        if (lA[[1]][1] == "File Name") {
            the$File.Name <- lA[[1]][2]
        }

        # maintain backwards compatibility - simply move this to a new line for analysis...
        if (lA[[1]][1] == "Stats STTest Pairs") { lA[[1]] <- c("Stats Test", "STTest", lA[[1]][-1]) }
        else if (lA[[1]][1] == "Stats PTTest Pairs") { lA[[1]] <- c("Stats Test", "PTTest", lA[[1]][-1]) }

        ################ OVERRIDE? ################
        if (lA[[1]][1] == "Override") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", "1")) {
                if (isTRUE(the$Override)) { histova_msg("turning override ON AND overwriting previous override!!", tabs=1) }
                else { histova_msg("turning override ON!!", tabs=1) }

                # set override to true from here on out
                Override.tmp <- TRUE
                # turn off override protection if it was set
                the$Override <- FALSE
                # set all variables back to their default before moving on
                histova_msg("resetting variables to defaults BEFORE loading config", tabs=1)
                init_vars()
            } else if (lA[[1]][2] %in% c("FALSE", "False", "false", "0")) {
                histova_msg("turning override OFF!")
                the$Override <- FALSE
                histova_msg("resetting variables to defaults BEFORE loading config", tabs=1)
                init_vars()
            }
        }
        ## OPTIONAL / OVERRIDEABLE SETTINGS ##
        # Override will be set to false in init_vars() (called earlier) IF it doesn't exist
        if (isFALSE(the$Override)) {

            # MOVING TO SET FUNCTION!
            if ( (lA[[1]][1] == "Title Size") || (lA[[1]][1] == "Axis Title Size") ||
                 (lA[[1]][1] == "Axis Label Size") || (lA[[1]][1] == "Axis Value Size") ||
                 (lA[[1]][1] == "Legend Label Size") || (lA[[1]][1] == "Axis Label Sep") ||
                 (lA[[1]][1] == "Text Convert") || (lA[[1]][1] == "X Value Display") ||
                 (lA[[1]][1] == "X Tick Display") || (lA[[1]][1] == "Text Font") ||
                 (lA[[1]][1] == "X Angle") || (lA[[1]][1] == "X Value Angle") ||
                 (lA[[1]][1] == "Bar Width") || (lA[[1]][1] == "Bar Border Color") ||
                 (lA[[1]][1] == "Bar Border Width") || (lA[[1]][1] == "Scatter Display") ||
                 (lA[[1]][1] == "Scatter Alpha") || (lA[[1]][1] == "Colors Alpha") ||
                 (lA[[1]][1] == "Scatter Stroke") || (lA[[1]][1] == "Save Width") ||
                 (lA[[1]][1] == "Save Height") || (lA[[1]][1] == "Save DPI") ||
                 (lA[[1]][1] == "Save Units") || (lA[[1]][1] == "Save Type") ||
                 (lA[[1]][1] == "Legend Display") || (lA[[1]][1] == "Stat Caption Size") ||
                 (lA[[1]][1] == "Whisker Plot") || (lA[[1]][1] == "Scatter ColorShapeSize") ||
                 (lA[[1]][1] == "Axis X Main Style") || (lA[[1]][1] == "Axis Y Main Style") ||
                 (lA[[1]][1] == "Axis X Tick Style") || (lA[[1]][1] == "Axis Y Tick Style") ||
                 (lA[[1]][1] == "Error Bars Style") || (lA[[1]][1] == "HLine Style OVRD") ||
                 (lA[[1]][1] == "Colors") || (lA[[1]][1] == "Colors Unique") ||
                 (lA[[1]][1] == "Colors Specific") || (lA[[1]][1] == "Legend Color Source") ||
                 (lA[[1]][1] == "Legend Title") || (lA[[1]][1] == "Legend Position") ||
                 (lA[[1]][1] == "Stat Offset") || (lA[[1]][1] == "Stat Letter Size") ||
                 (lA[[1]][1] == "Stat Caption Display")
            ) {
                hsa$set(lA[[1]][1], lA[[1]][2], TRUE)
            }

        }
        if ( (lA[[1]][1] == "Title Main") || (lA[[1]][1] == "HLine") ||
             (lA[[1]][1] == "X Leg") || (lA[[1]][1] == "Y Leg")  || ### CHANGED - was not being assigned to global env ###
             (lA[[1]][1] == "Y Min") || (lA[[1]][1] == "Y Max") ||
             (lA[[1]][1] == "Y Interval") || (lA[[1]][1] == "Y Break") ||
             (lA[[1]][1] == "Y Value Rig") || (lA[[1]][1] == "Y Value Rig Newline")
        ) {
            hsa$set(lA[[1]][1], lA[[1]][2], TRUE)
        }


        ################ Stats Tests (REQ) ################
        if (lA[[1]][1] == "Stats Test") {
            # set the default value to FALSE whenever a user assigns any specific test
            stats$Test[1] <- FALSE ### CHANGED - was not explicitly changing global env previously... ###
            ### CHANGED - IS THERE A REASON I AM NOT CHECKING FOR ANOVA ALREADY IN THE stats$Test LIST? ###
            if (lA[[1]][2] %in% c("ANOVA", "anova", "Anova")) { stats$Test <- c(stats$Test, "ANOVA") } ### CHANGED - was not explicitly changing global env previously... ###
            else if (lA[[1]][2] %in% c("STTest", "sttest", "STtest")) {
                if (!"STTest" %in% stats$Test) { stats$Test <- c(stats$Test, "STTest") } ### CHANGED - was not explicitly changing global env previously... ###
                # for a TTtest the comparison groups need to be submitted
                # set default test
                STTest.tails <- "two.sided"
                # set default variance
                STTest.variance <- "equal"
                # set default pairing
                STTest.paired <- "unpaired"
                # check to see if the pairing is being defined AND if it
                if (length(lA[[1]]) > 7) {
                    if (tolower(lA[[1]][8]) %in% c("paired", "unpaired")) { STTest.paired <- tolower(lA[[1]][8]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][8], STTest.paired), type="warn", tabs=1) }
                }
                # check to see if the variance is being defined AND if it
                if (length(lA[[1]]) > 6) {
                    if (tolower(lA[[1]][7]) %in% c("equal", "unequal")) { STTest.variance <- tolower(lA[[1]][7]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][7], STTest.variance), type="warn", tabs=1) }
                }
                # check to see if a test is request AND if it is workable...
                if (length(lA[[1]]) > 5) {
                    if (tolower(lA[[1]][6]) %in% c("two.sided", "greater", "less")) { STTest.tails <- tolower(lA[[1]][6]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][6], STTest.tails), type="warn", tabs=1) }
                }
                # retain backwards compatability when the config file had sep lines for test & parings...
                if (length(lA[[1]]) > 2) {
                    stats$STTest.Pairs <- rbind(stats$STTest.Pairs, data.frame(g1 = convert_text(lA[[1]][3]), g2 = convert_text(lA[[1]][4]), l = lA[[1]][5], alt = STTest.tails, var = STTest.variance, pair = STTest.paired, ftest = I(vector(mode="list", length=1)), sttest = I(vector(mode="list", length=1))) )
                }
            }
            else if (lA[[1]][2] %in% c("PTTest", "pttest", "PTtest", "Pttest")) {
                if (!"PTTest" %in% stats$Test) { stats$Test <- c(stats$Test, "PTTest") } ### CHANGED - was not explicitly changing global env previously... ###
                # for a TTtest the comparison groups need to be submitted
                # set default test
                PTTest.tails <- "two.sided"
                # set default variance
                PTTest.variance <- "equal"
                # check to see if the variance is being defined AND if it
                if (length(lA[[1]]) > 6) {
                    if (tolower(lA[[1]][7]) %in% c("equal", "unequal")) { PTTest.variance <- tolower(lA[[1]][7]) }
                    else { histova_msg(sprintf("---- Argument in PTTest (%s) NOT VALID, using default (%s) instead", lA[[1]][7], PTTest.variance), type="warn", tabs=1) }
                }
                # check to see if a test is request AND if it is workable...
                if (length(lA[[1]]) > 5) {
                    if (lA[[1]][6] %in% c("two.sided", "greater", "less")) { PTTest.tails <- lA[[1]][6] }
                    else { histova_msg(sprintf("---- Argument in PTTest (%s) NOT VALID, using default (%s) instead", lA[[1]][6], PTTest.tails), type="warn", tabs=1) }
                }
                # retain backwards compatability when the config file had sep lines for test & parings...
                if (length(lA[[1]]) > 2) {
                    stats$PTTest.Pairs <- rbind(stats$PTTest.Pairs, data.frame(g1 = convert_text(lA[[1]][3]), g2 = convert_text(lA[[1]][4]), l = lA[[1]][5], alt = PTTest.tails, var = PTTest.variance, pttest = I(vector(mode="list", length=1))) )
                }
            }
            #assign("Stats.Test", Stats.Test, envir = .GlobalEnv) ### CHANGED - should no longer be needed as assigned to stats env at each update ###
        }
        ################ Stats Transformation or Outlier (REQ) ################
        else if (lA[[1]][1] == "Stats Transform") {
            if (lA[[1]][2] %in% c("TreatmentControl", "TREATMENTCONTROL")) {
                # a specified treatment is required, if it isn't there, leave it set at FALSE
                if (!is.na(lA[[1]][3])) {
                    stats$Transform <- "ToverC"
                    tc <- c(lA[[1]][3])
                    if (!is.na(lA[[1]][4])) { tc <- c(convert_text(lA[[1]][3]), convert_text(lA[[1]][4])) }
                    stats$Transform.Treatment <- tc
                }
            } else if (lA[[1]][2] %in% c("TimeCourse", "TIMECOURSE")) {
                stats$Transform <- "TimeCourse"
            }
        }
        else if (lA[[1]][1] == "Stats Outlier") {
            if (lA[[1]][2] %in% c("ONE", "One", "one", 1)) { stats$Outlier <- "ONE" }
            else if (lA[[1]][2] %in% c("TWO", "Two", "two", 2)) { stats$Outlier <- "TWO" }
            else { stats$Outlier <- FALSE }
        }
        ################ Split on Group 2? (REQ) ################
        else if (lA[[1]][1] == "Stats Anova Group2") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", 1)) { stats$Anova.Group2 <- TRUE }
            else { stats$Anova.Group2 <- FALSE }
        }
        else if (lA[[1]][1] == "Facet Split") {
            if (lA[[1]][2] %in% c("FALSE", "False", "false", 0)) { fig$Facet.Split <- FALSE }
            else { fig$Facet.Split <- TRUE }
        }
    } # while(substring(l, 1, 1) == '#') {
    close(CON)

    if (isTRUE(the$Override)) { message("OVERRIDE ON - Optional config settings skipped") }

    if (!is.null(Override.tmp)) { the$Override <- Override.tmp }

    if (exists("Title.Replace", envir=fig)) {
        hsa$fig$title.tmp <- fig$Title.Replace
        rm("Title.Replace", envir = fig)
    }
    if (exists("Y.Replace", envir=fig)) {
        hsa$set("fig.y.tmp", fig$Y.Replace)
        rm("Y.Replace", envir = fig)
    }
    if (exists("X.Replace", envir=fig)) {
        hsa$set("fig.x.tmp", fig$X.Replace)
        rm("X.Replace", envir = fig)
    }
    # if (exists("Legend.Title.Replace", envir=fig)) {
    #     fig$Legend.Title.tmp <- fig$Legend.Title.Replace
    #     rm("Legend.Title.Replace", envir = fig)
    # }
    if (hsa$get("fig.convert")) {
        hsa$set("fig.title.tmp", convert_text(hsa$get("fig.title.tmp")))
        hsa$set("fig.y.tmp", convert_text(hsa$get("fig.y.tmp")))
        hsa$set("fig.x.tmp", convert_text(hsa$get("fig.x.tmp")))
        hsa$set("fig.legend.title.tmp", convert_text(hsa$get("fig.legend.title.tmp")))
    }

    # IF a master HLine style was provided replace the current value and cleanup
    if ( isFALSE(is.null(hsa$get("fig.plot.hline.OVRD.color"))) ) {
        hsa$set("fig.plot.hline.color", hsa$get("fig.plot.hline.OVRD.color") )
        histova_msg(sprintf("OVERRIDING ALL horizontal line colors, set to: \'%s\'", hsa$get("fig.plot.hline.OVRD.color")))
    }
    if ( isFALSE(is.null(hsa$get("fig.plot.hline.OVRD.size"))) ) {
        hsa$set("fig.plot.hline.size", hsa$get("fig.plot.hline.OVRD.size") )
        histova_msg(sprintf("OVERRIDING ALL horizontal line sizes, set to: \'%s\'", hsa$get("fig.plot.hline.OVRD.size")))
    }

    fig$Title <- hsa$get("fig.title.tmp")
    fig$Y <- hsa$get("fig.y.tmp")
    fig$X <- hsa$get("fig.x.tmp")
    hsa$set("fig.legend.title", hsa$get("fig.legend.title.tmp"))
}
