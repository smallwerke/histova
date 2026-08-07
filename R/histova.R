#' R6 Class Representing a HISTOVA object
#'
#' Store all of the data and provide a get() function
#' @export
histova <- R6::R6Class(
    "HISTOVA",
    public <- list(

        #' @field behave list for object behavior, default to FALSE
        behave = list(
            "verbose"=FALSE,
            "debug"=FALSE,
            #"debug"=TRUE,
            "print"=TRUE,
            "log"=TRUE
        ),
        #' @field fig list for figure data
        fig = list(
            "plot.hline" = data.frame(y=c(NA), size=c(0), color=c("")), # keep default as NA as this is the return from the sapply Y.Rig function...
            "colors.specific" = data.frame(matrix(ncol = 8, nrow = 0,
                        dimnames = list(NULL, c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha")) ) )
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
            name.L <- key[1]
            name.I <- key[2]

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
            if (is.list(private$default[[name.L]][[name.I]])) {
                return(private$default[[name.L]][[name.I]]$style)
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
                    key <- private$convert[[key]]
                } else {
                    histova::histova_msg(paste0("KEY (", key, ") NOT FOUND"))
                    # ADD EXIT / ERROR MESSAGE FUNCTION HERE!!!!
                }
            }
            key = self$split(key)
            if (is.list(private$default[[key[1]]][[key[2]]])) {
                histova_msg(paste0("in: ", key[1], " setting ", key[2], " as: ", val))

                if (private$default[[key[1]]][[key[2]]]$type == "alpha") {
                    if ((as.numeric(val) >= 0) && (as.numeric(val) <= 1)) {
                        self[[key[1]]][[key[2]]] <- as.numeric(val)
                    }

                # this is taking 5 similar BUT rather different settings and lumping them together
                # in one rather ugly section... axis x & y main style should only have 2 entries
                # and only check for 2... the second was just being directly assigned
                # for tick & errobar style though item 2 is checked to be numeric before assigning
                # and these should have a third option that is simply assigned...
                #
                # probably a more elegant way to do this but this is a direct copy of the previous
                # setup for now...
                } else if ( (private$default[[key[1]]][[key[2]]]$type == "axisX.main.style") ||
                            (private$default[[key[1]]][[key[2]]]$type == "axisY.main.style") ||
                            (private$default[[key[1]]][[key[2]]]$type == "axisX.tick.style") ||
                            (private$default[[key[1]]][[key[2]]]$type == "axisY.tick.style") ||
                            (private$default[[key[1]]][[key[2]]]$type == "error.bars.style") ) {

                    # there are three possible HISTOVA variables to set here
                    # going to go ahead and initialize the placeholders...
                    pos.1 <- ""
                    pos.2 <- ""
                    pos.3 <- ""
                    # setup data details...
                    if (private$default[[key[1]]][[key[2]]]$type == "axisX.main.style") {
                        pos.1 <- "axis.x.main.size"
                        pos.2 <- "axis.x.main.color"
                    } else if (private$default[[key[1]]][[key[2]]]$type == "axisY.main.style") {
                        pos.1 <- "axis.y.main.size"
                        pos.2 <- "axis.y.main.color"
                    } else if (private$default[[key[1]]][[key[2]]]$type == "axisX.tick.style") {
                        pos.1 <- "axis.x.tick.size"
                        pos.2 <- "axis.x.tick.length"
                        pos.3 <- "axis.x.tick.color"
                    } else if (private$default[[key[1]]][[key[2]]]$type == "axisY.tick.style") {
                        pos.1 <- "axis.y.tick.size"
                        pos.2 <- "axis.y.tick.length"
                        pos.3 <- "axis.y.tick.color"
                    } else if (private$default[[key[1]]][[key[2]]]$type == "error.bars.style") {
                        pos.1 <- "plot.errorbar.size"
                        pos.2 <- "plot.errorbar.endwidth"
                        pos.3 <- "plot.errorbar.color"
                    }

                    # lumped together because the actual logic of what to set and why
                    # is basically the same for all 5 different settings
                    # 1: only set the size variable IF the input works to be numeric
                    #       currently only looking to see if value > 0
                    # 2: for the main.style settings simply assign pos2,
                    #    for tick & bar styles this should be numeric and >= 0
                    # 3: only for tick & bar styles ATM, simply assign, no check for now
                    setDets = strsplit(val, ",")[[1]]
                    if (length(setDets) >= 1) {
                        if ( (histova::is_num(setDets[1])) && (as.numeric(setDets[1]) >= 0) ) {
                            self$fig[[pos.1]] <- as.numeric(setDets[1])
                        }

                        if (length(setDets) >= 2) {
                            if ( (private$default[[key[1]]][[key[2]]]$type == "axisX.main.style") ||
                                 (private$default[[key[1]]][[key[2]]]$type == "axisY.main.style") ) {

                                self$fig[[pos.2]] <- setDets[2]

                            } else if ( (private$default[[key[1]]][[key[2]]]$type == "axisX.tick.style") ||
                                 (private$default[[key[1]]][[key[2]]]$type == "axisY.tick.style") ||
                                 (private$default[[key[1]]][[key[2]]]$type == "error.bars.style") ) {

                                if ( (histova::is_num(setDets[2])) && (as.numeric(setDets[2]) >= 0) ) {
                                    self$fig[[pos.2]] <- as.numeric(setDets[2])
                                }

                                # these options have a 3RD position - go there now...
                                if (length(setDets) >=3) {
                                    if (histova::is_color(setDets[3])) {
                                        self$fig[[pos.3]] <- setDets[3]
                                    }
                                }
                            }
                        }
                    }

                } else if (private$default[[key[1]]][[key[2]]]$type == "bool") {
                    if (val %in% c("TRUE", "True", "true", "1")) {
                        self[[key[1]]][[key[2]]] <- TRUE
                    } else {
                        self[[key[1]]][[key[2]]] <- FALSE
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "color") {
                    if (histova::is_color(val)) {
                        self[[key[1]]][[key[2]]] <- val
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "colors") {
                    self$fig$colors <- strsplit(val, "[, ]+")[[1]]

                # this is a customized check for one variable... refine later if possible
                } else if ( (private$default[[key[1]]][[key[2]]]$type == "colors.specific") ||
                            (private$default[[key[1]]][[key[2]]]$type == "colors.unique") ) {
                    #Colors Unique	#000000, #FFD700, 4, 1.8
                    #Colors Unique	COLOR, ALPHA, COLOR, SHAPE, SIZE, STROKE, ALPHA
                    #Unique: will be loaded into color array, followed by any Colors list and finally any specific colors will be
                    #loaded (and override any previously set values)
                    #Colors Specific    G1_G2, HTML, ALPHA, HTML, SHAPE, SIZE, STROKE, ALPHA
                    #Colors Specific	G1_G2, #000000, 0.6, #FFD700, 0.8, 4, 1, 1.8
                    #Specific: first two (G1_G2 & HTML) are minimum required, will check for numeric for alpha or use default (NULL)
                    #then assume HTML is next followed by SHAPE, SIZE & ALPHA with defaults used for any missing values

                    # regardless of the setting break the values into an array
                    colorDets <- trimws(strsplit(val, ",")[[1]])

                    # if it is colors unique just go ahead and insert an 'NA' value at the beginning for the G1_G2
                    # value and then treat it the same as Colors Specific
                    if (private$default[[key[1]]][[key[2]]]$type == "colors.unique") {
                        colorDets = append(colorDets, NA, 0)
                    }

                    if (length(colorDets) < 2) {
                        histova_msg(sprintf("Colors Specific entry (%s) NOT VALID, at minimum \"G1_G2\", \"HTML\" is required", lA[[1]][2]), type="warn", tabs=1)
                    } else {
                        #Colors Unique	G1_G2, #000000, 0.6, #FFD700, 0.8, 4, 1, 1.8
                        #Colors Unique	G1_G2, HTML, ALPHA, HTML, SHAPE, SIZE, STROKE, ALPHA
                        #Colors Unique	string, color, num, string, num, num, num, num
                        #MIN: G1_G2, HTML -> G1_G2, HTML, NA, NA, NA, NA, NA, NA
                        #Basic: G1_G2, HTML, HTML -> G1_G2, HTML, NA, HTML, NA, NA, NA, NA
                        #NA = DEFAULT
                        # pad out the length to 7 for now as the following are legal entries:
                        #Colors Unique	G1_G2, #000000
                        #Colors Unique	G1_G2, #000000, #FFD700
                        #Colors Unique	G1_G2, #000000, , 0.8, 4 (or any other length of ending #s)
                        while (length(colorDets) < 7) { colorDets <- append(colorDets, NA) }
                        if (is.na(colorDets[3])) { colorDets[3] = "" }
                        # assume that HTML codes will always evaluate to FALSE for numeric, IF TRUE assume unique ALPHA, otherwise assign NA
                        if ((!varhandle::check.numeric(colorDets[3])) || (colorDets[3] == "")) { colorDets <- append(colorDets, NA, 2) }
                        # see if a final item is needed
                        while (length(colorDets) < 8) { colorDets <- append(colorDets, NA) }

                        # check up on the scatter color, IF it is still lingering as "" then set it as NA (check for NA first as NA will crash the == "")
                        if ((!is.na(colorDets[4])) && (colorDets[4] == "")) { colorDets[4] <- NA }
                        # check to see that alpha, size & shape are all numeric OR force as defaults
                        if (!varhandle::check.numeric(colorDets[5])) { colorDets[5] <- NA }
                        if (!varhandle::check.numeric(colorDets[6])) { colorDets[6] <- NA }
                        if (!varhandle::check.numeric(colorDets[7])) { colorDets[7] <- NA }
                        if (!varhandle::check.numeric(colorDets[8])) { colorDets[8] <- NA }

                        if ((!is.na(colorDets[3])) && ((as.numeric(colorDets[3]) < 0) || (as.numeric(colorDets[3]) > 1))) { colorDets[3] <- NA }
                        if ((!is.na(colorDets[8])) && ((as.numeric(colorDets[8]) < 0) || (as.numeric(colorDets[8]) > 1))) { colorDets[8] <- NA }

                        histova_msg(sprintf("Adding to %s: %s", private$default[[key[1]]][[key[2]]]$type, paste(colorDets, collapse=" ")))
                        # handle all formatting in set_aesthetics now
                        self$fig$colors.specific <- rbind(self$fig$colors.specific, setNames(as.list(colorDets), names(self$fig$colors.specific)))
                    }

                # this is a customized check for one variable... refine later if possible
                } else if (private$default[[key[1]]][[key[2]]]$type == "GROUP.scatterCSS") {
                    scatterDets <- strsplit(val, ",")[[1]]
                    if (length(scatterDets) >= 1) {
                        if (tolower(trimws(scatterDets[1])) == "match") {
                            self$fig$scatter.color.source <- "MATCH"
                        } else if ((tolower(trimws(scatterDets[1])) == "unique") || (trimws(scatterDets[1]) == "")) {
                            self$fig$scatter.color.source <- "UNIQUE"
                        } else {
                            self$fig$scatter.color <- scatterDets[1]
                        }

                        if (length(scatterDets) >= 2) {
                            self$fig$scatter.shape <- as.numeric(scatterDets[2])

                            if (length(scatterDets) >= 3) {
                                self$fig$scatter.size <- as.numeric(scatterDets[2])
                            }
                        }
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "font") {
                    if (val %in% c("serif", "sans", "mono")) {
                        self[[key[1]]][[key[2]]] <- val
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "hline") {
                    lines <- unlist(strsplit(val, ","))
                    # if the first value is NOT numeric there is no real point in
                    # any of this... even an empty string will have [1] set
                    if (histova::is_num(lines[1])) {
                        if (length(lines) < 2) {
                            lines[2] <- self$get_default("fig", "plot.hline.def.size")
                        }
                        if (length(lines) < 3) {
                            lines[3] <- self$get_default("fig", "plot.hline.def.color")
                        }
                        if(is.na(self$get("fig.plot.hline")$y[1])) {
                            self$fig$plot.hline$y[1] <- as.numeric(lines[1])
                            self$fig$plot.hline$size[1] <- as.numeric(lines[2])
                            self$fig$plot.hline$color[1] <- lines[3]
                        } else {
                            self$fig$plot.hline <- rbind(self$fig$plot.hline, setNames(list(as.numeric(lines[1]), as.numeric(lines[2]), lines[3]), names(self$fig$plot.hline)) )
                        }
                    }

                # goal is to set the color for ALL lines (if no Y position is given)
                # or the color for any & all lines at the give Y position under the format:
                # "color,pos"
                } else if  (private$default[[key[1]]][[key[2]]]$type == "hline.color") {
                    if (!is.character(val)) { val = "" }
                    axisDets = strsplit(val, ",")[[1]]

                    # no point in any of this if the first position is not a valid color
                    if (histova::is_color(axisDets[1])) {
                        # larger than 1 indicates yPos given... not checking
                        # for number here since a given value but no number we'll just move on
                        if (length(axisDets) > 1) {
                           if (histova::is_num(axisDets[2])) {
                               self$fig$plot.hline[self$fig$plot.hline$y == axisDets[2],"color"] = axisDets[1]
                           }
                        # assign the color to ALL lines...
                        } else {
                           self$fig$plot.hline$color = axisDets[1]
                        }
                    }

                # goal is to set the sizefor ALL lines (if no Y position is given)
                # or the size for any & all lines at the give Y position under the format:
                # "size,pos"
                } else if  (private$default[[key[1]]][[key[2]]]$type == "hline.size") {
                    if (!is.character(val)) { val = "" }
                    axisDets = strsplit(val, ",")[[1]]

                    # no point in any of this if the first position is not a valid number
                    if (histova::is_num(axisDets[1])) {
                        # larger than 1 indicates yPos given... not checking
                        # for number here since a given value but no number we'll just move on
                        if (length(axisDets) > 1) {
                            if (histova::is_num(axisDets[2])) {
                                self$fig$plot.hline[self$fig$plot.hline$y == axisDets[2],"size"] = as.numeric(axisDets[1])
                            }
                            # assign the color to ALL lines...
                        } else {
                            self$fig$plot.hline$size= as.numeric(axisDets[1])
                        }
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "hline.style") {
                    axisDets = strsplit(val, ",")[[1]]
                    if (length(axisDets) >= 1) {
                        histova_msg(paste0("\tval 1: ", axisDets[1]))
                        if ( (histova::is_num(axisDets[1])) && (as.numeric(axisDets[1]) >= 0) ) {
                            self$fig[["plot.hline.OVRD.size"]] <- axisDets[1]
                        } else {
                            ### CHANGED - should be fine but was assumed pulling from gloabl env ###
                            self$fig[["plot.hline.OVRD.size"]] <- self$get_default("fig", "plot.hline.def.size")
                        }
                    }

                    if ( (length(axisDets) >= 2) && (histova::is_color(axisDets[2])) ) {
                        histova_msg(paste0("\tval 2: ", axisDets[2]))
                        self$fig[["plot.hline.OVRD.color"]] <- axisDets[2]
                    } else {
                        ### CHANGED - should be fine but was assumed pulling from gloabl env ###
                        self$fig[["plot.hline.OVRD.color"]] <- self$get_default("fig", "plot.hline.def.color")
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "imgType") {
                    if (tolower(val) %in% c("tex", "pdf", "jpg", "jpeg", "tiff", "png", "bmp", "svg")) {
                        self[[key[1]]][[key[2]]] <- tolower(val)
                    } else {
                        self[[key[1]]][[key[2]]] <- "jpg"
                    }

                } else if  (private$default[[key[1]]][[key[2]]]$type == "imgUnits") {
                    if (tolower(val) %in% c("in", "cm", "mm", "px")) {
                        self[[key[1]]][[key[2]]] <- tolower(val)
                    } else {
                        self[[key[1]]][[key[2]]] <- "in"
                    }

                } else if (private$default[[key[1]]][[key[2]]]$type == "num") {
                    if (histova::is_num(val)) {
                        self[[key[1]]][[key[2]]] <- as.numeric(val)
                    }

                } else if (private$default[[key[1]]][[key[2]]]$type == "text") {
                    self[[key[1]]][[key[2]]] <- val

                } else if (private$default[[key[1]]][[key[2]]]$type == "whisker") {
                    if (val %in% c("TRUE", "true", 1, "BOX", "Box", "box")) {
                        val <- "BOX"
                    } else if (tolower(val) == "violin") {
                        val <- "VIOLIN"
                    } else {
                        val <- FALSE
                    }
                    self[[key[1]]][[key[2]]] <- val
                }

                # now check and see if the new value is the same as default
                # IF it is go ahead and simply remove it from the list
                # goal is to only store values that do NOT equal default
                # IF the default entry does NOT have a "val" key then assume no default value
                # exists and DO NOT check (eg hline)
                if ( (key[2] %in% names(self[[key[1]]])) && ("val" %in% names(private$default[[key[1]]][[key[2]]]) ) &&
                          (private$default[[key[1]]][[key[2]]]$val == self[[key[1]]][[key[2]]]) ) {
                    self[[key[1]]][[key[2]]] <- NULL
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
                debug <- self$behave$debug
            } else {
                debug <- TRUE
            }

            name.L <- ""
            name.I <- ""
            if (length(strsplit(key, ".", fixed=TRUE)[[1]]) < 2) {
                if (debug) { message("    D: not enough depth (need at least a list.var) - try again!") }
                return(NA)
            } else {
                name.L <-  strsplit(key, ".", fixed=TRUE)[[1]][1]
                name.I <-  paste(unlist(strsplit(key, ".", fixed=TRUE)[[1]][-1]), collapse=".")
                if (debug) { message(paste0("    D: pulling from list: \'", name.L, "\' var: \'", name.I, "\'")) }
            }
            return (c(name.L, name.I))
        }
    ),
    private <- list(
        convert = list(
            "Axis Label Sep" = "fig.axis.label.sep",
            "Axis Label Size" = "fig.axis.label.size",
            "Axis Title Size" = "fig.axis.title.size",
            "Axis Value Size" = "fig.axis.value.size",
            "Axis X Main Style" = "fig.axis.x.main.style",
            "Axis Y Main Style" = "fig.axis.y.main.style",
            "Axis X Tick Style" = "fig.axis.x.tick.style",
            "Axis Y Tick Style" = "fig.axis.y.tick.style",
            "Bar Width" = "fig.bar.width",
            "Bar Border Color" = "fig.bar.border.color",
            "Bar Border Width" = "fig.bar.border.width",
            "Colors" = "fig.colors",
            "Colors Alpha" = "fig.colors.alpha",
            "Colors Specific" = "fig.colors.specific",
            "Colors Unique" = "fig.colors.unique",  # largely outmoded
            "Error Bars Style" = "fig.plot.errorbar.style",
            "HLine" = "fig.plot.hline",
            "HLine Style OVRD" = "fig.plot.hline.OVRD.style",
            "Legend Display" = "fig.legend.display",
            "Legend Label Size" = "fig.legend.label.size",
            "Legend Size" = "fig.legend.key.size",
            "Save Width" = "fig.save.width",
            "Save Height" = "fig.save.height",
            "Save DPI" = "fig.save.dpi",
            "Save Units" = "fig.save.units",
            "Save Type" = "fig.save.type",
            "Scatter Alpha" = "fig.scatter.alpha",
            "Scatter ColorShapeSize" = "fig.scatter.color.shape.size", # this should never be set in the public list
            "Scatter Display" = "fig.scatter.disp",
            "Scatter Stroke" = "fig.scatter.stroke",
            "Stat Caption Size" = "stats.caption.size",
            "Text Convert" = "fig.convert",
            "Text Font" = "fig.font",
            "Title Main" = "fig.title.tmp",
            "Title Size" = "fig.title.size",
            "X Angle" = "fig.x.angle", # check / remove this option...
            "X Leg" = "fig.x.tmp",
            "X Value Angle" = "fig.x.angle",
            "X Tick Display" = "fig.x.tick.display",
            "X Value Display" = "fig.x.value.display",
            "Y Leg" = "fig.y.tmp"
        ),
        # include ALL variables, if no default just return NULL
        # have a list w/ default AND check type
        default = list(
            behave = list(
                "debug" = list(val=FALSE,type="bool",style=FALSE),
                "log" = list(val=FALSE,type="bool",style=FALSE),
                "print" = list(val=TRUE,type="bool",style=FALSE),
                "verbose" = list(val=FALSE,type="bool",style=FALSE)
            ),
            fig = list(
                "axis.label.sep" = list(val=20,type="num",style=TRUE),
                "axis.label.size" = list(val=26,type="num",style=TRUE),
                "axis.title.size" = list(val=26,type="num",style=TRUE),
                "axis.value.size" = list(val=26,type="num",style=TRUE),
                "axis.x.main.color" = list(val="black",type="color",style=TRUE),
                "axis.x.main.size" = list(val=0.8,type="num",style=TRUE),
                "axis.x.main.style" = list(val=NULL,type="axisX.main.style",style=TRUE),
                "axis.x.tick.color" = list(val="black",type="color",style=TRUE),
                "axis.x.tick.length" = list(val=0.1,type="num",style=TRUE),
                "axis.x.tick.size" = list(val=0.6,type="num",style=TRUE),
                "axis.x.tick.style" = list(val=NULL,type="axisX.tick.style",style=TRUE),
                "axis.y.main.color" = list(val="black",type="color",style=TRUE),
                "axis.y.main.size" = list(val=0.8,type="num",style=TRUE),
                "axis.y.main.style" = list(val=NULL,type="axisY.main.style",style=TRUE),
                "axis.y.tick.color" = list(val="black",type="color",style=TRUE),
                "axis.y.tick.length" = list(val=0.1,type="num",style=TRUE),
                "axis.y.tick.size" = list(val=0.6,type="num",style=TRUE),
                "axis.y.tick.style" = list(val=NULL,type="axisY.tick.style",style=TRUE),
                "bar.border.color" = list(val="white",type="color",style=TRUE),
                "bar.border.width" = list(val=0.2,type="num",style=TRUE),
                "bar.width" = list(val=0.8,type="num",style=TRUE),
                "color.alpha.list" = list(type="",style=FALSE),
                "color.list" = list(type="",style=FALSE),
                "colors" = list(type="colors",style=FALSE),
                "colors.alpha" = list(val=1,type="alpha",style=TRUE),
                #"colors.specific" = list(val=data.frame(matrix(
                        #ncol = 8, nrow = 0,
                        #dimnames = list(NULL, c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha"))
                    #)),type="",style=TRUE),
                "colors.specific" = list(type="colors.specific", style=TRUE),
                "colors.unique" = list(type="colors.unique", style=TRUE),
                "convert" = list(val=TRUE,type="bool",style=TRUE),
                "facet.split" = list(val=TRUE,type="bool",style=FALSE),
                "font" = list(val="sans",type="font",style=TRUE),
                "legend.color.source" = list(val="All",type="",style=TRUE),
                "legend.display" = list(val=FALSE,type="bool",style=TRUE),
                "legend.key.size" = list(val=0.25,type="num",style=TRUE),
                "legend.label.size" = list(val=26,type="num",style=TRUE),
                "legend.position" = list(val="bottom",type="",style=TRUE),
                "legend.title" = list(val="Groups",type="",style=TRUE),
                "legend.title.tmp" = list(val="",type="",style=TRUE),
                "plot.errorbar.style" = list(val=NULL,type="error.bars.style",style=TRUE),
                "plot.errorbar.color" = list(val="black",type="color",style=TRUE),
                "plot.errorbar.endwidth" = list(val=0.4,type="num",style=TRUE),
                "plot.errorbar.size" = list(val=0.8,type="num",style=TRUE),
                "plot.hline" = list(type="hline",style=FALSE), # no val so no default check after set!
                "plot.hline.color" = list(val="black",type="hline.color",style=FALSE),
                "plot.hline.size" = list(val=1,type="hline.size",style=FALSE),
                "plot.hline.def.color" = list(val="black",type="color",style=TRUE),
                "plot.hline.def.size" = list(val=1,type="num",style=TRUE),
                "plot.hline.OVRD.color" = list(val=NULL,type="",style=TRUE),
                "plot.hline.OVRD.size" = list(val=NULL,type="",style=TRUE),
                "plot.hline.OVRD.style" = list(val=NULL,type="hline.style",style=TRUE),
                "plot.labels" = list(val="",type="",style=FALSE),
                "plot.whisker" = list(val="FALSE",type="whisker",style=TRUE),
                "save.dpi" = list(val=320,type="num",style=TRUE),
                "save.height" = list(val=8.5,type="num",style=TRUE),
                "save.type" = list(val="jpg",type="imgType",style=TRUE),
                "save.units" = list(val="in",type="imgUnits",style=TRUE),
                "save.width" = list(val=8,type="num",style=TRUE),
                "scatter.alpha" = list(val=1,type="alpha",style=TRUE),
                "scatter.color.shape.size" = list(val=NULL,type="GROUP.scatterCSS",style=TRUE),
                "scatter.color" = list(val="#FFD700",type="color",style=TRUE),
                "scatter.color.source" = list(val="DEF",type="",style=TRUE),
                "scatter.disp" = list(val=TRUE,type="bool",style=TRUE),
                "scatter.shape" = list(val=4,type="num",style=TRUE),
                "scatter.size" = list(val=1.8,type="num",style=TRUE),
                "scatter.stroke" = list(val=2,type="num",style=TRUE),
                "shape.list" = "",
                "size.list" = "",
                "stroke.list" = "",
                "title" = "",
                "title.size" = list(val=32,type="num",style=TRUE),
                "title.tmp" = list(val="",type="text",style=FALSE),
                "x" = "",
                "x.angle" = list(val=45,type="num",style=TRUE),
                "x.tick.display" = list(val=TRUE,type="bool",style=TRUE),
                "x.tmp" = list(val="",type="text",style=FALSE),
                "x.value.display" = list(val=TRUE,type="bool",style=TRUE),
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
                "y.tmp" = list(val="",type="text",style=FALSE)
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
                "stats.method" = list(val="",type="",style=TRUE),
                "stats.outlier" = list(val="",type="",style=TRUE)
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
                "caption.display" = list(val=TRUE,type="bool",style=TRUE),
                "caption.size" = list(val=6,type="num",style=TRUE),
                "letters.offset" = list(val=FALSE,type="bool",style=TRUE),
                "letters.size" = list(val=18,type="num",style=TRUE)
            )
        )
    )
)
