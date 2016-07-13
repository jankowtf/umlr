context("R6-class")

test_that("multiplication works", {
  library(R6)
  ClassA <- R6Class("ClassA",
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
  ClassB <- R6Class("ClassB", inherit = ClassA, public = list(x_3 = 1))
  uml <- transform("ClassA")

  uml <- transform("ClassB")

  uml_file <- umlr:::render(uml, 'Architecture',
    filename = "vignettes/uml", jarfile = "lib/plantuml.jar",
    normalize = TRUE
  )
})
