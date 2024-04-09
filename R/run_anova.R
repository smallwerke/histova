#' Run ANOVA
#'
#' @description
#' Calculate the ANOVA values for the specified groups. Depending on the configuration the ANOVA
#' is either run within each Group2 or between all possible Group1_Group2 combinations. All of the
#' data is pulled from environment variables.
#'
#' @export
#'
run_anova <- function() {

    histova_msg("ANOVA w/ Tukeys Post Hoc", type="subhead")
    ##########################################
    # anova on the data
    # this code is currently redundant and should be removed...
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
    # get some useful data out of the aov...
    #raw.aov.multi[[1]]$residuals
    #str(summary(raw.aov.multi[[1]]))
    #summary(raw.aov.multi[[1]])[[1]][[1,'Pr(>F)']]


    ##########################################
    # TUKEY post hoc stats...
    # seperated from above for the future implementation of other post hoc test options...
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
}
