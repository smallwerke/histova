#' Run Outlier
#'
#' @description
#' Remove any outliers, if requested. DEPENDS on already having loaded data into the environment
#' to function as it operates on saved environment variables. The histova function load_data() should
#' load the needed data. The configuration file can specify if one or two tailed outlier checking
#' should be performed. Only the most extreme outlier will be removed in the current configuration.
#'
#' @export
#'
run_outlier <- function() {

    histova_msg("Outlier checking", type="subhead")
    # determined by the header in the data file...
    # not impacted by the Group2 setting as each Group1_Group2 should create a unique ID combination
    if ((stats$Outlier == "ONE") || (stats$Outlier == "TWO")) {

        # set some general configs
        two.sided.val = TRUE
        if (stats$Outlier == "ONE") {
            two.sided.val = FALSE
            notes$Stats.Outlier <- paste(notes$Stats.Outlier, "Outlier Check (one tailed removal)", sep=" ")
        } else if (stats$Outlier == "TWO") {
            notes$Stats.Outlier <- paste(notes$Stats.Outlier, "Outlier Check (two tailed removal)", sep=" ")
        }
        outlier.list <- ""
        outlier.skip <- ""

        # create a data frame to hold any discovered outliers, nrow(raw$outlier) will provide total outlier count (inclding 0)
        raw$outlier = data.frame()

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
                # one or two sided tests are determined by two.sided=FALSE/TRUE
                # make a list of the data in the Value column of the raw data frame
                # for all entries that match c(l) (from above) in the 'Group1' column
                # [raw[,'Group1'] %in% c(l),][,'Value']
                #
                # one tailed check can throw a warning message: "In sqrt(s) : NaNs produced" though script
                # continues running and so far no issue has been discovered; double check if concerned
                outlier.pval <- outliers::grubbs.test(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], type=10, two.sided = two.sided.val)$p.value
                if (outlier.pval <= 0.05) {

                    # find out what value is going to be removed by rm.outlier and report that
                    outlier.value = outliers::outlier(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'])

                    # save the removed outliers into a separate data frame
                    raw$outlier = rbind(raw$outlier, data.frame("Value" = c(outlier.value), "pVal" = c(outlier.pval), "statGroups" = c(l)) )

                    histova_msg(sprintf("%s TAILED REMOVAL on group %s (value %s, p.val: %#.2e)",
                                        stats$Outlier, l, outlier.value, outlier.pval
                                        ), type="warn", tabs=2)
                    if (outlier.list == "") { outlier.list <- sprintf("%s (%#.3f)", l, outlier.value) }
                    else { outlier.list = paste(outlier.list, sprintf(", %s (%#.3f)", l, outlier.value), sep="") }

                    # overwrites the existing group *** NOT NECESSARILY IN THE SAME ORDER! ***
                    # runs rm.outlier function to remove outlier and appends 'NA' in its place
                    raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'] <- append(outliers::rm.outlier(raw$base[raw$base[,'statGroups'] %in% c(l),][,'Value'], fill=FALSE), NA)
                }
            } else {
                histova_msg(sprintf("NOT ENOUGH VALUES to perform outlier check on group %s (file: %s)", l, the$Location.File), type="warn")
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

    } else { # if ((stats$Outlier == "ONE") || (stats$Outlier == "TWO")) {
        notes$Stats.Outlier <- paste(notes$Stats.Outlier, "No Outlier Check Performed", sep=" ")
    }
}
