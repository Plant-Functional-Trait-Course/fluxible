## Internal helper: validate that user supplied a bare column name (unquoted)
#' Check that a column argument was supplied as a bare name
#'
#' This helper is internal to the package. It accepts a quosure (from
#' `rlang::enquo()`) and a parameter name and aborts with a clear message
#' when the user provided a string literal or another unsuitable value
#' instead of a bare (unquoted) column name.
#' @param arg_quo A quosure (created with `enquo(arg)`).
#' @param arg_name Character name of the argument (for error messages).
#' @keywords internal
#' @importFrom rlang quo_is_missing quo_is_symbol get_expr abort
check_bare_col <- function(arg_quo, arg_name) {
  # if the argument was not provided, nothing to check
  if (rlang::quo_is_missing(arg_quo)) {
    return(invisible(NULL))
  }

  # extract the expression behind the quosure
  expr <- rlang::get_expr(arg_quo)

  # allow bare symbol (e.g. `conc`) or numeric literals (e.g. 1)
  if (rlang::quo_is_symbol(arg_quo) || (is.atomic(expr) && is.numeric(expr))) {
    return(invisible(NULL))
  }

  # everything else is likely a quoted string or an unexpected expression
  rlang::abort(sprintf(
    "`%s` must be provided as a bare (unquoted) column name, e.g. %s not '%s'",
    arg_name,
    arg_name,
    deparse(expr)
  ))
}
