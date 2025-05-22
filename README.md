
<!-- README.md is generated from README.Rmd. Please edit that file -->

**NOTE: This is still a work in progress *but* the package is
functioning! I have begun to add new functions to make the package more
interactive.** Immediate goals are to make the figure options (aesthetic
& data) editable within R and then have the ability to write the figure
data from session out to file. Functions now exist to view & edit figure
options. Next step is to write the config file and then make the import
of data from other sources possible. This will help integrate this
package with things like
[RQdeltaCT](https://github.com/Donadelnal/RQdeltaCT) (which enables
generation of relative expression data from CT information) into a
streamlined path to running QC and generating relative expression
figures from RT-qPCR data. I have an R Markdown script that will be
uploaded which walks through the use of both scripts…

**All Images in this readme are loaded from file since the plot output
from generate_figure() or build_figure() have skewed dimensions from
what is specified in the options and written to file.**

# histova

<!-- badges: start -->

<!-- badges: end -->

The goal of histova is to package a script that I am using to display a
variety of data generated in a molecular biology lab (RT-qPCR, ELISA,
protein quantification…) and enable the user to perform basic
statistical tests on the data. Given that the desired layout and overall
aesthetics of figures change depending on the audience (slide
presentation vs. poster vs. paper etc.) *strange* custom features have
been included to allow certain aesthetic settings to be defined in one
**master** configuration file and essentially override all subsequent
files allowing for batch application of formatting edits.

## Installation

You can install the development *aka* **UNCOMPLETE** version of histova
from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("smallwerke/histova")
```

This version needs to undergo final testing but appears to be fully
functioning at this time.

## Overview

I will be adding more example configuration files in the near future
along with more detailed examples. The basic premise is that the figures
are generated based off of a simple text file that controls the
appearance, statistical tests, and holds the raw data. This is often
pasted in from excel or directly from an instrument. The file is tab
delimited with the configuration options at the head.

The header lines all begin with `#` with `##` denoting a comment and `#`
a configuration setting. The default values and typical options are
detailed in the config header. Example files are in
[inst/extdata](https://github.com/smallwerke/histova/tree/main/inst/extdata).

Data lines are in the format of value-\>group1-\>group2.

I am currently planning on writing a function that will generate a
config file for you that just needs to have data appended to it.

## Example

Basic use of the histova sript. Very simple process that generates a
figure by specifying the source directory and the config file. The
output figure is saved to the source directory.

All of the example config files are included in the extdata directory.

### Load Package

``` r
library(histova)
library(stringr) # for the str_remove call needed in the readme file...
```

***The following examples are loading the final jpg figure that is
produced. It is possible to have the package output a figure to RStudio
for immediate examination though the font configuration is often
incomplete.***

### One Group

A rather basic 1 Group version of this script that does include
individual data points and the results of a ANOVA test displayed as
letters in the figure with a p \< 0.05 used for significance.

``` r
f = "test-1_group-ANOVA_scatter_outlier.txt"
d = stringr::str_remove(histova_example(f), paste0("/",f))
# running generate_figure with plot display & save turned off since readme 
# saves in a temporary location
histova::generate_figure(d,f, FALSE, FALSE)
#> --------------------------------------------------------------------------------
#> ------------------------------- histova 3.5.0.2 --------------------------------
#> ----------------------- run on Thu May 22 15:22:23 2025 ------------------------
#> --------------------------------------------------------------------------------
#> -------- Prep & Load config settings and data --------
#>         file found and environments loaded successfully
#> ---- Initialize envrionment variables
#> ---- Load config (file: test-1_group-ANOVA_scatter_outlier.txt)
#> ---- Load data (file: test-1_group-ANOVA_scatter_outlier.txt)
#>         6 final Group1_Group2 (statGroups - should be unique!) ids:
#>              G1 G2 G3 G4 G5 G6
#> -------- Statistical Analysis --------
#> ---- Outlier checking
#>         TWO TAILED REMOVAL on group G1 (value 19, p.val: 2.34e-03)
#> Warning: FROM run_outlier(): TWO TAILED REMOVAL on group G1 (value 19, p.val:
#> 2.34e-03)
#> ---- Run stats prep (basic summaries)
#>         6 final Group1_Group2 (statGroups - should be unique!) ids:
#>              G1 G2 G3 G4 G5 G6
#> ---- ANOVA w/ Tukeys Post Hoc
#>         6 final Group1_Group2 (statGroups - should be unique!) ids:
#>              G1 G2 G3 G4 G5 G6
#> -------- Build Histogram --------
#> ---- Setting Aesthetics
#>         assigning settings for 6 groups (G1 G2 G3 G4 G5 G6)
#> ---- Building Histogram
#> ---- Generate Figure Labels
#> --------------------------------------------------------------------------------
#> --------------------- finihsed on Thu May 22 15:22:24 2025 ---------------------
#> --------------------------------------------------------------------------------
knitr::include_graphics("inst/extdata/test-1_group-ANOVA_scatter_outlier.jpg")
```

<img src="inst/extdata/test-1_group-ANOVA_scatter_outlier.jpg" width="100%" />

### Review Options

Print out the main aesthetic settings used for this plot (contained in
the *figure* environment).

``` r
histova::opt_print("fig")
#> -------------------------- Variables per Environment ---------------------------
#>     select environments submitted, checking to make sure each is valid...
#>     print out the following environments: 'fig'
#>     Data summary (first 40 characters) will be printed for each listed variable.
#> ----------------------------------- ENV: fig -----------------------------------
#> Axis
#>     LabelSep                    Axis.LabelSep            20
#>     LabelSize                   Axis.LabelSize           26
#>     TitleSize                   Axis.TitleSize           26
#>     ValueSize                   Axis.ValueSize           26
#>     X
#>         Main
#>             Color               Axis.X.Main.Color        black
#>             Size                Axis.X.Main.Size         0.8
#>         Tick
#>             Color               Axis.X.Tick.Color        black
#>             Length              Axis.X.Tick.Length       0.1
#>             Size                Axis.X.Tick.Size         0.6
#>     Y
#>         Main
#>             Color               Axis.Y.Main.Color        black
#>             Size                Axis.Y.Main.Size         0.8
#>         Tick
#>             Color               Axis.Y.Tick.Color        black
#>             Length              Axis.Y.Tick.Length       0.1
#>             Size                Axis.Y.Tick.Size         0.6
#> Bar
#>     Border
#>         Color                   Bar.Border.Color         white
#>         Width                   Bar.Border.Width         0.2
#>     Width                       Bar.Width                0.8
#> Color
#>     Alpha
#>         List                    Color.Alpha.List         0.6, 0.6, 0.6, 0.6, 0.6, 0.6
#>     List                        Color.List               #000000, #606060, #00c000, #f71480, #000
#> Colors                          Colors
#>     Alpha                       Colors.Alpha             0.6
#>     Unique                      Colors.Unique            c("G1", "G2", "G3", "G4", "G5", "G6"), c
#> Convert                         Convert                  TRUE
#> Coord
#>     Fixed                       Coord.Fixed              TRUE
#>         Ratio                   Coord.Fixed.Ratio        SQUARE
#> Facet
#>     Split                       Facet.Split              FALSE
#> Font                            Font                     sans
#> Legend
#>     Color
#>         Source                  Legend.Color.Source      All
#>     Display                     Legend.Display           FALSE
#>     Key
#>         Size                    Legend.Key.Size          0.25
#>     LabelSize                   Legend.LabelSize         26
#>     Position                    Legend.Position          bottom
#>     Title                       Legend.Title
#>         tmp                     Legend.Title.tmp
#> Plot
#>     ErrorBar
#>         Color                   Plot.ErrorBar.Color      black
#>         EndWidth                Plot.ErrorBar.EndWidth   0.4
#>         Size                    Plot.ErrorBar.Size       0.8
#>     HLine                       Plot.HLine               NA, 0,
#>     Labels                      Plot.Labels              G5, G4, G3, G6, G2, G1
#>     Whisker                     Plot.Whisker             FALSE
#> Save
#>     DPI                         Save.DPI                 320
#>     Height                      Save.Height              8.5
#>     Type                        Save.Type                jpg
#>     Units                       Save.Units               in
#>     Width                       Save.Width               8
#> Scatter
#>     Alpha                       Scatter.Alpha            0.8
#>         List                    Scatter.Alpha.List       0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8,
#>     Color                       Scatter.Color            #FFD700
#>         List                    Scatter.Color.List       #FFD700, #FFD700, #FFD700, #FFD700, #FFD
#>         Source                  Scatter.Color.Source     UNIQUE
#>     Disp                        Scatter.Disp             TRUE
#>     Shape                       Scatter.Shape            4
#>         List                    Scatter.Shape.List       4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1, 1, 1
#>     Size                        Scatter.Size             1.8
#>         List                    Scatter.Size.List        1.8, 1.8, 1.8, 1.8, 1.8, 3.8, 3.8, 3.8,
#>     Stroke                      Scatter.Stroke           1
#>         List                    Scatter.Stroke.List      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> Title                           Title                    1 Group Test
#>     Size                        Title.Size               32
#>     tmp                         Title.tmp                1 Group Test
#> X                               X                        Basic Figure<br>*differing scatter shape
#>     Angle                       X.Angle                  45
#>     Tick
#>         Display                 X.Tick.Display           TRUE
#>     tmp                         X.tmp                    Basic Figure<br>*differing scatter shape
#>     Value
#>         Display                 X.Value.Display          TRUE
#> Y                               Y                        µ values
#>     Break                       Y.Break                  FALSE
#>         df                      Y.Break.df               logical(0), logical(0), logical(0)
#>     Interval                    Y.Interval               5
#>     Max                         Y.Max                    20
#>     Min                         Y.Min                    0
#>     Rig                         Y.Rig                    FALSE
#>         Newline                 Y.Rig.Newline            FALSE
#>     Supp                        Y.Supp
#>     tmp                         Y.tmp                    µ values
```

### Edit Option

Edit an aesthetic value.

``` r
histova::opt_set("fig", "X.Angle", 90)
#> ---------------------------------- Set Option ----------------------------------
#> [1] "PASS"
histova::opt_set("the", "Location.File", "test-1_group-ANOVA_scatter_outlier-90.txt")
#> ---------------------------------- Set Option ----------------------------------
#> [1] "PASS"
```

### Check Option

Print out the main aesthetic settings used for this plot (contained in
the *figure* environment).

``` r
histova::opt_print("fig", "X.Angle")
#> -------------------------- Variables per Environment ---------------------------
#> -------- Env: fig --------
#> -------- Var: X.Angle --------
#> -------- Data: --------
#> 90
histova::opt_print("the", "Location.File")
#> -------------------------- Variables per Environment ---------------------------
#> -------- Env: the --------
#> -------- Var: Location.File --------
#> -------- Data: --------
#> test-1_group-ANOVA_scatter_outlier-90.txt
```

### Review Figure

See what changed.

``` r
histova::build_figure(FALSE, FALSE)
#> -------- Build Histogram --------
#> ---- Setting Aesthetics
#>         assigning settings for 6 groups (G1 G2 G3 G4 G5 G6)
#> ---- Building Histogram
#> ---- Generate Figure Labels
#> --------------------------------------------------------------------------------
#> --------------------- finihsed on Thu May 22 15:22:24 2025 ---------------------
#> --------------------------------------------------------------------------------
knitr::include_graphics("inst/extdata/test-1_group-ANOVA_scatter_outlier-90.jpg")
```

<img src="inst/extdata/test-1_group-ANOVA_scatter_outlier-90.jpg" width="100%" />

## Config File

Following is a header file config file detailing all the various
settings and outlining the defaults.

``` r
# print out the full contents of the header sample file
# this is availabe in inst/extdata on gitub above
#
#
paste(readLines('inst/extdata/header_config.txt')) 
#>   [1] "## TEST DATA - file name & details"                                                                                                                                                                      
#>   [2] "################ OVERRIDE? ################"                                                                                                                                                             
#>   [3] "## !! OVERRIDE MUST BE AT THE TOP OF THE DATA FILE !!"                                                                                                                                                   
#>   [4] "## Ability to save the optional (OPT) headed data for subsequent data files - makes consistent style formatting easier when making multiple figures"                                                     
#>   [5] "## Override -> (TRUE: store the OPT values from this file until another TRUE is encountered; FALSE: turn override off and clear out the stored values)"                                                  
#>   [6] "## DEF \"Override:''\" "                                                                                                                                                                                 
#>   [7] "#"                                                                                                                                                                                                       
#>   [8] "################ Label Size and Appearance (OPT) ################"                                                                                                                                       
#>   [9] "## Set the size of the labels, the distance between the axis labels and the values & the axis value size"                                                                                                
#>  [10] "## Text Convert -> scan the title & axis for html codes and convert to unicode; Text Font -> select a font"                                                                                              
#>  [11] "## Conversion: (&Alpha; &Sigma; &alpha; &beta; &epsilon; &pi; &sigma; &bull; &isin; &radic; &micro; \\n); Fonts: (mono, sans, serif)"                                                                    
#>  [12] "## DEF: \"Title Size:32\"; \"Axis Title Size:26\"; Axis Label Size:26\"; \"Axis Label Sep:20\"; \"Axis Value Size: 26\"; \"Legend Label Size:26\"; \"Text Convert:TRUE\"; \"Text Font:sans\""            
#>  [13] "#"                                                                                                                                                                                                       
#>  [14] "################ Display of the Axis & Plot (OPT) ################"                                                                                                                                      
#>  [15] "## X Value Angle -> Set the angle for X axis values (0 = no rotation, number = degree rotation)"                                                                                                         
#>  [16] "## X Value Display -> display or not the values on the x-axis (TRUE / FALSE)"                                                                                                                            
#>  [17] "## X Tick Display -> display the tick marks on the x-axis (TRUE / FALSE)"                                                                                                                                
#>  [18] "## Coord Fixed Ratio -> ***CURRENTLY DISABLED*** Coordinate ratio or manual (FALSE: disabled, SQUARE: 1/(Y Max / # of X Groups), NUM: [eg 1/2, 1/3])"                                                    
#>  [19] "## Bar Width -> how wide should the bar be (number)"                                                                                                                                                     
#>  [20] "## Bar Border Color -> color of the border (color code) ~ (TimeCourse def: black)"                                                                                                                       
#>  [21] "## Bar Border Width -> how thick should the bar border be (number) ~ (TimeCourse def: 1)"                                                                                                                
#>  [22] "## DEF: \"X Value Angle:45\"; \"X Value Display:TRUE\"; \"X Tick Display:TRUE\"; \"Coord Fixed Ratio:SQUARE\"; \"Bar Width:0.8\"; \"Bar Border Color:white\"; \"Bar Border Width:0.2\""                  
#>  [23] "#"                                                                                                                                                                                                       
#>  [24] "################ Colors and General Display Settings (OPT) ################"                                                                                                                             
#>  [25] "## Colors -> list of colors in html/R format, can handle \",\" and \" \" when splitting **Legend Color Source can simplify the color list for multi group figures**"                                     
#>  [26] "## Colors -> this data is loaded after Colors Unique and can be overriden with the 'Colors Specific' setting"                                                                                            
#>  [27] "## Colors Unique -> one row per set color applied as a set before the Colors data and can be overriden with the Colors Specific setting (for backwards compatibility)"                                   
#>  [28] "## Colors Unique -> one row per set color and then the scatter point details (COLOR, ALPHA, COLOR, SHAPE, SIZE, STROKE, ALPHA)"                                                                          
#>  [29] "## OVERRIDES the Colors Unique & Colors setting as follows:"                                                                                                                                             
#>  [30] "## Colors Specific -> G1_G2, COLOR             -> use defaults for all other values, scatter color can be set to match"                                                                                  
#>  [31] "## Colors Specific -> G1_G2, COLOR, COLOR      -> all other values optional AND must be numeric"                                                                                                         
#>  [32] "## Colors Specific -> G1_G2, COLOR, , SHAPE    -> this will set 1st ALPHA and 2nd COLOR to defaults along with SIZE, STROKE, 2nd ALPHA"                                                                  
#>  [33] "## Colors Specific OVERIDES ALL other settings; if a setting is not speficied defaults to program defaults (scatter color, size, etc) and a random color for the group..."                               
#>  [34] "## Colors Alpha -> level of transparency for the given colors (0 to 1, def: 1)"                                                                                                                          
#>  [35] "## Scatter Display -> display individual data points as default of gold stars (TRUE / FALSE) (DEF: gold: #FFD700, shape: 4)"                                                                             
#>  [36] "## Scatter Alpha -> set default transparency of the scatter points (0 to 1, def: 1)"                                                                                                                     
#>  [37] "## Scatter ColorShapeSize -> set ONE color OR MATCH the group colors OR UNIQUE from the unique/specific setting list (MATCH, UNIQUE, or COLOR) "                                                         
#>  [38] "## Scatter ColorShapeSize -> followed by NUMERIC Shape & Size for setting ALL / DEFAULT for missing"                                                                                                     
#>  [39] "## Scatter Stroke -> border stroke (a number, def: 2) "                                                                                                                                                  
#>  [40] "## Whisker Plot -> display as a bar & whisker plot instead of standard histogram *NOT compatible with TimeCourse, ALWAYS uses Colors Alpha over individual settings* (Box / Violin / FALSE)"             
#>  [41] "## DEF: \"Colors:''\"; \"Colors Alpha:1\"; \"Scatter Display:TRUE\"; \"Scatter Alpha:1\"; \"Scatter ColorShapeSize:#FFD700,4,1.8\"; \"Scatter Stroke:2\"; \"Whisker Plot:FALSE\""                        
#>  [42] "#"                                                                                                                                                                                                       
#>  [43] "################ Chart Line Designs (OPT) ################"                                                                                                                                              
#>  [44] "## Axis (XY) Main Style -> LineSize,LineColor"                                                                                                                                                           
#>  [45] "## Axis (XY) Tick Style -> LineWidth,LineLength(cm),LineColor"                                                                                                                                           
#>  [46] "## Error Bars Style -> LineWidth,EndWidth,Color (does not apply to violin or box plots)"                                                                                                                 
#>  [47] "## HLine Style OVRD -> LineSize,LineColor (applies to all lines regardless of individual style, if nothing specified defaults to 1 & black)"                                                             
#>  [48] "## DEF: \"Axis (XY) Main Style:0.8,black\";\"Axis (XY) Tick Style:0.6,0.1,black\";\"Error Bars Style:0.8,0.4,black\";\"HLine Style:1,black\";"                                                           
#>  [49] "#"                                                                                                                                                                                                       
#>  [50] "################ Chart Legend (OPT) ################"                                                                                                                                                    
#>  [51] "## Legend Display -> should the legend be displayed at all (TRUE / FALSE)"                                                                                                                               
#>  [52] "## Legend Color Source -> display colors AND legend reflect Group1 only OR 1 & 2 (Group1 / All) **TimeCourse always = Group2**"                                                                          
#>  [53] "## Legend Title -> title for the legend (markdown)"                                                                                                                                                      
#>  [54] "## Legend Position -> where to display the legend (Bottom / Right / Left / Top)"                                                                                                                         
#>  [55] "## Legend Size -> size of legend (in save units)"                                                                                                                                                        
#>  [56] "## DEF: \"Legend Display:FALSE\"; \"Legend Color Source:All\"; \"Legend Title:Groups\"; \"Legend Position:Bottom\"; \"Legend Size:0.25\""                                                                
#>  [57] "#"                                                                                                                                                                                                       
#>  [58] "################ Stats Labels (OPT) ################"                                                                                                                                                    
#>  [59] "## Stat offset -> distance above figure bars (FALSE: default value is guessed for a Letter Size of 12, Y Max value & image export of 1800x935; override with a number)"                                  
#>  [60] "## Stat Letter Size -> font size of letters; Stat Caption Display -> display the caption (TRUE or FALSE); Stat Caption Size -> font size of caption"                                                     
#>  [61] "## DEF: \"Stat Offset:FALSE\"; \"Stat Letter Size:18\"; \"Stat Caption Display:TRUE\"; \"Stat Caption Size:6\""                                                                                          
#>  [62] "#"                                                                                                                                                                                                       
#>  [63] "################ Figure Save (OPT) ################"                                                                                                                                                     
#>  [64] "## Specify the image details for the export (dpi, size, type)"                                                                                                                                           
#>  [65] "## Save Units -> (\"in\", \"cm\", \"mm\", \"px\"); Save Type -> (\"tex\", \"pdf\", \"jpg\", \"jpeg\", \"tiff\", \"png\", \"bmp\", \"svg\")"                                                              
#>  [66] "## DEF: \"Save Width:8\"; \"Save Height:8.5\"; \"Save DPI: 320\"; \"Save Units:in\"; \"Save Type:jpg\""                                                                                                  
#>  [67] "#"                                                                                                                                                                                                       
#>  [68] "################ Title & Axis Labels (REQ) ################"                                                                                                                                             
#>  [69] "## Title, X and Y axis text (Title & X Leg have markdown enabled)"                                                                                                                                       
#>  [70] "## DEF (\"Title Main\", \"X Leg\", \"Y Leg\"): \"\""                                                                                                                                                     
#>  [71] "#"                                                                                                                                                                                                       
#>  [72] "################ Height of Y-axis and Horizontal Line/s (REQ) ################"                                                                                                                          
#>  [73] "## Set the size of the y axis and the interval and if there are any horizontal lines"                                                                                                                    
#>  [74] "## HLine -> YValue,LineSize,LineColor (one entry per line)"                                                                                                                                              
#>  [75] "## Break -> accepts csv list as start,stop,scale(opt, def = \"fixed\") eg 0,20,2; multiple breaks allowed"                                                                                               
#>  [76] "## DEF: (\"Y Max\", \"Y Interval\"): \"\"; \"HLine:FALSE\"; \"Y Min:0\"; \"Y Break:FALSE\""                                                                                                              
#>  [77] "#"                                                                                                                                                                                                       
#>  [78] "################ Alter the Axis (REQ) ################"                                                                                                                                                  
#>  [79] "## Y Value Rig -> manipulate the y-axis labels (0 or FALSE = no change; SCI = use scientific notation; # = divide all data by #  incl axis values -> make note on axis label!)"                          
#>  [80] "## Y Value Rig Newline -> newline between Y Leg and rigging note (TRUE or FALSE) - can impact yaxis display!"                                                                                            
#>  [81] "## DEF: \"Y Value Rig:FALSE\"; \"Y Value Rig Newline:FALSE\";"                                                                                                                                           
#>  [82] "#"                                                                                                                                                                                                       
#>  [83] "################ Stats Tests (REQ) ################"                                                                                                                                                     
#>  [84] "## \"Stats Post Test:Tukeys\" -> the post hoc test to run ** IN PLANNING - currently ALL are Tukeys... **"                                                                                               
#>  [85] "## Stats Test -> what type of primary test to carry out (ANOVA, STTest), a combination is possible (use multiple lines)"                                                                                 
#>  [86] "## STTest Comparison Format -> Group1_Group2:Group1_Group2:Symbol:Tails:Variance:Paired"                                                                                                                 
#>  [87] "## First group is compared to group, symbol is placed over second group, Tails is optional that determines tails test (two.sided, greater, less) DEF:two.sided"                                          
#>  [88] "## Variance is optional, determines if sample variance is assumed equal or not (equal, unequal) DEF: equal"                                                                                              
#>  [89] "## Paired is optional, determines if paired or unpaired student T-test is run (paired, unpaired) DEF: unpaired"                                                                                          
#>  [90] "## !! IF data is being separated based on group2 - make sure that the group1_group2 comparisons are within the same group2 !!"                                                                           
#>  [91] "## DEF: \"Stats Test\":'' (ANOVA = ANOVA w/ Tukeys Post Hoc Test; STTest = Students t-Test; WTTest = Wilcoxen TTest - in development)"                                                                   
#>  [92] "#"                                                                                                                                                                                                       
#>  [93] "################ Stats Transformation or Outlier (REQ) ################"                                                                                                                                 
#>  [94] "## \"Stats Transform:FALSE\" -> no transformation"                                                                                                                                                       
#>  [95] "## \"Stats Transform:TreatmentControl:Group1:Group2\" -> define control group: Group1 required, Group2 required if using 2 groups "                                                                      
#>  [96] "## \tcontrol group will be used to normalize all other groups and will be removed from the figure, a line will be automatically added at '1' for this group"                                             
#>  [97] "## \tANOVA (if requested) will be run post transform & group removal; in order to remove a group (treatment) \"Stats Anova Group2\" MUST be set to FALSE!"                                               
#>  [98] "## \"Stats Transform:TimeCourse\" -> group1 defines the time points; group 2 the control & treatment/s "                                                                                                 
#>  [99] "## Stats Outlier -> Outlier detection (FALSE, ONE, TWO) FALSE: no detection; ONE: one tailed; TWO: two tailed (careful when using paired t-tests)"                                                       
#> [100] "## DEF: \"Stats Transform:FALSE\"; \"Stats Outlier:TWO\""                                                                                                                                                
#> [101] "#"                                                                                                                                                                                                       
#> [102] "################ Split on Group 2? (REQ) ################"                                                                                                                                               
#> [103] "## Stats Anova Group2  -> TRUE: compare only within each group2 & include borders around each (req facet split); FALSE: compare between all the group2's [a unique Group1_Group2 id is always generated]"
#> [104] "## Facet Split -> Group2 based header (TRUE: Group2 value as a header above the group [disabled w \"Stats Transform:TimeCourse\"]; FALSE: no Group2 header) & border (req Stats Anova Group2)"           
#> [105] "## DEF: \"Stats Anova Group2:FALSE\"; \"Facet Split:TRUE\""                                                                                                                                              
#> [106] "#"                                                                                                                                                                                                       
#> [107] "################ DATA (REQ) ################"                                                                                                                                                            
#> [108] "## Make sure that Group1 has adequate labels to distinguish any repeats in Group2..."                                                                                                                    
#> [109] "## ALL Group1 entries should come before Group2, order in list is currently order (L>R) on figure"                                                                                                       
#> [110] "Value\tGroup1\tGroup2"
```
