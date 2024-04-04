#' Run STTest
#'
#' @description Run Students TTest.
#'
#' @export
#'
run_sttest <- function() {

    i = 1
    histova_msg("Student T-Test", type="subhead")
    for (i in rownames(stats$STTest.Pairs)) {
        i = as.numeric(i)
        # check homogeneity of the variances of the two groups before running students ttest
        # a p > 0.05 inidicates that the variances ARE homogeous and can proceed, if < 0.05 throw a warning
        stats$STTest.Pairs$ftest[[i]][1] = list(stats::var.test(
            raw$base[raw$base[,'statGroups'] %in% stats$STTest.Pairs[i,"g1"],]$Value,
            raw$base[raw$base[,'statGroups'] %in% stats$STTest.Pairs[i,"g2"],]$Value ))
        if (stats$STTest.Pairs$ftest[[i]][[1]]$p.value > 0.05) {
            stats$STTest.Pairs$ftest[[i]][2] = "Homogenous"
            histova_msg(sprintf("variances between group1 %s & group2 %s ARE homogenous with a p-value: %s", stats$STTest.Pairs[i,"g1"], stats$STTest.Pairs[i,"g2"], stats$STTest.Pairs$ftest[[i]][[1]]$p.value), tabs=2)
        } else {
            stats$STTest.Pairs$ftest[[i]][2] = "NOT Homogenous - CHECK DATA"
            histova_msg(sprintf("** CHECK DATA - variances between group1 %s & group2 %s ARE NOT homogenous with a p-value: %s (file: %s)", stats$STTest.Pairs[i,"g1"], stats$STTest.Pairs[i,"g2"], stats$STTest.Pairs$ftest[[i]][[1]]$p.value, the$Location.File), type="warn", tabs=2)
        }
        variance = TRUE
        if (stats$STTest.Pairs$var[i] == "unequal") variance = FALSE
        paired = FALSE
        if (stats$STTest.Pairs$pair[i] == "paired") paired = TRUE
        stats$STTest.Pairs[i,]$sttest[[1]] = stats::t.test(
            raw$base[raw$base[,'statGroups'] %in% stats$STTest.Pairs[i,"g1"],]$Value,
            raw$base[raw$base[,'statGroups'] %in% stats$STTest.Pairs[i,"g2"],]$Value,
            alternative=as.character(stats$STTest.Pairs$alt)[i],
            var.equal = variance,
            paired = paired,
            conf.level=0.95)
        histova_msg(sprintf("ran a %s students t-test on group1 %s to group2 %s, with tail: %s, variance: %s, p-value: %s", toupper(stats$STTest.Pairs[i,"pair"]), stats$STTest.Pairs[i,"g1"], stats$STTest.Pairs[i,"g2"], toupper(stats$STTest.Pairs[i,"alt"]), toupper(stats$STTest.Pairs[i,"var"]), stats$STTest.Pairs$sttest[[i]]$p.value), tabs=2)
    } # for (i in rownames(Stats.STTest.Pairs)) {
    #assign("Stats.STTest.Pairs", Stats.STTest.Pairs, envir = .GlobalEnv) ### CHANGED - no longer needed ###
}
