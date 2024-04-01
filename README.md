
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

Basic use of the histova sript. Very simple process that generates a
figure by specifying the source directory and the config file. The
output figure is saved to the source directory.

All of the example config files are included in the extdata directory.

### Load Package

``` r
library(histova)
library(stringr) # for the str_remove call
```

***The following examples are loading the final jpg figure that is
produced. It is possible to have the package output a figure to RStudio
for immediate examination though the font configuration is often
incomplete.***

### One Group

The most basic version of this script is simply for building a histogram
with only *one* group type defined out of the two that are possible. No
statistics were run on this data and the individual data scatter is not
being displayed.

``` r
f = "test-1_group-basic_no_stats.txt"
d = stringr::str_remove(histova_example(f), paste0("/",f))
histova::generate_figure(d,f)
#> ----------------  ----------------  ----------------
#> -------- Prep & Load config settings and data --------
#> ---- Load config (file: test-1_group-basic_no_stats.txt)
#> ---- Load data (file: test-1_group-basic_no_stats.txt)
#>  6 final Group1_Group2 (statGroups - should be unique!) ids:
#>   G1 G2 G3 G4 G5 G6
#> -------- Statistical Analysis --------
#> ---- Prep stats overview
#> -------- Build Histogram --------
#> Figure coordinate ratio for display: 0.3
#> ---- Generate Figure Labels
#> -------- SAVE Histogram --------
#> saving your new figure to: '/private/var/folders/cc/2hgnkp915jd5ks4z8mpqhrg00000gs/T/RtmpLR37pl/temp_libpath2db46540265/histova/extdata/test-1_group-basic_no_stats.jpg'
#> Warning: Using ragg device as default. Ignoring `type` and `antialias`
#> arguments
#> Warning in min(x): no non-missing arguments to min; returning Inf
#> Warning in max(x): no non-missing arguments to max; returning -Inf
#> ----------------  ----------------  ----------------
knitr::include_graphics("inst/extdata/test-1_group-basic_no_stats.jpg")
```

<img src="inst/extdata/test-1_group-basic_no_stats.jpg" width="100%" />
