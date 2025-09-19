#' print plots in a single long pdf
#' @param f_plot plot from flux_plots
#' @param nb_fluxid number of facets
#' @param f_plotname name of plot
#' @param longpdf_args arguments for longpdf in the form
#' `list(ncol, width (in cm), ratio)`
#' @importFrom ggplot2 ggsave
#' @keywords internal

flux_plot_longpdf <- function(f_plot,
  f_plotname,
  nb_fluxid,
  longpdf_args
) {
  f_plotname <- paste(f_plotname, ".pdf", sep = "")


  f_ncol <- longpdf_args$ncol
  width <- longpdf_args$width
  ratio <- longpdf_args$ratio

  f_plot <- f_plot +
    facet_wrap(~f_facetid, ncol = f_ncol, scales = "free")

  f_height <- (((width) / f_ncol)
               * ceiling((nb_fluxid / f_ncol)) / ratio)

  message("Starting ggsave...")

  ggsave(
    f_plotname,
    plot = f_plot,
    width = width,
    height = f_height,
    units = "cm",
    limitsize = FALSE
  )

  message("Plots saved in f_quality_plots folder.")
}
