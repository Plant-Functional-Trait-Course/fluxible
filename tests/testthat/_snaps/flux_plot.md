# plot for exponential fit

    Code
      suppressMessages(flux_plot(slopes0_flag, conc, datetime, f_plotname = "test_exp_plot",
        print_plot = FALSE, output = "pdfpages"))

# plot for linear fit with jpg extension works

    Code
      flux_plot(slopes30lin_flag, conc, datetime, f_plotname = "test_lin_plot",
        print_plot = FALSE, output = "ggsave", ggsave_args = list(device = "jpg"))
    Message
      Plotting in progress
      Saving plots with ggsave.
      Saving 7 x 7 in image
      Plots saved in f_quality_plots folder.

# longpdf works

    Code
      flux_plot(slopes0_flag, conc, datetime, f_plotname = "test_exp_plot",
        print_plot = FALSE, output = "longpdf")
    Message
      Plotting in progress
      Starting ggsave...
      Plots saved in f_quality_plots folder.

