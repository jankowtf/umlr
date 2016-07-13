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
renderUml <- function(
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
  out
}
