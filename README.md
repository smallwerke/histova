
<!-- README.md is generated from README.Rmd. Please edit that file -->

**NOTE: This is still a work in progress *but* the package is
functioning and was able to recreate my previous set of test figures
without error. I am still going through and doing some code cleanup &
documentation before beginning to add more features. A few ggplot2
related warning messages still print during figure generation but the
code is functional. I will be uploading additional example configuration
files in the near future and adding documentation. The config header
file DOES explain all of the existing options.**

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
library(stringr) # for the str_remove call
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
#> ------------------------------- histova 3.5.0.1 --------------------------------
#> ----------------------- run on Mon May  6 19:07:53 2024 ------------------------
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
#> --------------------- finihsed on Mon May  6 19:07:54 2024 ---------------------
#> --------------------------------------------------------------------------------
knitr::include_graphics("inst/extdata/test-1_group-ANOVA_scatter_outlier.jpg")
```

<img src="inst/extdata/test-1_group-ANOVA_scatter_outlier.jpg" width="100%" />

## Config

<a href="data:text/plain;base64,IyMgVEVTVCBEQVRBIC0gZmlsZSBuYW1lICYgZGV0YWlscw0KIyMjIyMjIyMjIyMjIyMjIyBPVkVSUklERT8gIyMjIyMjIyMjIyMjIyMjIw0KIyMgISEgT1ZFUlJJREUgTVVTVCBCRSBBVCBUSEUgVE9QIE9GIFRIRSBEQVRBIEZJTEUgISENCiMjIEFiaWxpdHkgdG8gc2F2ZSB0aGUgb3B0aW9uYWwgKE9QVCkgaGVhZGVkIGRhdGEgZm9yIHN1YnNlcXVlbnQgZGF0YSBmaWxlcyAtIG1ha2VzIGNvbnNpc3RlbnQgc3R5bGUgZm9ybWF0dGluZyBlYXNpZXIgd2hlbiBtYWtpbmcgbXVsdGlwbGUgZmlndXJlcw0KIyMgT3ZlcnJpZGUgLT4gKFRSVUU6IHN0b3JlIHRoZSBPUFQgdmFsdWVzIGZyb20gdGhpcyBmaWxlIHVudGlsIGFub3RoZXIgVFJVRSBpcyBlbmNvdW50ZXJlZDsgRkFMU0U6IHR1cm4gb3ZlcnJpZGUgb2ZmIGFuZCBjbGVhciBvdXQgdGhlIHN0b3JlZCB2YWx1ZXMpDQojIyBERUYgIk92ZXJyaWRlOicnIiANCiMNCiMjIyMjIyMjIyMjIyMjIyMgTGFiZWwgU2l6ZSBhbmQgQXBwZWFyYW5jZSAoT1BUKSAjIyMjIyMjIyMjIyMjIyMjDQojIyBTZXQgdGhlIHNpemUgb2YgdGhlIGxhYmVscywgdGhlIGRpc3RhbmNlIGJldHdlZW4gdGhlIGF4aXMgbGFiZWxzIGFuZCB0aGUgdmFsdWVzICYgdGhlIGF4aXMgdmFsdWUgc2l6ZQ0KIyMgVGV4dCBDb252ZXJ0IC0+IHNjYW4gdGhlIHRpdGxlICYgYXhpcyBmb3IgaHRtbCBjb2RlcyBhbmQgY29udmVydCB0byB1bmljb2RlOyBUZXh0IEZvbnQgLT4gc2VsZWN0IGEgZm9udA0KIyMgQ29udmVyc2lvbjogKCZBbHBoYTsgJlNpZ21hOyAmYWxwaGE7ICZiZXRhOyAmZXBzaWxvbjsgJnBpOyAmc2lnbWE7ICZidWxsOyAmaXNpbjsgJnJhZGljOyAmbWljcm87IFxuKTsgRm9udHM6IChtb25vLCBzYW5zLCBzZXJpZikNCiMjIERFRjogIlRpdGxlIFNpemU6MzIiOyAiQXhpcyBUaXRsZSBTaXplOjI2IjsgQXhpcyBMYWJlbCBTaXplOjI2IjsgIkF4aXMgTGFiZWwgU2VwOjIwIjsgIkF4aXMgVmFsdWUgU2l6ZTogMjYiOyAiTGVnZW5kIExhYmVsIFNpemU6MjYiOyAiVGV4dCBDb252ZXJ0OlRSVUUiOyAiVGV4dCBGb250OnNhbnMiDQojDQojIyMjIyMjIyMjIyMjIyMjIERpc3BsYXkgb2YgdGhlIEF4aXMgJiBQbG90IChPUFQpICMjIyMjIyMjIyMjIyMjIyMNCiMjIFggVmFsdWUgQW5nbGUgLT4gU2V0IHRoZSBhbmdsZSBmb3IgWCBheGlzIHZhbHVlcyAoMCA9IG5vIHJvdGF0aW9uLCBudW1iZXIgPSBkZWdyZWUgcm90YXRpb24pDQojIyBYIFZhbHVlIERpc3BsYXkgLT4gZGlzcGxheSBvciBub3QgdGhlIHZhbHVlcyBvbiB0aGUgeC1heGlzIChUUlVFIC8gRkFMU0UpDQojIyBYIFRpY2sgRGlzcGxheSAtPiBkaXNwbGF5IHRoZSB0aWNrIG1hcmtzIG9uIHRoZSB4LWF4aXMgKFRSVUUgLyBGQUxTRSkNCiMjIENvb3JkIEZpeGVkIFJhdGlvIC0+ICoqKkNVUlJFTlRMWSBESVNBQkxFRCoqKiBDb29yZGluYXRlIHJhdGlvIG9yIG1hbnVhbCAoRkFMU0U6IGRpc2FibGVkLCBTUVVBUkU6IDEvKFkgTWF4IC8gIyBvZiBYIEdyb3VwcyksIE5VTTogW2VnIDEvMiwgMS8zXSkNCiMjIEJhciBXaWR0aCAtPiBob3cgd2lkZSBzaG91bGQgdGhlIGJhciBiZSAobnVtYmVyKQ0KIyMgQmFyIEJvcmRlciBDb2xvciAtPiBjb2xvciBvZiB0aGUgYm9yZGVyIChjb2xvciBjb2RlKSB+IChUaW1lQ291cnNlIGRlZjogYmxhY2spDQojIyBCYXIgQm9yZGVyIFdpZHRoIC0+IGhvdyB0aGljayBzaG91bGQgdGhlIGJhciBib3JkZXIgYmUgKG51bWJlcikgfiAoVGltZUNvdXJzZSBkZWY6IDEpDQojIyBERUY6ICJYIFZhbHVlIEFuZ2xlOjQ1IjsgIlggVmFsdWUgRGlzcGxheTpUUlVFIjsgIlggVGljayBEaXNwbGF5OlRSVUUiOyAiQ29vcmQgRml4ZWQgUmF0aW86U1FVQVJFIjsgIkJhciBXaWR0aDowLjgiOyAiQmFyIEJvcmRlciBDb2xvcjp3aGl0ZSI7ICJCYXIgQm9yZGVyIFdpZHRoOjAuMiINCiMNCiMjIyMjIyMjIyMjIyMjIyMgQ29sb3JzIGFuZCBHZW5lcmFsIERpc3BsYXkgU2V0dGluZ3MgKE9QVCkgIyMjIyMjIyMjIyMjIyMjIw0KIyMgQ29sb3JzIC0+IGxpc3Qgb2YgY29sb3JzIGluIGh0bWwvUiBmb3JtYXQsIGNhbiBoYW5kbGUgIiwiIGFuZCAiICIgd2hlbiBzcGxpdHRpbmcgKipMZWdlbmQgQ29sb3IgU291cmNlIGNhbiBzaW1wbGlmeSB0aGUgY29sb3IgbGlzdCBmb3IgbXVsdGkgZ3JvdXAgZmlndXJlcyoqDQojIyBDb2xvcnMgLT4gdGhpcyBkYXRhIGlzIGxvYWRlZCBhZnRlciBDb2xvcnMgVW5pcXVlIGFuZCBjYW4gYmUgb3ZlcnJpZGVuIHdpdGggdGhlICdDb2xvcnMgU3BlY2lmaWMnIHNldHRpbmcNCiMjIENvbG9ycyBVbmlxdWUgLT4gb25lIHJvdyBwZXIgc2V0IGNvbG9yIGFwcGxpZWQgYXMgYSBzZXQgYmVmb3JlIHRoZSBDb2xvcnMgZGF0YSBhbmQgY2FuIGJlIG92ZXJyaWRlbiB3aXRoIHRoZSBDb2xvcnMgU3BlY2lmaWMgc2V0dGluZyAoZm9yIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5KQ0KIyMgQ29sb3JzIFVuaXF1ZSAtPiBvbmUgcm93IHBlciBzZXQgY29sb3IgYW5kIHRoZW4gdGhlIHNjYXR0ZXIgcG9pbnQgZGV0YWlscyAoQ09MT1IsIEFMUEhBLCBDT0xPUiwgU0hBUEUsIFNJWkUsIFNUUk9LRSwgQUxQSEEpDQojIyBPVkVSUklERVMgdGhlIENvbG9ycyBVbmlxdWUgJiBDb2xvcnMgc2V0dGluZyBhcyBmb2xsb3dzOg0KIyMgQ29sb3JzIFNwZWNpZmljIC0+IEcxX0cyLCBDT0xPUiAgICAgICAgICAgICAtPiB1c2UgZGVmYXVsdHMgZm9yIGFsbCBvdGhlciB2YWx1ZXMsIHNjYXR0ZXIgY29sb3IgY2FuIGJlIHNldCB0byBtYXRjaA0KIyMgQ29sb3JzIFNwZWNpZmljIC0+IEcxX0cyLCBDT0xPUiwgQ09MT1IgICAgICAtPiBhbGwgb3RoZXIgdmFsdWVzIG9wdGlvbmFsIEFORCBtdXN0IGJlIG51bWVyaWMNCiMjIENvbG9ycyBTcGVjaWZpYyAtPiBHMV9HMiwgQ09MT1IsICwgU0hBUEUgICAgLT4gdGhpcyB3aWxsIHNldCAxc3QgQUxQSEEgYW5kIDJuZCBDT0xPUiB0byBkZWZhdWx0cyBhbG9uZyB3aXRoIFNJWkUsIFNUUk9LRSwgMm5kIEFMUEhBDQojIyBDb2xvcnMgU3BlY2lmaWMgT1ZFUklERVMgQUxMIG90aGVyIHNldHRpbmdzOyBpZiBhIHNldHRpbmcgaXMgbm90IHNwZWZpY2llZCBkZWZhdWx0cyB0byBwcm9ncmFtIGRlZmF1bHRzIChzY2F0dGVyIGNvbG9yLCBzaXplLCBldGMpIGFuZCBhIHJhbmRvbSBjb2xvciBmb3IgdGhlIGdyb3VwLi4uDQojIyBDb2xvcnMgQWxwaGEgLT4gbGV2ZWwgb2YgdHJhbnNwYXJlbmN5IGZvciB0aGUgZ2l2ZW4gY29sb3JzICgwIHRvIDEpICpCb3ggLyBWaW9saW4gdXNlcyBkZWZhdWx0IGZvciBhbGwgZ3JvdXBzKg0KIyMgU2NhdHRlciBEaXNwbGF5IC0+IGRpc3BsYXkgaW5kaXZpZHVhbCBkYXRhIHBvaW50cyBhcyBkZWZhdWx0IG9mIGdvbGQgc3RhcnMgKFRSVUUgLyBGQUxTRSkgKERFRjogZ29sZDogI0ZGRDcwMCwgc2hhcGU6IDQpDQojIyBTY2F0dGVyIEFscGhhIC0+IHNldCBkZWZhdWx0IHRyYW5zcGFyZW5jeSBvZiB0aGUgc2NhdHRlciBwb2ludHMgKDAgdG8gMSwgZGVmOiAxKQ0KIyMgU2NhdHRlciBDb2xvclNoYXBlU2l6ZSAtPiBzZXQgT05FIGNvbG9yIE9SIE1BVENIIHRoZSBncm91cCBjb2xvcnMgT1IgVU5JUVVFIGZyb20gdGhlIHVuaXF1ZS9zcGVjaWZpYyBzZXR0aW5nIGxpc3QgKE1BVENILCBVTklRVUUsIG9yIENPTE9SKSANCiMjIFNjYXR0ZXIgQ29sb3JTaGFwZVNpemUgLT4gZm9sbG93ZWQgYnkgTlVNRVJJQyBTaGFwZSAmIFNpemUgZm9yIHNldHRpbmcgQUxMIC8gREVGQVVMVCBmb3IgbWlzc2luZw0KIyMgU2NhdHRlciBTdHJva2UgLT4gYm9yZGVyIHN0cm9rZSAoYSBudW1iZXIsIGRlZjogMikgDQojIyBXaGlza2VyIFBsb3QgLT4gZGlzcGxheSBhcyBhIGJhciAmIHdoaXNrZXIgcGxvdCBpbnN0ZWFkIG9mIHN0YW5kYXJkIGhpc3RvZ3JhbSAqTk9UIGNvbXBhdGlibGUgd2l0aCBUaW1lQ291cnNlKiAoQm94IC8gVmlvbGluIC8gRkFMU0UpDQojIyBERUY6ICJDb2xvcnM6JyciOyAiQ29sb3JzIEFscGhhOjEiOyAiU2NhdHRlciBEaXNwbGF5OlRSVUUiOyAiU2NhdHRlciBBbHBoYToxIjsgIlNjYXR0ZXIgQ29sb3JTaGFwZVNpemU6I0ZGRDcwMCw0LDEuOCI7ICJTY2F0dGVyIFN0cm9rZToyIjsgIldoaXNrZXIgUGxvdDpGQUxTRSINCiMNCiMjIyMjIyMjIyMjIyMjIyMgQ2hhcnQgTGluZSBEZXNpZ25zIChPUFQpICMjIyMjIyMjIyMjIyMjIyMNCiMjIEF4aXMgKFhZKSBNYWluIFN0eWxlIC0+IExpbmVTaXplLExpbmVDb2xvcg0KIyMgQXhpcyAoWFkpIFRpY2sgU3R5bGUgLT4gTGluZVdpZHRoLExpbmVMZW5ndGgoY20pLExpbmVDb2xvcg0KIyMgRXJyb3IgQmFycyBTdHlsZSAtPiBMaW5lV2lkdGgsRW5kV2lkdGgsQ29sb3IgKGRvZXMgbm90IGFwcGx5IHRvIHZpb2xpbiBvciBib3ggcGxvdHMpDQojIyBITGluZSBTdHlsZSBPVlJEIC0+IExpbmVTaXplLExpbmVDb2xvciAoYXBwbGllcyB0byBhbGwgbGluZXMgcmVnYXJkbGVzcyBvZiBpbmRpdmlkdWFsIHN0eWxlLCBpZiBub3RoaW5nIHNwZWNpZmllZCBkZWZhdWx0cyB0byAxICYgYmxhY2spDQojIyBERUY6ICJBeGlzIChYWSkgTWFpbiBTdHlsZTowLjgsYmxhY2siOyJBeGlzIChYWSkgVGljayBTdHlsZTowLjYsMC4xLGJsYWNrIjsiRXJyb3IgQmFycyBTdHlsZTowLjgsMC40LGJsYWNrIjsiSExpbmUgU3R5bGU6MSxibGFjayI7DQojDQojIyMjIyMjIyMjIyMjIyMjIENoYXJ0IExlZ2VuZCAoT1BUKSAjIyMjIyMjIyMjIyMjIyMjDQojIyBMZWdlbmQgRGlzcGxheSAtPiBzaG91bGQgdGhlIGxlZ2VuZCBiZSBkaXNwbGF5ZWQgYXQgYWxsIChUUlVFIC8gRkFMU0UpDQojIyBMZWdlbmQgQ29sb3IgU291cmNlIC0+IGRpc3BsYXkgY29sb3JzIEFORCBsZWdlbmQgcmVmbGVjdCBHcm91cDEgb25seSBPUiAxICYgMiAoR3JvdXAxIC8gQWxsKSAqKlRpbWVDb3Vyc2UgYWx3YXlzID0gR3JvdXAyKioNCiMjIExlZ2VuZCBUaXRsZSAtPiB0aXRsZSBmb3IgdGhlIGxlZ2VuZCAobWFya2Rvd24pDQojIyBMZWdlbmQgUG9zaXRpb24gLT4gd2hlcmUgdG8gZGlzcGxheSB0aGUgbGVnZW5kIChCb3R0b20gLyBSaWdodCAvIExlZnQgLyBUb3ApDQojIyBMZWdlbmQgU2l6ZSAtPiBzaXplIG9mIGxlZ2VuZCAoaW4gc2F2ZSB1bml0cykNCiMjIERFRjogIkxlZ2VuZCBEaXNwbGF5OkZBTFNFIjsgIkxlZ2VuZCBDb2xvciBTb3VyY2U6QWxsIjsgIkxlZ2VuZCBUaXRsZTpHcm91cHMiOyAiTGVnZW5kIFBvc2l0aW9uOkJvdHRvbSI7ICJMZWdlbmQgU2l6ZTowLjI1Ig0KIw0KIyMjIyMjIyMjIyMjIyMjIyBTdGF0cyBMYWJlbHMgKE9QVCkgIyMjIyMjIyMjIyMjIyMjIw0KIyMgU3RhdCBvZmZzZXQgLT4gZGlzdGFuY2UgYWJvdmUgZmlndXJlIGJhcnMgKEZBTFNFOiBkZWZhdWx0IHZhbHVlIGlzIGd1ZXNzZWQgZm9yIGEgTGV0dGVyIFNpemUgb2YgMTIsIFkgTWF4IHZhbHVlICYgaW1hZ2UgZXhwb3J0IG9mIDE4MDB4OTM1OyBvdmVycmlkZSB3aXRoIGEgbnVtYmVyKQ0KIyMgU3RhdCBMZXR0ZXIgU2l6ZSAtPiBmb250IHNpemUgb2YgbGV0dGVyczsgU3RhdCBDYXB0aW9uIERpc3BsYXkgLT4gZGlzcGxheSB0aGUgY2FwdGlvbiAoVFJVRSBvciBGQUxTRSk7IFN0YXQgQ2FwdGlvbiBTaXplIC0+IGZvbnQgc2l6ZSBvZiBjYXB0aW9uDQojIyBERUY6ICJTdGF0IE9mZnNldDpGQUxTRSI7ICJTdGF0IExldHRlciBTaXplOjE4IjsgIlN0YXQgQ2FwdGlvbiBEaXNwbGF5OlRSVUUiOyAiU3RhdCBDYXB0aW9uIFNpemU6NiINCiMNCiMjIyMjIyMjIyMjIyMjIyMgRmlndXJlIFNhdmUgKE9QVCkgIyMjIyMjIyMjIyMjIyMjIw0KIyMgU3BlY2lmeSB0aGUgaW1hZ2UgZGV0YWlscyBmb3IgdGhlIGV4cG9ydCAoZHBpLCBzaXplLCB0eXBlKQ0KIyMgU2F2ZSBVbml0cyAtPiAoImluIiwgImNtIiwgIm1tIiwgInB4Iik7IFNhdmUgVHlwZSAtPiAoInRleCIsICJwZGYiLCAianBnIiwgImpwZWciLCAidGlmZiIsICJwbmciLCAiYm1wIiwgInN2ZyIpDQojIyBERUY6ICJTYXZlIFdpZHRoOjgiOyAiU2F2ZSBIZWlnaHQ6OC41IjsgIlNhdmUgRFBJOiAzMjAiOyAiU2F2ZSBVbml0czppbiI7ICJTYXZlIFR5cGU6anBnIg0KIw0KIyMjIyMjIyMjIyMjIyMjIyBUaXRsZSAmIEF4aXMgTGFiZWxzIChSRVEpICMjIyMjIyMjIyMjIyMjIyMNCiMjIFRpdGxlLCBYIGFuZCBZIGF4aXMgdGV4dCAoVGl0bGUgJiBYIExlZyBoYXZlIG1hcmtkb3duIGVuYWJsZWQpDQojIyBERUYgKCJUaXRsZSBNYWluIiwgIlggTGVnIiwgIlkgTGVnIik6ICIiDQojDQojIyMjIyMjIyMjIyMjIyMjIEhlaWdodCBvZiBZLWF4aXMgYW5kIEhvcml6b250YWwgTGluZS9zIChSRVEpICMjIyMjIyMjIyMjIyMjIyMNCiMjIFNldCB0aGUgc2l6ZSBvZiB0aGUgeSBheGlzIGFuZCB0aGUgaW50ZXJ2YWwgYW5kIGlmIHRoZXJlIGFyZSBhbnkgaG9yaXpvbnRhbCBsaW5lcw0KIyMgSExpbmUgLT4gWVZhbHVlLExpbmVTaXplLExpbmVDb2xvciAob25lIGVudHJ5IHBlciBsaW5lKQ0KIyMgQnJlYWsgLT4gYWNjZXB0cyBjc3YgbGlzdCBhcyBzdGFydCxzdG9wLHNjYWxlKG9wdCwgZGVmID0gImZpeGVkIikgZWcgMCwyMCwyOyBtdWx0aXBsZSBicmVha3MgYWxsb3dlZA0KIyMgREVGOiAoIlkgTWF4IiwgIlkgSW50ZXJ2YWwiKTogIiI7ICJITGluZTpGQUxTRSI7ICJZIE1pbjowIjsgIlkgQnJlYWs6RkFMU0UiDQojDQojIyMjIyMjIyMjIyMjIyMjIEFsdGVyIHRoZSBBeGlzIChSRVEpICMjIyMjIyMjIyMjIyMjIyMNCiMjIFkgVmFsdWUgUmlnIC0+IG1hbmlwdWxhdGUgdGhlIHktYXhpcyBsYWJlbHMgKDAgb3IgRkFMU0UgPSBubyBjaGFuZ2U7IFNDSSA9IHVzZSBzY2llbnRpZmljIG5vdGF0aW9uOyAjID0gZGl2aWRlIGFsbCBkYXRhIGJ5ICMgIGluY2wgYXhpcyB2YWx1ZXMgLT4gbWFrZSBub3RlIG9uIGF4aXMgbGFiZWwhKQ0KIyMgWSBWYWx1ZSBSaWcgTmV3bGluZSAtPiBuZXdsaW5lIGJldHdlZW4gWSBMZWcgYW5kIHJpZ2dpbmcgbm90ZSAoVFJVRSBvciBGQUxTRSkgLSBjYW4gaW1wYWN0IHlheGlzIGRpc3BsYXkhDQojIyBERUY6ICJZIFZhbHVlIFJpZzpGQUxTRSI7ICJZIFZhbHVlIFJpZyBOZXdsaW5lOkZBTFNFIjsNCiMNCiMjIyMjIyMjIyMjIyMjIyMgU3RhdHMgVGVzdHMgKFJFUSkgIyMjIyMjIyMjIyMjIyMjIw0KIyMgIlN0YXRzIFBvc3QgVGVzdDpUdWtleXMiIC0+IHRoZSBwb3N0IGhvYyB0ZXN0IHRvIHJ1biAqKiBJTiBQTEFOTklORyAtIGN1cnJlbnRseSBBTEwgYXJlIFR1a2V5cy4uLiAqKg0KIyMgU3RhdHMgVGVzdCAtPiB3aGF0IHR5cGUgb2YgcHJpbWFyeSB0ZXN0IHRvIGNhcnJ5IG91dCAoQU5PVkEsIFNUVGVzdCksIGEgY29tYmluYXRpb24gaXMgcG9zc2libGUgKHVzZSBtdWx0aXBsZSBsaW5lcykNCiMjIFNUVGVzdCBDb21wYXJpc29uIEZvcm1hdCAtPiBHcm91cDFfR3JvdXAyOkdyb3VwMV9Hcm91cDI6U3ltYm9sOlRhaWxzOlZhcmlhbmNlOlBhaXJlZA0KIyMgRmlyc3QgZ3JvdXAgaXMgY29tcGFyZWQgdG8gZ3JvdXAsIHN5bWJvbCBpcyBwbGFjZWQgb3ZlciBzZWNvbmQgZ3JvdXAsIFRhaWxzIGlzIG9wdGlvbmFsIHRoYXQgZGV0ZXJtaW5lcyB0YWlscyB0ZXN0ICh0d28uc2lkZWQsIGdyZWF0ZXIsIGxlc3MpIERFRjp0d28uc2lkZWQNCiMjIFZhcmlhbmNlIGlzIG9wdGlvbmFsLCBkZXRlcm1pbmVzIGlmIHNhbXBsZSB2YXJpYW5jZSBpcyBhc3N1bWVkIGVxdWFsIG9yIG5vdCAoZXF1YWwsIHVuZXF1YWwpIERFRjogZXF1YWwNCiMjIFBhaXJlZCBpcyBvcHRpb25hbCwgZGV0ZXJtaW5lcyBpZiBwYWlyZWQgb3IgdW5wYWlyZWQgc3R1ZGVudCBULXRlc3QgaXMgcnVuIChwYWlyZWQsIHVucGFpcmVkKSBERUY6IHVucGFpcmVkDQojIyAhISBJRiBkYXRhIGlzIGJlaW5nIHNlcGFyYXRlZCBiYXNlZCBvbiBncm91cDIgLSBtYWtlIHN1cmUgdGhhdCB0aGUgZ3JvdXAxX2dyb3VwMiBjb21wYXJpc29ucyBhcmUgd2l0aGluIHRoZSBzYW1lIGdyb3VwMiAhIQ0KIyMgREVGOiAiU3RhdHMgVGVzdCI6JycgKEFOT1ZBID0gQU5PVkEgdy8gVHVrZXlzIFBvc3QgSG9jIFRlc3Q7IFNUVGVzdCA9IFN0dWRlbnRzIHQtVGVzdDsgV1RUZXN0ID0gV2lsY294ZW4gVFRlc3QgLSBpbiBkZXZlbG9wbWVudCkNCiMNCiMjIyMjIyMjIyMjIyMjIyMgU3RhdHMgVHJhbnNmb3JtYXRpb24gb3IgT3V0bGllciAoUkVRKSAjIyMjIyMjIyMjIyMjIyMjDQojIyAiU3RhdHMgVHJhbnNmb3JtOkZBTFNFIiAtPiBubyB0cmFuc2Zvcm1hdGlvbg0KIyMgIlN0YXRzIFRyYW5zZm9ybTpUcmVhdG1lbnRDb250cm9sOkdyb3VwMTpHcm91cDIiIC0+IGRlZmluZSBjb250cm9sIGdyb3VwOiBHcm91cDEgcmVxdWlyZWQsIEdyb3VwMiByZXF1aXJlZCBpZiB1c2luZyAyIGdyb3VwcyANCiMjIAljb250cm9sIGdyb3VwIHdpbGwgYmUgdXNlZCB0byBub3JtYWxpemUgYWxsIG90aGVyIGdyb3VwcyBhbmQgd2lsbCBiZSByZW1vdmVkIGZyb20gdGhlIGZpZ3VyZSwgYSBsaW5lIHdpbGwgYmUgYXV0b21hdGljYWxseSBhZGRlZCBhdCAnMScgZm9yIHRoaXMgZ3JvdXANCiMjIAlBTk9WQSAoaWYgcmVxdWVzdGVkKSB3aWxsIGJlIHJ1biBwb3N0IHRyYW5zZm9ybSAmIGdyb3VwIHJlbW92YWw7IGluIG9yZGVyIHRvIHJlbW92ZSBhIGdyb3VwICh0cmVhdG1lbnQpICJTdGF0cyBBbm92YSBHcm91cDIiIE1VU1QgYmUgc2V0IHRvIEZBTFNFIQ0KIyMgIlN0YXRzIFRyYW5zZm9ybTpUaW1lQ291cnNlIiAtPiBncm91cDEgZGVmaW5lcyB0aGUgdGltZSBwb2ludHM7IGdyb3VwIDIgdGhlIGNvbnRyb2wgJiB0cmVhdG1lbnQvcyANCiMjIFN0YXRzIE91dGxpZXIgLT4gT3V0bGllciBkZXRlY3Rpb24gKEZBTFNFLCBPTkUsIFRXTykgRkFMU0U6IG5vIGRldGVjdGlvbjsgT05FOiBvbmUgdGFpbGVkOyBUV086IHR3byB0YWlsZWQgKGNhcmVmdWwgd2hlbiB1c2luZyBwYWlyZWQgdC10ZXN0cykNCiMjIERFRjogIlN0YXRzIFRyYW5zZm9ybTpGQUxTRSI7ICJTdGF0cyBPdXRsaWVyOlRXTyINCiMNCiMjIyMjIyMjIyMjIyMjIyMgU3BsaXQgb24gR3JvdXAgMj8gKFJFUSkgIyMjIyMjIyMjIyMjIyMjIw0KIyMgU3RhdHMgQW5vdmEgR3JvdXAyICAtPiBUUlVFOiBjb21wYXJlIG9ubHkgd2l0aGluIGVhY2ggZ3JvdXAyICYgaW5jbHVkZSBib3JkZXJzIGFyb3VuZCBlYWNoIChyZXEgZmFjZXQgc3BsaXQpOyBGQUxTRTogY29tcGFyZSBiZXR3ZWVuIGFsbCB0aGUgZ3JvdXAyJ3MgW2EgdW5pcXVlIEdyb3VwMV9Hcm91cDIgaWQgaXMgYWx3YXlzIGdlbmVyYXRlZF0NCiMjIEZhY2V0IFNwbGl0IC0+IEdyb3VwMiBiYXNlZCBoZWFkZXIgKFRSVUU6IEdyb3VwMiB2YWx1ZSBhcyBhIGhlYWRlciBhYm92ZSB0aGUgZ3JvdXAgW2Rpc2FibGVkIHcgIlN0YXRzIFRyYW5zZm9ybTpUaW1lQ291cnNlIl07IEZBTFNFOiBubyBHcm91cDIgaGVhZGVyKSAmIGJvcmRlciAocmVxIFN0YXRzIEFub3ZhIEdyb3VwMikNCiMjIERFRjogIlN0YXRzIEFub3ZhIEdyb3VwMjpGQUxTRSI7ICJGYWNldCBTcGxpdDpUUlVFIg0KIw0KIyMjIyMjIyMjIyMjIyMjIyBEQVRBIChSRVEpICMjIyMjIyMjIyMjIyMjIyMNCiMjIE1ha2Ugc3VyZSB0aGF0IEdyb3VwMSBoYXMgYWRlcXVhdGUgbGFiZWxzIHRvIGRpc3Rpbmd1aXNoIGFueSByZXBlYXRzIGluIEdyb3VwMi4uLg0KIyMgQUxMIEdyb3VwMSBlbnRyaWVzIHNob3VsZCBjb21lIGJlZm9yZSBHcm91cDIsIG9yZGVyIGluIGxpc3QgaXMgY3VycmVudGx5IG9yZGVyIChMPlIpIG9uIGZpZ3VyZQ0KVmFsdWUJR3JvdXAxCUdyb3VwMg0K" download="header_config.txt">Download header_config.txt</a>

``` r
# print out the full contents of the header sample file
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
#>  [34] "## Colors Alpha -> level of transparency for the given colors (0 to 1) *Box / Violin uses default for all groups*"                                                                                       
#>  [35] "## Scatter Display -> display individual data points as default of gold stars (TRUE / FALSE) (DEF: gold: #FFD700, shape: 4)"                                                                             
#>  [36] "## Scatter Alpha -> set default transparency of the scatter points (0 to 1, def: 1)"                                                                                                                     
#>  [37] "## Scatter ColorShapeSize -> set ONE color OR MATCH the group colors OR UNIQUE from the unique/specific setting list (MATCH, UNIQUE, or COLOR) "                                                         
#>  [38] "## Scatter ColorShapeSize -> followed by NUMERIC Shape & Size for setting ALL / DEFAULT for missing"                                                                                                     
#>  [39] "## Scatter Stroke -> border stroke (a number, def: 2) "                                                                                                                                                  
#>  [40] "## Whisker Plot -> display as a bar & whisker plot instead of standard histogram *NOT compatible with TimeCourse* (Box / Violin / FALSE)"                                                                
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
