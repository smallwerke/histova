#' Set Aesthetics
#'
#' @description Generate the lists and variables needed for displaying the correct aesthetics in the figure
#' current focus is on the color of the bars & the points being used along with size
#'
#' output the correct set of named lists
#' <br>Fig.Colors -> list for the histogram
#' <br>Fig.Scatter.Colors.List -> colors for the scatter
#' <br>Fig.Scatter.Shape.List -> list of shapes
#' <br>Fig.Scatter.Size.List -> list of sizes
#'
#' output of the stroke size
#' <br>Fig.Scatter.Stroke -> the one size for stroking the scatter
#'
#' @export
#'
set_aesthetics <- function() {

    ##############################
    # SETUP THE LENGTHS AND NAMES
    #
    # get the length needed
    if (stats$Transform == "TimeCourse") {
        colorLength = length(unique(raw$base$Group2))
        colorNames = unique(raw$base$Group2)
    } else if (fig$Legend.Color.Source == "Group1") {
        colorLength = length(unique(raw$base$Group1))
        colorNames = unique(raw$base$Group1)
    } else {
        colorLength = length(unique(raw$base$statGroups))
        colorNames = unique(raw$base$statGroups)
    }
    ##############################
    # HISTOGRAM COLOR
    #
    # I think that this will never actually evaluate to true as an empty string
    # is initiated in init_vars...
    #if (exists("Fig.Colors") == FALSE) {
    if (exists("Colors", envir=fig) == FALSE) {
        # setup 'random' colors for the data if nothing has been assigned...
        fig$Colors = scales::hue_pal()(length(unique(raw$base$statGroups)))
        message(sprintf("No colors specified, %s are needed, ADDING EXTRAS", colorLength))
    }
    # Fig.Colors.Unique is always initiated as an empty list in init_vars
    # if it has data assume we're to use it...
    # go ahead and overwrite whatever is in Fig.Colors and move on
    if (length(fig$Colors.Unique$color) > 0) {
        fig$Colors = trimws(fig$Colors.Unique$color)
    }

    #there SHOULD be a Fig.Colors with sufficient entries, IF NOT go ahead and pad it out
    if (length(fig$Colors) < colorLength) {
        message(sprintf("Only %s colors supplied when %s are needed, ADDING EXTRAS", length(fig$Colors), colorLength))
        fig$Colors = append(fig$Colors, scales::hue_pal()(colorLength - length(fig$Colors)))
    }

    # List should be complete
    # add names
    names(fig$Colors) = colorNames

    ##############################
    # SCATTER COLOR
    #
    if (is.na(fig$Scatter.Color)) {
        fig$Scatter.Color.List = rep("#FFD700", colorLength) # gold default
    } else if (fig$Scatter.Color == "MATCH") {
        fig$Scatter.Color.List = fig$Colors
    } else if (fig$Scatter.Color == "UNIQUE") {
        fig$Scatter.Color.List = trimws(fig$Colors.Unique$scatterColor)

        # check this list for empties... should only be in the form of NA or ""
        # if any, replace with default value of #FFD700
        fig$Scatter.Color.List = replace(fig$Scatter.Color.List, fig$Scatter.Color.List == "", "#FFD700")
        fig$Scatter.Color.List = replace(fig$Scatter.Color.List, is.na(fig$Scatter.Color.List), "#FFD700")
    } else {
        # assuming if this is set and NOT match or unique that it is a HTML color code
        fig$Scatter.Color.List = rep(fig$Scatter.Color, colorLength)
    }

    if (length(fig$Scatter.Color.List) < colorLength) {
        message(sprintf("Only %s scatter colors supplied when %s are needed, ADDING EXTRAS", length(fig$Scatter.Color.List), colorLength))
        fig$Scatter.Color.List = append(fig$Scatter.Color.List, scales::hue_pal()(colorLength - length(fig$Scatter.Color.List)))
    }

    # List should be complete
    # add names
    names(fig$Scatter.Color.List) = colorNames

    ##############################
    # SCATTER SHAPE
    #
    # if this is set it overrides all else...
    # for whatever fucking reason NA resolves as is.numeric...
    if ((is.numeric(fig$Scatter.Shape)) && (!is.na(fig$Scatter.Shape))) {
        fig$Scatter.Shape.List = rep(fig$Scatter.Shape, colorLength)
    } else if (length(fig$Colors.Unique$scatterColor) > 0) {
        # assume IF there are entries that they are to be used
        fig$Scatter.Shape.List = as.numeric(fig$Colors.Unique$scatterShape)

        # check this list for empties... should only be in the form of NA or ""
        # if any, replace with default value of 4
        fig$Scatter.Shape.List = replace(fig$Scatter.Shape.List, fig$Scatter.Shape.List == "", 4)
        fig$Scatter.Shape.List = replace(fig$Scatter.Shape.List, is.na(fig$Scatter.Shape.List), 4)
    } else {
        # if still nothing assign the default
        fig$Scatter.Shape.List = rep(4, colorLength)
    }

    # make sure the list is in fact long enough!
    if (length(fig$Scatter.Shape.List) < colorLength) {
        message(sprintf("Only %s scatter shapes supplied when %s are needed, ADDING EXTRAS", length(fig$Scatter.Shape.List), colorLength))
        fig$Scatter.Shape.List = append(fig$Scatter.Shape.List, rep(4, colorLength - length(fig$Scatter.Shape.List)))
    }

    # List should be complete
    # add names
    names(fig$Scatter.Shape.List) = colorNames

    ##############################
    # SCATTER SIZE
    #
    #
    # if this is set it overrides all else...
    if ((is.numeric(fig$Scatter.Size)) && (!is.na(fig$Scatter.Size))) {
        fig$Scatter.Size.List = rep(fig$Scatter.Size, colorLength)
    } else if (length(fig$Colors.Unique$scatterSize) > 0) {
        # assume IF there are entries that they are to be used
        fig$Scatter.Size.List = as.numeric(fig$Colors.Unique$scatterSize)

        # check this list for empties... should only be in the form of NA or ""
        # if any, replace with default value of 4
        fig$Scatter.Size.List = replace(fig$Scatter.Size.List, fig$Scatter.Size.List == "", 1.8)
        fig$Scatter.Size.List = replace(fig$Scatter.Size.List, is.na(fig$Scatter.Size.List), 1.8)
    } else {
        # if still nothing assign the default
        fig$Scatter.Size.List = rep(1.8, colorLength)
    }

    # make sure the list is in fact long enough!
    if (length(fig$Scatter.Size.List) < colorLength) {
        message(sprintf("Only %s scatter sizes supplied when %s are needed, ADDING EXTRAS", length(fig$Scatter.Size.List), colorLength))
        fig$Scatter.Size.List = append(fig$Scatter.Size.List, rep(1.8, colorLength - length(fig$Scatter.Size.List)))
    }

    # List should be complete
    # add names
    names(fig$Scatter.Size.List) = colorNames

    ##############################
    # STROKE SIZE
    #
    # setup the stroke size, default is 2
    # NA is what the init assigns it AND the result if a non numeric value is passed in...
    if (is.na(fig$Scatter.Stroke)) { fig$Scatter.Stroke = 2 }

    ##############################
    # ASSIGN THE DATA OUT
    #
    #assign("colorLength", colorLength, envir = .GlobalEnv) ### CHANGED - does not appear to be used outside of this function ###
    #assign("Fig.Colors", Fig.Colors, envir = .GlobalEnv) ### CHANGED - not needed ###
    #assign("Fig.Scatter.Color.List", Fig.Scatter.Color.List, envir = .GlobalEnv) ### CHANGED - not needed ###
    #assign("Fig.Scatter.Shape.List", Fig.Scatter.Shape.List, envir = .GlobalEnv) ### CHANGED - not needed ###
    #assign("Fig.Scatter.Size.List", Fig.Scatter.Size.List, envir = .GlobalEnv) ### CHANGED - not needed ###
    #assign("Fig.Scatter.Stroke", Fig.Scatter.Stroke, envir = .GlobalEnv) ### CHANGED - not needed ###

}
