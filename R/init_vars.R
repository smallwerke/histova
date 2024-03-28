#' Initialize variables to defaults
#'
#' @return nothing
#' @export
#'
#' @examples
#' init_vars()
init_vars <- function() {

    if (!exists("Override", envir=the)) { the$Override <- FALSE }
    if (isFALSE(the$Override)) {
        ################ Label Size and Appearance (OPT) ################
        fig$Title.Size <- 32
        fig$Axis.TitleSize <- 26
        fig$Axis.LabelSize <- 26
        fig$Axis.LabelSep <- 20
        fig$Axis.ValueSize <- 26
        fig$Legend.LabelSize <- 26
        fig$Convert <- TRUE
        fig$Font <- "sans"

        ################ Display of the Axis & Plot (OPT) ################
        fig$X.Angle <- 45
        fig$X.Value.Display <- TRUE
        fig$X.Tick.Display <- TRUE
        # .Ratio for when a number is entered in config
        fig$Coord.Fixed <- TRUE
        fig$Coord.Fixed.Ratio <- "SQUARE"
        fig$Bar.Width <- 0.8
        fig$Bar.Border.Color <- "white"
        fig$Bar.Border.Width <- 0.2

        ################ Colors and Display Individual Points (OPT) ################
        fig$Colors <- c()
        colors.unique = data.frame(matrix(ncol = 4, nrow = 0))
        colnames(colors.unique) = c("color", "scatterColor", "scatterShape", "scatterSize")
        fig$Colors.Unique <- colors.unique
        fig$Colors.Alpha <- 1
        fig$Scatter.Disp <- TRUE
        fig$Scatter.Alpha <- 1
        fig$Scatter.Color <- NA
        fig$Scatter.Shape <- NA
        fig$Scatter.Size <- NA
        fig$Scatter.Stroke <- NA
        fig$Plot.Whisker <- "FALSE"
    }

    ################ Title & Axis Labels (REQ) ################
    fig$Title <- ""

    ################ Height of Y-axis and Horizontal Line/s (REQ) ################
    fig$Y.Min <- 0
}
