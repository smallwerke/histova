
<!-- README.md is generated from README.Rmd. Please edit that file -->

**NOTE: This is very much a work in progress. The current script appears
functional but is in the process of going through extensive testing,
documentation, and code cleanup. However the initial very basic test
file worked. It is designed around the work I am doing routinely in a
molecular biology lab and it might be of use to others.**

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

I will be adding example configuration files in the near future along
with more detailed examples.

## Example

*this is just the boilerplate text that RStudio dumps out… I’ll edit
this once there are actual examples to be had…*

Basic use of the histova sript. Very simple process that generates a
figure by specifying the source directory and the config file. The
output figure is saved to the source directory.

### Load Package

``` r
library(histova)

knitr::include_graphics("inst/extdata/test.jpg")
```

<img src="inst/extdata/test.jpg" width="100%" />

**The following images are the default output from RStudio, the saved
versions from the script have complete font embedding and higher
resoltion.**

### Two Groups

This is an old basic example of an early version of the script with
minimal options.

``` r
d = "/Users/Shared/HISTOVA_DATA"
f = "test-2_groups.txt"
histova::generate_figure(d,f)
#> ----------------  ----------------  ----------------
#> -------- Prep & Load config settings and data --------
#> ---- Load config (file: test-2_groups.txt)
#> ---- Load data (file: test-2_groups.txt)
#>  12 final Group1_Group2 (statGroups - should be unique!) ids:
#>   G1_24hrs G2_24hrs G3_24hrs G4_24hrs G5_24hrs G6_24hrs G1_48hrs G2_48hrs G3_48hrs G4_48hrs G5_48hrs G6_48hrs
#> -------- Statistical Analysis --------
#> ---- Outlier checking
#> ---- Prep stats overview
#> ---- ANOVA w/ Tukeys Post Hoc
#> ---- Student T-Test
#> ** CHECK DATA - variances between group1 G1_48hrs & group2 G3_48hrs ARE NOT homogenous with a p-value: 0.00336347783100344
#> Warning in run_sttest(): ** CHECK DATA - variances between group1 G1_48hrs &
#> group2 G3_48hrs ARE NOT homogenous with a p-value: 0.00336347783100344 (file:
#> test-2_groups.txt)
#> ran a UNPAIRED students t-test on group1 G1_48hrs to group2 G3_48hrs, with tail: LESS, variance: EQUAL, p-value: 0.383700232956247
#> -------- Build Histogram --------
#> setting y-axis to use scientific notation, replacing existing scale_y_continuous...
#> Scale for y is already present.
#> Adding another scale for y, which will replace the existing scale.
#> Figure coordinate ratio for display: 0.75
#> 
#> ---- Generate Figure Labels
#> 
#> ---- Generate Figure Labels
#> 
#> adding a horizontal line to the figure at: '8.5'
#> 
#> adding a horizontal line to the figure at: '4.25'
#> 
#> saving your new figure to: '/Users/Shared/HISTOVA_DATA/test-2_groups.jpg'
#> 
#> -------- SAVE Histogram --------
#> Warning: Using ragg device as default. Ignoring `type` and `antialias`
#> arguments
#> ----------------  ----------------  ----------------
```

<img src="man/figures/README-example2-1.png" width="100%" />

### First Version

This is an old basic example of an early version of the script with
minimal options.

``` r
d = "/Users/Shared/HISTOVA_DATA"
f = "test.txt"
histova::generate_figure(d,f)
#> ----------------  ----------------  ----------------
#> -------- Prep & Load config settings and data --------
#> ---- Load config (file: test.txt)
#> ---- Load data (file: test.txt)
#>  6 final Group1_Group2 (statGroups - should be unique!) ids:
#>   G1_24hrs G2_24hrs G3_24hrs G4_24hrs G5_24hrs G6_24hrs
#> -------- Statistical Analysis --------
#> ---- Outlier checking
#> Warning in run_outlier(): ONE TAILED REMOVAL on group G2_24hrs (file: test.txt)
#> ---- Prep stats overview
#> -------- Build Histogram --------
#> Figure coordinate ratio for display: 0.1
#> ---- Generate Figure Labels
#> Warning in min(x): no non-missing arguments to min; returning Inf
#> Warning in max(x): no non-missing arguments to max; returning -Inf
#> saving your new figure to: '/Users/Shared/HISTOVA_DATA/test.jpg'
#> -------- SAVE Histogram --------
#> Warning: Using ragg device as default. Ignoring `type` and `antialias`
#> arguments
#> Warning in min(x): no non-missing arguments to min; returning Inf
#> Warning in max(x): no non-missing arguments to max; returning -Inf
#> ----------------  ----------------  ----------------
```

<img src="man/figures/README-example1-1.png" width="100%" />
