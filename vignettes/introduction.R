## ---- include = FALSE----------------------------------------------------
run <- FALSE
root_dir <- paste(rep("../", 1), collapse = "")
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)
knitr::opts_knit$set(root.dir = root_dir)

## ----echo=FALSE----------------------------------------------------------
umlr_uml <- '
  @startuml
  ICrud *-- Crud: implements <
  Crud <|-- Crud.Settings: extends <

  class ICrud {
    +init()
    +has()
    +create()
    +read()
    +update()
    +delete()
    +reset()
    -stopIfInterface()
  }
  class Crud {
    +main: environment
    -initial_state: list
    -stopIfEmpty()
    -createMessage(),
    -cacheInitialState()
  }
  class Crud.Settings {
    +main: function
    -cacheInitialState()
  }
  @enduml
'
# knitr::opts_knit$set(root.dir = root_dir)
uml_file <- umlr:::renderUml(
  umlr_uml, 'Architecture', 
  filename = "vignettes/uml",
  jarfile = "lib/plantuml.jar",
  normalize = TRUE
)
# print(uml_file)
# uml_file <- normalizePath(uml_file)
# print(uml_file)
# print(getwd())
# knitr::opts_knit$set(root.dir = getwd())

