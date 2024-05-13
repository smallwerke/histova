#' Build Histogram
#'
#' @description
#' Build histogram using data and configuration settings saved in the package environment. This function
#' tries to put all the possible options specified in the configuration together into a working figure.
#' Package is typically called by generate_figure after environment variables have been loaded and all
#' desired statistical tests have been carried out.
#'
#' @export
#'
#' @importFrom rlang .data
build_histo <- function(){

    histova_msg("Building Histogram", type="subhead")
    # using the .data feature from rlang as specified:
    # https://cran.r-project.org/web/packages/ggplot2/vignettes/ggplot2-in-packages.html
    # to address warnings from check()

    # Determine if any calculations are to be done for the Stat Letter Offset
    if (! isTRUE(stats$Letters.Offset)) {
        # take into account the reduction due to any y-axis breaks
        breakLess = 0
        if (fig$Y.Break == TRUE) {
            for(i in 1:nrow(fig$Y.Break.df)) {
                breakLess = breakLess + abs(fig$Y.Break.df[i,]$stop - fig$Y.Break.df[i,]$start)
            }
        }
        stats$Letters.Offset <- abs(fig$Y.Max - fig$Y.Min - breakLess) / 25
    }

    mynamestheme = ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", size = (18)))

    ##########################################
    # Time Course Figure
    ##########################################
    if (stats$Transform == "TimeCourse") {
        gplot = ggplot2::ggplot(raw$summary, ggplot2::aes(y=mean, label = .data$Group2, x = .data$Group1, fill = .data$Group2, width=.85)) +
            ggplot2::geom_bar(
                alpha = fig$Colors.Alpha,
                color = fig$Bar.Border.Color,
                linewidth = fig$Bar.Border.Width,
                position = ggplot2::position_dodge(),
                stat = 'identity') +
            # turn off the legend (or certain aspects of it)...
            #guides(shape = 'none') +
            #guides(size = 'none') +
            #guides(color = 'none') +
            ggplot2::scale_fill_manual(
                values=fig$Color.List,
                name=fig$Legend.Title)
        ##########################################
        # Basic Whiskerplot
        # ggplot(df, aes(x, y, <other aesthetics>))
        ##########################################
    } else if (fig$Plot.Whisker %in% c("BOX", "VIOLIN")) {
        if (fig$Legend.Color.Source == "Group1") {
            gplot = ggplot2::ggplot(raw$base, ggplot2::aes(.data$Group1, .data$Value, label = .data$Group1, fill = .data$Group1))
        } else {
            gplot = ggplot2::ggplot(raw$base, ggplot2::aes(.data$Group1, .data$Value, label = .data$Group1, fill = .data$statGroups))
        }
        if (fig$Plot.Whisker == "BOX") {
            gplot = gplot +
                ggplot2::geom_boxplot(
                    outlier.shape = NA,
                    alpha = fig$Colors.Alpha)
        } else if (fig$Plot.Whisker == "VIOLIN") {
            gplot = gplot +
                ggplot2::geom_violin(
                    trim = TRUE,
                    alpha = fig$Colors.Alpha)
        }
        gplot = gplot + ggplot2::scale_fill_manual(
            values=fig$Color.List,
            name=fig$Legend.Title)
        ##########################################
        # 'Standard' Figure
        # ggplot(df, aes(x, y, <other aesthetics>))
        ##########################################
    } else {
        if (fig$Legend.Color.Source == "Group1") {
            gplot = ggplot2::ggplot(raw$summary, ggplot2::aes(.data$Group1, .data$mean, label = .data$Group1, fill = .data$Group1))
        } else {
            gplot = ggplot2::ggplot(raw$summary, ggplot2::aes(.data$Group1, .data$mean, label = .data$Group1, fill = .data$statGroups))
        }
        gplot = gplot + ggplot2::geom_bar(
            alpha= fig$Color.Alpha.List,
            color= fig$Bar.Border.Color,
            linewidth = fig$Bar.Border.Width,
            width= fig$Bar.Width,
            position=ggplot2::position_dodge(),
            stat='identity') +

            ggplot2::scale_fill_manual(values=fig$Color.List, name=fig$Legend.Title)
    }
    ##########################################
    # Common Settings
    ##########################################
    # set the main titles for the figure
    gplot = gplot + ggplot2::labs(
        title=fig$Title,
        y=fig$Y,
        #caption = paste(Notes.Stats.Method, Notes.Stats.Outlier, sep="\n"),
        x=fig$X)
    gplot = gplot + ggplot2::theme(
        text=ggplot2::element_text(family=fig$Font),
        plot.title = ggtext::element_markdown(lineheight=0.8, size=fig$Title.Size, hjust=0.5, vjust=0, margin=ggplot2::margin(b=0, unit = "pt")),
        plot.caption = ggplot2::element_text(color="black", size=stats$Caption.Size, face="italic"),
        axis.title = ggplot2::element_text(color="black", size=fig$Axis.LabelSize ),
        axis.title.y = ggplot2::element_text(angle = 90, margin = ggplot2::margin(t = 0, r = fig$Axis.LabelSep, b = 0, l = 0)),
        axis.title.x = ggtext::element_markdown(margin = ggplot2::margin(t = fig$Axis.LabelSep, r = 0, b = 0, l = 0)),
        axis.line.y = ggplot2::element_line(color=fig$Axis.Y.Main.Color, linewidth=fig$Axis.Y.Main.Size),
        axis.line.x = ggplot2::element_line(color=fig$Axis.X.Main.Color, linewidth=fig$Axis.X.Main.Size),
        axis.text = ggplot2::element_text(color="black", size=fig$Axis.ValueSize),
        axis.ticks.y = ggplot2::element_line(color=fig$Axis.Y.Tick.Color, linewidth=fig$Axis.Y.Tick.Size),
        axis.ticks.length.y = ggplot2::unit(fig$Axis.Y.Tick.Length, "cm"),
        axis.ticks.x = ggplot2::element_line(color=fig$Axis.X.Tick.Color, linewidth=fig$Axis.X.Tick.Size),
        axis.ticks.length.x = ggplot2::unit(fig$Axis.X.Tick.Length, "cm"),
        # CUSTOMIZE
        #plot.title = element_text(lineheight=0.8, size=Fig.Title.Size, face="bold", hjust=0.5, vjust=0, margin=margin(b=5, unit = "pt")),
        #plot.caption = element_text(color="black", size=Stats.Caption.Size, face="italic"),
        #axis.title = element_text(color="black", size=Fig.Axis.LabelSize, face="bold"),
        #axis.title.y = element_text(angle = 90, margin = margin(t = 0, r = Fig.Axis.LabelSep, b = 0, l = 0)),
        #axis.title.x = element_text(margin = margin(t = Fig.Axis.LabelSep, r = 0, b = 0, l = 0)),
        #axis.text.y = element_text(color="black", size=Fig.Axis.ValueSize, face="bold"),
        #axis.text.x = element_text(color="black", size=50, face="bold"),
        #axis.text.x = element_text(angle=0, hjust=0),
        plot.background = ggplot2::element_rect(fill = 'white', colour = 'white'),
        panel.background = ggplot2::element_rect(fill = 'white', colour = 'white'),
        panel.grid.major = ggplot2::element_line(colour = "white", linewidth=0),
        panel.grid.minor.y = ggplot2::element_line(linewidth=3),
        legend.title = ggtext::element_markdown(colour="black", size=fig$Legend.LabelSize),
        legend.text = ggplot2::element_text(colour="black", size = fig$Legend.LabelSize),
        legend.key.size = ggplot2::unit(fig$Legend.Key.Size, fig$Save.Units),
        strip.text.x = ggplot2::element_text(size = fig$Axis.TitleSize, colour = "black"), # defines the above figure sub titles
        strip.background = ggplot2::element_rect(colour="white", fill="white", linewidth=1.5, linetype="solid")
    )

    ###
    # Y axis - add labels to any horizontal lines being added to the figure
    # the labels are going on the secondary y-axis
    # swap Y axis labels to scientific notation...
    Y.Rig.SCI = FALSE
    if (fig$Y.Rig == "SCI") {
        histova_msg(sprintf("setting y-axis to use scientific notation, replacing existing scale_y_continuous..."), tabs=2)
        Y.Rig.SCI = TRUE
    }
    if (is.na(fig$Plot.HLine$y[1]) != TRUE) {
        gplot = gplot + ggplot2::scale_y_continuous(
            labels = function(x) format(x, scientific = Y.Rig.SCI),
            expand = c(0, 0),
            limits=c(fig$Y.Min,fig$Y.Max),
            breaks = seq(fig$Y.Min, fig$Y.Max, by = fig$Y.Interval),
            sec.axis = ggplot2::sec_axis(~ . * 1 , breaks = fig$Plot.HLine$y, labels = format(fig$Plot.HLine$y, scientific = Y.Rig.SCI) )
        )
    } else if (fig$Y.Break == TRUE) {
        # include a NULL secondary axis otherwise IF a y-axis break is included there will be a second y-axis added
        gplot = gplot + ggplot2::scale_y_continuous(
            labels = function(x) format(x, scientific = Y.Rig.SCI),
            expand = c(0, 0),
            limits=c(fig$Y.Min,fig$Y.Max),
            breaks = seq(fig$Y.Min, fig$Y.Max, by = fig$Y.Interval)
            #sec.axis = ggplot2::sec_axis(~ . * 1 , breaks = NULL, labels = NULL)
        )
    } else {
        # if no y-breaks than don't bother with the secondary axis (it will throw an error if left in)
        gplot = gplot + ggplot2::scale_y_continuous(
            labels = function(x) format(x, scientific = Y.Rig.SCI),
            expand = c(0, 0),
            limits=c(fig$Y.Min,fig$Y.Max),
            breaks = seq(fig$Y.Min, fig$Y.Max, by = fig$Y.Interval)
        )
    }

    #########################################################
    # add scatter plot into the figure
    #
    ############################
    if (fig$Scatter.Disp) {
        if (stats$Transform == "TimeCourse") {
            gplot = gplot + ggplot2::geom_point(
                data=raw$base, ggplot2::aes(x = .data$Group1, y = .data$Value, group = .data$statGroups, color = .data$Group2, shape = .data$Group2, size = .data$Group2, stroke = .data$Group2, alpha = .data$Group2),
                position = ggplot2::position_dodge2(width=0.85,padding=0.35),
                stat='identity',
                #alpha=fig$Scatter.Alpha,
                #stroke=fig$Scatter.Stroke,
                show.legend = FALSE
            )
            # makes the scatter points placed in the legend match the group color
            #guides(fill = guide_legend(override.aes = list(shape = NA)))
        } else if (fig$Legend.Color.Source == "Group1") {
            gplot = gplot + ggplot2::geom_point(
                data=raw$base, ggplot2::aes(x = .data$Group1, y = .data$Value, color = .data$Group1, shape = .data$Group1, size = .data$Group1, stroke = .data$Group1, alpha = .data$Group1),
                position=ggplot2::position_dodge2(width=0.7,padding=0.1),
                show.legend = FALSE
            )
        } else {
            gplot = gplot + ggplot2::geom_point(
                data=raw$base, ggplot2::aes(x = .data$Group1, y = .data$Value, color = .data$statGroups, shape = .data$statGroups, size = .data$statGroups, stroke = .data$statGroups, alpha = .data$statGroups),
                position=ggplot2::position_dodge2(width=0.7,padding=0.1),
                show.legend = FALSE
            )
        }
        gplot = gplot + ggplot2::scale_color_manual(values=fig$Scatter.Color.List) +
            ggplot2::scale_shape_manual(values=fig$Scatter.Shape.List) +
            ggplot2::scale_size_manual(values=fig$Scatter.Size.List) +
            ggplot2::scale_discrete_manual("stroke", values=fig$Scatter.Stroke.List) +
            ggplot2::scale_alpha_manual(values=fig$Scatter.Alpha.List)

    }
    #########################################################
    # add error bars to the figure
    #
    # keep this after the scatter plot to ensure the bars
    # aren't covered by the scatter...
    if (fig$Plot.Whisker == "FALSE") {
        if (stats$Transform == "TimeCourse") {
            gplot = gplot + ggplot2::geom_errorbar(
                ggplot2::aes(ymin = .data$mean - .data$se, ymax = .data$mean + .data$se),
                color=fig$Plot.ErrorBar.Color,
                width=fig$Plot.ErrorBar.EndWidth,
                linewidth=fig$Plot.ErrorBar.Size,
                position = ggplot2::position_dodge(width=0.85))
        } else {
            gplot = gplot + ggplot2::geom_errorbar(
                ggplot2::aes(ymin = .data$mean - .data$se, ymax = .data$mean + .data$se),
                color=fig$Plot.ErrorBar.Color,
                width=fig$Plot.ErrorBar.EndWidth,
                linewidth=fig$Plot.ErrorBar.Size,
                position=ggplot2::position_dodge(0.7))
        }
    }

    #
    # modify x axis labels to put them at an angle
    if (fig$X.Angle != 0) {
        gplot = gplot + ggplot2::theme(axis.text.x = ggplot2::element_text(angle=fig$X.Angle, hjust=1))
    }
    #
    # break the figure into two separate ones for each secondary grouping
    if ((fig$Facet.Split) && (stats$Transform != "TimeCourse")) {
        gplot = gplot + ggplot2::facet_grid(~ Group2, scales="free_x", space="free_x")
        # old facet grid that used fixed scales to allow for coord_fixed
        #gplot = gplot + ggplot2::facet_grid(~ Group2, scales="fixed", space="fixed")
    }
    #
    # old code and not very useful until / if there are ever non discrete values for the x-axis
    # having groups simply provide each group with equal width,
    # coord_fixed and aspect.ratio DO NOT work with facet_grid(space="free_x")... This option
    # would have to be avoided if deciding to use coord_fixed or aspect.ratio again...
    # at the moment all space / sizing is done by the width and height settings for saving the figure...
    #
    # determine if the fig shape should be modified:
    #if (fig$Coord.Fixed) {
    if (FALSE) {
        ratio.reset = NULL
        # determine the ratio for any auto requests
        if (fig$Coord.Fixed.Ratio == "SQUARE") {
            fig$Coord.Fixed.Ratio <- 1/(abs(fig$Y.Max-fig$Y.Min) / length(raw$summary[['statGroups']]))
            ratio.reset = TRUE
        }
        histova_msg(sprintf("Figure coordinate ratio for display: %s", fig$Coord.Fixed.Ratio), tabs=2)
        gplot = gplot + ggplot2::coord_fixed(ratio = fig$Coord.Fixed.Ratio)
        # alternative method for controlling the plot dimensions
        #gplot = gplot + ggplot2::theme(aspect.ratio = 1)
        #
        # reset the variable to SQUARE for when override is being used so that the ratio
        # is calculated correctly for each figure
        if (isTRUE(ratio.reset)) {
            fig$Coord.Fixed.Ratio <- "SQUARE"
        }
    }
    #
    # determine where and how the stat letters are applied to each figure
    #
    # if TRUE only run stats WITHIN each group2
    n = 0
    if (stats$Anova.Group2) {
        for (l in levels(raw$base[,'Group2'])) {
            n = n + 1
            s = "\n"
            if (notes$Stats.Method == "") { s = "" }
            notes$Stats.Method <- paste(notes$Stats.Method, sprintf("For group %s: ", l), sep=s)
            #gplot = gplot + geom_text(data = generate_label_df(raw.multi[[n]], raw.aov.multi[[n]], raw.aov.tukey.multi[[n]], raw.summary.multi[[n]], Value ~ statGroups, 'statGroups', Stats.Letters.Offset), size = (Stats.Letters.Size / 2.834645669), fontface="bold", aes(x = Group1, y = V1, label = labels))
            if (stats$Transform == "TimeCourse") {
                gplot = gplot + ggplot2::geom_text(data = generate_label_df(n), size = (stats$Letters.Size / 2.834645669), fontface="bold", ggplot2::aes(y = .data$V1, label = .data$labels), position = ggplot2::position_dodge(0.85))
            } else {
                gplot = gplot + ggplot2::geom_text(data = generate_label_df(n), size = (stats$Letters.Size / 2.834645669), fontface="bold", ggplot2::aes(y = .data$V1, label = .data$labels), position = ggplot2::position_dodge(0.7))
            }
        }
        # add border lines between / around the facet grids in order to make it clear that the stats are separate...
        gplot = gplot + ggplot2::theme(
            panel.spacing = ggplot2::unit(.05, "lines"),
            panel.border = ggplot2::element_rect(color = "black", fill = NA, linewidth=1)
        )

    # if FALSE run stats on entire dataset regardless...
    } else {
        s = "\n"
        if (notes$Stats.Method == "") { s = "" }
        notes$Stats.Method <- paste(notes$Stats.Method, "Statistical test: ", sep=s)
        #gplot = gplot + geom_text(data = generate_label_df(raw, raw.aov.multi, raw.aov.tukey.multi, raw.summary.multi, Value ~ statGroups, 'statGroups', Stats.Letters.Offset), size = (Stats.Letters.Size / 2.834645669), fontface="bold", aes(x = Group1, y = V1, label = labels))
        if (stats$Transform == "TimeCourse") {
            gplot = gplot + ggplot2::geom_text(data = generate_label_df(n), size = (stats$Letters.Size / 2.834645669), fontface="bold", ggplot2::aes(y = .data$V1, label = .data$labels), position = ggplot2::position_dodge(0.85))
        } else {
            gplot = gplot + ggplot2::geom_text(data = generate_label_df(n), size = (stats$Letters.Size / 2.834645669), fontface="bold", ggplot2::aes(y = .data$V1, label = .data$labels), position = ggplot2::position_dodge(0.7))
        }
    }

    if (isTRUE(stats$Caption.Display)) {
        if (notes$Stats.Method == "Statistical test: ") { notes$Stats.Method <- paste(notes$Stats.Method, "----") }
        gplot = gplot + ggplot2::labs(caption = paste(notes$Stats.Method, notes$Stats.Outlier, sep="\n"))
    }
    # REGARDLESS print the statistical notes to the logfile
    histova_msg("Stat Notes:", type="subhead", PRINT = FALSE)
    histova_msg(notes$Stats.Method, PRINT = FALSE)
    histova_msg(notes$Stats.Outlier, PRINT = FALSE)
    histova_msg("----", PRINT = FALSE)

    # is it possible to create figures with the exact same internal size?
    #grid.arrange(grobs=lapply(list(gplot), set_panel_size, height=unit(18, "cm"), width=unit(18, "cm")))

    # add the y-axis breaks to the figure
    if (fig$Y.Break == TRUE) {
        for(i in 1:nrow(fig$Y.Break.df)) {
            histova_msg(sprintf("adding a break to the y-axis between %s and %s with scales of \'%s\'", fig$Y.Break.df[i,]$start, fig$Y.Break.df[i,]$stop, fig$Y.Break.df[i,]$scales), tabs=2)
            gplot = gplot + ggbreak::scale_y_break(c(fig$Y.Break.df[i,]$start, fig$Y.Break.df[i,]$stop), scales = fig$Y.Break.df[i,]$scales)
        }
        # remove the right Y axis from the plot (is added by default with a Y Break)...
        # BUT not when HLines have been included (as the right y axis holds that info)
        if (is.na(fig$Plot.HLine$y[1]) == TRUE) {
             gplot = gplot +  ggplot2::theme(axis.text.y.right = ggplot2::element_blank(),
                axis.ticks.y.right = ggplot2::element_blank(), axis.line.y.right = ggplot2::element_blank())
        } else {
            gplot = gplot +  ggplot2::theme(axis.line.y.right = ggplot2::element_blank())
        }
    }

    # set the position of the legend (IF there even is a legend)...
    if (fig$Legend.Display == TRUE) {
        gplot = gplot + ggplot2::theme(legend.position = fig$Legend.Position)
    } else {
        gplot = gplot + ggplot2::theme(legend.position = "none")
    }

    # turn off the x-axis labels
    if (fig$X.Value.Display == FALSE) { gplot = gplot + ggplot2::theme(axis.text.x=ggplot2::element_blank()) }
    # turn off the x-axis ticks
    if (fig$X.Tick.Display == FALSE) { gplot = gplot + ggplot2::theme(axis.ticks.x=ggplot2::element_blank()) }

    # make the plot accessible...
    #assign("gplot", gplot, envir = .GlobalEnv) ### CHANGED - putting the plot into THE main environment 'the' ###
    the$gplot = gplot

    #n = 2
    #generate_label_df(raw.multi[[n]], raw.aov.tukey.multi[[n]], raw.summary.multi[[n]], Value ~ statGroups, 'statGroups', Stats.Letters.Offset)
}
