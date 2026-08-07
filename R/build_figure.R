#' Build Figure
#'
#' @description
#' This function uses the aesthetic settings as defined in the environment and the
#' data and constructs a corresponding figure with the contained information. The
#' only inputs are optional defining if the plot should be printed and / or if
#' it should be saved to disk.
#'
#' @param hsa the histova R6 object
#' @param printPlot T/F Should the finished plot be printed (def F)
#' @param savePlot T/F Should the finished plot & log be saved to disk (def T)
#' @param printEnvMsg T/F Passed on to set_env to determine if resume message printed (def T)
#'
#' @export
#'
build_figure <- function(hsa, printPlot = FALSE, savePlot = TRUE, printEnvMsg = TRUE) {

    set_env(the$Location.Dir, the$Location.File, the$Log.Save, env.new=FALSE, printEnvMsg)

    histova_msg("Build Histogram", type="head")
    set_aesthetics(hsa)
    build_histo(hsa)

    # add a line to the figure...
    if ( isFALSE(is.na(hsa$get("fig.plot.hline")$y[[1]])) ) {
         for (HL in 1:nrow(hsa$get("fig.plot.hline"))) {
             histova_msg(sprintf("adding a horizontal line to the figure at: \'%s\'", hsa$get("fig.plot.hline")$y[HL]))
             the$gplot = the$gplot + ggplot2::geom_hline(yintercept=hsa$get("fig.plot.hline")$y[HL], linetype="solid", color=hsa$get("fig.plot.hline")$color[HL], linewidth=hsa$get("fig.plot.hline")$size[HL])
         }
    }

    # print out the plot for viewing in RStudio - probably good idea to make this an optional setting...
    if (printPlot) { print(the$gplot) }

    # save the image to the working directory using the modified txt filename - this WILL
    # overwrite an existing image...
    if (savePlot) {
        the$Location.Image = paste0(the$Location.Dir, "/", sub("txt", hsa$get("fig.save.type"), the$Location.File))
        histova_msg("SAVE Histogram", type="head")
        histova_msg(sprintf("saving your new figure to: \'%s\'", the$Location.Image), tabs=1)

        # implement cairo package to better embed fonts into the output
        if (hsa$get("fig.save.type") %in% c("tex", "svg")) {
            ggplot2::ggsave(the$Location.Image, width = hsa$get("fig.save.width"), height = hsa$get("fig.save.height"), dpi = hsa$get("fig.save.dpi"), units = hsa$get("fig.save.units"), device = hsa$get("fig.save.type"), limitsize = FALSE)
        } else if (hsa$get("fig.save.type") == "pdf") {
            ggplot2::ggsave(the$Location.Image, width = hsa$get("fig.save.width"), height = hsa$get("fig.save.height"), dpi = hsa$get("fig.save.dpi"), units = hsa$get("fig.save.units"), device = grDevices::cairo_pdf, limitsize = FALSE)
        } else if (hsa$get("fig.save.type") %in% c("jpg", "jpeg", "png", "tiff")) {
            ggplot2::ggsave(the$Location.Image, width = hsa$get("fig.save.width"), height = hsa$get("fig.save.height"), dpi = hsa$get("fig.save.dpi"), units = hsa$get("fig.save.units"), device = hsa$get("fig.save.type"), limitsize = FALSE)
        } else {
            ggplot2::ggsave(the$Location.Image, width = hsa$get("fig.save.width"), height = hsa$get("fig.save.height"), dpi = hsa$get("fig.save.dpi"), units = hsa$get("fig.save.units"), device = hsa$get("fig.save.type"), type="cairo", limitsize = FALSE)
        }
    }
    histova_msg(sprintf("finihsed on %s", date()), type="title", breaker = "both")

    if (is_con_open(the$LOG)) {
        close(the$LOG)
    }
}



