
<!-- README.md is generated from README.Rmd. Please edit that file -->

**NOTE: This is very much a work in progress. The current script appears
functional but is in the process of going through extensive testing,
documentation, and code cleanup. However the initial very basic test
files are working. A few ggplot2 related warning messages still print
during figure generation but the code is functional. I will be uploading
additional example configuration files in the near future and adding
documentation. The config header file DOES explain all of the existing
options. It is designed around the work I am doing routinely in a
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

Data lines are in the format of value.

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
# running generate_figure with plot display & save turned off since readme 
# saves in a temporary location
histova::generate_figure(d,f, FALSE, FALSE)
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
#> ----------------  ----------------  ----------------
knitr::include_graphics("inst/extdata/test-1_group-basic_no_stats.jpg")
```

<img src="inst/extdata/test-1_group-basic_no_stats.jpg" width="100%" />
