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
#' @param hsa the R6 histova object being worked on
#'
#' @export
#'
#' @examples
#' init_vars()
init_vars <- function(hsa) {

    histova_msg("Initialize envrionment variables", type="subhead")
    if (!exists("Override", envir=the)) { the$Override <- FALSE }
    if (isFALSE(the$Override)) {
        ################ Label Size and Appearance (OPT) ################
        #fig$Title.Size <- histova::get_default("fig", "Title.Size")
        #fig$Axis.TitleSize <- histova::get_default("fig", "Axis.TitleSize")
        #fig$Axis.LabelSize <- histova::get_default("fig", "Axis.LabelSize")
        #fig$Axis.LabelSep <- histova::get_default("fig", "Axis.LabelSep")
        #fig$Axis.ValueSize <- histova::get_default("fig", "Axis.ValueSize")
        #fig$Legend.LabelSize <- histova::get_default("fig", "Legend.LabelSize")
        #fig$Convert <- histova::get_default("fig", "Convert")
        #fig$Font <- histova::get_default("fig", "Font")

        ################ Display of the Axis & Plot (OPT) ################
        #fig$X.Angle <- histova::get_default("fig", "X.Angle")
        #fig$X.Value.Display <- histova::get_default("fig", "X.Value.Display")
        #fig$X.Tick.Display <- histova::get_default("fig", "X.Tick.Display")

        # .Ratio for when a number is entered in config
        ### currently disabled ###
        #fig$Coord.Fixed <- histova::get_default("fig", "Coord.Fixed")
        #fig$Coord.Fixed.Ratio <- histova::get_default("fig", "Coord.Fixed.Ratio")
        ###
        #fig$Bar.Width <- histova::get_default("fig", "Bar.Width")
        #fig$Bar.Border.Color <- histova::get_default("fig", "Bar.Border.Color")
        #fig$Bar.Border.Width <- histova::get_default("fig", "Bar.Border.Width")

        ################ Colors and Display Individual Points (OPT) ################
        fig$Colors.Unique <- histova::get_default("fig", "Colors.Unique")
        #fig$Colors.Alpha <- histova::get_default("fig", "Colors.Alpha")
        #fig$Scatter.Disp <- histova::get_default("fig", "Scatter.Disp")
        #fig$Scatter.Alpha <- histova::get_default("fig", "Scatter.Alpha")
        fig$Scatter.Color.Source <- histova::get_default("fig", "Scatter.Color.Source") # INTERNAL SETTING
        fig$Scatter.Color <- histova::get_default("fig", "Scatter.Color")
        fig$Scatter.Shape <- histova::get_default("fig", "Scatter.Shape")
        fig$Scatter.Size <- histova::get_default("fig", "Scatter.Size")
        #fig$Scatter.Stroke <- histova::get_default("fig", "Scatter.Stroke")
        fig$Plot.Whisker <- histova::get_default("fig", "Plot.Whisker")

        ################ Line Design Options (OPT) ################
        fig$Axis.X.Main.Size <- histova::get_default("fig", "Axis.X.Main.Size")
        fig$Axis.X.Main.Color <- histova::get_default("fig", "Axis.X.Main.Color")
        fig$Axis.Y.Main.Size <- histova::get_default("fig", "Axis.Y.Main.Size")
        fig$Axis.Y.Main.Color <- histova::get_default("fig", "Axis.Y.Main.Color")
        fig$Axis.X.Tick.Size <- histova::get_default("fig", "Axis.X.Tick.Size")
        fig$Axis.X.Tick.Color <- histova::get_default("fig", "Axis.X.Tick.Color")
        fig$Axis.X.Tick.Length <- histova::get_default("fig", "Axis.X.Tick.Length")
        fig$Axis.Y.Tick.Size <- histova::get_default("fig", "Axis.Y.Tick.Size")
        fig$Axis.Y.Tick.Color <- histova::get_default("fig", "Axis.Y.Tick.Color")
        fig$Axis.Y.Tick.Length <- histova::get_default("fig", "Axis.Y.Tick.Length")
        fig$Plot.ErrorBar.Size <- histova::get_default("fig", "Plot.ErrorBar.Size")
        fig$Plot.ErrorBar.EndWidth <- histova::get_default("fig", "Plot.ErrorBar.EndWidth")
        fig$Plot.ErrorBar.Color <- histova::get_default("fig", "Plot.ErrorBar.Color")
        fig$Plot.HLine.Def.Size <- histova::get_default("fig", "Plot.HLine.Def.Size")
        fig$Plot.HLine.Def.Color <- histova::get_default("fig", "Plot.HLine.Def.Color")
        fig$Plot.HLine.OVRD.Size <- histova::get_default("fig", "Plot.HLine.OVRD.Size")
        fig$Plot.HLine.OVRD.Color <- histova::get_default("fig", "Plot.HLine.OVRD.Color")

        ################ Legend Display Options (OPT) ################
        fig$Legend.Color.Source <- histova::get_default("fig", "Legend.Color.Source")
        fig$Legend.Display <- histova::get_default("fig", "Legend.Display")
        fig$Legend.Key.Size <- histova::get_default("fig", "Legend.Key.Size")
        fig$Legend.Position <- histova::get_default("fig", "Legend.Position")
        fig$Legend.Title <- histova::get_default("fig", "Legend.Title")
        fig$Legend.Title.tmp <- histova::get_default("fig", "Legend.Title.tmp")

        ################ Stats Labels (OPT) ################
        stats$Letters.Offset <- histova::get_default("stats", "Letters.Offset")
        stats$Letters.Size <- histova::get_default("stats", "Letters.Size")
        stats$Caption.Display <- histova::get_default("stats", "Caption.Display")
        stats$Caption.Size <- histova::get_default("stats", "Caption.Size")

        ################ Figure Save (OPT) ################
        #fig$Save.DPI <- histova::get_default("fig", "Save.DPI")
        #fig$Save.Height <- histova::get_default("fig", "Save.Height")
        #fig$Save.Type <- histova::get_default("fig", "Save.Type")
        #fig$Save.Units <- histova::get_default("fig", "Save.Units")
        #fig$Save.Width <- histova::get_default("fig", "Save.Width")
    }

    ################ Title & Axis Labels (REQ) ################
    fig$Title <- histova::get_default("fig", "Title")
    fig$Title.tmp <- histova::get_default("fig", "Title.tmp")
    fig$X <- histova::get_default("fig", "X")
    fig$Y <- histova::get_default("fig", "Y")

    ################ Height of Y-axis and Horizontal Line/s (REQ) ################
    fig$Y.Break <- histova::get_default("fig", "Y.Break")
    fig$Y.Break.df <- histova::get_default("fig", "Y.Break.df")
    fig$Y.Interval <- histova::get_default("fig", "Y.Interval")
    fig$Y.Max <- histova::get_default("fig", "Y.Max")
    fig$Y.Min <- histova::get_default("fig", "Y.Min")
    fig$Plot.HLine <- histova::get_default("fig", "Plot.HLine")

    ################ Alter the Axis (REQ) ################
    fig$Y.Rig <- histova::get_default("fig", "Y.Rig")
    fig$Y.Rig.Newline <- histova::get_default("fig", "Y.Rig.Newline")
    # if there is additional info from Y manipulation store here, not editable in CONFIG
    fig$Y.Supp <- histova::get_default("fig", "Y.Supp")

    ################ Stats Labels (OPT) ################
    # set by the script - RESET per run:
    notes$Stats.Method <- histova::get_default("notes", "Stats.Method")
    notes$Stats.Outlier <- histova::get_default("notes", "Stats.Outlier")

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
