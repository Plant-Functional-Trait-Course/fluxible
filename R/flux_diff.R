#' Calculates difference between fluxes
#' @description to calculate a flux such as gross ecosystem production (GPP) or
#' transpiration (T) as the difference between other fluxes (such as
#' GPP = NEE - ER). Datetime and other variables to keep will be taken from the
#' `type1` measurement. Fluxes not used here (soilR, LRC or other) are not lost.
#' @param fluxes_df a dataframe containing fluxes
#' @param id_cols columns used to identify each pair of fluxes
#' @param f_flux column containing flux values
#' @param type_col column containing type of flux. Supply as a bare (unquoted)
#' column name (e.g. `type`), not a string; this function uses tidy-evaluation
#' with `{{ }}`.
#' @param type_a argument designating type_a fluxes in type column
#' @param type_b argument designating type_b fluxes in type column
#' @param diff_name name to give to the new calculated flux
#' @param cols_keep columns to keep from `fluxes_df`. Values from type_a row
#' will be filled in diff row. `none` (default) keeps only the columns in
#' `id_cols`, flux, type and datetime columns; `all` keeps all the columns;
#' can also be a vector of column names.
#' @return a dataframe with $diff = type_a - type_b$ in long format with diff,
#' type_a, and type_b as flux type, datetime, and any column specified in
#' `cols_keep`. Values of datetime and columns in `cols_keep` for diff row are
#' taken from type_a measurements.
#' @importFrom dplyr rename select mutate case_when filter full_join cur_group_id bind_rows
#' @importFrom tidyr pivot_wider fill
#' @importFrom purrrlyr slice_rows unslice
#' @importFrom rlang := as_label enquo
#' @examples
#' data(co2_fluxes)
#' flux_diff(co2_fluxes, type, id_cols = "turfID", cols_keep = c("temp_soil"),
#' type_a = "NEE", type_b = "ER", diff_name = "GPP")
#' @export

flux_diff <- function(fluxes_df,
                      type_col,
                      f_flux = f_flux,
                      id_cols,
                      type_a,
                      type_b,
                      diff_name,
                      cols_keep = "none") {

  name <- as_label(enquo(fluxes_df))

  check_bare_col(enquo(type_col), "type_col")
  check_bare_col(enquo(f_flux), "f_flux")

  fluxes_df_check <- fluxes_df |>
    select({{f_flux}})

  fluxes_df_ok <- flux_fun_check(fluxes_df_check,
                                 fn = list(is.numeric),
                                 msg = "has to be numeric",
                                 name_df = name)


  if (!fluxes_df_ok)
    stop("Please correct the arguments", call. = FALSE)



  if (length(cols_keep) == 1 && cols_keep == "all") {
    cols_keep <- fluxes_df |>
      select(!c(
        all_of(id_cols),
        {{type_col}},
        {{f_flux}}
      )) |>
      names()
  }

  if (length(cols_keep) == 1 && cols_keep == "none") {
    cols_keep <- c()
  }


  fluxes_df <- fluxes_df |>
    mutate(
      id = cur_group_id(),
      .by = all_of(id_cols)
    )

  a_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}}
    ) |>
    filter(
      {{type_col}} == type_a
    )

  b_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}}
    ) |>
    filter(
      {{type_col}} == type_b
    )

  other_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}}
    ) |>
    filter(
      {{type_col}} != type_b
      & {{type_col}} != type_a
    )

  fluxes_diff <- fluxes_df |>
    select(
      {{f_flux}},
      {{type_col}},
      "id"
    ) |>
    mutate(
      {{type_col}} := case_when(
        {{type_col}} == type_a ~ "type_a",
        {{type_col}} == type_b ~ "type_b"
      )
    ) |>
    filter(
      {{type_col}} == "type_a" |
        {{type_col}} == "type_b"
    )

  duplicate_check <- fluxes_diff |>
    select("id", {{type_col}}) |>
    duplicated()

  if (any(duplicate_check)) {
    stop("The id_cols provided do not form unique pairs.")
  }

  fluxes_diff <- fluxes_diff |>
    pivot_wider(id_cols = "id",
      names_from = {{type_col}},
      values_from = {{f_flux}}
    ) |>
    mutate(
      {{f_flux}} := type_a - type_b,
      {{type_col}} := diff_name
    ) |>
    select(
      "id",
      {{type_col}},
      {{f_flux}}
    )

  id_cols_df <- fluxes_df |>
    select(all_of(id_cols), "id")

  missing <- fluxes_diff |>
    filter(
      is.na({{f_flux}})
    ) |>
    select("id") |>
    left_join(id_cols_df, by = "id")

  missing[] <- Map(paste, names(missing), missing, sep = ": ")

  missing <- missing |>
    mutate(
      msg = apply(missing[, id_cols], 1, paste, collapse = ", "),
      f_warnings = paste(
        "\n", "type_a or type_b missing for measurement", .data$msg
      )
    ) |>
    pull(.data$f_warnings)

  fluxes_diff <- fluxes_diff |>
    drop_na({{f_flux}})

  fluxes_diff <- fluxes_diff |>
    bind_rows(a_df) |>
    group_by(.data$id) |>
    fill(all_of(c(cols_keep, id_cols)), .direction = "updown") |>
    ungroup() |>
    bind_rows(b_df) |>
    bind_rows(other_df) |>
    arrange(.data$id, {{type_col}}) |>
    select(!"id")

  f_warnings <- str_c(missing)


  if (any(!is.na(missing))) warning(f_warnings)

  fluxes_diff

}
