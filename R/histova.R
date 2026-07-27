#' R6 Class Representing a HISTOVA object
#'
#' Store all of the data and provide a get() function
#' @export
histova <- R6::R6Class(
    "HISTOVA",
    public = list(

        #' @field behave list for object behavior, default to FALSE
        behave = list(
            "verbose"=FALSE,
            "debug"=FALSE,
            "print"=TRUE,
            "log"=TRUE
        ),
        #' @field fig list for figure data
        fig = list(
            "convert" = NULL,
            "axis.title.size" = NULL,
            "axis.label.size" = NULL,
            "axis.label.sep" = NULL,
            "axis.value.size" = NULL,
            "legend.label.size" = NULL,
            "font" = NULL,
            "title.size" = NULL
        ),
        #' @field file list for histova including open file connections
        file = list(),
        #' @field notes list for histova process
        notes = list(),
        #' @field raw list for histova input data for fallback after transformation
        raw = list(),
        #' @field stats list for stats output
        stats = list(),

        #' @description
        #' get data from object
        #' @param x data to pull
        #' @param ref reference HISTOVA object
        get = function(x, ref=NA) {
            # don't want to call get from get so...
            # do a quick check IN CASE behave.verbose was deleted, default to TRUE in this instance
            # as something fundamental is likely wrong...
            if ( ("behave" %in% names(self)) && ("debug" %in% names(self$behave)) ) {
                debug = self$behave$debug
            } else {
                debug = TRUE
            }
            if (debug) { message(paste0("D: HISTOVA$GET pulling data: ", x)) }
            if (length(strsplit(x, ".", fixed=TRUE)[[1]]) < 2) {
                if (debug) { message("    D: not enough depth (need at least a list.var) - try again!") }
                return(NA)
            } else {
                name.L =  strsplit(x, ".", fixed=TRUE)[[1]][1]
                name.I =  paste(unlist(strsplit(x, ".", fixed=TRUE)[[1]][-1]), collapse=".")
                if (debug) { message(paste0("    D: pulling from list: \'", name.L, "\' var: \'", name.I, "\'")) }
            }

            # IF the requested variable is a style type reference AND the
            # submitted reference is not NA
            if ( (class(ref)[1] == "HISTOVA") && (self$is_style(name.L, name.I)) ) {
                if (debug) { message("    D: pulling a reference value") }
                return(ref$get(x))
            } else {
                if (debug) { message("    D: pulling from self") }
                if ( (name.L %in% names(self)) && (name.I %in% names(self[[name.L]])) ) {
                    # now check on if NA for default value call...
                    if (is.null(self[[name.L]][[name.I]])) {
                        if (debug) { message("    D: pull default value") }
                        return(self$get_default(name.L, name.I))
                    } else {
                        if (debug) { message("    D: send the stored value!") }
                        return(self[[name.L]][[name.I]])
                    }
                } else {
                    if (debug) { message(paste0("    D: unable to find \"", x, "\", send default if exists")) }
                    #return(NULL)
                    return(self$get_default(name.L, name.I))
                }
            }
        },
        #' @description
        #' if there is a default value available pull it, otherwise return NULL
        #' @param name.L the list name
        #' @param name.I the info name / variable
        get_default = function(name.L, name.I) {
            if ( ("behave" %in% names(self)) && ("debug" %in% names(self$behave)) ) {
                debug = self$behave$debug
            } else {
                debug = TRUE
            }
            if ( (name.L %in% names(private$default)) && (name.I %in% names(private$default[[name.L]])) ) {
                if (debug) { message("    D: send the default!") }
                return(private$default[[name.L]][[name.I]])
            } else {
                if (debug) { message("    D: send NULL!") }
                return(NULL)
            }
        },
        #' @description
        #' is this a style variable that can be overidden?
        #' @param name.L the list name
        #' @param name.I the info name / variable
        is_style = function(name.L, name.I) {
            if ( (name.L %in% names(private$styles)) && (name.I %in% private$styles[[name.L]]) ) {
                return(TRUE)
            } else {
                return(FALSE)
            }
        }
    ),
    private = list(
        styles = list(
            fig = c(
                "axis.title.size",
                "axis.label.sep",
                "axis.label.size",
                "axis.value.size",
                "axis.x.main.color",
                "axis.x.main.size",
                "axis.x.tick.color",
                "axis.x.tick.length",
                "axis.x.tick.size",
                "axis.y.main.color",
                "axis.y.main.size",
                "axis.y.tick.color",
                "axis.y.tick.length",
                "axis.y.tick.size",
                "bar.border.color",
                "bar.border.width",
                "bar.width",
                "colors.alpha",
                "colors.unique",
                "convert",
                "coord.fixed",
                "coord.fixed.ratio",
                "font",
                "legend.color.source",
                "legend.display",
                "legend.key.size",
                "legend.label.size",
                "legend.position",
                "legend.title",
                "legend.title.tmp",
                "plot.errorbar.endwidth",
                "plot.errorbar.color",
                "plot.errorbar.size",
                "plot.hline.def.color",
                "plot.hline.def.size",
                "plot.hline.OVRD.color",
                "plot.hline.OVRD.size",
                "plot.whisker",
                "save.dpi",
                "save.height",
                "save.type",
                "save.units",
                "save.width",
                "scatter.alpha",
                "scatter.color",
                "scatter.color.source",
                "scatter.disp",
                "scatter.shape",
                "scatter.size",
                "scatter.stroke",
                "title.size",
                "x.angle",
                "x.tick.display",
                "x.value.display"
            ),
            notes = c(
                "stats.method",
                "stats.outlier"
            ),
            stats = c(
                "caption.display",
                "caption.size",
                "letters.offset",
                "letters.size"
            )
        ),
        default = list(
            behave = list(),
            fig = list(
                "axis.label.sep" = 20,
                "axis.label.size" = 26,
                "axis.title.size" = 26,
                "axis.value.size" = 26,
                "axis.x.main.color" = "black",
                "axis.x.main.size" = 0.8,
                "axis.x.tick.color" = "black",
                "axis.x.tick.length" = 0.1,
                "axis.x.tick.size" = 0.6,
                "axis.y.main.color" = "black",
                "axis.y.main.size" = 0.8,
                "axis.y.tick.color" = "black",
                "axis.y.tick.length" = 0.1,
                "axis.y.tick.size" = 0.6,
                "bar.border.color" = "white",
                "bar.border.width" = 0.2,
                "bar.width" = 0.8,
                "color.alpha.list" = "",
                "color.list" = "",
                "colors" = c(),
                "colors.alpha" = 1,
                "colors.unique" = data.frame(matrix(
                    ncol = 8, nrow = 0,
                    dimnames = list(NULL, c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha"))
                )),
                "convert" = TRUE,
                "coord.fixed" = TRUE,
                "coord.fixed.ratio" = "SQUARE",
                "facet.split" = TRUE,
                "font" = "sans",
                "legend.color.source" = "All",
                "legend.display" = FALSE,
                "legend.key.size" = 0.25,
                "legend.label.size" = 26,
                "legend.position" = "bottom",
                "legend.title" = "Groups",
                "legend.title.tmp" = "",
                "plot.errorbar.color" = "black",
                "plot.errorbar.endwidth" = 0.4,
                "plot.errorbar.size" = 0.8,
                "plot.hline" = data.frame(y=c(NA), size=c(0), color=c("")),
                "plot.labels" = "",
                "plot.whisker" = "FALSE",
                "plot.hline.def.color" = "black",
                "plot.hline.def.size" = 1,
                "plot.hline.OVRD.color" = NA,
                "plot.hline.OVRD.size" = NA,
                "save.dpi" = 320,
                "save.height" = 8.5,
                "save.type" = "jpg",
                "save.units" = "in",
                "save.width" = 8,
                "scatter.alpha" = 1,
                "scatter.color" = "#FFD700",
                "scatter.color.source" = "DEF",
                "scatter.disp" = TRUE,
                "scatter.shape" = 4,
                "scatter.size" = 1.8,
                "scatter.stroke" = 2,
                "shape.list" = "",
                "size.list" = "",
                "stroke.list" = "",
                "title" = "",
                "title.size" = 32,
                "title.tmp" = "",
                "x" = "",
                "x.angle" = 45,
                "x.tick.display" = TRUE,
                "x.tmp" = "",
                "x.value.display" = TRUE,
                "y" = "",
                "y.break" = FALSE,
                "y.break.df" = data.frame(matrix(
                    ncol = 3, nrow = 0,
                    dimnames = list(NULL, c("start", "stop", "scales"))
                )),
                "y.interval" = "",
                "y.max" = "",
                "y.min" = 0,
                "y.rig" = FALSE,
                "y.rig.newline" = FALSE,
                "y.supp" = "",
                "y.tmp" = ""
            ),
            file = list(
                "location.dir" = "",
                "location.file" = "",
                "location.file.name" = "",
                "location.file.suffix" = "",
                "location.log" = "",
                "LOG" = ""
            ),
            notes = list(
                "stats.method" = "",
                "stats.outlier" = ""
            ),
            raw = list(
                "anova.multi" = "",
                "aov.multi" = "",
                "aov.tukey.multi" = "",
                "base" = "",
                "IN" = "",
                "multi" = "",
                "outlier" = "",
                "summary" = "",
                "summary.multi" = ""
            ),
            stats = list(
                "caption.display" = TRUE,
                "caption.size" = 6,
                "letters.offset" = FALSE,
                "letters.size" = 18
            )
        )
    )
)
