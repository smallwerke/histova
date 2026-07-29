##########################################################
# SETUP ENVIRONMENTS
fig <- new.env(parent = emptyenv())
notes <- new.env(parent = emptyenv())
raw <- new.env(parent = emptyenv())
stats <- new.env(parent = emptyenv())
the <- new.env(parent = emptyenv())
# save environment names
the$envList = c("fig", "notes", "raw", "stats", "the")
#
##########################################################
# SET DEFAULT VALS FOR REFERNCE AND ASSIGNMENT
#
default_vals <- new.env(hash = TRUE, parent = emptyenv())
#
# create sub environments to store the default values
default_vals$fig <- new.env(hash=TRUE, parent=default_vals)
default_vals$notes <- new.env(hash=TRUE, parent=default_vals)
default_vals$raw <- new.env(hash=TRUE, parent=default_vals)
default_vals$stats <- new.env(hash=TRUE, parent=default_vals)
default_vals$the <- new.env(hash=TRUE, parent=default_vals)
#
##########################################################
# STORE DEFAULT VALUES
#
# FIG
#
# create some of the data structures for the environment
colors.unique = data.frame(matrix(ncol = 8, nrow = 0))
colnames(colors.unique) = c("group", "color", "colorAlpha", "scatterColor", "scatterShape", "scatterSize", "scatterStroke", "scatterAlpha")
#
Y.Break.df <- data.frame(matrix(ncol=3, nrow=0))
colnames(Y.Break.df) <- c("start","stop", "scales")
#
#assign("Axis.LabelSep", 20, envir=default_vals$fig)
#assign("Axis.LabelSize", 26, envir=default_vals$fig)
#assign("Axis.TitleSize", 26, envir=default_vals$fig)
#assign("Axis.ValueSize", 26, envir=default_vals$fig)
assign("Axis.X.Main.Color", "black", envir=default_vals$fig)
assign("Axis.X.Main.Size", 0.8, envir=default_vals$fig)
assign("Axis.X.Tick.Color", "black", envir=default_vals$fig)
assign("Axis.X.Tick.Length", 0.1, envir=default_vals$fig)
assign("Axis.X.Tick.Size", 0.6, envir=default_vals$fig)
assign("Axis.Y.Main.Color", "black", envir=default_vals$fig)
assign("Axis.Y.Main.Size", 0.8, envir=default_vals$fig)
assign("Axis.Y.Tick.Color", "black", envir=default_vals$fig)
assign("Axis.Y.Tick.Length", 0.1, envir=default_vals$fig)
assign("Axis.Y.Tick.Size", 0.6, envir=default_vals$fig)
#assign("Bar.Border.Color", "white", envir=default_vals$fig)
#assign("Bar.Border.Width", 0.2, envir=default_vals$fig)
#assign("Bar.Width", 0.8, envir=default_vals$fig)
assign("Color.Alpha.List", "", envir=default_vals$fig) #CHECK!
assign("Color.List", "", envir=default_vals$fig) #CHECK!
assign("Colors", c(), envir=default_vals$fig)
#assign("Colors.Alpha", 1, envir=default_vals$fig)
assign("Colors.Unique", colors.unique, envir=default_vals$fig)
#assign("Convert", TRUE, envir=default_vals$fig)
#assign("Coord.Fixed", TRUE, envir=default_vals$fig)
#assign("Coord.Fixed.Ratio", "SQUARE", envir=default_vals$fig)
assign("Facet.Split", TRUE, envir=default_vals$fig)
#assign("Font", "sans", envir=default_vals$fig)
assign("Legend.Color.Source", "All", envir=default_vals$fig)
#assign("Legend.Display", FALSE, envir=default_vals$fig)
#assign("Legend.Key.Size", 0.25, envir=default_vals$fig)
#assign("Legend.LabelSize", 26, envir=default_vals$fig)
assign("Legend.Position", "bottom", envir=default_vals$fig)
assign("Legend.Title", "Groups", envir=default_vals$fig)
assign("Legend.Title.tmp", "", envir=default_vals$fig)
assign("Plot.ErrorBar.Color", "black", envir=default_vals$fig)
assign("Plot.ErrorBar.EndWidth", 0.4, envir=default_vals$fig)
assign("Plot.ErrorBar.Size", 0.8, envir=default_vals$fig)
assign("Plot.HLine", data.frame(y=c(NA),size=c(0),color=c("")), envir=default_vals$fig)
assign("Plot.Labels", "", envir=default_vals$fig) ### CHANGED ### PAY ATTENTION AND MAKE UPERCASE!
assign("Plot.Whisker", "FALSE", envir=default_vals$fig)
assign("Plot.HLine.Def.Color", "black", envir=default_vals$fig) #CHECK!
assign("Plot.HLine.Def.Size", 1, envir=default_vals$fig) #CHECK!
assign("Plot.HLine.OVRD.Color", NA, envir=default_vals$fig) #CHECK!
assign("Plot.HLine.OVRD.Size", NA, envir=default_vals$fig) #CHECK!
#assign("Save.DPI", 320, envir=default_vals$fig)
#assign("Save.Height", 8.5, envir=default_vals$fig)
#assign("Save.Type", "jpg", envir=default_vals$fig)
#assign("Save.Units", "in", envir=default_vals$fig)
#assign("Save.Width", 8, envir=default_vals$fig)
#assign("Scatter.Alpha", 1, envir=default_vals$fig)
assign("Alpha.List", "", envir=default_vals$fig) #CHECK!
assign("Scatter.Color", "#FFD700", envir=default_vals$fig)
assign("Color.List", "", envir=default_vals$fig) #CHECK!
assign("Scatter.Color.Source", "DEF", envir=default_vals$fig) # INTERNAL SETTING
#assign("Scatter.Disp", TRUE, envir=default_vals$fig)
assign("Scatter.Shape", 4, envir=default_vals$fig)
assign("Scatter.Size", 1.8, envir=default_vals$fig)
#assign("Scatter.Stroke", 2, envir=default_vals$fig)
assign("Shape.List", "", envir=default_vals$fig) #CHECK!
assign("Size.List", "", envir=default_vals$fig) #CHECK!
assign("Stroke.List", "", envir=default_vals$fig) #CHECK!
assign("Title", "", envir=default_vals$fig)
#assign("Title.Size", 32, envir=default_vals$fig)
#assign("Title.tmp", "", envir=default_vals$fig)
assign("X", "", envir=default_vals$fig)
#assign("X.Angle", 45, envir=default_vals$fig)
#assign("X.Tick.Display", TRUE, envir=default_vals$fig)
#assign("X.tmp", "", envir=default_vals$fig)
#assign("X.Value.Display", TRUE, envir=default_vals$fig)
assign("Y", "", envir=default_vals$fig)
assign("Y.Break", FALSE, envir=default_vals$fig)
assign("Y.Break.df", Y.Break.df, envir=default_vals$fig)
assign("Y.Interval", "", envir=default_vals$fig)
assign("Y.Max", "", envir=default_vals$fig)
assign("Y.Min", 0, envir=default_vals$fig)
assign("Y.Rig", FALSE, envir=default_vals$fig)
assign("Y.Rig.Newline", FALSE, envir=default_vals$fig)
assign("Y.Supp", "", envir=default_vals$fig)
#assign("Y.tmp", "", envir=default_vals$fig)
#
##########################################################
#
# NOTES
#
assign("Stats.Method", "", envir=default_vals$notes)
assign("Stats.Outlier", "", envir=default_vals$notes)
#
##########################################################
#
# RAW
#
assign("anova.multi", "", envir=default_vals$raw)
assign("aov.multi", "", envir=default_vals$raw)
assign("aov.tukey.multi", "", envir=default_vals$raw)
assign("base", "", envir=default_vals$raw)
assign("IN", "", envir=default_vals$raw)
assign("multi", "", envir=default_vals$raw)
assign("outlier", "", envir=default_vals$raw)
assign("summary", "", envir=default_vals$raw)
assign("summary.multi", "", envir=default_vals$raw)
#
##########################################################
#
# STATS
#
assign("Letters.Offset", FALSE, envir=default_vals$stats)
assign("Letters.Size", 18, envir=default_vals$stats)
assign("Caption.Display", TRUE, envir=default_vals$stats)
#assign("Caption.Size", 6, envir=default_vals$stats)
#
##########################################################
#
# THE
#
assign("envList", c("the", "fig", "notes", "raw", "stats"), envir=default_vals$the)
assign("Location.Dir", "", envir=default_vals$the)
assign("Location.File", "", envir=default_vals$the)
assign("Location.File.Name", "", envir=default_vals$the)
assign("Location.File.Suffix", "", envir=default_vals$the)
assign("Location.Log", "", envir=default_vals$the)
assign("LOG", "", envir=default_vals$the)
assign("Log.Save", TRUE, envir=default_vals$the)
assign("Override", FALSE, envir=default_vals$the)
