#' Run WTTest
#'
#' @description Run Wilcox TTest **IN DEVELOPMENT - NOT YET FUNCTIONAL OR IMPLEMENTED!**
#'
#' @export
#'
run_wttest <- function() {
    # old code from the wilcox t-test, need to add in again as w-test or something...
    if (FALSE) {
        histova_msg("---- Paired Wilcox T-Test")
        for (i in rownames(stats$PTTest.Pairs)) {
            i = as.numeric(i)

            variance = TRUE
            if (stats$PTTest.Pairs$var[i] == "unequal") variance = FALSE

            stats$PTTest.Pairs[i,]$pttest[[1]] = stats::wilcox.test(
                raw$base[raw$base[,'statGroups'] %in% stats$PTTest.Pairs[i,"g1"],]$Value,
                raw$base[raw$base[,'statGroups'] %in% stats$PTTest.Pairs[i,"g2"],]$Value,
                alternative=as.character(Stats.PTTest.Pairs$alt)[i],
                var.equal = variance,
                paired=TRUE,
                conf.level=0.95)
            histova_msg(sprintf("ran paired wilcox t-test on group1 %s to group2 %s, with tail: %s, variance: %s, p-value: %s", stats$PTTest.Pairs[i,"g1"], stats$PTTest.Pairs[i,"g2"], stats$PTTest.Pairs[i,"alt"], stats$PTTest.Pairs[i,"var"], stats$PTTest.Pairs$pttest[[i]]$p.value))
        }
        #assign("Stats.PTTest.Pairs", Stats.PTTest.Pairs, envir = .GlobalEnv) ### CHANGED - not needed ###
    }
}
