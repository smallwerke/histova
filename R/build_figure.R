#' Build Figure
#'
#' @description
#' This function uses the aesthetic settings as defined in the environment and the
#' data and constructs a corresponding figure with the contained information. The
#' only inputs are optional defining if the plot should be printed and / or if
#' it should be saved to disk.
#'
#' @param printPlot Should the finished plot be printed
#' @param savePlot Should the finished plot & log be saved to disk
#'
#' @export
#'
build_figure <- function(printPlot = FALSE, savePlot = TRUE) {
    histova_msg("Build Histogram", type="head")
    set_aesthetics()
    build_histo()

    # add a line to the figure...
    if (is.na(fig$Plot.HLine$y[1]) != TRUE) {
        for (HL in 1:nrow(fig$Plot.HLine)) {
            histova_msg(sprintf("adding a horizontal line to the figure at: \'%s\'", fig$Plot.HLine$y[HL]))
            the$gplot = the$gplot + ggplot2::geom_hline(yintercept=fig$Plot.HLine$y[HL], linetype="solid", color=fig$Plot.HLine$color[HL], linewidth=fig$Plot.HLine$size[HL])
        }
    }

    # print out the plot for viewing in RStudio - probably good idea to make this an optional setting...
    if (printPlot) { print(the$gplot) }

    # save the image to the working directory using the modified txt filename - this WILL
    # overwrite an existing image...
    if (savePlot) {
        the$Location.Image = paste0(the$Location.Dir, "/", sub("txt", fig$Save.Type, the$Location.File))
        histova_msg("SAVE Histogram", type="head")
        histova_msg(sprintf("saving your new figure to: \'%s\'", the$Location.Image), tabs=1)

        # implement cairo package to better embed fonts into the output
        if (fig$Save.Type %in% c("tex", "svg")) {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, limitsize = FALSE)
        } else if (fig$Save.Type == "pdf") {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = grDevices::cairo_pdf, limitsize = FALSE)
        } else if (fig$Save.Type %in% c("jpg", "jpeg", "png", "tiff")) {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, limitsize = FALSE)
        } else {
            ggplot2::ggsave(the$Location.Image, width = fig$Save.Width, height = fig$Save.Height, dpi = fig$Save.DPI, units = fig$Save.Units, device = fig$Save.Type, type="cairo", limitsize = FALSE)
        }
    }
    histova_msg(sprintf("finihsed on %s", date()), type="title", breaker = "both")
    if (savePlot) { close(the$LOG) }
}
