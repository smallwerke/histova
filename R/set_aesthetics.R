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
    # get the length needed for the fill colors and then for the scatter colors
    # following the logic used in the build_histo.R function where the colors are
    # assigned and then the scatter aesthetics are assigned
    #
    # for the fill information the color data is based on the type of figure (timecourse, box/violin, or bar)
    # with timecourse being based off of raw$summary$Group2
    # box/violine based off of raw$base$ Group1 or statGroups
    # everything else based off of raw$summary$ Group1 or statGroups
    if (stats$Transform == "TimeCourse") {
        colorLength = length(raw$summary$Group2)
        colorNames = raw$summary$Group2
    } else if (fig$Plot.Whisker %in% c("BOX", "VIOLIN")) {
        if (fig$Legend.Color.Source == "Group1") {
            colorLength = length(raw$base$Group1)
            colorNames = raw$base$Group1
        } else {
            colorLength = length(raw$base$statGroups)
            colorNames = raw$base$statGroups
        }
    } else {
        if (fig$Legend.Color.Source == "Group1") {
            colorLength = length(raw$summary$Group1)
            colorNames = raw$summary$Group1
        } else {
            colorLength = length(raw$summary$statGroups)
            colorNames = raw$summary$statGroups
        }
    }

    # figure out the scatter details
    if (stats$Transform == "TimeCourse") {
        scatterLength = length(raw$base$Group2)
        scatterNames = raw$base$Group2
    } else if (fig$Legend.Color.Source == "Group1") {
        scatterLength = length(raw$base$Group1)
        scatterNames = raw$base$Group1
    } else {
        scatterLength = length(raw$base$statGroups)
        scatterNames = raw$base$statGroups
    }

    # reference data
    colorNamesUnique = unique(colorNames)
    colorLengthUnique = length(colorNamesUnique)

    histova_msg(sprintf("assigning settings for %s groups (%s)", colorLengthUnique, paste(colorNamesUnique, collapse=" ")), tabs=2)

    # setup the variables that will be used to build the histogram
    fig$Color.List = rep(NA, colorLength)
    names(fig$Color.List) = colorNames
    fig$Color.Alpha.List = rep(NA, colorLength)
    names(fig$Color.Alpha.List) = colorNames

    fig$Scatter.Color.List = rep(NA, scatterLength)
    names(fig$Scatter.Color.List) = scatterNames
    fig$Scatter.Shape.List = rep(NA, scatterLength)
    names(fig$Scatter.Shape.List) = scatterNames
    fig$Scatter.Size.List = rep(NA, scatterLength)
    names(fig$Scatter.Size.List) = scatterNames
    fig$Scatter.Stroke.List = rep(NA, scatterLength)
    names(fig$Scatter.Stroke.List) = scatterNames
    fig$Scatter.Alpha.List = rep(NA, scatterLength)
    names(fig$Scatter.Alpha.List) = scatterNames

    ##############################
    # HISTOGRAM COLOR
    #
    # take any entries from Fig.Colors.Unique where the group name is 'NA' and dump all setting data into the  lists
    # since any non specific values are always set to NA go ahead and load all rows where a group is set to NA
    uniqueLength = length(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$color)
    if (uniqueLength > 0) {
        # since this should all be based on G1_G2 names NOT simply length and some settings require a value PER sample
        # scan through and set it based on NAME not simply list location...
        for (i in 1:uniqueLength) {
            #histova_msg(sprintf("AT %s in names = %s",i, colorNamesUnique[i]))
            fig$Color.List[names(fig$Color.List) == colorNamesUnique[i]] =  fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$color[i]
            fig$Color.Alpha.List[names(fig$Color.Alpha.List) == colorNamesUnique[i]] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$colorAlpha[i])
            fig$Scatter.Color.List[names(fig$Scatter.Color.List) == colorNamesUnique[i]] =  fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterColor[i]
            fig$Scatter.Shape.List[names(fig$Scatter.Shape.List) == colorNamesUnique[i]] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterShape[i])
            fig$Scatter.Size.List[names(fig$Scatter.Size.List) == colorNamesUnique[i]] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterSize[i])
            fig$Scatter.Stroke.List[names(fig$Scatter.Stroke.List) == colorNamesUnique[i]] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterStroke[i])
            fig$Scatter.Alpha.List[names(fig$Scatter.Alpha.List) == colorNamesUnique[i]] =  as.numeric(fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$scatterAlpha[i])
        }
        # old simple setting for X entries in the list...
        #fig$Color.List[1:uniqueLength] =  fig$Colors.Unique[is.na(fig$Colors.Unique$group), ]$color
    }

    # start by simply assigning any entries in the fig$Colors list to the beginning of the
    # fig$Color.List list any unique entries will override any values and then the list will be padded as needed...
    if (length(fig$Colors) > 0) {
        for (i in (uniqueLength+1):(uniqueLength+length(fig$Colors)) ) {
            #histova_msg(sprintf("Colors %s in names = %s",i, colorNamesUnique[i]))
            fig$Color.List[names(fig$Color.List) == colorNamesUnique[i]] = fig$Colors[i - uniqueLength]
        }
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
                    fig$Color.Alpha.List[names(fig$Color.Alpha.List) == nameCheck] <- as.numeric(specificColors$colorAlpha[i])
                }
                if (!is.na(specificColors$scatterColor[i])) {
                    fig$Scatter.Color.List[names(fig$Scatter.Color.List) == nameCheck] <- specificColors$scatterColor[i]
                }
                if (!is.na(specificColors$scatterShape[i])) {
                    fig$Scatter.Shape.List[names(fig$Scatter.Shape.List) == nameCheck] <- as.numeric(specificColors$scatterShape[i])
                }
                if (!is.na(specificColors$scatterSize[i])) {
                    fig$Scatter.Size.List[names(fig$Scatter.Size.List) == nameCheck] <- as.numeric(specificColors$scatterSize[i])
                }
                if (!is.na(specificColors$scatterStroke[i])) {
                    fig$Scatter.Stroke.List[names(fig$Scatter.Stroke.List) == nameCheck] <- as.numeric(specificColors$scatterStroke[i])
                }
                if (!is.na(specificColors$scatterAlpha[i])) {
                    fig$Scatter.Alpha.List[names(fig$Scatter.Alpha.List) == nameCheck] <- as.numeric(specificColors$scatterAlpha[i])
                }
            } else {
                histova_msg(sprintf("Colors Specific: unable to find the group name %s, SKIPPING entry", nameCheck), tabs=2, type="warn")

            }
        }
    }

    # set the remaining colors that are still 'NA' to draw from scales::hue_pal()
    # color alpha level get set to default
    if (length(unique(names(fig$Color.List[is.na(fig$Color.List)]))) > 0) {
        histova_msg(sprintf("Only %s colors supplied when %s are needed, ADDING EXTRAS", length(unique(names(fig$Color.List[!is.na(fig$Color.List)]))), colorLengthUnique), tabs=2, type="warn")
        # replace any NA values with a color from scales::hue_pal
        unsetNames =  unique(names(fig$Color.List[is.na(fig$Color.List)]))
        generatedColors = scales::hue_pal()(length(unsetNames))
        for (i in 1:length(unsetNames)) {
            fig$Color.List[names(fig$Color.List) == unsetNames[i]] <- generatedColors[i]
        }
        #histova_msg(sprintf("added %s colors for groups %s ", generatedColors, unsetNames), tabs=2, type="warn")
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

    fig$Scatter.Color.List <- fig$Scatter.Color.List[1:scatterLength]
    fig$Scatter.Shape.List <- fig$Scatter.Shape.List[1:scatterLength]
    fig$Scatter.Size.List <- fig$Scatter.Size.List[1:scatterLength]
    fig$Scatter.Stroke.List <- fig$Scatter.Stroke.List[1:scatterLength]
    fig$Scatter.Alpha.List <- fig$Scatter.Alpha.List[1:scatterLength]
}
