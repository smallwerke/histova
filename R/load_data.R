#' Load Data
#'
#' @description
#' Load the data in from the file and perform any global manipulations. Following the file header
#' (all lines that begin with '#') comes the data for the figure. The format is
#' value<tab>Group1<tab>Group2
#' Group 2 is optional. The data is displayed in the order it is entered into the file.
#' All data is saved to the histova environment for use by other functions.
#'
#' @export
#'
#' @examples
#' load_data()
load_data <- function () {

    histova_msg(sprintf("Load data (file: %s)", the$Location.File), type="subhead")
    # read in the data
    fullPath <- paste0(the$Location.Dir, "/", the$Location.File)
    rawIN <- utils::read.table(fullPath, sep="\t", header=TRUE, comment.char = '#', check.names = FALSE)

    #
    # address any value manipulations - this can apply a standard division to ALL data values (eg divide by 1,000)
    # prepare the Y axis label supplement that contains details on what was done to the data
    if (is.numeric(fig$Y.Rig)) {
        histova_msg(sprintf("MODIFYING VALUES: DIVIDING ALL BY %s (file: %s)", fig$Y.Rig, the$Location.File), type="warn")
        rawIN['Value'] = rawIN['Value']/fig$Y.Rig
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
    rawIN$Group1 <- factor(convert_text(rawIN$Group1), levels = unique(convert_text(rawIN$Group1)))
    if (!methods::is(rawIN$Group2, "NULL")) {
        rawIN$Group2 <- factor(convert_text(rawIN$Group2), levels = unique(convert_text(rawIN$Group2)))
    }

    # create a list  of group IDs for use in the analysis - either a combination of 1 & 2 or simply 1
    if (!methods::is(rawIN$Group2, "NULL")) {
        rawIN$statGroups <- factor(with(rawIN, paste(Group1, Group2, sep="_")))
        rawIN$statGroups <- factor(rawIN$statGroups, levels = unique(rawIN$statGroups))
    } else {
        rawIN$statGroups <- factor(rawIN$Group1, levels = unique(rawIN$Group1))
    }
    raw$base <- rawIN ### CHANGED - using $base as location... ####
    histova_msg(sprintf("%s final Group1_Group2 (statGroups - should be unique!) ids:", length(levels(raw$base$statGroups)) ), tabs=2)
    histova_msg(sprintf("%s", paste("", levels(raw$base$statGroups), collapse="")), tabs=3)
}
