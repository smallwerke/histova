#env_dict <- new.env(parent = emptyenv(), hash = TRUE)
the <- new.env(parent = emptyenv())
fig <- new.env(parent = emptyenv())
notes <- new.env(parent = emptyenv())
raw <- new.env(parent = emptyenv())
stats <- new.env(parent = emptyenv())

#the$envList = c("stats")
the$envList = c("the", "fig", "notes", "raw", "stats")
