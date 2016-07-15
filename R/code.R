# plantuml <- function(uml, text, as_is = TRUE) {
#   filename <- tempfile()
#   uml_filename <- paste0(filename, ".uml")
#   write(uml, uml_filename)
#   system2("java", paste0(" -jar plantuml.jar ", uml_filename))
#
#   if (as_is) {
#     path <- paste0('![', text, '](', paste0(filename, '.png)'))
#     cat(path)
#   } else {
#     path <- paste0('![', text, '](', normalizePath(
#       paste0(filename, '.png)'), winslash = "/"))
#     path
#   }
# }

# #' @importFrom png readPNG
# #' @importFrom grid grid.raster
# plantuml2 <- function(uml, text, ...) {
#   filename <- tempfile()
#   uml_filename <- paste0(filename, ".uml")
#
#   write(uml, uml_filename)
#   system2("java", paste0(" -jar plantuml.jar ", uml_filename))
#   library(png)
#   library(grid)
#   img <- png::readPNG(paste0(filename, '.png'))
#   grid::grid.raster(img, ...)
# }

#' @export
render <- function(
  uml,
  text,
  filename = tempfile(),
  jarfile = "lib/plantuml.jar",
  normalize = FALSE
) {
  uml_filename <- paste0(filename, ".uml")
  write(uml, uml_filename)
  # system2("java", paste0(" -jar plantuml.jar ", uml_filename))
  system2("java", paste0(" -jar ", jarfile, " ", uml_filename))
  # normalizePath(paste0(filename, ".png"), winslash = "/")
  out <- paste0(filename, ".png")
  if (normalize) {
    out <- normalizePath(out)
  }

  # library(png)
  # library(grid)
  #   img <- png::readPNG(out)
  #   grid::grid.raster(img, ...)
  #
  out
}

#' @export
transformCore <- function(classname, where = parent.frame()) {
  if (exists(classname, envir = where, inherits = FALSE)) {
    obj <- get(classname, envir = where, inherits = FALSE)
    attr <- ls(obj)

    value_list <- NULL

    what <- c(
      "public_fields",
      "public_methods",
      "private_fields",
      "private_methods"
    )
    value_list <- unlist(lapply(what, function(ii) {
      what <- ii
      if (what %in% attr) {
        symbol <- if (grepl("public_", what)) {
          "+"
        } else if (grepl("private_", what)) {
          "-"
        }

        if (grepl("_fields$", what)) {
          value <- sapply(obj[[what]], class)
          value <- sprintf("%s%s: %s", symbol, names(value), value)
        } else if (grepl("_methods$", what)) {
          value <- sapply(obj[[what]], class)
          value <- sprintf("%s%s()", symbol, names(value))
        }
      }
    }))
    c(
      sprintf("class %s {", classname),
      paste(value_list, collapse = "\n"),
      "}"
    )
  }
}

#' @export
transform <- function(classname, where = parent.frame()) {
  if (exists(classname, envir = where, inherits = FALSE)) {
    obj <- get(classname, envir = where, inherits = FALSE)
    if (inherits(obj, "R6ClassGenerator")) {
      attr <- ls(obj)

      meta_list <- NULL
      value_list <- NULL

      what <- "inherit"
      if (what %in% attr) {
        super <- as.character(obj[[what]])
        meta_list <- c(meta_list, sprintf("%s <|-- %s: extends <", super, classname))
        value <- transformCore(super, where = where)
      }
      value_list <- c(value_list, value)

      value <- transformCore(classname, where = where)
      value_list <- c(value_list, value)

      out <- c(
        "@startuml",
        meta_list,
        value_list,
        "@enduml"
      )
      out
    }
  }
}
