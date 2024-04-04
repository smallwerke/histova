#' Generate Label df
#'
#' @description generate labels for the figure
#'
#' @param n the number of labels
#'
#' @return A data frame of labels
#' @export
#'
generate_label_df <- function(n){

    ####################################################################################
    # ACTUAL CALLS:
    # data = generate_label_df(raw.multi[[n]], raw.aov.multi[[n]], raw.aov.tukey.multi[[n]], raw.summary.multi[[n]], Value ~ statGroups, 'statGroups', Stats.Letters.Offset)
    # data = generate_label_df(raw, raw.aov.multi, raw.aov.tukey.multi, raw.summary.multi, Value ~ statGroups, 'statGroups', Stats.Letters.Offset)
    #
    # generate_label_df <- function(
    #   HSDdata     -> is a global variable already
    #   HSDaov      -> is a global variable already
    #   HSDtukey    -> is a global variable already
    #   HSDsummary  -> is a global variable already
    #   comparison  -> is set & defined in the run_anova function and would have to be changed their as well... pretty static
    #   flev        -> is set & defined throughout the script, would require a near global redesign...
    #   yOff        -> is a global variable already
    # )
    # moving to:
    # data = generate_label_df(n)
    # 0 denotes the 'entire dataset' ie raw, raw.aov.multi
    # > 0 denotes that section of the dataset ie: raw.multi[n], raw.aov.multi[[n]]
    #
    ####################################################################################
    # GENERATE LABEL DF
    #
    # generate the data frame containing the letters displayed in the figure
    #
    # warning - changing headers or variable names needs to be reflected in this function!
    # AUTOMATED significant letter group asignment
    # FROM: https://stackoverflow.com/questions/18771516/is-there-a-function-to-add-aov-post-hoc-testing-results-to-ggplot2-boxplot
    # call used: generate_label_df(raw, raw.aov.tukey.multi, raw.summary.multi, Value ~ statGroups, 'statGroups', Stats.Letters.Offset)
    # OR: generate_label_df(raw.multi[[n]], raw.aov.multi[[n]], raw.aov.tukey.multi[[n]], raw.summary.multi[[n]], Value ~ statGroups, 'statGroups', Stats.Letters.Offset)
    # generate_label_df <- function(HSDdata, HSDaov, HSDtukey, HSDsummary, comparison, flev, yOff){
    #
    #
    ##########################################
    # build the variables required in this function - some are redundant and could/should be cleaned up...
    histova_msg("Generate Figure Labels", type="subhead")
    comparison = Value ~ statGroups
    flev = 'statGroups'
    yOff = stats$Letters.Offset
    alpha = 0.05

    if (n > 0) {
        #n = 1
        HSDdata = raw$multi[[n]]
        HSDsummary = raw$summary.multi[[n]]
    } else {
        HSDdata = raw$base
        HSDsummary = raw$summary.multi
    }
    #
    ##########################################

    ##########################################
    # generate the 'basic' table with an empty labels column...

    # Get highest quantile for Tukey's 5 number summary and add a bit of space to buffer between
    # upper quantile and label placement
    # $mean and $se are referring to an external column IN HSDsummary - a calculated summary OF HSD
    # HSDsummary is from:
    # ddply(traw, c("variable"), summarise, N=sum(!is.na(value)), mean=mean(value, na.rm=TRUE),sd=sd(value, na.rm=TRUE),se=sd/sqrt(N))
    # ORIG: boxplot.df <- ddply(traw, flev, function (x) max(fivenum(x$value)) + .02)
    if (fig$Plot.Whisker %in% c("BOX", "VIOLIN")) {
        boxplot.df = plyr::ddply(HSDsummary, flev, function (x) ifelse(x$IQR75>=0, ((x$IQR75) + yOff), ((x$IQR75) - yOff)))
    } else {
        boxplot.df = plyr::ddply(HSDsummary, flev, function (x) ifelse(x$mean>=0, ((x$mean) + (x$se) + yOff), ((x$mean) - (x$se) - yOff)))
    }

    # add the corresponding summary data 'back' in...
    labels.df = merge(boxplot.df, raw$summary, by.x = flev, by.y = flev, sort = FALSE)

    main.labels = data.frame(row.names = labels.df$statGroups, plot.labels = labels.df$statGroups, stringsAsFactors = FALSE)
    anova.labels = data.frame(row.names = labels.df$statGroups, plot.labels = labels.df$statGroups, stringsAsFactors = FALSE)
    anova.labels['labels'] = ""
    sttest.labels = data.frame(row.names = labels.df$statGroups, plot.labels = labels.df$statGroups, stringsAsFactors = FALSE)
    sttest.labels['labels'] = ""
    pttest.labels = data.frame(row.names = labels.df$statGroups, plot.labels = labels.df$statGroups, stringsAsFactors = FALSE)
    pttest.labels['labels'] = ""


    # build the letters that will be used from each test, they will be combined into one table later
    # what tests are being carried out and need statistics reporting?
    if ("ANOVA" %in% stats$Test) {
        ##########################################
        # ANOVA variables:
        if (n > 0) {
            HSDaov = raw$aov.multi[[n]]
            HSDtukey = raw$aov.tukey.multi[[n]]
        } else {
            HSDaov = raw$aov.multi
            HSDtukey = raw$aov.tukey.multi
        }
        #
        ##########################################

        ##########################################
        # build the ANOVA letters

        # Extract labels and factor levels from Tukey post-hoc
        # aka: raw.aov.tukey.multi[,"p adj"]
        stats$Tukey.Levels <- HSDtukey[[flev]][,4]

        # IF all results for Tukey.levels are identical (eg 0) then multcompLetters2 will fail as there is nothing to do
        # check to ensure that there is something to work with OTHERWISE throw a warning
        # and assign 'A' to everything
        if (length(unique(stats$Tukey.Levels[!is.na(1)])) == 1) {
            anova.labels = data.frame(labels = rep('--', 6), plot.labels = raw$summary.multi[[1]]$statGroups)
            histova_msg(sprintf("UNABLE to determine significance based on the tukey results! (%s) \n\tAll groups assigned as having NO SIGNIFICANT DIFFERENCE! (file: %s)", paste("", stats$Tukey.levels, collapse=""), the$Location.File ), type="warn", tabs=2)

            # get the work done 'by hand'
        } else {

            # letters but NO order to them...
            # Tukey.labels <- multcompLetters(Tukey.levels)['Letters']
            # ordered by the mean, descending...
            # *** DEFINE STAT NOTE BELOW IF CHANGING APPLIED STATS ***
            stats$Tukey.Labels <- multcompView::multcompLetters2(comparison, stats$Tukey.Levels, HSDdata, Letters=c(LETTERS), threshold=alpha)
            fig$Plot.Labels <- names(stats$Tukey.Labels[['Letters']])
            #names(stats$Tukey.Labels[['Letters']])

            # Create a data frame out of the factor levels and Tukey's homogenous group letters
            # this has the letter description and the statGroup name in the data frame...
            anova.labels <- data.frame(plot.labels = fig$Plot.Labels, labels = stats$Tukey.Labels[['Letters']], stringsAsFactors = FALSE)
            #data.frame(fig$Plot.Labels, labels = stats$Tukey.Labels[['Letters']], stringsAsFactors = FALSE)
        }

        # for figure notes - currently using one-way ANOVA w/ Tukey Post-Hoc Test with a threshold of alpha = 0.05
        notes$Stats.Method <- paste(notes$Stats.Method, sprintf("one-way ANOVA (F(%s,%s) = %s, p = %s) with Tukey's HSD post hoc test (alpha = %s)", summary(HSDaov)[[1]][[1,'Df']], summary(HSDaov)[[1]][[2,'Df']], signif(summary(HSDaov)[[1]][[1,'F value']], digits=4), signif(summary(HSDaov)[[1]][[1,'Pr(>F)']], digits=4), alpha), sep=" ")
    }

    if ("STTest" %in% stats$Test) {
        # t test letters / symbols / whatever should be contained in the sttest data frame
        # and simply need to be assembled into a simplified table
        # from Stats.STTest.Pairs data frame: g1 is group 1 being compared to by g2, group 2
        # l is the symbol that gets placed above g2 denoting significance when compared to g1
        sttest.notes = "Student T-Test:"
        for (i in rownames(stats$STTest.Pairs)) {
            i = as.numeric(i)
            if ((stats$STTest.Pairs$sttest[[i]]$p.value < alpha) && (stats$STTest.Pairs$g2[[i]] %in% HSDsummary$statGroups)) {
                sttest.labels[as.character(stats$STTest.Pairs[i,'g2']),'labels'] = as.character(stats$STTest.Pairs[i,'l'])
                #sttest.notes = sprintf("Fisher F-test with p of %s (%s); Student T-Test:", round(Stats.STTest.Pairs$ftest[[i]][[1]]$p.value, digits=4), Stats.STTest.Pairs$ftest[[i]][[2]])
                sttest.notes = paste(sttest.notes, sprintf("\'%s\' significant to %s with p of %s (F-Test: %s: %s);", stats$STTest.Pairs[i,'l'], stats$STTest.Pairs[i, 'g1'], round(stats$STTest.Pairs$sttest[[i]]$p.value, digits=4), round(stats$STTest.Pairs$ftest[[i]][[1]]$p.value, digits=4), stats$STTest.Pairs$ftest[[i]][[2]]), sep=" ")
            }
        }
        if (substr(sttest.notes, nchar(sttest.notes), nchar(sttest.notes)) == ":") {
            sttest.notes = paste(sttest.notes, "nothing significant found or nothing checked", sep = " ")
        }
        notes$Stats.Method <- paste(notes$Stats.Method, sttest.notes)
    }
    if ("PTTest" %in% stats$Test) {
        # t test letters / symbols / whatever should be contained in the pttest data frame
        # and simply need to be assembled into a simplified table
        # from Stats.PTTest.Pairs data frame: g1 is group 1 being compared to by g2, group 2
        # l is the symbol that gets placed above g2 denoting significance when compared to g1
        pttest.notes = ""
        for (i in rownames(stats$PTTest.Pairs)) {
            i = as.numeric(i)
            if ((stats$PTTest.Pairs$pttest[[i]]$p.value < alpha) && (stats$PTTest.Pairs$g2[[i]] %in% HSDsummary$statGroups)) {
                pttest.labels[as.character(stats$PTTest.Pairs[i,'g2']),'labels'] = as.character(stats$PTTest.Pairs[i,'l'])

                if (pttest.notes == "") { pttest.notes = "Paired Wilcox:" }
                pttest.notes = paste(pttest.notes, sprintf("\'%s\' significant to %s with p of %s;", stats$PTTest.Pairs[i,'l'], stats$PTTest.Pairs[i, 'g1'], round(stats$PTTest.Pairs$pttest[[i]]$p.value, digits=4)), sep=" ")
            }
        }
        if (pttest.notes == "") { pttest.notes = "Paired Wilcox: nothing significant found or nothing checked"}
        notes$Stats.Method <- paste(notes$Stats.Method, pttest.notes)
    }

    # merge the stats results into one data frame for use in displaying the results
    main.labels = merge(anova.labels, pttest.labels, by='plot.labels', all=TRUE)
    #main.labels = plyr::mutate(main.labels, labels = ifelse(labels.x == '', labels.y, ifelse(labels.y == '', labels.x, paste(labels.x, labels.y, sep = ' ')))) ### CHANGED - check() was throwing notes ###
    main.labels = plyr::mutate(main.labels, labels = ifelse(main.labels$labels.x == '', main.labels$labels.y, ifelse(main.labels$labels.y == '', main.labels$labels.x, paste(main.labels$labels.x, main.labels$labels.y, sep = ' '))))
    main.labels$labels.x = NULL
    main.labels$labels.y = NULL
    main.labels
    main.labels = merge(main.labels, sttest.labels, by='plot.labels', all=TRUE)
    #main.labels = plyr::mutate(main.labels, labels = ifelse(labels.x == '', labels.y, ifelse(labels.y == '', labels.x, paste(labels.x, labels.y, sep = ' ')))) ### CHANGED - to below to avoid check() note ###
    main.labels = plyr::mutate(main.labels, labels = ifelse(main.labels$labels.x == '', main.labels$labels.y, ifelse(main.labels$labels.y == '', main.labels$labels.x, paste(main.labels$labels.x, main.labels$labels.y, sep = ' '))))
    main.labels$labels.x = NULL
    main.labels$labels.y = NULL

    labels.df = merge(labels.df, main.labels, by.x = flev, by.y = 'plot.labels', sort = FALSE)

    return(labels.df)
}
