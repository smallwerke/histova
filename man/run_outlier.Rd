% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_outlier.R
\name{run_outlier}
\alias{run_outlier}
\title{Run Outlier}
\usage{
run_outlier()
}
\description{
Remove any outliers, if requested. DEPENDS on already having loaded data into the environment
to function as it operates on saved environment variables. The histova function load_data() should
load the needed data. The configuration file can specify if one or two tailed outlier checking
should be performed. Only the most extreme outlier will be removed in the current configuration.
}
