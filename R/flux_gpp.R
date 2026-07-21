#' Calculates GPP
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' See the more generic \link[fluxible:flux_diff]{flux_diff}
#'
#' to calculate gross primary production (GPP) from net ecosystem
#' (NEE) exchange and ecosystem respiration (ER) as GPP = NEE - ER.
#' Datetime and other variables to keep will be taken from the NEE measurement.
#' Fluxes presents in the dataset that are neither NEE nor ER
#' (soilR, LRC or other) are not lost.
#' @param fluxes_df a dataframe containing NEE and ER
#' @param id_cols columns used to identify each pair of ER and NEE
#' @param f_flux column containing flux values
#' @param type_col column containing type of flux (NEE or ER). Supply as a bare
#' (unquoted) column name (e.g. `type`), not a string; this function uses
#' tidy-evaluation with `{{ }}`.
#' @param f_datetime column containing start of measurement as datetime. Supply
#' as a bare (unquoted) column name (e.g. `f_datetime`), not a string.
#' @param nee_arg argument designating NEE fluxes in type column
#' @param er_arg argument designating ER fluxes in type column
#' @param cols_keep columns to keep from `fluxes_df`. Values from NEE row will
#' be filled in GPP row. `none` (default) keeps only the columns in `id_cols`,
#' flux, type and datetime columns; `all` keeps all the columns;
#' can also be a vector of column names.
#' @return a dataframe with $GPP = NEE - ER$ in long format with GPP, NEE, and
#' ER as flux type, datetime, and any column specified in `cols_keep`.
#' Values of datetime and columns in `cols_keep` for GPP row are taken from
#' NEE measurements.
#' @importFrom dplyr rename select mutate case_when filter full_join cur_group_id bind_rows
#' @importFrom tidyr pivot_wider fill
#' @importFrom purrrlyr slice_rows unslice
#' @examples
#' data(co2_fluxes)
#' flux_gpp(co2_fluxes, type, f_start, id_cols = "turfID",
#' cols_keep = c("temp_soil"))
#' @export

flux_gpp <- function(fluxes_df,
                     type_col,
                     f_datetime,
                     f_flux = f_flux,
                     id_cols,
                     nee_arg = "NEE",
                     er_arg = "ER",
                     cols_keep = "none") {

  name <- as_label(enquo(fluxes_df))

  check_bare_col(enquo(type_col), "type_col")
  check_bare_col(enquo(f_datetime), "f_datetime")
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
        {{f_flux}},
        {{f_datetime}}
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

  nee_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}},
      {{f_datetime}}
    ) |>
    filter(
      {{type_col}} == nee_arg
    )

  er_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}},
      {{f_datetime}}
    ) |>
    filter(
      {{type_col}} == er_arg
    )

  other_df <- fluxes_df |>
    select(
      "id",
      all_of(c(cols_keep, id_cols)),
      {{type_col}},
      {{f_flux}},
      {{f_datetime}}
    ) |>
    filter(
      {{type_col}} != er_arg
      & {{type_col}} != nee_arg
    )

  fluxes_gpp <- fluxes_df |>
    select(
      {{f_flux}},
      {{type_col}},
      {{f_datetime}},
      "id"
    ) |>
    mutate(
      type = case_when(
        .data$type == nee_arg ~ "NEE",
        .data$type == er_arg ~ "ER"
      )
    ) |>
    filter(
      .data$type == "NEE" |
        .data$type == "ER"
    )

  duplicate_check <- fluxes_gpp |>
    select("id", {{type_col}}) |>
    duplicated()

  if (any(duplicate_check)) {
    stop("The id_cols provided do not form unique pairs of ER and NEE.")
  }

  fluxes_gpp <- fluxes_gpp |>
    rename(
      f_flux = {{f_flux}},
      f_datetime = {{f_datetime}}
    ) |>
    pivot_wider(id_cols = "id",
      names_from = {{type_col}},
      values_from = c("f_flux", "f_datetime")
    ) |>
    rename(
      {{f_datetime}} := "f_datetime_NEE"
    ) |>
    mutate(
      {{f_flux}} := .data$f_flux_NEE - .data$f_flux_ER,
      {{type_col}} := "GPP"
    ) |>
    select(
      {{f_datetime}},
      "id",
      {{type_col}},
      {{f_flux}}
    )

  id_cols_df <- fluxes_df |>
    select(all_of(id_cols), "id")

  nee_missing <- fluxes_gpp |>
    filter(
      is.na({{f_datetime}})
    ) |>
    select("id") |>
    left_join(id_cols_df, by = "id")

  nee_missing[] <- Map(paste, names(nee_missing), nee_missing, sep = ": ")

  nee_missing <- nee_missing |>
    mutate(
      msg = apply(nee_missing[, id_cols], 1, paste, collapse = ", "),
      f_warnings = paste(
        "\n", "NEE missing for measurement", .data$msg
      )
    ) |>
    pull(.data$f_warnings)

  fluxes_gpp <- fluxes_gpp |>
    drop_na({{f_datetime}})

  fluxes_gpp <- fluxes_gpp |>
    bind_rows(nee_df) |>
    group_by(.data$id) |>
    fill(all_of(c(cols_keep, id_cols)), .direction = "updown") |>
    ungroup() |>
    bind_rows(er_df) |>
    bind_rows(other_df) |>
    select(!"id") |>
    arrange({{f_datetime}})

  f_warnings <- str_c(nee_missing)


  if (any(!is.na(nee_missing))) warning(f_warnings)

  fluxes_gpp

}
