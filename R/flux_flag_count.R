#' Counts quality flags
#' @description Provides a table of how many fluxes were attributed
#' which quality flag. This function is incorporated in
#' \link[fluxible]{flux_quality} as a message, but can be used alone to extract
#' a dataframe with the flag count.
#' @param flags_df dataframe of flux slopes
#' @param f_flags list of flags used in the dataset
#' (if different from default from flux_quality).
#' If not provided, it will list only the flags that are
#' present in the dataset (no showing 0).
#' @param f_fluxid column containing fluxes unique ID. Supply as a bare (unquoted)
#' column name (e.g. `f_fluxid`), not a string; this function uses tidy-evaluation
#' with `{{ }}`.
#' @param f_quality_flag column containing the quality flags. Supply as a bare
#' (unquoted) column name (e.g. `f_quality_flag`), not a string; this function
#' uses tidy-evaluation with `{{ }}`.
#' @return a dataframe with the number of fluxes for each quality flags
#' and their proportion to the total
#' @param show_total logical, if TRUE (default), adds a row with the total
#' number of fluxes
#' @importFrom dplyr all_of select group_by summarise tibble right_join filter distinct arrange desc
#' @importFrom tidyr replace_na
#' @author Vincent Belde
#' @examples
#' data(co2_conc)
#' slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#' slopes_flag <- flux_quality(slopes, conc)
#' flux_flag_count(slopes_flag)
#' @export


flux_flag_count <- function(flags_df,
                            f_fluxid = f_fluxid,
                            f_quality_flag = f_quality_flag,
                            f_flags = c(
                              "ok",
                              "discard",
                              "zero",
                              "force_discard",
                              "start_error",
                              "no_data",
                              "force_ok",
                              "force_zero",
                              "force_lm",
                              "no_slope"
                            ),
                            show_total = TRUE) {

  check_bare_col(enquo(f_fluxid), "f_fluxid")
  check_bare_col(enquo(f_quality_flag), "f_quality_flag")

  flag_df <- flags_df |>
    mutate(
      f_quality_flag = as.factor({{f_quality_flag}})
    ) |>
    select({{f_fluxid}}, {{f_quality_flag}}) |>
    distinct()

  if (show_total) {
    f_flags <- c(f_flags, "total")
  }

  flags <- tibble({{f_quality_flag}} := factor(f_flags))

  count_table <- flag_df |>
    summarise(
      n = length({{f_quality_flag}}),
      .by = {{f_quality_flag}}
    ) |>
    right_join(flags, by = join_by({{f_quality_flag}})) |>
    mutate(
      n = case_when(
        f_quality_flag == "total" ~ sum(.data$n, na.rm = TRUE),
        .default = replace_na(.data$n, 0)
      ),
      ratio = .data$n / sum(.data$n[!.data$f_quality_flag == "total"])
    ) |>
    arrange(desc(.data$n))

  count_table
}
