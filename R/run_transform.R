#' Run Transform
#'
#' @description Carry out any desired transformations.
#'
#' @export
#'
run_transform <- function() {

    if (stats$Transform == "ToverC") {

        message("---- Transform: Treatment OVER Control")
        warning(sprintf("Transforming data to generate treatment over control figure (file: %s)", the$Location.File))

        # we want to divide all groups by the transform control group AND drop that group from the figure as it should all be set to 1
        trans = ""
        if (is.na(stats$Transform.Treatment[2])) { trans = stats$Transform.Treatment[1]
        } else { trans = paste(stats$Transform.Treatment[1], stats$Transform.Treatment[2], sep="_") }

        for (l in levels(raw$base[,'statGroups'])) {
            # don't want to run treat over treat since then everything will be divided by 1...
            if (l != trans) {
                raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'] = (raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'] / raw$base[raw$base[,'statGroups'] %in% c(trans),][,'Value'])
            }
        }
        raw$base[raw$base[,'statGroups'] %in% c(trans),][,'Value'] = (raw$base[raw$base[,'statGroups'] %in% c(trans),][,'Value'] / raw$base[raw$base[,'statGroups'] %in% c(trans),][,'Value'])
        #assign("raw", raw, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }
}
