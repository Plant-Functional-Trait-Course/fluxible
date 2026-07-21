#' Standardizes CO2 fluxes at fixed PAR values
#' @description Calculates light response curves (LRC) for CO2 fluxes and
#' standardizes CO2 fluxes according to the LRC
#' @param fluxes_df a dataframe containing NEE, ER and LRC measurements
#' @param type_col column containing type of flux (NEE, ER, LRC). Supply as a
#' bare (unquoted) column name (e.g. `type`), not a string; this function uses
#' tidy-evaluation with `{{ }}`.
#' @param par_ave column containing the PAR value for each flux. Supply as a
#' bare (unquoted) column name (e.g. `PAR_ave`), not a string.
#' @param f_flux column containing flux values. Supply as a bare (unquoted)
#' column name (e.g. `f_flux`), not a string.
#' @param nee_arg argument designating NEE fluxes in type column
#' @param er_arg argument designating ER fluxes in type column
#' @param lrc_arg argument designating LRC fluxes in type column
#' @param lrc_group character vector of columns to use to group the LRC
#' (campaign, site, treatment), if applicable
#' @param par_nee PAR value to correct the NEE fluxes to
#' @param par_er PAR value to correct the ER fluxes to
#' @details The light response curves are calculated with a quadratic of the
#' form
#' \ifelse{html}{\out{flux(PAR) = a * PAR<sup>2</sup> + b * PAR + c}}{\eqn{flux(PAR) = a * PAR^2 + b * PAR + c}{ASCII}}
#' @return the same dataframe with the additional column `par_correction = TRUE`
#' for correct fluxes. Corrected fluxes
#' are in the same `f_flux` column. Non corrected fluxes and other fluxes are
#' kept, with NA in `par_correction`.
#' @details The long format of the output with both uncorrected and corrected
#' fluxes in the same flux column allows for easier gross primary production
#' (GPP) fluxes with \link[fluxible:flux_gpp]{flux_gpp} (`par_correction` will
#' have to be added to the argument `id_cols`).
#' @importFrom dplyr group_by_at filter rename vars select mutate left_join cross_join case_when
#' @importFrom tidyr nest unnest
#' @importFrom purrr map
#' @importFrom broom tidy
#' @importFrom tibble rowid_to_column
#' @examples
#' data(co2_fluxes_lrc)
#' flux_lrc(
#' fluxes_df = co2_fluxes_lrc,
#' type_col = type,
#' par_ave = PAR_ave,
#' f_flux = f_flux,
#' lrc_arg = "LRC",
#' nee_arg = "NEE",
#' er_arg = "ER",
#' lrc_group = c("warming"),
#' par_nee = 300,
#' par_er = 0
#' )
#' @export


flux_lrc <- function(fluxes_df,
                     type_col,
                     par_ave = par_ave,
                     f_flux = f_flux,
                     lrc_arg = "LRC",
                     nee_arg = "NEE",
                     er_arg = "ER",
                     lrc_group = c(),
                     par_nee = 300,
                     par_er = 0) {

  name <- as_label(enquo(fluxes_df))

  check_bare_col(enquo(type_col), "type_col")
  check_bare_col(enquo(par_ave), "par_ave")
  check_bare_col(enquo(f_flux), "f_flux")

  args_ok <- flux_fun_check(list(
    par_nee = par_nee,
    par_er = par_er
  ),
  fn = list(is.numeric, is.numeric),
  msg = rep("has to be numeric", 2))

  fluxes_df_check <- fluxes_df |>
    select({{par_ave}}, {{f_flux}})

  fluxes_df_ok <- flux_fun_check(fluxes_df_check,
                                 fn = list(is.numeric, is.numeric),
                                 msg = rep("has to be numeric", 2),
                                 name_df = name)

  if (any(!c(args_ok, fluxes_df_ok)))
    stop("Please correct the arguments", call. = FALSE)

  fluxes_df <- fluxes_df |>
    rowid_to_column("rowid") # to keep the user's row order

  coefficients_lrc <- fluxes_df |>
    filter(
      {{type_col}} == ((lrc_arg))
    ) |>
    rename(
      PARavg = {{par_ave}},
      f_flux = {{f_flux}}
    ) |>
    group_by_at(vars(all_of(((lrc_group))))) |>
    nest() |>
    mutate(
      lm = map(data, ~ lm(f_flux ~ PARavg + I(PARavg^2), data = .x)),
      table = map(lm, tidy),
      table = map(table, select, "term", "estimate"),
      table = map(
        table, pivot_wider, names_from = "term", values_from = "estimate"
      )
    ) |>
    unnest(table) |>
    select(all_of(lrc_group), "PARavg", "I(PARavg^2)") |>
    rename(
      a = "I(PARavg^2)",
      b = "PARavg"
    )

  flux_corrected_par <- fluxes_df |>
    filter(
      {{type_col}} %in% c("NEE", "ER")
    )

  if (is.null(lrc_group)) {
    flux_corrected_par <- flux_corrected_par |>
      cross_join(coefficients_lrc)
  }

  if (!is.null(lrc_group)) {
    flux_corrected_par <- flux_corrected_par |>
      left_join(coefficients_lrc)
  }

  flux_corrected_par <- flux_corrected_par |>
    mutate(
      {{f_flux}} :=
        case_when( # NEE correction
          type == "NEE" ~
            {{f_flux}} +
              a * (par_nee^2 - {{par_ave}}^2) +
              b * (par_nee - {{par_ave}}),
          type == "ER" ~ # ER correction
            {{f_flux}} +
              a * (par_er^2 - {{par_ave}}^2) +
              b * (par_er - {{par_ave}})
        ),
      par_correction = TRUE
    ) |>
    bind_rows(fluxes_df) |>
    arrange(.data$rowid) |>
    select(!c("a", "b", "rowid"))

  flux_corrected_par
}
