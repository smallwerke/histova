#' Run Stats Prep
#'
#' @description Calculate the stats (outlier removal, anova, TUKEY post hoc, summary table)
#' this function reads in the raw data and then calls the appropriate functions
#' depending on what tests were specified in the config file...
#'
#' No examples specified as the function *depends* on having data loaded by other functions
#'
#' @export
#'
#' @importFrom rlang .data
#' @importFrom magrittr "%>%"
run_stats_prep <- function () {

    histova_msg("Run stats prep (basic summaries)", type="subhead")
    # Create a subset of raw (raw.multi) that stores the data in raw broken down by Group2 for future analysis...
    # no stats are being run on raw.multi, simply used for defining the different groups AND for defining letters for statistical significance.....
    # if TRUE run stats WITHIN each group2
    if (stats$Anova.Group2) {
        n = 1
        raw$multi = vector(mode="list", length = length(levels(raw$base$Group2)))
        for (l in levels(raw$base[,'Group2'])) {
            raw$multi[[n]] = droplevels(raw$base[raw$base[,'Group2'] %in% c(l),])
            n = n + 1
        }
        #assign("raw.multi", raw.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###
    }

    # REQUIRED for error bars AND placing statistical letters!
    # following from: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
    # IN BRIEF:
    # ddply is applying a function to each subset of values in the data frame 'raw' as split into groups by 'Group1'
    # and summarising the data for the groups
    # sum(!is.na(Value)) counting the values in each group that haven't been set to 'NA' eg by remove outlier function above...
    # mean(Value, na.rm=TRUE) calculates the mean of each group dropping any 'NA' values (reducing N for that mean)
    # sd(Value, na.rm=TRUE) runs the standard dev function also dropping any 'NA' values
    # sd/sqrt(N) determines the stadard error based on the above standard dev...
    # summary of all data is assigned to raw.summary, subsets (when needed) to raw.summary.multi
    #
    # keep this around even with multi since the entire dataset is sent to gplot for making the figure...
    #utils::globalVariables('raw', 'group_var', 'weight_var')
    if (is.null(raw$base$Group2)) {
        # raw$summary <- plyr::ddply(raw$base, c('statGroups'), plyr::summarise, ### CHANGED - replaced below ###
        #                            Group1 = unique(Group1),
        #                            N = sum(!is.na(Value)),
        #                            mean = mean(Value, na.rm=TRUE),
        #                            sd = stats::sd(Value, na.rm=TRUE),
        #                            se = sd/sqrt(N),
        #                            median = stats::median(Value, na.rm=TRUE),
        #                            IQR25 = stats::quantile(Value, probs=(0.25), na.rm=TRUE)[[1]],
        #                            IQR75 = stats::quantile(Value, probs=(0.75), na.rm=TRUE)[[1]] )
        raw$summary <- raw$base %>% dplyr::group_by(.data$statGroups) %>%
                            dplyr::summarise(
                                Group1 = unique(.data$Group1),
                                N = sum(!is.na(.data$Value)),
                                mean = mean(.data$Value, na.rm=TRUE),
                                sd = stats::sd(.data$Value, na.rm=TRUE),
                                se = .data$sd/sqrt(.data$N),
                                median = stats::median(.data$Value,na.rm=TRUE),
                                IQR25 = stats::quantile(.data$Value, probs=(0.25), na.rm=TRUE)[[1]],
                                IQR75 = stats::quantile(.data$Value, probs=(0.75), na.rm=TRUE)[[1]]
                            )
    } else {
        # raw$summary <- plyr::ddply(raw$base, c('statGroups'), plyr::summarise, ### CHANGED - replaced below ###
        #                            Group1 = unique(Group1),
        #                            Group2 = unique(Group2),
        #                            N = sum(!is.na(Value)),
        #                            mean = mean(Value, na.rm=TRUE),
        #                            sd = stats::sd(Value, na.rm=TRUE),
        #                            se = sd/sqrt(N),
        #                            median = stats::median(Value,na.rm=TRUE),
        #                            IQR25 = stats::quantile(Value, probs=(0.25), na.rm=TRUE)[[1]],
        #                            IQR75 = stats::quantile(Value, probs=(0.75), na.rm=TRUE)[[1]] )
        raw$summary <- raw$base %>% dplyr::group_by(.data$statGroups) %>%
                            dplyr::summarise(
                                Group1 = unique(.data$Group1),
                                Group2 = unique(.data$Group2),
                                N = sum(!is.na(.data$Value)),
                                mean = mean(.data$Value, na.rm=TRUE),
                                sd = stats::sd(.data$Value, na.rm=TRUE),
                                se = .data$sd/sqrt(.data$N),
                                median = stats::median(.data$Value,na.rm=TRUE),
                                IQR25 = stats::quantile(.data$Value, probs=(0.25), na.rm=TRUE)[[1]],
                                IQR75 = stats::quantile(.data$Value, probs=(0.75), na.rm=TRUE)[[1]]
                            )
    }

    #raw.summary.multi
    #
    # if TRUE only run stats WITHIN each group2
    if (stats$Anova.Group2) {
        n = 1
        raw$summary.multi = vector(mode="list", length = length(levels(raw$base$Group2)))
        for (l in levels(raw$base[,'Group2'])) {
            # raw$summary.multi[[n]] = plyr::ddply(raw$base[raw$base[,'Group2'] %in% c(l),], c('statGroups'), plyr::summarise, ### CHANGED - replaced below ###
            #                                      Group1=unique(Group1),
            #                                      Group2=unique(Group2),
            #                                      N=sum(!is.na(Value)),
            #                                      mean=mean(Value, na.rm=TRUE),
            #                                      sd=stats::sd(Value, na.rm=TRUE),
            #                                      se=sd/sqrt(N),
            #                                      upper=mean+se,
            #                                      median=stats::median(Value,na.rm=TRUE),
            #                                      IQR25=stats::quantile(Value, probs=(0.25), na.rm=TRUE)[[1]],
            #                                      IQR75=stats::quantile(Value, probs=(0.75), na.rm=TRUE)[[1]])
            raw$summary.multi[[n]] <- raw$base[raw$base[,'Group2'] %in% c(l),] %>% dplyr::group_by(.data$statGroups) %>%
                            dplyr::summarise(
                                Group1 = unique(.data$Group1),
                                Group2 = unique(.data$Group2),
                                N = sum(!is.na(.data$Value)),
                                mean = mean(.data$Value, na.rm=TRUE),
                                sd = stats::sd(.data$Value, na.rm=TRUE),
                                se = .data$sd/sqrt(.data$N),
                                upper = .data$mean + .data$se,
                                median = stats::median(.data$Value,na.rm=TRUE),
                                IQR25 = stats::quantile(.data$Value, probs=(0.25), na.rm=TRUE)[[1]],
                                IQR75 = stats::quantile(.data$Value, probs=(0.75), na.rm=TRUE)[[1]]
                            )
            n = n + 1
        }
        # if FALSE run stats on entire dataset regardless...
    } else {
        if(is.null(raw$base$Group2)) {
            # raw$summary.multi = plyr::ddply(raw$base, c('statGroups'), plyr::summarise,  ### CHANGED - replaced below ###
            #                                 Group1=unique(Group1),
            #                                 N=sum(!is.na(Value)),
            #                                 mean=mean(Value, na.rm=TRUE),
            #                                 sd=stats::sd(Value, na.rm=TRUE),
            #                                 se=sd/sqrt(N),
            #                                 upper=mean+se,
            #                                 median=stats::median(Value,na.rm=TRUE),
            #                                 IQR25=stats::quantile(Value, probs=(0.25), na.rm=TRUE)[[1]],
            #                                 IQR75=stats::quantile(Value, probs=(0.75), na.rm=TRUE)[[1]])
            raw$summary.multi <- raw$base %>% dplyr::group_by(.data$statGroups) %>%
                            dplyr::summarise(
                                Group1 = unique(.data$Group1),
                                N = sum(!is.na(.data$Value)),
                                mean = mean(.data$Value, na.rm=TRUE),
                                sd = stats::sd(.data$Value, na.rm=TRUE),
                                se = .data$sd/sqrt(.data$N),
                                upper = .data$mean + .data$se,
                                median = stats::median(.data$Value,na.rm=TRUE),
                                IQR25 = stats::quantile(.data$Value, probs=(0.25), na.rm=TRUE)[[1]],
                                IQR75 = stats::quantile(.data$Value, probs=(0.75), na.rm=TRUE)[[1]]
                            )
        } else {
            # raw$summary.multi = plyr::ddply(raw$base, c('statGroups'), plyr::summarise,  ### CHANGED - replaced below ###
            #                                 Group1=unique(Group1),
            #                                 Group2=unique(Group2),
            #                                 N=sum(!is.na(Value)),
            #                                 mean=mean(Value, na.rm=TRUE),
            #                                 sd=stats::sd(Value, na.rm=TRUE),
            #                                 se=sd/sqrt(N),
            #                                 upper=mean+se,
            #                                 median=stats::median(Value,na.rm=TRUE),
            #                                 IQR25=stats::quantile(Value, probs=(0.25), na.rm=TRUE)[[1]],
            #                                 IQR75=stats::quantile(Value, probs=(0.75), na.rm=TRUE)[[1]])
            raw$summary.multi <- raw$base %>% dplyr::group_by(.data$statGroups) %>%
                            dplyr::summarise(
                                Group1 = unique(.data$Group1),
                                Group2 = unique(.data$Group2),
                                N = sum(!is.na(.data$Value)),
                                mean = mean(.data$Value, na.rm=TRUE),
                                sd = stats::sd(.data$Value, na.rm=TRUE),
                                se = .data$sd/sqrt(.data$N),
                                upper = .data$mean + .data$se,
                                median = stats::median(.data$Value,na.rm=TRUE),
                                IQR25 = stats::quantile(.data$Value, probs=(0.25), na.rm=TRUE)[[1]],
                                IQR75 = stats::quantile(.data$Value, probs=(0.75), na.rm=TRUE)[[1]]
                            )
        }
    }
    #assign("raw.summary.multi", raw.summary.multi, envir = .GlobalEnv) ### CHANGED - no longer needed ###

    # beginning of auto setting YMax - find the upper most values...
    #max(raw.summary.multi[[2]]['upper'])
}
