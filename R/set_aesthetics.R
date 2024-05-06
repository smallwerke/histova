#' Set Aesthetics
#'
#' @description Generate the lists needed for displaying the correct aesthetics in the figure.
#' The following logic determines the aesthetic information. The values defined by the
#' 'Colors Unique' configuration setting is applied first as a set, that is
#' it is dumped in the order given in the file header into the corresponding lists, anything not specified
#' is set as 'NA', next any colors defined in the old 'Colors' list option is *appended* onto the figure's
#' color list. Finally 'Colors Specific' settings are added. These have a named group and will overwrite any
#' color/setting specified by either 'Colors Unique' or 'Colors'.
#' Finally all remaining 'NA' color values are replaced with valeus from the scales::hue_pal() function
#' and all other values (color alpha & scatter details) still set as 'NA' are replaced by default values.
#' IF 'Scatter ColorShapeSize' is set to MATCH then all scatter color values will be replaced by
#' the corresponding fill color values *regardless* of what is specified in 'Colors Unique', or 'Colors Specific'.
#'
#' output the correct set of named lists to the 'fig' environment
#' <br>Color.List -> list for the histogram
#' <br>Color.Alpha.List -> list for the histogram fill alpha levels
#' <br>Scatter.Color.List -> colors for the scatter points
#' <br>Scatter.Shape.List -> list of shapes for the scatter points
#' <br>Scatter.Size.List -> list of sizes for the scatter points
#' <br>Scatter.Stroke.List -> list of stroke width for the scatter points
#' <br>Scatter.Alpha.List -> list of alpha levels for the scatter points
#'
#' @export
#'
set_aesthetics <- function() {

    histova_msg("Setting Aesthetics", type="subhead")
    ##############################
    # SETUP THE LENGTHS AND NAMES
    #
    # get the length needed
    if (stats$Transform == "TimeCourse") {
        colorLength = length(unique(raw$base$Group2))
        colorNames = unique(raw$base$Group2)
    } else if (fig$Legend.Color.Source == "Group1") {
        # since this is for the aesthetic data make sure settings exist for each so draw from summary
        #colorLength = length(unique(raw$base$Group1))
        #colorNames = unique(raw$base$Group1)
        colorLength = length(raw$summary$Group1)
        colorNames = raw$summary$Group1
    } else {
        colorLength = length(unique(raw$base$statGroups))
        colorNames = unique(raw$base$statGroups)
    }
    histova_msg(sprintf("assigning settings for %s groups (%s)", colorLength, paste(colorNames, collapse=" ")), tabs=2)

    # setup the variables that will be used to build the histogram
    fig$Color.List = rep(NA, colorLength)
    names(fig$Color.List) = colorNames
    fig$Color.Alpha.List = rep(NA, colorLength)
    names(fig$Color.Alpha.List) = colorNames

    fig$Scatter.Color.List = rep(NA, colorLength)
    names(fig$Scatter.Color.List) = colorNames
    fig$Scatter.Shape.List = rep(NA, colorLength)
    names(fig$Scatter.Shape.List) = colorNames
    fig$Scatter.Size.List = rep(NA, colorLength)
    names(fig$Scatter.Size.List) = colorNames
    fig$Scatter.Stroke.List = rep(NA, colorLength)
    names(fig$Scatter.Stroke.List) = colorNames
    fig$Scatter.Alpha.List = rep(NA, colorLength)
    names(fig$Scatter.Alpha.List) = colorNames

    ##############################
    # HISTOGRAM COLOR
    #
    # take any entries from Fig.Colors.Unique where the group name is 'NA' and dump all setting data into the  lists
    # since any non specific values are always set to NA go ahead and load all rows where a group is set to NA
    uniqueLength = length(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$color)
    if (uniqueLength > 0) {
        fig$Color.List[1:uniqueLength] =  fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$color
        fig$Color.Alpha.List[1:uniqueLength] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$colorAlpha)
        fig$Scatter.Color.List[1:uniqueLength] =  fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterColor
        fig$Scatter.Shape.List[1:uniqueLength] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterShape)
        fig$Scatter.Size.List[1:uniqueLength] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterSize)
        fig$Scatter.Stroke.List[1:uniqueLength] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterStroke)
        fig$Scatter.Alpha.List[1:uniqueLength] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterAlpha)
    }

    # start by simply assigning any entries in the fig$Colors list to the beginning of the
    # fig$Color.List list any unique entries will override any values and then the list will be padded as needed...
    if (length(fig$Colors) > 0) {
        fig$Color.List[(uniqueLength+1):(uniqueLength + length(fig$Colors))] = fig$Colors
    }
    #
    # Fig.Colors.Unique is always initiated as an empty list in init_vars if it has data assume we're to use it...
    # go ahead and assign colors to corresponding group names in fig$Color.List
    specificLength = length(fig$Colors.Unique[!is.na(fig$Colors.Unique$group), ]$color)
    specificColors = fig$Colors.Unique[!is.na(fig$Colors.Unique$group), ]
    if (specificLength > 0) {
        # loop through the data frame and pull the G1_G2 that corresponds to the type of figure (as defined above)
        # and if that group name exists in the colorNames list update the associated color in the fig$Color.List
        for (i in 1:nrow(specificColors)) {
            # check the group is valid by seeing if it is in the previously created colorNames list
            if (stats$Transform == "TimeCourse") {
                nameCheck <- strsplit(specificColors$group[i], "_")[[1]][2]
            } else if (fig$Legend.Color.Source == "Group1") {
                nameCheck <- strsplit(specificColors$group[i], "_")[[1]][1]
            } else {
                nameCheck <- specificColors$group[i]
            }
            if (nameCheck %in% colorNames) {
                # the minimum values to have a unique color are group name & color
                # so the group color is assumed to exist, shouldn't be possible to have an NA value
                # though even this would be cleaned up below
                #fig$Color.List[[nameCheck]] <- specificColors$color[i]
                fig$Color.List[names(fig$Color.List) == nameCheck] <- specificColors$color[i]

                # set the scatter color list if the unique value isn't NA
                # after scrolling through the unique list all remaining NA's get set to default
                if (!is.na(specificColors$colorAlpha[i])) {
                    fig$Color.Alpha.List[[nameCheck]] <- as.numeric(specificColors$colorAlpha[i])
                }
                if (!is.na(specificColors$scatterColor[i])) {
                    fig$Scatter.Color.List[[nameCheck]] <- specificColors$scatterColor[i]
                }
                if (!is.na(specificColors$scatterShape[i])) {
                    fig$Scatter.Shape.List[[nameCheck]] <- as.numeric(specificColors$scatterShape[i])
                }
                if (!is.na(specificColors$scatterSize[i])) {
                    fig$Scatter.Size.List[[nameCheck]] <- as.numeric(specificColors$scatterSize[i])
                }
                if (!is.na(specificColors$scatterStroke[i])) {
                    fig$Scatter.Stroke.List[[nameCheck]] <- as.numeric(specificColors$scatterStroke[i])
                }
                if (!is.na(specificColors$scatterAlpha[i])) {
                    fig$Scatter.Alpha.List[[nameCheck]] <- as.numeric(specificColors$scatterAlpha[i])
                }
            } else {
                histova_msg(sprintf("Colors Specific: unable to find the group name %s, SKIPPING entry", nameCheck), tabs=2, type="warn")

            }
        }
    }

    # set the remaining colors that are still 'NA' to draw from scales::hue_pal()
    # color alpha level get set to default
    if (length(fig$Color.List[is.na(fig$Color.List)]) > 0) {
        histova_msg(sprintf("Only %s colors supplied when %s are needed, ADDING EXTRAS", length(fig$Color.List[!is.na(fig$Color.List)]), colorLength), tabs=2, type="warn")
        # replace any NA values with a color from scales::hue_pal
        fig$Color.List[is.na(fig$Color.List)] = scales::hue_pal()(length(fig$Color.List[is.na(fig$Color.List)]))
    }
    fig$Color.Alpha.List[is.na(fig$Color.Alpha.List)] = fig$Colors.Alpha

    # assign all remaining scatter NA values to the defaults
    fig$Scatter.Color.List[is.na(fig$Scatter.Color.List)] = fig$Scatter.Color
    fig$Scatter.Shape.List[is.na(fig$Scatter.Shape.List)] = as.numeric(fig$Scatter.Shape)
    fig$Scatter.Size.List[is.na(fig$Scatter.Size.List)] = as.numeric(fig$Scatter.Size)
    fig$Scatter.Stroke.List[is.na(fig$Scatter.Stroke.List)] = as.numeric(fig$Scatter.Stroke)
    fig$Scatter.Alpha.List[is.na(fig$Scatter.Alpha.List)] = as.numeric(fig$Scatter.Alpha)

    # IF MATCH IS SET OVERRIDE ALL OTHER ASSIGNMENTS
    if (fig$Scatter.Color.Source == "MATCH") {
        fig$Scatter.Color.List = fig$Color.List
    }

    # in rare instances the final colors list can be greater than what should be available
    # (eg when a group is dropped during treatment / control) so go ahead and trim
    # everything down to the length of determined colors to keep ggplot2 happy
    fig$Color.List <- fig$Color.List[1:colorLength]
    fig$Color.Alpha.List <- fig$Color.Alpha.List[1:colorLength]

    fig$Scatter.Color.List <- fig$Scatter.Color.List[1:colorLength]
    fig$Scatter.Shape.List <- fig$Scatter.Shape.List[1:colorLength]
    fig$Scatter.Size.List <- fig$Scatter.Size.List[1:colorLength]
    fig$Scatter.Stroke.List <- fig$Scatter.Stroke.List[1:colorLength]
    fig$Scatter.Alpha.List <- fig$Scatter.Alpha.List[1:colorLength]
}
