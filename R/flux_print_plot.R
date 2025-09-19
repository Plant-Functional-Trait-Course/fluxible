#' Printing plot
#' @description printing plot from flux_plot
#' @param f_plot plot from flux_plot
#' @param facet_wrap_args list of arguments for
#' \link[ggplot2:facet_wrap]{facet_wrap}
#' @importFrom ggplot2 facet_wrap
#' @keywords internal

flux_print_plot <- function(f_plot,
  facet_wrap_args
) {
  f_plot <- f_plot +
    do.call(facet_wrap, # do.call is here to pass arguments as a list
      args = c(facets = ~f_facetid, facet_wrap_args)
    )
  f_plot
}
