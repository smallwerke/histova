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

            key = self$split(x)
            name.L = key[1]
            name.I = key[2]

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
                if (is.list(private$default[[name.L]][[name.I]])) {
                    return(private$default[[name.L]][[name.I]]$val)
                } else {
                    return(private$default[[name.L]][[name.I]])
                }
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
        },
        #' @description
        #' is this a style variable that can be overidden?
        #' @param key the list name
        #' @param val the info name / variable
        #' @param convert the info name / variable
        set = function(key, val, convert=FALSE) {
            # if convert is set the key is in the file input format and needs
            # converting to the internal format by pulling from a list
            if (isTRUE(convert)) {
                if (key %in% names(private$convert)) {
                    key = private$convert[[key]]
                } else {
                    histova::histova_msg("KEY NOT FOUND")
                    # ADD EXIT / ERROR MESSAGE FUNCTION HERE!!!!
                }
            }
            key = self$split(key)
            if (is.list(private$default[[key[1]]][[key[2]]])) {
                message(paste0("in: ", key[1], " setting ", key[2], " as: ", val))
                if (private$default[[key[1]]][[key[2]]]$type == "bool") {
                    if (val %in% c("TRUE", "True", "true", "1")) {
                        self[[key[1]]][[key[2]]] = TRUE
                    } else {
                        self[[key[1]]][[key[2]]] = FALSE
                    }
                } else if (private$default[[key[1]]][[key[2]]]$type == "num") {
                    self[[key[1]]][[key[2]]] = as.numeric(val)
                }
            }
        },
        #' @description
        #' is this a style variable that can be overidden?
        #' @param key the val to split
        split = function(key) {
            # do a quick check IN CASE behave.verbose was deleted, default to TRUE in this instance
            # as something fundamental is likely wrong...
            if ( ("behave" %in% names(self)) && ("debug" %in% names(self$behave)) ) {
                debug = self$behave$debug
            } else {
                debug = TRUE
            }

            name.L = ""
            name.I = ""
            if (length(strsplit(key, ".", fixed=TRUE)[[1]]) < 2) {
                if (debug) { message("    D: not enough depth (need at least a list.var) - try again!") }
                return(NA)
            } else {
                name.L =  strsplit(key, ".", fixed=TRUE)[[1]][1]
                name.I =  paste(unlist(strsplit(key, ".", fixed=TRUE)[[1]][-1]), collapse=".")
                if (debug) { message(paste0("    D: pulling from list: \'", name.L, "\' var: \'", name.I, "\'")) }
            }
            return (c(name.L, name.I))
        }
    ),
    private = list(
        convert = list(
            "Axis Label Sep" = "fig.axis.label.sep",
            "Axis Label Size" = "fig.axis.label.size",
            "Axis Title Size" = "fig.axis.title.size",
            "Axis Value Size" = "fig.axis.value.size",
            "Legend Label Size" = "fig.legend.label.size",
            "Text Convert" = "fig.convert",
            "Title Size" = "fig.title.size",
            "X Tick Display" = "fig.x.tick.display",
            "X Value Display" = "fig.x.value.display"
        ),
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
        # include ALL variables, if no default just return NULL
        # have a list w/ default AND check type
        default = list(
            behave = list(),
            fig = list(
                "axis.label.sep" = list(val=20,type="num"),
                "axis.label.size" = list(val=26,type="num"),
                "axis.title.size" = list(val=26,type="num"),
                "axis.value.size" = list(val=26,type="num"),
                "axis.x.main.color" = "black",
                "axis.x.main.size" = list(val=0.8,type="num"),
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
                "colors.unique" = list(val=data.frame(matrix(
                    ncol = 8, nrow = 0,
                    dimnames = list(NULL, c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha"))
                )),type="df"),
                "convert" = list(val=TRUE,type="bool"),
                "coord.fixed" = TRUE,
                "coord.fixed.ratio" = "SQUARE",
                "facet.split" = TRUE,
                "font" = "sans",
                "legend.color.source" = "All",
                "legend.display" = FALSE,
                "legend.key.size" = 0.25,
                "legend.label.size" = list(val=26,type="num"),
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
                "title.size" = list(val=32,type="num"),
                "title.tmp" = "",
                "x" = "",
                "x.angle" = 45,
                "x.tick.display" = list(val=TRUE,type="bool"),
                "x.tmp" = "",
                "x.value.display" = list(val=TRUE,type="bool"),
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
