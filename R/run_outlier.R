#' Run Outlier
#'
#' @description remove any outliers, if requested; DEPENDS on already having loaded data to function as it operates on saved environment variables
#'
#' @export
#'
run_outlier <- function() {

    message("---- Outlier checking")
    # determined by the header in the data file...
    # not impacted by the Group2 setting as each Group1_Group2 should create a unique ID combination
    if ((stats$Outlier == "ONE") || (stats$Outlier == "TWO")) {
        if (stats$Outlier == "ONE") { notes$Stats.Outlier <- paste(notes$Stats.Outlier, "Outlier Check (one tailed removal)", sep=" ") }
        else if (stats$Outlier == "TWO") { notes$Stats.Outlier <- paste(notes$Stats.Outlier, "Outlier Check (two tailed removal)", sep=" ") }
        outlier.list <- ""
        outlier.skip <- ""

        # cycle through the raw data frame based on the groupings in 'Group1'
        for (l in levels(raw$base[,'statGroups'])) {
            #message(sprintf("checking: %s", l))

            # first check to ensure that the list is not simply the same values
            # if all of the values are the same (eg 0s) then the outlier test will FAIL
            # and end the script
            # ALSO check to ensure that there are AT LEAST 3 actual numerical values in order to run a outlier test
            if ((length(unique(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'])) > 1) && (length(stats::na.omit(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'])) > 2)) {

                # there are multiple types of tests to run w/ grubbs https://cran.r-project.org/web/packages/outliers/outliers.pdf
                # type 10: looks for one outlier; type 11: checks highest & lowest value; type 20: checks for two outliers on SAME tail
                # make a list of the data in the Value column of the raw data frame
                # for all entries that match c(l) (from above) in the 'Group1' column
                # [raw[,'Group1'] %in% c(l),][,'Value']
                #
                # one tailed check can throw a warning message: "In sqrt(s) : NaNs produced" though script
                # continues running and so far no issue has been discovered; double check if concerned
                #message(sprintf("VALUES: %s", raw[raw[,'statGroups'] %in% c(l),][,'Value']))
                #message(sprintf("1 P: %s", grubbs.test(raw[raw[,'statGroups'] %in% c(l),][,'Value'], type=10)$p.value))
                #message(sprintf("2 P: %s", grubbs.test(raw[raw[,'statGroups'] %in% c(l),][,'Value'], type=11)$p.value))
                if (stats$Outlier == "ONE") {
                    if (outliers::grubbs.test(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], type=10)$p.value <= 0.05) {
                        warning(sprintf("ONE TAILED REMOVAL on group %s (file: %s)", l, the$Location.File))
                        if (outlier.list == "") { outlier.list <- l }
                        else { outlier.list = paste(outlier.list, sprintf(", %s", l), sep="") }
                        raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'] <- append(outliers::rm.outlier(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], fill=FALSE), NA)
                    }
                    # check for outliers on both tails
                } else if (stats$Outlier == "TWO") {
                    if (outliers::grubbs.test(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], type=11)$p.value <= 0.05) {
                        warning(sprintf("TWO TAILED REMOVAL on group %s (file: %s)", l, the$Location.File))
                        if (outlier.list == "") { outlier.list = l }
                        else { outlier.list <- paste(outlier.list, sprintf(", %s", l), sep="") }

                        # overwrites the existing group *** NOT NECESSARILY IN THE SAME ORDER! ***
                        # runs rm.outlier function to remove outlier and appends 'NA' in its place
                        raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'] <- append(outliers::rm.outlier(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], fill=FALSE), NA)
                    }
                }
                # write out a message if the test is skipped
            } else {
                warning(sprintf("NOT ENOUGH VALUES to perform outlier check on group %s (file: %s)", l, the$Location.File))
                if (outlier.skip == "") { outlier.skip <- l }
                else { outlier.skip <- paste(outlier.skip, sprintf(", %s", l), sep="") }
            }
        } # for (l in levels(raw[,'statGroups'])) {

        # remove any 'NA' rows entered during outlier search as they confuse the ordering of
        # letters during figure creation, this will also remove any 'NA' rows in the initial file
        raw$base = stats::na.omit(raw$base)
        if (outlier.list == "") { outlier.list <- "None Found" }
        if (outlier.skip != "") { outlier.list <- paste(outlier.list, "\nToo few values to check outliers: ", outlier.skip) }
        notes$Stats.Outlier <- paste(notes$Stats.Outlier, outlier.list, sep=" ")
        #assign("raw", raw, envir = .GlobalEnv) ### CHANGED - not needed, assigned directory ###

    } else { # if ((stats$Outlier == "ONE") || (stats$Outlier == "TWO")) {
        notes$Stats.Outlier <- paste(notes$Stats.Outlier, "No Outlier Check Performed", sep=" ")
    }
    #assign("Notes.Stats.Outlier", Notes.Stats.Outlier, envir = .GlobalEnv) ### CHANGED - no longer needed ###
}
