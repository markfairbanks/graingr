#' Run invisible garbage collection
#'
#' Run garbage collection without the typical output.
#'
#' @return
#' @export
#'
#' @examples
#' inv_gc()
inv_gc <- function() {
  invisible(gc())
}
