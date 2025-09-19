#' Plotting fluxes for visual evaluation
#' @description Plots the fluxes, fit and slope in facets
#' with color code indicating quality flags
#' This function takes time to run and is optional in the workflow,
#' but it is still highly recommended to use it to visually check
#' the measurements. Note that 'flux_plot' is specific to the
#' \link[fluxible]{fluxible} package and
#' will work best with datasets produced following a fluxible workflow.
#' @param slopes_df dataset containing slopes,
#' with flags produced by \link[fluxible:flux_quality]{flux_quality}
#' @param f_conc column with gas concentration
#' @param f_datetime column with datetime of each data point
#' @param color_discard color for fits with a discard quality flag
#' @param color_cut color for the part of the flux that is cut
#' @param color_ok color for fits with an ok quality flag
#' @param color_zero color for fits with a zero quality flag
#' @param scale_x_datetime_args list of arguments for
#' \link[ggplot2:scale_x_datetime]{scale_x_datetime}
#' @param f_ylim_upper y axis upper limit
#' @param f_ylim_lower y axis lower limit
#' @param f_plotname filename for the extracted pdf file;
#' if empty, the name of `slopes_df` will be used
#' @param facet_wrap_args list of arguments for
#' \link[ggplot2:facet_wrap]{facet_wrap}, also used by
#' \link[ggforce:facet_wrap_paginate]{facet_wrap_paginate} in case
#' `output = "pdfpages`
#' @param y_text_position position of the text box
#' @param print_plot logical, if TRUE it prints the plot as a ggplot object
#' but will take time depending on the size of the dataset
#' @param output `"pdfpages"`, the plots are saved as A4 landscape pdf pages;
#' `"ggsave"`, the plots can be saved with the ggsave function;
#' `"print_only"` (default) prints the plot without creating a file
#' (independently from `print_plot` being TRUE or FALSE);
#' `"longpdf"`, the plots are saved as a pdf file as long as needed (faster than
#' `"pdfpages"`)
#' @param ggsave_args list of arguments for \link[ggplot2:ggsave]{ggsave}
#' (in case `output = "ggsave"`)
#' @param f_facetid character vector of columns to use as facet IDs. Note that
#' they will be united, and that has to result in a unique facet ID for each
#' measurement. Default is `f_fluxid`
#' @param longpdf_args arguments for longpdf in the form
#' `list(ncol, width (in cm), ratio)`
#' @return plots of fluxes, with raw concentration data points, fit, slope,
#' and color code indicating quality flags and cuts. The plots are organized
#' in facets according to flux ID, and a text box display the quality flag and
#' diagnostics of each measurement.
#' The plots are returned as a ggplot object if `print_plot = TRUE`;
#' if `print_plot = FALSE` it will not return anything but will produce a file
#' according to the `output` argument.
#' @details `output = "pdfpages"` uses
#' \link[ggforce:facet_wrap_paginate]{facet_wrap_paginate}, which tends to be
#' slow and heavy. With `output = "longpdf`, a long single page pdf is exported.
#' Default width is 29.7 cm (A4 landscape) and is will be as long as it needs
#' to be to fit all the facets. The arguments `ncol` and `ratio` in
#' `longpdf_args` specify the number of columns and the ratio of the facet
#' respectively. This method is considerably faster than `pdfpages`, because
#' it bypasses `facet_wrap_paginate`, but is a bit less aesthetic.
#' @importFrom dplyr select distinct mutate n_distinct
#' @importFrom ggplot2 ggplot aes geom_point geom_line scale_color_manual
#' scale_x_datetime ylim facet_wrap labs geom_text theme_bw ggsave
#' scale_linetype_manual guides guide_legend geom_vline
#' @importFrom purrr quietly
#' @importFrom stringr str_detect
#' @importFrom tidyr unite
#' @importFrom forcats fct_reorder
#' @examples
#' data(co2_conc)
#' slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#' slopes_flag <- flux_quality(slopes, conc)
#' flux_plot(slopes_flag, conc, datetime)
#' @export

flux_plot <- function(slopes_df,
                      f_conc = f_conc,
                      f_datetime = f_datetime,
                      color_discard = "#D55E00",
                      color_cut = "#D55E00",
                      color_ok = "#009E73",
                      color_zero = "#CC79A7",
                      scale_x_datetime_args = list(
                        date_breaks = "1 min",
                        minor_breaks = "10 sec",
                        date_labels = "%e/%m \n %H:%M"
                      ),
                      f_ylim_upper = 800,
                      f_ylim_lower = 400,
                      f_plotname = "",
                      f_facetid = "f_fluxid",
                      facet_wrap_args = list(
                        ncol = 4,
                        nrow = 3,
                        scales = "free"
                      ),
                      longpdf_args = list(
                        ncol = 4,
                        width = 29.7,
                        ratio = 1
                      ),
                      y_text_position = 500,
                      print_plot = "FALSE",
                      output = "print_only",
                      ggsave_args = list()) {

  # fortify data
  slopes_params <- flux_fortify(
    slopes_df = slopes_df,
    f_conc = {{f_conc}},
    f_datetime = {{f_datetime}},
    f_ylim_upper = f_ylim_upper,
    f_ylim_lower = f_ylim_lower,
    f_facetid = f_facetid,
    y_text_position = y_text_position
  )
  slopes_df <- slopes_params$slopes_df

  # prepare for plotting
  output <- match.arg(output, c("pdfpages", "ggsave", "print_only", "longpdf"))

  if (output == "print_only") {
    print_plot <- "TRUE"
  }

  if (f_plotname == "") {
    f_plotname <- as_label(enquo(slopes_df))
  }

  if (output %in% c("pdfpages", "ggsave", "longpdf")) {
    f_plotname <- paste("f_quality_plots/", f_plotname, sep = "")
    folder <- "./f_quality_plots"
    if (!file.exists(folder)) {
      dir.create(folder)
    }
  }

  # build plot
  f_plot <- slopes_df |>
    ggplot(aes({{f_datetime}}))

  if (any(names(slopes_df) == "f_start_z")) {

    f_plot <- f_plot +
      geom_vline(
        mapping = aes(xintercept = .data$f_start_z),
        data = distinct(slopes_df, .data$f_facetid, .keep_all = TRUE),
        color = "grey",
        linewidth = 0.5
      )
  }

  f_plot <- f_plot +
    geom_point(aes(y = {{f_conc}}, color = .data$f_quality_flag),
      size = 0.4,
      na.rm = TRUE
    ) +
    geom_text(
      data = slopes_params$param_df,
      aes(
        x = .data$f_start, y = y_text_position,
        label = .data$print_col
      ),
      vjust = 0, hjust = "inward",
      na.rm = TRUE
    ) +
    geom_line(
      aes(y = .data$f_fit, linetype = .data$linetype),
      data = slopes_params$fits_df,
      linewidth = 0.5,
      na.rm = TRUE,
      show.legend = TRUE
    ) +
    scale_color_manual(values = c(
      "cut" = color_cut,
      "ok" = color_ok,
      "discard" = color_discard,
      "zero" = color_zero,
      "start_error" = color_discard,
      "force_discard" = color_discard,
      "force_lm" = color_ok,
      "force_ok" = color_ok,
      "force_zero" = color_zero,
      "no_slope" = color_discard
    )) +
    scale_linetype_manual(values = c(
      "f_fit" = "longdash",
      "f_fit_slope" = "solid",
      "f_fit_lm" = "dotted"
    )) +
    do.call(scale_x_datetime, args = scale_x_datetime_args) +
    ylim(f_ylim_lower, f_ylim_upper) +
    labs(
      title = "Fluxes quality assessment",
      subtitle = paste(slopes_params$fit_type, "model"),
      x = "Datetime",
      y = "Concentration",
      colour = "Quality flags",
      linetype = "Fits"
    ) +
    guides(color = guide_legend(override.aes = list(linetype = 0, size = 3))) +
    theme_bw()

  message("Plotting in progress")

  # select plotting engine
  switch(
    output,
    pdfpages = flux_plot_pdf(
      f_plot, f_plotname, facet_wrap_args, slopes_params$nb_fluxid
    ),
    longpdf = flux_plot_longpdf(
      f_plot, f_plotname, slopes_params$nb_fluxid, longpdf_args
    ),
    ggsave = {
      message("Saving plots with ggsave.")
      f_plot <- flux_print_plot(f_plot, facet_wrap_args)
      do.call(
        ggsave,
        args = c(filename = f_plotname, ggsave_args)
      )

      message("Plots saved in f_quality_plots folder.")
      if (print_plot) {
        return(f_plot)
      }
    }
  )

  if (print_plot) {
    f_plot <- flux_print_plot(f_plot, facet_wrap_args)
    return(f_plot)
  }

}
