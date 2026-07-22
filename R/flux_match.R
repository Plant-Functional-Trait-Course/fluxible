#' Matching continuously measured fluxes with measurement IDs and meta data
#' @description Matching a dataframe of continuously measured
#' gas concentration data with measurement metadata from another dataframe.
#' Measurements are paired with their metadata based on datetime.
#' Extra variables in both dataframes are kept in the output.
#' @param raw_conc dataframe of CO2 concentration measured continuously.
#' Has to contain at least a datetime column in ymd_hms format and
#' a gas concentration column as double.
#' @param field_record dataframe recording which measurement happened when.
#' Has to contain at least a column containing the start of each measurement,
#' and any other column identifying the measurements.
#' @param measurement_length length of the measurements (in seconds)
#' from the start specified in the `field_record`. Use `measurement_length` if
#' all the measurements have the same length and no end column is present in
#' `field_record`.
#' @param time_diff time difference (in seconds) between the two datasets.
#' Will be added to the datetime column of the `raw_conc` dataset.
#' For situations where the time was not synchronized correctly.
#' @param f_datetime datetime column in raw_conc (`ymd_hms` format). Supply as
#' a bare (unquoted) column name (e.g. `datetime`), not a string.
#' @param start_col start column in field_record (`ymd_hms` format). Supply as
#' a bare (unquoted) column name (e.g. `start`), not a string.
#' @param end_col end column in field_record (`ymd_hms` format), if present
#' (see `measurement_length`). Supply as a bare (unquoted) column name (e.g.
#' `end`), not a string.
#' @return a dataframe with concentration measurements, corresponding datetime,
#' flux ID (`f_fluxid`), measurements start (`f_start`) and end (`f_end`).
#' @details If both `end_col` and `measurement_length` are provided, `end_col`
#' will be ignored. Measurements either all have the same length (provide
#' `measurement_length`), or the length varies and `end_col` has to be provided.
#' @importFrom dplyr arrange mutate row_number full_join case_when group_by filter ungroup select distinct pull join_by coalesce
#' @importFrom tidyr fill drop_na
#' @importFrom lubridate is.POSIXct
#' @importFrom rlang as_label enquo
#' @importFrom lifecycle is_present
#' @examples
#' data(co2_df_short, record_short)
#' flux_match(co2_df_short, record_short, datetime, start,
#' measurement_length = 180)
#' @export


flux_match <- function(raw_conc,
                       field_record,
                       f_datetime,
                       start_col,
                       end_col,
                       measurement_length,
                       time_diff = 0) {

  name_raw_conc <- as_label(enquo(raw_conc))
  name_field_record <- as_label(enquo(field_record))

  check_bare_col(enquo(f_datetime), "f_datetime")
  check_bare_col(enquo(start_col), "start_col")
  check_bare_col(enquo(end_col), "end_col")

  args_ok <- flux_fun_check(
    list(time_diff = time_diff),
    fn = list(is.numeric),
    msg = "has to be numeric"
  )

  raw_conc_check <- raw_conc |>
    select({{f_datetime}})

  field_record_check <- field_record |>
    select({{start_col}})

  raw_conc_ok <- flux_fun_check(raw_conc_check,
                                fn = list(is.POSIXct),
                                msg = "has to be POSIXct",
                                name_df = name_raw_conc)

  field_record_ok <- flux_fun_check(field_record_check,
                                    fn = list(is.POSIXct),
                                    msg = "has to be POSIXct",
                                    name_df = name_field_record)

  if (any(!c(args_ok, raw_conc_ok, field_record_ok)))
    stop("Please correct the arguments", call. = FALSE)

  # test if cols in field_record and raw_conc are different
  colnames_raw_conc <- names(raw_conc)
  colnames_field_record <- names(field_record)

  colnames_test <- colnames_raw_conc %in% colnames_field_record

  if (any(colnames_test)) {
    stop("raw_conc and field_record must have different column names")
  }


  field_record <- field_record |>
    arrange({{start_col}}) |>
    mutate(
      f_start = {{start_col}},
      f_fluxid = row_number()
    )

  if (is_present(measurement_length)) {

    field_record <- flux_match_fixed(
      field_record,
      {{start_col}},
      measurement_length = measurement_length
    )
  }


  if (!is_present(measurement_length)) {

    field_record <- flux_match_col(
      field_record,
      {{start_col}},
      {{end_col}},
      name_field_record = name_field_record
    )
  }


  raw_conc <- raw_conc |>
    mutate(
      {{f_datetime}} := {{f_datetime}} + time_diff
    )


  conc_df <- full_join(
    raw_conc, field_record,
    by = join_by({{f_datetime}} == "f_start"), keep = TRUE
  ) |>
    mutate(
      {{f_datetime}} := coalesce({{f_datetime}}, .data$f_start)
    ) |>
    arrange({{f_datetime}}) |>
    fill("f_fluxid") |>
    drop_na("f_fluxid")

  conc_df <- conc_df |>
    group_by(.data$f_fluxid) |>
    fill(names(field_record)) |>
    filter(
      ({{f_datetime}} < .data$f_end &
         {{f_datetime}} >= .data$f_start)
    ) |>
    ungroup()

  conc_df <- conc_df |>
    mutate(
      f_fluxid = as.factor(.data$f_fluxid),
    ) |>
    arrange(.data$f_fluxid)

  conc_df
}
