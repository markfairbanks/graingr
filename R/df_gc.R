#' Dataframe gc()
#'
#' Run gc in the middle of a long pipe chain
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
#' df %>%
#'   df_gc() %>%
#'   select(col1, col2)
df_gc <- function(df) {
  invisible(gc())
  return(df)
}
