#' Run ANOVA
#'
#' @description calculate the ANOVA values
#'
#' @export
#'
run_anova <- function() {

    message("---- ANOVA w/ Tukeys Post Hoc")
    ##########################################
    # anova on the data
    #
    # if TRUE only run stats WITHIN each group2
    if (stats$Anova.Group2) {
        n = 1
        raw$anova.multi = vector(mode="list", length = length(levels(raw$base$Group2)))
        for (l in levels(raw$base[,'Group2'])) {
            raw$anova.multi[[n]] = stats::lm(Value ~ statGroups, data = raw$base[raw$base[,'Group2'] %in% c(l),], na.action=stats::na.exclude)
            n = n + 1
        }
        # if FALSE run stats on entire dataset regardless...
    } else {
        raw$anova.multi = stats::lm(Value ~ statGroups, data = raw$base, na.action=stats::na.exclude)
    }
    #assign("raw.anova.multi", raw.anova.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    #summary(raw.anova.multi[[1]])
    #anova(raw.anova.multi[[1]])


    ##########################################
    # anova again using aov()
    #
    # if TRUE only run stats WITHIN each group2
    if (stats$Anova.Group2) {
        n = 1
        raw$aov.multi = vector(mode="list", length = length(levels(raw$base$Group2)))
        for (l in levels(raw$base[,'Group2'])) {
            raw$aov.multi[[n]] = stats::aov(Value ~ statGroups, data = raw$base[raw$base[,'Group2'] %in% c(l),])
            n = n + 1
        }
        # if FALSE run stats on entire dataset regardless...
    } else {
        raw$aov.multi = stats::aov(Value ~ statGroups, data = raw$base)
    }
    #assign("raw.aov.multi", raw.aov.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    # get some useful data out of the aov...
    #raw.aov.multi[[1]]$residuals
    #str(summary(raw.aov.multi[[1]]))
    #summary(raw.aov.multi[[1]])[[1]][[1,'Pr(>F)']]


    ##########################################
    # TUKEY post hoc stats...
    #
    # if TRUE only run stats WITHIN each group2
    if (stats$Anova.Group2) {
        n = 1
        raw$aov.tukey.multi = vector(mode="list", length = length(levels(raw$base$Group2)))
        for (l in levels(raw$base[,'Group2'])) {
            raw$aov.tukey.multi[[n]] = stats::TukeyHSD(raw$aov.multi[[n]])
            n = n + 1
        }
        # if FALSE run stats on entire dataset regardless...
    } else {
        raw$aov.tukey.multi = stats::TukeyHSD(raw$aov.multi)
    }
    #assign("raw.aov.tukey.multi", raw.aov.tukey.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    #raw.aov.tukey.multi[[1]]
}
