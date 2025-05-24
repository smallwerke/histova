#' Load File Head
#'
#' @description
#' Load the configuration from the head of the file specified in the$Location.file. Each
#' configuration file should begin with the settings section that details the aesthetics of
#' the desired figure as well as what kind of statistical tests to carry out. These settings
#' are all loaded into a few environments within the histova package and stored there
#' to be accessible between functions. The Override option is controlled in this function.
#'
#' @export
#'
load_file_head = function() {

    # forced reset
    init_vars()

    histova_msg(sprintf("Load config (file: %s)", the$Location.File), type="subhead")

    fullPath <- paste0(the$Location.Dir, "/", the$Location.File)

    # set the override placeholder to NULL
    Override.tmp <- NULL
    Fig.Y.tmp <- NULL

    # read in the comments and set any specified variables (title, legend, etc)
    CON = file(fullPath, open = "r")
    l <- readLines(CON, 1)
    while(substring(l, 1, 1) == '#') {
        #message(sprintf("---- Load data (line: %s)", l))

        # pull out the information
        lA <- strsplit(substring(l, 2), "\t");

        # if the line is a comment skip to the next iteration
        if (substring(l, 2, 2) == '#') {
            l <- readLines(CON, 1);
            next
        } else {
            l <- readLines(CON, 1);
        }

        # maintain backwards compatibility - simply move this to a new line for analysis...
        if (lA[[1]][1] == "Stats STTest Pairs") { lA[[1]] <- c("Stats Test", "STTest", lA[[1]][-1]) }
        else if (lA[[1]][1] == "Stats PTTest Pairs") { lA[[1]] <- c("Stats Test", "PTTest", lA[[1]][-1]) }

        ################ OVERRIDE? ################
        if (lA[[1]][1] == "Override") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", "1")) {
                if (isTRUE(the$Override)) { histova_msg("turning override ON AND overwriting previous override!!", tabs=1) }
                else { histova_msg("turning override ON!!", tabs=1) }

                # set override to true from here on out
                Override.tmp <- TRUE
                # turn off override protection if it was set
                the$Override <- FALSE
                # set all variables back to their default before moving on
                histova_msg("resetting variables to defaults BEFORE loading config", tabs=1)
                init_vars()
            } else if (lA[[1]][2] %in% c("FALSE", "False", "false", "0")) {
                histova_msg("turning override OFF!")
                the$Override <- FALSE
                histova_msg("resetting variables to defaults BEFORE loading config", tabs=1)
                init_vars()
            }
        }
        ## OPTIONAL / OVERRIDEABLE SETTINGS ##
        # Override will be set to false in init_vars() (called earlier) IF it doesn't exist
        if (isFALSE(the$Override)) {
            ################ Label Size and Appearance (OPT) ################
            if (lA[[1]][1] == "Title Size") { fig$Title.Size <- lA[[1]][2]
            } else if (lA[[1]][1] == "Axis Title Size") { fig$Axis.TitleSize <- lA[[1]][2]
            } else if (lA[[1]][1] == "Axis Label Size") { fig$Axis.LabelSize <- lA[[1]][2]
            } else if (lA[[1]][1] == "Axis Label Sep") { fig$Axis.LabelSep <- lA[[1]][2]
            } else if (lA[[1]][1] == "Axis Value Size") { fig$Axis.ValueSize <- lA[[1]][2]
            } else if (lA[[1]][1] == "Legend Label Size") { fig$Legend.LabelSize <- lA[[1]][2]
            } else if (lA[[1]][1] == "Text Convert") {
                if (lA[[1]][2] %in% c("TRUE", "True", "true", "1")) { fig$Convert <- TRUE
                } else { fig$Convert <- FALSE }
            } else if (lA[[1]][1] == "Text Font") {
                if (lA[[1]][2] %in% c("serif", "sans", "mono")) { fig$Font <- lA[[1]][2] }
            }
            ################ Display of the Axis & Plot (OPT) ################
            else if (lA[[1]][1] == "X Value Angle") { fig$X.Angle <- as.numeric(lA[[1]][2])
            } else if (lA[[1]][1] == "X Value Display") {
                if (lA[[1]][2] %in% c("TRUE", "True", "true", 0)) { fig$X.Value.Display <- TRUE
                } else { fig$X.Value.Display <- FALSE }
            }
            else if (lA[[1]][1] == "X Tick Display") {
                if (lA[[1]][2] %in% c("TRUE", "True", "true", 0)) { fig$X.Tick.Display <- TRUE
                } else { fig$X.Tick.Display <- FALSE }
            }
            # THIS SETTING CURRENTLY DISABLED AND NOT IMPLEMENTED IN build_histo FUNCTION
            else if (lA[[1]][1] == "Coord Fixed Ratio") {
                histova_msg(sprintf("Coord Fixed Ratio is currently disabled! Setting of \"Coord Fixed Ratio %s\" is being ignored.", lA[[1]][2]), type="warn", tabs=1)
                if (lA[[1]][2] %in% c("FALSE", "False", "false")) {
                    fig$Coord.Fixed <- FALSE
                    fig$Coord.Fixed.Ratio <- ""
                } else if (lA[[1]][2] %in% c("SQUARE", "Square", "square")) {
                    fig$Coord.Fixed <- TRUE
                    fig$Coord.Fixed.Ratio <- "SQUARE"
                } else {
                    fig$Coord.Fixed <- TRUE
                    if (grepl("/", lA[[1]][2], fixed=TRUE)) {
                        fig$Coord.Fixed.Ratio <- sapply(strsplit(lA[[1]][2], "/"), function(x) { x <- as.numeric(x); x[1] / x[2]})
                    } else {
                        fig$Coord.Fixed.Ratio <- as.numeric(lA[[1]][2])
                    }
                }
            }
            else if (lA[[1]][1] == "Bar Width") {
                fig$Bar.Width <- as.numeric(lA[[1]][2])
            }
            else if (lA[[1]][1] == "Bar Border Color") {
                fig$Bar.Border.Color <- lA[[1]][2]
            }
            else if (lA[[1]][1] == "Bar Border Width") {
                fig$Bar.Border.Width <- as.numeric(lA[[1]][2])
            }
            ################ Colors and Display Individual Points (OPT) ################
            # can handle "," and " " for splitting ([, ]+ looks for "," or " " multiple times for splitting)
            else if (lA[[1]][1] == "Colors") { fig$Colors <- strsplit(lA[[1]][2], "[, ]+")[[1]]
            } else if ((lA[[1]][1] == "Colors Unique") || (lA[[1]][1] == "Colors Specific")) {
                #Colors Unique	#000000, #FFD700, 4, 1.8
                #Colors Unique	COLOR, ALPHA, COLOR, SHAPE, SIZE, STROKE, ALPHA
                #Unique: will be loaded into color array, followed by any Colors list and finally any specific colors will be
                #loaded (and override any previously set values)
                #Colors Specific    G1_G2, HTML, ALPHA, HTML, SHAPE, SIZE, STROKE, ALPHA
                #Colors Specific	G1_G2, #000000, 0.6, #FFD700, 0.8, 4, 1, 1.8
                #Specific: first two (G1_G2 & HTML) are minimum required, will check for numeric for alpha or use default (NULL)
                #then assume HTML is next followed by SHAPE, SIZE & ALPHA with defaults used for any missing values

                # regardless of the setting break the values into an array
                colorDets <- trimws(strsplit(lA[[1]][2], ",")[[1]])

                # if it is colors unique just go ahead and insert an 'NA' value at the beginning for the G1_G2
                # value and then treat it the same as Colors Specific
                if (lA[[1]][1] == "Colors Unique") { colorDets = append(colorDets, NA, 0) }

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

                    # handle all formatting in set_aesthetics now
                    fig$Colors.Unique[nrow(fig$Colors.Unique)+1,] <- colorDets
                }
            } else if (lA[[1]][1] == "Colors Alpha") {
                if ((as.numeric(lA[[1]][2]) >= 0) && (as.numeric(lA[[1]][2]) <= 1)) {
                    fig$Colors.Alpha <- as.numeric(lA[[1]][2])
                }
            }
            else if (lA[[1]][1] == "Scatter Display") {
                if (lA[[1]][2] %in% c("FALSE", "False", "false", 0)) {
                    fig$Scatter.Disp <- FALSE
                }
            }
            else if (lA[[1]][1] == "Scatter Alpha") {
                if ((as.numeric(lA[[1]][2]) >= 0) && (as.numeric(lA[[1]][2]) <= 1)) {
                    fig$Scatter.Alpha <- as.numeric(lA[[1]][2])
                }
            }
            else if (lA[[1]][1] == "Scatter ColorShapeSize") {
                # not doing much checking here, assume that anything from 1 to 3 items
                # can be supplied here...
                scatterDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(scatterDets) >= 1) {
                    if (tolower(trimws(scatterDets[1])) == "match") { fig$Scatter.Color.Source <- "MATCH" }
                    else if ((tolower(trimws(scatterDets[1])) == "unique") || (trimws(scatterDets[1]) == "")) {  fig$Scatter.Color.Source <- "UNIQUE" }
                    else { fig$Scatter.Color <- scatterDets[1] }
                }
                if (length(scatterDets) >= 2) { fig$Scatter.Shape <- as.numeric(scatterDets[2]) }
                if (length(scatterDets) >= 3) { fig$Scatter.Size <- as.numeric(scatterDets[3]) }
            }
            else if (lA[[1]][1] == "Scatter Stroke") {
                fig$Scatter.Stroke <-  as.numeric(lA[[1]][2])
            }
            else if (lA[[1]][1] == "Whisker Plot") {
                # this is also checked in generate_label_df(), if expanding options check there for continuity
                if (lA[[1]][2] %in% c("TRUE", "True", "true", 1, "BOX", "Box", "box")) { fig$Plot.Whisker <- "BOX" }
                else if (tolower(lA[[1]][2]) == "violin") { fig$Plot.Whisker <- "VIOLIN" }
                else { fig$Plot.Whisker <- "FALSE" }
            }
            ################ Line Design Options (OPT) ################
            else if (lA[[1]][1] == "Axis Y Main Style") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Axis.Y.Main.Size <- as.numeric(axisDets[1]) } }
                if (length(axisDets) >= 2) { fig$Axis.Y.Main.Color <- axisDets[2] }
            }
            else if (lA[[1]][1] == "Axis X Main Style") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Axis.X.Main.Size <- as.numeric(axisDets[1]) } }
                if (length(axisDets) >= 2) { fig$Axis.X.Main.Color <- axisDets[2] }
            }
            else if (lA[[1]][1] == "Axis Y Tick Style") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Axis.Y.Tick.Size <- as.numeric(axisDets[1])} }
                if (length(axisDets) >= 2) { if (as.numeric(axisDets[2]) >= 0) { fig$Axis.Y.Tick.Length <- as.numeric(axisDets[2])} }
                if (length(axisDets) >= 3) { fig$Axis.Y.Tick.Color <- axisDets[3] }
            }
            else if (lA[[1]][1] == "Axis X Tick Style") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Axis.X.Tick.Size <- as.numeric(axisDets[1])} }
                if (length(axisDets) >= 2) { if (as.numeric(axisDets[2]) >= 0) { fig$Axis.X.Tick.Length <- as.numeric(axisDets[2])} }
                if (length(axisDets) >= 3) { fig$Axis.X.Tick.Color <- axisDets[3] }
            }
            else if (lA[[1]][1] == "Error Bars Style") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Plot.ErrorBar.Size <- as.numeric(axisDets[1]) } }
                if (length(axisDets) >= 2) { if (as.numeric(axisDets[2]) >= 0) {  fig$Plot.ErrorBar.EndWidth <- as.numeric(axisDets[2]) } }
                if (length(axisDets) >= 3) { fig$Plot.ErrorBar.Color <- axisDets[3] }
            }
            else if (lA[[1]][1] == "HLine Style OVRD") {
                axisDets = strsplit(lA[[1]][2], ",")[[1]]
                if (length(axisDets) >= 1) { if (as.numeric(axisDets[1]) >= 0) { fig$Plot.HLine.OVRD.Size <- as.numeric(axisDets[1]) } }
                else { fig$Plot.HLine.OVRD.Size <- fig$Plot.HLine.Def.Size } ### CHANGED - should be fine but was assumed pulling from gloabl env ###
                if (length(axisDets) >= 2) { fig$Plot.HLine.OVRD.Color <- axisDets[2] }
                else { fig$Plot.HLine.OVRD.Color <- fig$Plot.HLine.Def.Color } ### CHANGED - should be fine but was assumed pulling from gloabl env ###
            }
            ################ Legend Display Options (OPT) ################
            else if (lA[[1]][1] == "Legend Display") {
                if (lA[[1]][2] %in% c("TRUE", "True", "true", 0)) { fig$Legend.Display <- TRUE }
                else { fig$Legend.Display <- FALSE }
            }
            else if (lA[[1]][1] == "Legend Color Source") {
                if (lA[[1]][2] %in% c("Group1", "group1", 1)) { fig$Legend.Color.Source <- "Group1" }
                else { fig$Legend.Color.Source <- "All" }
            }
            else if (lA[[1]][1] == "Legend Title") { fig$Legend.Title.tmp <- lA[[1]][2] } ### CHANGED - this was not being assigned to globalenv previously ###
            else if (lA[[1]][1] == "Legend Position") {
                if (tolower(lA[[1]][2]) == "top") { fig$Legend.Position <- "top" }
                else if (tolower(lA[[1]][2]) == "right") { fig$Legend.Position <- "right" }
                else if (tolower(lA[[1]][2]) == "left") { fig$Legend.Position <- "left" }
                else { fig$Legend.Position <- "bottom" }
            }
            else if (lA[[1]][1] == "Legend Size") {
                fig$Legend.Key.Size <- as.numeric(lA[[1]][2])
            }
            ################ Stats Labels (OPT) ################
            else if (lA[[1]][1] == "Stat Offset") {
                if (lA[[1]][2] %in% c("FALSE", "False", "false")) { stats$Letters.Offset <- FALSE }
                else { stats$Letters.Offset <- as.numeric(lA[[1]][2]) }
            }
            else if (lA[[1]][1] == "Stat Letter Size") { stats$Letters.Size <- as.numeric(lA[[1]][2]) }
            else if (lA[[1]][1] == "Stat Caption Display") {
                if (lA[[1]][2] %in% c("FALSE", "False", "false", 0)) { stats$Caption.Display <- FALSE }
                else { stats$Caption.Display <- TRUE }
            }
            else if (lA[[1]][1] == "Stat Caption Size") { stats$Caption.Size <- as.numeric(lA[[1]][2]) }
            ################ Figure Save (OPT) ################
            else if (lA[[1]][1] == "Save Width") { fig$Save.Width <- as.numeric(lA[[1]][2]) }
            else if (lA[[1]][1] == "Save Height") { fig$Save.Height <- as.numeric(lA[[1]][2]) }
            else if (lA[[1]][1] == "Save DPI") { fig$Save.DPI <- as.numeric(lA[[1]][2]) }
            else if (lA[[1]][1] == "Save Units") {
                if (tolower(lA[[1]][2]) %in% c("in", "cm", "mm", "px")) { fig$Save.Units <- tolower(lA[[1]][2]) }
                else { fig$Save.Units <- "in" }
            }
            else if (lA[[1]][1] == "Save Type") {
                if (tolower(lA[[1]][2]) %in% c("tex", "pdf", "jpg", "jpeg", "tiff", "png", "bmp", "svg")) { fig$Save.Type <- tolower(lA[[1]][2]) }
                else { fig$Save.Type <- "jpg" }
            }
        }

        ################ Title & Axis Labels (REQ) ################
        if (lA[[1]][1] == "Title Main") { fig$Title.tmp <- lA[[1]][2] } ### CHANGED - was not being assigned to global env ###
        else if (lA[[1]][1] == "X Leg") { fig$X.tmp <- lA[[1]][2] } ### CHANGED - was not being assigned to global env ###
        else if (lA[[1]][1] == "Y Leg") { fig$Y.tmp <- lA[[1]][2] } ### CHANGED - was not being assigned to global env ###
        ################ Height of Y-axis and Horizontal Line/s (REQ) ################
        else if (lA[[1]][1] == "Y Min") { fig$Y.Min <- as.numeric(lA[[1]][2]) }
        else if (lA[[1]][1] == "Y Max") { fig$Y.Max <- as.numeric(lA[[1]][2]) }
        else if (lA[[1]][1] == "Y Interval") { fig$Y.Interval <- as.numeric(lA[[1]][2]) }
        # any breaks in the y-axis? can handle comma delimited array of break details
        else if (lA[[1]][1] == "Y Break") {
            fig$Y.Break <- TRUE
            tmp <- unlist(strsplit(lA[[1]][2], ","))
            # scales column is optional, if absent 'fixed' is default for ggbreak
            if (length(tmp) < 3) { tmp[3] <- "fixed" }
            # add a new row to the break data frame
            fig$Y.Break.df[nrow(fig$Y.Break.df) + 1,] <- tmp
            # start and stop columns must be numeric for ggbreak, scales column can be character
            fig$Y.Break.df$start <- as.numeric(fig$Y.Break.df$start)
            fig$Y.Break.df$stop <- as.numeric(fig$Y.Break.df$stop)
        }
        # can handle comma delimited array of horizontal lines
        else if (lA[[1]][1] == "HLine") {
            tmp <- unlist(strsplit(lA[[1]][2], ","))
            # if the HLine provided by the user doesn't specify the size and color start by using the default
            # going to deal with the overide option later since I don't want to impose config file line order requirements
            if (length(tmp) < 2) { tmp[2] <- fig$Plot.HLine.Def.Size }
            if (length(tmp) < 3) { tmp[3] <- fig$Plot.HLine.Def.Color }
            if(is.na(fig$Plot.HLine$y[1])) {
                fig$Plot.HLine[1,] <- list(as.numeric(tmp[1]), as.numeric(tmp[2]), tmp[3])
            } else {
                fig$Plot.HLine[nrow(fig$Plot.HLine) + 1,] <- list(as.numeric(tmp[1]), as.numeric(tmp[2]), tmp[3])
            }
            #assign("Fig.Plot.HLine", Fig.Plot.HLine, envir = .GlobalEnv) ### CHANGED - should now be taken care of above when being setup... ###
        }
        ################ Alter the Axis (REQ) ################
        else if (lA[[1]][1] == "Y Value Rig") {
            if (lA[[1]][2] %in% c("FALSE", "False", "false", "0")) { fig$Y.Rig <- FALSE
            } else if (lA[[1]][2] %in% c("SCI", "Sci", "sci")) { fig$Y.Rig <- "SCI"
            } else { fig$Y.Rig <- as.numeric(lA[[1]][2]) }
        }
        else if (lA[[1]][1] == "Y Value Rig Newline") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", "1")) { fig$Y.Rig.Newline <- TRUE
            } else { fig$Y.Rig.Newline <- FALSE }
        }
        ################ Stats Tests (REQ) ################
        else if (lA[[1]][1] == "Stats Test") {
            # set the default value to FALSE whenever a user assigns any specific test
            stats$Test[1] <- FALSE ### CHANGED - was not explicitly changing global env previously... ###
            ### CHANGED - IS THERE A REASON I AM NOT CHECKING FOR ANOVA ALREADY IN THE stats$Test LIST? ###
            if (lA[[1]][2] %in% c("ANOVA", "anova", "Anova")) { stats$Test <- c(stats$Test, "ANOVA") } ### CHANGED - was not explicitly changing global env previously... ###
            else if (lA[[1]][2] %in% c("STTest", "sttest", "STtest")) {
                if (!"STTest" %in% stats$Test) { stats$Test <- c(stats$Test, "STTest") } ### CHANGED - was not explicitly changing global env previously... ###
                # for a TTtest the comparison groups need to be submitted
                # set default test
                STTest.tails <- "two.sided"
                # set default variance
                STTest.variance <- "equal"
                # set default pairing
                STTest.paired <- "unpaired"
                # check to see if the pairing is being defined AND if it
                if (length(lA[[1]]) > 7) {
                    if (tolower(lA[[1]][8]) %in% c("paired", "unpaired")) { STTest.paired <- tolower(lA[[1]][8]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][8], STTest.paired), type="warn", tabs=1) }
                }
                # check to see if the variance is being defined AND if it
                if (length(lA[[1]]) > 6) {
                    if (tolower(lA[[1]][7]) %in% c("equal", "unequal")) { STTest.variance <- tolower(lA[[1]][7]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][7], STTest.variance), type="warn", tabs=1) }
                }
                # check to see if a test is request AND if it is workable...
                if (length(lA[[1]]) > 5) {
                    if (tolower(lA[[1]][6]) %in% c("two.sided", "greater", "less")) { STTest.tails <- tolower(lA[[1]][6]) }
                    else { histova_msg(sprintf("---- Argument in STTest (%s) NOT VALID, using default (%s) instead", lA[[1]][6], STTest.tails), type="warn", tabs=1) }
                }
                # retain backwards compatability when the config file had sep lines for test & parings...
                if (length(lA[[1]]) > 2) {
                    stats$STTest.Pairs <- rbind(stats$STTest.Pairs, data.frame(g1 = convert_text(lA[[1]][3]), g2 = convert_text(lA[[1]][4]), l = lA[[1]][5], alt = STTest.tails, var = STTest.variance, pair = STTest.paired, ftest = I(vector(mode="list", length=1)), sttest = I(vector(mode="list", length=1))) )
                }
            }
            else if (lA[[1]][2] %in% c("PTTest", "pttest", "PTtest", "Pttest")) {
                if (!"PTTest" %in% stats$Test) { stats$Test <- c(stats$Test, "PTTest") } ### CHANGED - was not explicitly changing global env previously... ###
                # for a TTtest the comparison groups need to be submitted
                # set default test
                PTTest.tails <- "two.sided"
                # set default variance
                PTTest.variance <- "equal"
                # check to see if the variance is being defined AND if it
                if (length(lA[[1]]) > 6) {
                    if (tolower(lA[[1]][7]) %in% c("equal", "unequal")) { PTTest.variance <- tolower(lA[[1]][7]) }
                    else { histova_msg(sprintf("---- Argument in PTTest (%s) NOT VALID, using default (%s) instead", lA[[1]][7], PTTest.variance), type="warn", tabs=1) }
                }
                # check to see if a test is request AND if it is workable...
                if (length(lA[[1]]) > 5) {
                    if (lA[[1]][6] %in% c("two.sided", "greater", "less")) { PTTest.tails <- lA[[1]][6] }
                    else { histova_msg(sprintf("---- Argument in PTTest (%s) NOT VALID, using default (%s) instead", lA[[1]][6], PTTest.tails), type="warn", tabs=1) }
                }
                # retain backwards compatability when the config file had sep lines for test & parings...
                if (length(lA[[1]]) > 2) {
                    stats$PTTest.Pairs <- rbind(stats$PTTest.Pairs, data.frame(g1 = convert_text(lA[[1]][3]), g2 = convert_text(lA[[1]][4]), l = lA[[1]][5], alt = PTTest.tails, var = PTTest.variance, pttest = I(vector(mode="list", length=1))) )
                }
            }
            #assign("Stats.Test", Stats.Test, envir = .GlobalEnv) ### CHANGED - should no longer be needed as assigned to stats env at each update ###
        }
        ################ Stats Transformation or Outlier (REQ) ################
        else if (lA[[1]][1] == "Stats Transform") {
            if (lA[[1]][2] %in% c("TreatmentControl", "TREATMENTCONTROL")) {
                # a specified treatment is required, if it isn't there, leave it set at FALSE
                if (!is.na(lA[[1]][3])) {
                    stats$Transform <- "ToverC"
                    tc <- c(lA[[1]][3])
                    if (!is.na(lA[[1]][4])) { tc <- c(convert_text(lA[[1]][3]), convert_text(lA[[1]][4])) }
                    stats$Transform.Treatment <- tc
                }
            } else if (lA[[1]][2] %in% c("TimeCourse", "TIMECOURSE")) {
                stats$Transform <- "TimeCourse"
            }
        }
        else if (lA[[1]][1] == "Stats Outlier") {
            if (lA[[1]][2] %in% c("ONE", "One", "one", 1)) { stats$Outlier <- "ONE" }
            else if (lA[[1]][2] %in% c("TWO", "Two", "two", 2)) { stats$Outlier <- "TWO" }
            else { stats$Outlier <- FALSE }
        }
        ################ Split on Group 2? (REQ) ################
        else if (lA[[1]][1] == "Stats Anova Group2") {
            if (lA[[1]][2] %in% c("TRUE", "True", "true", 1)) { stats$Anova.Group2 <- TRUE }
            else { stats$Anova.Group2 <- FALSE }
        }
        else if (lA[[1]][1] == "Facet Split") {
            if (lA[[1]][2] %in% c("FALSE", "False", "false", 0)) { fig$Facet.Split <- FALSE }
            else { fig$Facet.Split <- TRUE }
        }
    } # while(substring(l, 1, 1) == '#') {
    close(CON)

    if (isTRUE(the$Override)) { message("OVERRIDE ON - Optional config settings skipped") }

    if (!is.null(Override.tmp)) { the$Override <- Override.tmp }

    if (exists("Title.Replace", envir=fig)) {
        fig$Title.tmp <- fig$Title.Replace
        rm("Title.Replace", envir = fig)
    }
    if (exists("Y.Replace", envir=fig)) {
        fig$Y.tmp <- fig$Y.Replace
        rm("Y.Replace", envir = fig)
    }
    if (exists("X.Replace", envir=fig)) {
        fig$X.tmp <- fig$X.Replace
        rm("X.Replace", envir = fig)
    }
    if (exists("Legend.Title.Replace", envir=fig)) {
        fig$Legend.Title.tmp <- fig$Legend.Title.Replace
        rm("Legend.Title.Replace", envir = fig)
    }
    if (fig$Convert) {
        fig$Title.tmp <- convert_text(fig$Title.tmp)
        fig$Y.tmp <- convert_text(fig$Y.tmp)
        fig$X.tmp <- convert_text(fig$X.tmp)
        fig$Legend.Title.tmp <- convert_text(fig$Legend.Title.tmp)
    }

    # IF a master HLine style was provided replace the current value and cleanup
    if (is.na(fig$Plot.HLine.OVRD.Color) == FALSE) {
        fig$Plot.HLine$color <- fig$Plot.HLine.OVRD.Color
        histova_msg(sprintf("OVERRIDING ALL horizontal line colors, set to: \'%s\'", fig$Plot.HLine$color[1]))
        #assign("Fig.Plot.HLine", Fig.Plot.HLine, envir = .GlobalEnv) ### CHANGED - should no longer be needed as assigned on the fly ###
    }
    if (is.na(fig$Plot.HLine.OVRD.Size) == FALSE) {
        fig$Plot.HLine$size <- fig$Plot.HLine.OVRD.Size
        histova_msg(sprintf("OVERRIDING ALL horizontal line sizes, set to: \'%s\'", fig$Plot.HLine$size[1]))
        #assign("Fig.Plot.HLine", Fig.Plot.HLine, envir = .GlobalEnv) ### CHANGED - should no longer be needed as assigned on the fly ###
    }
    rm("Plot.HLine.Def.Color", "Plot.HLine.Def.Size", "Plot.HLine.OVRD.Color", "Plot.HLine.OVRD.Size", envir = fig)

    fig$Title <- fig$Title.tmp
    fig$Y <- fig$Y.tmp
    fig$X <- fig$X.tmp
    fig$Legend.Title <- fig$Legend.Title.tmp
}
