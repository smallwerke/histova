#' Initialize variables to defaults
#'
#' @description
#' Reset the variables to the defaults used to load and generate another figure. These
#' variables can all be set / changed in the config file. Nothing is passed in or
#' returned as the function is simply resetting the working environments. The variables
#' that are reset can be changed by enabling 'Override' in a config file to keep a
#' persistent aesthetic across multiple figures without having to set everything in each
#' config file. This is also designed to facilitate rapid style changes across multiple figures
#' as the setting only needs to be edited in one config file and will be essentially
#' inhereted by all subsequent figures provided the 'Override' option is not explicitly set.
#'
#' @export
#'
#' @examples
#' init_vars()
init_vars <- function() {

    histova_msg("Initialize envrionment variables", type="subhead")
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
        ### currently disabled ###
        fig$Coord.Fixed <- TRUE
        fig$Coord.Fixed.Ratio <- "SQUARE"
        ###
        fig$Bar.Width <- 0.8
        fig$Bar.Border.Color <- "white"
        fig$Bar.Border.Width <- 0.2

        ################ Colors and Display Individual Points (OPT) ################
        fig$Colors <- c()
        colors.unique = data.frame(matrix(ncol = 8, nrow = 0))
        colnames(colors.unique) = c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha")
        fig$Colors.Unique <- colors.unique
        fig$Colors.Alpha <- 1
        fig$Scatter.Disp <- TRUE
        fig$Scatter.Alpha <- 1
        fig$Scatter.Color.Source <- "DEF" # INTERNAL SETTING
        fig$Scatter.Color <- "#FFD700"
        fig$Scatter.Shape <- 4
        fig$Scatter.Size <- 1.8
        fig$Scatter.Stroke <- 2
        fig$Plot.Whisker <- "FALSE"

        ################ Line Design Options (OPT) ################
        fig$Axis.X.Main.Size <- 0.8
        fig$Axis.X.Main.Color <- "black"
        fig$Axis.Y.Main.Size <- 0.8
        fig$Axis.Y.Main.Color <- "black"
        fig$Axis.X.Tick.Size <- 0.6
        fig$Axis.X.Tick.Color <- "black"
        fig$Axis.X.Tick.Length <- 0.1
        fig$Axis.Y.Tick.Size <- 0.6
        fig$Axis.Y.Tick.Color <- "black"
        fig$Axis.Y.Tick.Length <- 0.1
        fig$Plot.ErrorBar.Size <- 0.8
        fig$Plot.ErrorBar.EndWidth <- 0.4
        fig$Plot.ErrorBar.Color <- "black"
        fig$Plot.HLine.Def.Size <- 1
        fig$Plot.HLine.Def.Color <- "black"
        fig$Plot.HLine.OVRD.Size <- NA
        fig$Plot.HLine.OVRD.Color <- NA

        ################ Legend Display Options (OPT) ################
        fig$Legend.Display <- FALSE
        fig$Legend.Color.Source <- "All"
        fig$Legend.Title <- "Groups"
        fig$Legend.Title.tmp <- ""
        fig$Legend.Position <- "bottom"
        fig$Legend.Key.Size <- 0.25

        ################ Stats Labels (OPT) ################
        stats$Letters.Offset <- FALSE
        stats$Letters.Size <- 18
        stats$Caption.Display <- TRUE
        stats$Caption.Size <- 6

        ################ Figure Save (OPT) ################
        fig$Save.Width <- 8
        fig$Save.Height <- 8.5
        fig$Save.DPI <- 320
        fig$Save.Units <- "in"
        fig$Save.Type <- "jpg"
    }

    ################ Title & Axis Labels (REQ) ################
    fig$Title <- ""
    fig$Title.tmp <- ""
    fig$X <- ""
    fig$Y <- ""

    ################ Height of Y-axis and Horizontal Line/s (REQ) ################
    fig$Y.Min <- 0
    fig$Y.Max <- ""
    fig$Y.Interval <- ""
    fig$Y.Break <- FALSE
    fig$Y.Break.df <- data.frame(matrix(ncol=3, nrow=0))
    colnames(fig$Y.Break.df) <- c("start","stop", "scales")
    fig$Plot.HLine <- data.frame(y=c(NA),size=c(0),color=c(""))

    ################ Alter the Axis (REQ) ################
    fig$Y.Rig <- FALSE
    fig$Y.Rig.Newline <- FALSE
    # if there is additional info from Y manipulation store here, not editable in CONFIG
    fig$Y.Supp <- ""

    ################ Stats Labels (OPT) ################
    # set by the script - RESET per run:
    notes$Stats.Method <- ""
    notes$Stats.Outlier <- ""

    ################ Stats Tests (REQ) ################
    stats$Test <- c()
    stats$STTest.Pairs <- data.frame()
    stats$PTTest.Pairs <- data.frame()

    ################ Stats Transformation or Outlier (REQ) ################
    stats$Transform <- FALSE
    stats$Transform.Treatment <- ""
    stats$Outlier <- "TWO"
    stats$Group1.Mute <- FALSE ### CHANGED ###

    ################ Split on Group 2? (REQ) ################
    stats$Anova.Group2 <- FALSE
    fig$Facet.Split <- TRUE

    # clear out all the variables generated in the run_stats_prep()
    raw$base <- "" ### CHANGED ###
    raw$multi <- ""
    raw$anova.multi <- ""
    raw$aov.multi <- ""
    raw$aov.tukey.multi <- ""
    raw$summary <- ""
    raw$summary.multi <- ""

    # clear out ANOVA generated values
    stats$Tukey.Levels <- "" ### CHANGED ###
    stats$Tukey.Labels <- ""

    # clear out plot generated values
    fig$Plot.Labels <- "" ### CHANGED ### PAY ATTENTION AND MAKE UPERCASE!
}
