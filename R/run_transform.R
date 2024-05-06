#' Run Transform
#'
#' @description
#' Carry out any desired transformations on the dataset. Currently the only transformation
#' available is 'treatment over control'. As with most functions in this package the
#' data controlling the behavior of the function is stored in the package environment
#' and the data being manipulated is also in the package environment.
#'
#' @export
#'
run_transform <- function() {

    if (stats$Transform == "ToverC") {

        histova_msg("Transform: Treatment OVER Control", type="subhead")
        histova_msg(sprintf("Transforming data to generate treatment over control figure (file: %s)", the$Location.File), type="warn", tabs=2)

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
    }
}
