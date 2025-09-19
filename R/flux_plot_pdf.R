#' print plots in pdf
#' @param f_plot plot from flux_plot
#' @param nb_fluxid number of facets
#' @param facet_wrap_args list of arguments for
#' \link[ggforce:facet_wrap_paginate]{facet_wrap_paginate}
#' @param f_plotname name of plot
#' @importFrom ggforce facet_wrap_paginate
#' @importFrom progress progress_bar
#' @importFrom grDevices pdf dev.off
#' @keywords internal

flux_plot_pdf <- function(f_plot,
  f_plotname,
  facet_wrap_args,
  nb_fluxid
) {

  # n_pages is too slow to get the number of page
  # instead we can use the nb of facets and nrow and ncol
  f_ncol <- facet_wrap_args$ncol
  f_nrow <- facet_wrap_args$nrow

  plot_pages <- ceiling(nb_fluxid / (f_nrow * f_ncol))

  f_plotname <- paste(f_plotname, ".pdf", sep = "")
  pdf(f_plotname, paper = "a4r", width = 11.7,
      height = 8.3, title = f_plotname)
  pb <- progress_bar$new(
    format =
      "Printing plots in pdf document [:bar] :current/:total (:percent)",
    total = plot_pages
  )
  pb$tick(0)
  Sys.sleep(0.5)
  for (i in 1:plot_pages) {
    pb$tick()
    Sys.sleep(0.001)
    print(f_plot +
      do.call(facet_wrap_paginate,
        args = c(
          facets = ~f_facetid,
          page = i,
          facet_wrap_args
        )
      ))
  }
  quietly(dev.off())
  message("Plots saved in f_quality_plots folder.")
}
