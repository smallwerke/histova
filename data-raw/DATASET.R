## code to prepare `DATASET` dataset goes here

f = "test-1_group-basic_no_stats.txt"
d = str_remove(histova_example(f), paste0("/", f))
generate_figure(d,f, FALSE, FALSE)

test.1Group.Basic.NoStats = the$gplot
# print(the$gplot) # check the output (printing OR saving it changes the gplot rda)

usethis::use_data(test.1Group.Basic.NoStats, internal = TRUE, overwrite = TRUE)
