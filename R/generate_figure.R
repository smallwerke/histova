#' Generate Figure
#'
#' @description
#' This is the main function that builds a plot based on the specified configuration file. Pass in
#' the desired directory and file name in string format. By default the function does not print the
#' resulting plot but does save the plot and a log file in the same directory where the configuration
#' file is located.
#'
#' The configuration file must end in .txt and follow a specific format. The resulting plot and log
#' files both take the same name as the config file and simply changes the file extension. The plot
#' type is specified in the config file (default is .jpg) and the log file is set as .histova.
#'
#' This function is a basic wrapper function for the following three main functions:
#' load_file()
#' run_data()
#' build_figure()
#' These can be run individually to the same effect. Functions are in development to allow editing and
#' setting of settings for use in developing what the finished figure will look like (e.g. color and fonts).
#'
#' @param location.dir The directory the data file is contained in
#' @param location.file The file containing the data
#' @param printPlot Should the finished plot be printed
#' @param savePlot Should the finished plot & log be saved to disk
#' @param saveLog T/f Should a log file be generated for this session
#'
#' @export
#'
#' @examples
#' generate_figure("/Users/Shared/HISTOVA_DATA", "test.txt", savePlot = FALSE)
#'
generate_figure <- function(location.dir, location.file, printPlot = FALSE, savePlot = TRUE, saveLog = TRUE) {

    ############################################
    # LOAD FILE (OPTIONS & DATA) - NOTHING MORE
    hsa <- histova::set_env(location.dir, location.file, saveLog) # OPENS logfile connection

    # prep & load config info / data
    load_file_head(hsa)

    # load the data from the file and store it under raw$IN with NO modifications
    load_data()

    ############################################
    # PREP DATA ADJUSTMENTS
    run_data()

    ############################################
    # RUN STATS
    run_stats()

    ############################################
    # BUILD FIGURE
    build_figure(hsa, printPlot, savePlot, printEnvMsg = FALSE) # CLOSES logfile connection

    return(hsa)
}


#
# other options to keep an eye on:
# ggbetweenstats
# example take from: https://stackoverflow.com/questions/77602454/how-to-use-ggbetweenstats-with-grouped-data-at-different-timepoints-in-r
#
# The 'base' ggplot2 code to make a similar plot to what ggbetweenstats outputs...
#
# Source - https://stackoverflow.com/a/77602621
# Posted by Allan Cameron, modified by community. See post 'Timeline' for change history
# Retrieved 2026-04-17, License - CC BY-SA 4.0
#
# library(ggplot2)
# library(ggrepel)
# library(ggsignif)
#
# ggplot(df, aes(Timepoint, Value, group = interaction(Timepoint, Treatment))) +
#     geom_point(aes(color = Treatment, fill = after_scale(alpha(colour, 0.5))),
#                position = position_jitterdodge(dodge.width = 0.9, 0.1),
#                size = 3, shape = 21) +
#     geom_boxplot(fill = NA, color = "black", width = 0.2, linewidth = 0.4,
#                  position = position_dodge(0.9)) +
#     geom_violin(fill = NA, color = "black", width = 0.6, linewidth = 0.4,
#                 position = position_dodge(0.9)) +
#     geom_point(stat = "summary", size = 5, color = "#8a0f00",
#                position = position_dodge(0.9), fun = mean) +
#     geom_label_repel(stat = "summary", fun = mean, size = 3.5,
#                      aes(label = paste0("hat(mu)*scriptstyle(mean)==",
#                                         round(after_stat(y), 2))),
#                      parse = TRUE, position = position_dodge(0.9)) +
#     geom_signif(y_position = 85, xmin = 1:3 - 0.22, xmax = 1:3 + 0.22,
#                 annotations = scales::pvalue(sapply(split(df, df$Timepoint),
#                                                     \(x) wilcox.test(Value~Treatment, x)$p.value),
#                                              add_p = TRUE)) +
#     scale_y_continuous(sec.axis = sec_axis(~.,
#                                            bquote(Pairwise~Test~paste(":")~bold(Wilcoxon~Test)))) +
#     scale_color_brewer(palette = "Set2") +
#     theme_minimal(base_size = 12) +
#     theme(axis.title = element_text(face = 2),
#           legend.position = "bottom",
#           axis.text.y.right = element_blank())

