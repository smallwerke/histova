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

    histova_msg("Data Manipulation", type = "head")

    histova_msg("run_data() carries out any requested manipulations (e.g. apply standard division for %)")

    # use raw$IN as the source for all data - this data should NOT be edited...
    # raw$base is the location for all active work towards figure generation
    # raw$IN is reserved for a dump of the input data immediately after it was read from the file and should NEVER be modified
    # this is also the source for when a new file is written
    #raw$base <- rlang::duplicate(raw$IN, shallow=FALSE)
    raw$base <- unserialize(serialize(raw$IN, NULL))

    # address any value manipulations - this can apply a standard division to ALL data values (eg divide by 1,000)
    # prepare the Y axis label supplement that contains details on what was done to the data
    if (is.numeric(fig$Y.Rig)) {
        histova_msg(sprintf("MODIFYING VALUES: DIVIDING ALL BY %s (file: %s)", fig$Y.Rig, the$Location.File), type="warn")
        raw$base['Value'] = raw$base['Value']/fig$Y.Rig
        fig$Y.Min <- fig$Y.Min/fig$Y.Rig
        fig$Y.Max <- fig$Y.Max/fig$Y.Rig
        fig$Y.Interval <- fig$Y.Interval/fig$Y.Rig

        # update the y-break values
        if (fig$Y.Break == TRUE) {
            fig$Y.Break.df$start <- fig$Y.Break.df$start / fig$Y.Rig
            fig$Y.Break.df$stop <- fig$Y.Break.df$stop / fig$Y.Rig
        }
        # update the HLine values
        fig$Plot.HLine$y = sapply(fig$Plot.HLine$y, function(x) x/fig$Y.Rig)
        #assign("Fig.Plot.HLine", Fig.Plot.HLine, envir = .GlobalEnv) ### CHANGED - no longer needed ###
        if (fig$Y.Rig > 100) {
            fig$Y.Supp <- sfsmisc::pretty10exp(fig$Y.Rig, drop.1=TRUE)
        } else {
            fig$Y.Supp <- paste("x ", fig$Y.Rig, sep="")
        }
        #assign("Fig.Y.Supp", Fig.Y.Supp, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }

    # set the levels to be in the same order as the file...
    # this also controls the order in which they display in the final figure...
    raw$base$Group1 <- factor(convert_text(raw$base$Group1), levels = unique(convert_text(raw$base$Group1)))
    if (!methods::is(raw$base$Group2, "NULL")) {
        raw$base$Group2 <- factor(convert_text(raw$base$Group2), levels = unique(convert_text(raw$base$Group2)))
    }

    # create a list  of group IDs for use in the analysis - either a combination of 1 & 2 or simply 1
    if (!methods::is(raw$base$Group2, "NULL")) {
        raw$base$statGroups <- factor(with(raw$base, paste(Group1, Group2, sep="_")))
        raw$base$statGroups <- factor(raw$base$statGroups, levels = unique(raw$base$statGroups))
    } else {
        raw$base$statGroups <- factor(raw$base$Group1, levels = unique(raw$base$Group1))
    }
    histova_msg(sprintf("%s final Group1_Group2 (statGroups - should be unique!) ids:", length(levels(raw$base$statGroups)) ), tabs=2)
    histova_msg(sprintf("%s", paste("", levels(raw$base$statGroups), collapse="")), tabs=3)


}
