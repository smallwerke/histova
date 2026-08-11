#' Run Data
#'
#' This function is a wrapper to run through all of the statistical operations
#' typically carried out on a set of data. This includes any tests as well as
#' modifications and transformations of the data itself.
#'
#' All relevant data and settings should be stored in the environment variables
#' that are accessed by this function.
#'
#' @param hsa the histova R6 object
#'
#' @export
#'
run_data <- function(hsa) {

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
    if (is.numeric(hsa$get("fig.y.rig")) ) {
        histova_msg(sprintf("MODIFYING VALUES: MULTIPLYING ALL BY %s (file: %s)", hsa$get("fig.y.rig"), the$Location.File), type="warn")
        raw$base['Value'] = raw$base['Value']*hsa$get("fig.y.rig")
        hsa$set("fig.y.min", hsa$get("fig.y.min")*hsa$get("fig.y.rig") )
        hsa$set("fig.y.max", hsa$get("fig.y.max")*hsa$get("fig.y.rig") )
        hsa$set("fig.y.interval", hsa$get("fig.y.interval")*hsa$get("fig.y.rig") )

        # update the y-break values
        if (isTRUE(hsa$get("fig.y.break")) ) {
            hsa$fig$y.break.df$start <- hsa$fig$y.break.df$start * hsa$get("fig.y.rig")
            hsa$fig$y.break.df$stop <- hsa$fig$y.break.df$stop * hsa$get("fig.y.rig")
        }
        # update the HLine values
        hsa$fig$plot.hline$y = sapply(hsa$fig$plot.hline$y, function(x) x * hsa$get("fig.y.rig") )
        if (hsa$get("fig.y.rig") > 100) {
            fig$Y.Supp <- sfsmisc::pretty10exp(hsa$get("fig.y.rig"), drop.1=TRUE)
        } else {
            fig$Y.Supp <- paste("x ", hsa$get("fig.y.rig"), sep="")
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
