#' Send Temp Queries with Mac
#'
#' Used to run temp table aka "volatile table" queries from R. \cr
#' Step 1: Use send_temp_mac() to send temp queries to teradata. \cr
#' Step 2: Query your temp table(s) using odbc::dbGetQuery() as normal.
#'
#' @param teradata_connection
#'
#'  A teradata connection created by `odbc::dbConnect()`
#' @param query A string containing one or multiple temp queries
#'
#' @return
#' @export
#'
#' @examples
#' # Establish connection to teradata
#' td_con <- dbConnect(odbc::odbc(), "TDXMXF129_64")
#'
#' # Temp query
#' temp_query <- "CREATE VOLATILE MULTISET TABLE origination_df AS (
#' 	 SELECT top 100 *
#' 	 FROM DLFIN_FA.monthly_sales_t
#'  )
#' WITH DATA PRIMARY INDEX(level_1, level_2, level_3, fiscper) ON  COMMIT  PRESERVE ROWS;
#'
#' ---- Fulfillment data
#' CREATE VOLATILE MULTISET TABLE fulfillment_df AS (
#' 	 SELECT top 100 *
#' 	 FROM DLFIN_FA.monthly_sales_t
#'  )
#' WITH DATA PRIMARY INDEX(level_1, level_2, level_3, fiscper) ON  COMMIT  PRESERVE ROWS;"
#'
#' # Send the temp queries
#' send_temp(td_con, temp_query)
#'
#' # Run final query
#' final_query <- "select top 100 *
#' from TDXMXF129.origination_df"
#' sales_df <- odbc::dbGetQuery(td_con, final_query) %>% as_tibble()
send_temp_mac <- function(teradata_connection, temp_query) {
  if (stringr::str_detect(temp_query, "COLLECT STATS") == TRUE) {
    rlang::abort("Temp queries cannot contain COLLECT STATS when using R")
  }

  if (stringr::str_detect(temp_query, ";") == FALSE) {
    rlang::abort("Did you place semicolons in the proper place(s)?")
  }

  invisible(
    temp_query %>%
      stringr::str_split(";") %>%
      purrr::pluck(1) %>%
      purrr::map(~stringr::str_c(.x, ";")) %>%
      purrr::map(~RJDBC::dbSendUpdate(teradata_connection, .x))
  )
}
