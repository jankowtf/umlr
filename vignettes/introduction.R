## ---- include = FALSE----------------------------------------------------
library(umlr)
run <- FALSE
root_dir <- paste(rep("../", 1), collapse = "")
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)
knitr::opts_knit$set(root.dir = root_dir)

## ------------------------------------------------------------------------
library(R6)
ClassA <- R6::R6Class("ClassA",
  public = list(
    x_1 = letters,
    x_2 = TRUE,
    foo = function() {
      "foo"
    }
  ),
  private = list(
    .x_1 = LETTERS,
    .x_2 = FALSE,
    .foo = function() {
      ".foo"
    }
  )
)
ClassB <- R6::R6Class("ClassB", inherit = ClassA, public = list(x_3 = 1))

## ------------------------------------------------------------------------
uml <- umlr::transform("ClassB")

uml_file <- umlr:::render(uml, 'Architecture',
  filename = "vignettes/uml", jarfile = "lib/plantuml.jar",
  normalize = TRUE
)

