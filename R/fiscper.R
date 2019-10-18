#' Fiscper functions
#'
#' Extract info from fiscper
#'
#' @param fiscper
#'
#' Column containing the fiscper
#'
#' @return
#' @export
#'
#' @examples
#' # Extract info from fiscper
#' your_df %>%
#'   mutate(year = fiscper_year(fiscper),
#'          month = fiscper_month(fiscper),
#'          quarter = fiscper_quarter(fiscper),
#'          semester = fiscper_semester(fiscper),
#'          work_days = fiscper_workdays(fiscper),
#'          date = fiscper_date(fiscper))
#'
#' # Create fiscper from year & month columns
#' your_df %>%
#'   mutate(make_fiscper(year, month))
fiscper_year <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  as.numeric(stringr::str_sub(fiscper, 1, 4))
}


#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_month <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  as.numeric(stringr::str_sub(fiscper, 6, 7))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_date <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::make_date(graingr::fiscper_year(fiscper),
                       graingr::fiscper_month(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_quarter <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::quarter(fiscper_date(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_semester <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::semester(fiscper_date(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_workdays <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  purrr::map_dbl(fiscper, ~graingr::work_days_df[graingr::work_days_df$fiscper == .x,]$work_days)

}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
make_fiscper <- function(year, month) {
  if (any(nchar(year) != 4)) {
    rlang::abort("Year must be 4 digits")
  }

  if (any(nchar(month) == 0) | any(nchar(month) > 2)) {
    rlang::abort("Month must be one or two digits")
  }

  year <- as.numeric(year)
  month <- as.numeric(month)

  as.numeric(
    ifelse(nchar(month) == 2,
           stringr::str_c(year, "0", month),
           stringr::str_c(year, "00", month))
  )
}


