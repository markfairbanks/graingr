#' Class accuracy
#'
#' `class_accuracy()` provides common classification metrics to convey results
#' business users will understand.
#'
#' @param df tibble
#'
#'   A data frame containing the truth and prediction columns
#'
#' @param truth factor
#'
#'   A column identifier for the true class results (that is a factor).
#'   This should be an unquoted column name.
#'
#' @param pred factor
#'
#'   A column identifier for the predicted class results (that is also a factor).
#'   This should be an unquoted column name.
#'
#' @param pos_flag numeric/factor
#'
#'  A numeric or string indicating the "positive" class.
#'
#' @return A tibble
#' @export
#'
#' @examples
class_accuracy <- function(df, truth, pred, pos_flag = 1) {

  pos_flag <- as.character(pos_flag)

  dplyr::tibble(true_positive = MLmetrics::Recall(df %>% dplyr::pull({{truth}}),
                                                  df %>% dplyr::pull({{pred}}),
                                                  positive = pos_flag),
                false_positive = 1-MLmetrics::Specificity(df %>% dplyr::pull({{truth}}),
                                                          df %>% dplyr::pull({{pred}}),
                                                          positive = pos_flag),
                precision = MLmetrics::Precision(df %>% dplyr::pull({{truth}}),
                                                 df %>% dplyr::pull({{pred}}),
                                                 positive = pos_flag),
                accuracy = MLmetrics::Accuracy(df %>% dplyr::pull({{truth}}),
                                               df %>% dplyr::pull({{pred}}))) %>%
    round(4) %>%
    tibble::add_column(model = rlang::quo({{pred}}) %>% rlang::as_label(), .before = 1)
}
