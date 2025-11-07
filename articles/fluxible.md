# From raw gas concentration data to clean ecosystem gas fluxes.

In this example we will process a dataset from the Plant Functional
Traits Course 6 (Vandvik *et al.*, 2025). Net ecosystem exchange (NEE),
ecosystem respiration (ER), air and soil temperature and
photosynthetically active radiation (PAR) were recorded over the course
of 24 hours at an experimental site called Liahovden, situated in an
alpine grassland in southwestern Norway. Those data are available in the
`fluxible` R package. To work with your own data, you need to import
them as a dataframe object in your R session. For import examples,
please see
[`vignette("data-prep", package = "fluxible")`](https://plant-functional-trait-course.github.io/fluxible/index.html/articles/data-prep.md).

## Input

The CO₂ concentration data as well as air and soil temperature and PAR
were recorded in a dataframe named `co2_liahovden`. The metadata for
each measurement are in a dataframe named `record_liahovden`. This
dataframe contains the starting time of each measurement, the
measurement type (NEE or ER), the measurement round, and the unique plot
ID (called turfs in this experiment).

Structure of the CO₂ concentration data (`co2_liahovden`):

    #> tibble [89,692 × 5] (S3: tbl_df/tbl/data.frame)
    #>  $ datetime : POSIXct[1:89692], format: "2022-07-27 05:34:49" ...
    #>  $ temp_air : num [1:89692] 3 NA NA NA NA NA NA NA NA NA ...
    #>  $ temp_soil: num [1:89692] 2.96 NA NA NA NA NA NA NA NA NA ...
    #>  $ conc     : num [1:89692] 468 469 468 468 468 ...
    #>  $ PAR      : num [1:89692] 2.59 NA NA NA NA NA NA NA NA NA ...

Structure of the meta data (`record_liahovden`):

    #> tibble [138 × 4] (S3: tbl_df/tbl/data.frame)
    #>  $ turfID           : chr [1:138] "4 AN1C 4" "4 AN1C 4" "27 AN3C 27"..
    #>  $ type             : chr [1:138] "NEE" "ER" "NEE" "ER" ...
    #>  $ measurement_round: num [1:138] 1 1 1 1 1 1 2 2 2 2 ...
    #>  $ start            : POSIXct[1:138], format: "2022-07-27 05:37:30" ..

## Attributing meta-data

The gas concentration was logged continuously in a single file and
therefore we need to trim the irrelevant data before and in between
measurements and attribute meta data (flux ID, turf ID, type, and
measurement round) to each row of gas concentration. The two inputs are
`raw_conc`, the dataframe containing field measured raw gas
concentration, and `field_record`, the meta data dataframe with the
start of each measurement. Then `f_datetime` is the column containing
date and time in the gas concentration dataframe, and `start_col` the
column containing the start date and time of each measurement in the
meta data dataframe. The length of the measurements is provided with
`measurement_length` (in seconds). Alternatively, a column indicating
the end time and date of each measurement can be provided to `end_col`.
The `time_diff` argument allow to account for a consistent time
difference (in seconds) between the two inputs. This value is added to
the datetime column of the gas concentration dataset.

``` r
library(fluxible)

conc_liahovden <- flux_match(
  raw_conc = co2_liahovden, # dataframe with raw gas concentration
  field_record = record_liahovden, # dataframe with meta data
  f_datetime = datetime, # date and time of each gas concentration row
  start_col = start, # start date and time of each measurement
  measurement_length = 220, # length of measurements (in seconds)
  time_diff = 0 # time difference between f_datetime and start_col
)
```

## Model fitting

We fit a model and obtain the slope at $t_{0}$, which is needed for the
flux calculation, with the `flux_fitting` function. In this example we
use the `exp_zhao18` model (Zhao *et al.*, 2018), which is the default
setting as it is more robust and recent. The `exp_zhao18` is a mix of an
exponential and linear model - thus fitting all fluxes independently
from curvature - and includes $t_{0}$ as a fitting parameter. A similar
model but with the option to manually set $t_{0}$ is `exp_tz`. Other
available models are: `linear` for a linear fit, `quadratic` for a
quadratic fit, and `exp_hm` for the original HM model (Hutchinson and
Mosier, 1981).

The `conc_df` argument is the dataframe with gas concentration, date and
time, and start and end of each measurement, ideally produced with
`flux_match` (see
[`vignette("data-prep", package = "fluxible")`](https://plant-functional-trait-course.github.io/fluxible/index.html/articles/data-prep.md)
for requirements to bypass `flux_match`). Then `f_conc` and `f_datetime`
are, similarly as in `flux_match`, the gas concentration and
corresponding datetime column. The arguments `f_start`, `f_end`, and
`f_fluxid` are produced by `flux_match`. They indicate, respectively,
the start, end and unique ID of each measurement. The model chosen to
fit the gas concentration is provided with `fit_type`. The user can
decide to restrict the fitting window before fitting the model with the
`start_cut` and `end_cut` arguments. For the models `quadratic`,
`exp_tz`, and `exp_hm`, `t_zero` needs to be provided to indicate how
many seconds after the start of the fitting window should the slope be
calculated. Arguments `cz_window`, `b_window`, `a_window` and
`roll_width` are specific to the automatic fitting of the `exp_zhao18`
and `exp_tz` models and we recommand keeping the default values.

``` r
slopes_liahovden <- flux_fitting(
  conc_df = conc_liahovden, # the output of flux_match
  f_conc = conc, # gas concentration column
  f_datetime = datetime, # date and time column
  f_start = f_start, # start of each measurement, provided by flux_match
  f_end = f_end, # end of each measurement, provided by flux_match
  f_fluxid = f_fluxid, # unique ID for each measurement, provided by flux_match
  fit_type = "exp_zhao18", # the model to fit to the gas concentration
  start_cut = 0, # seconds to prune at the start before fitting
  end_cut = 0 # seconds to prune at the end of all measurements before fitting
)
```

## Quality checks and visualisations

The function `flux_quality` is used to provide diagnostics about the
quality of the fit, potentially advising to discard some measurements or
replace them by zero. The main principle is that the user sets
thresholds on diagnostics (depending on the model used) to flag the
measurements according to the quality of the data and the model fit.
Those quality flags are then used to provide `f_slope_corr`, a column
containing the advised slope to use for calculation. The `force_`
arguments allow the user to override this automatic flagging by
providing a vector of fluxIDs. The `ambient_conc` and `error` arguments
are used to detect measurements starting outside of a reasonable range
(the mean of the three first gas concentration data points is used,
independently from the fitting window). The minimal detectable slope is
calculated as
$\frac{2 \times \text{instr error}}{\text{length of measurement}}$ and
is used to detect slopes that should be replaced by zero. Other
arguments are described in the function documentation (displayed with
[`?flux_quality`](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_quality.md)).
The function `flux_flag_count` provides a table with the counts of
quality flags, which is convenient for reporting on the dataset quality,
and can also be done on the final flux dataset. This table is also
printed as a side effect of `flux_quality`.

``` r
flags_liahovden <- flux_quality(
  slopes_df = slopes_liahovden,
  f_conc = conc,
  # force_discard = c(),
  # force_ok = c(),
  # force_zero = c(),
  # force_lm = c(),
  # force_exp = c(),
  ambient_conc = 421,
  error = 100,
  instr_error = 5
)
#> 
#>  Total number of measurements: 138
#> 
#>  ok   109     79 %
#>  zero     27      20 %
#>  discard      2   1 %
#>  force_discard    0   0 %
#>  start_error      0   0 %
#>  no_data      0   0 %
#>  force_ok     0   0 %
#>  force_zero   0   0 %
#>  force_lm     0   0 %
#>  no_slope     0   0 %

flux_flag_count(flags_liahovden)
#> # A tibble: 10 × 3
#>    f_quality_flag     n  ratio
#>    <fct>          <int>  <dbl>
#>  1 ok               109 0.790 
#>  2 zero              27 0.196 
#>  3 discard            2 0.0145
#>  4 force_discard      0 0     
#>  5 start_error        0 0     
#>  6 no_data            0 0     
#>  7 force_ok           0 0     
#>  8 force_zero         0 0     
#>  9 force_lm           0 0     
#> 10 no_slope           0 0
```

The function `flux_plot` provides plots for a visual assessment of the
measurements, explicitly displaying the quality flags from
`flux_quality` and the cuts from `flux_fitting`. Note that different
values than the default can be provided to `scale_x_datetime` and
`facet_wrap` by providing lists of arguments to `scale_x_datetime_args`
and `facet_wrap_args` respectively.

``` r
flags_liahovden |>
  # we show only a sample of the plots in this example
  dplyr::filter(f_fluxid %in% c(54, 95, 100, 101)) |>
  flux_plot(
    f_conc = conc,
    f_datetime = datetime,
    f_ylim_upper = 600, # upper limit of y-axis
    f_ylim_lower = 350, # lower limit of x-axis
    y_text_position = 450, # position of text with flags and diagnostics
    facet_wrap_args = list( # facet_wrap arguments, if different than default
      nrow = 2,
      ncol = 2,
      scales = "free"
    ),
    f_facetid = "f_fluxid"
  )
```

![Output of \`flux_plot\` for fluxid 54, 95, 100 and 101. With quality
flags and diagnostics from \`flux_quality\`, the slope at \$t_0\$
(continuous line), the model fit (dashed line), the linear fit (dotted
line), and the raw gas concentration (dots). The colours show the
quality flags (green for \`ok\`, red for \`discard\` and purple for
\`zero\` with default settings) and cuts (same colour as \`discard\`).
The gray vertical line indicates \$t_0\$ (a fitting parameter when using
the \`exp_zhao18\` model, otherwise user defined in \`flux_fitting\`).
The g-factor is calculated as slope/linear slope, and b is the b
parameter inside the exponential model. Concentration is in ppm in this
example. Due to poor quality (strong peak at the start),
\`flux_fitting\` could not provide a decent fit for fluxid 101. This was
detected by \`flux_quality\` which flagged it as
discard.](fluxible_files/figure-html/fig-explot-1.png)

Output of `flux_plot` for fluxid 54, 95, 100 and 101. With quality flags
and diagnostics from `flux_quality`, the slope at $t_{0}$ (continuous
line), the model fit (dashed line), the linear fit (dotted line), and
the raw gas concentration (dots). The colours show the quality flags
(green for `ok`, red for `discard` and purple for `zero` with default
settings) and cuts (same colour as `discard`). The gray vertical line
indicates $t_{0}$ (a fitting parameter when using the `exp_zhao18`
model, otherwise user defined in `flux_fitting`). The g-factor is
calculated as slope/linear slope, and b is the b parameter inside the
exponential model. Concentration is in ppm in this example. Due to poor
quality (strong peak at the start), `flux_fitting` could not provide a
decent fit for fluxid 101. This was detected by `flux_quality` which
flagged it as discard.

To export the plots as pdf without printing them in one’s R session,
which we recommend for large datasets, the code looks like this
(`pdfpages` produces nice A4 pages, `longpdf` produces a single long pdf
file, which is much faster):

``` r
flux_plot(
  slopes_df = flags_liahovden,
  f_conc = conc,
  f_datetime = datetime,
  print_plot = FALSE, # not printing the plots in the R session
  output = "longpdf", # the type of output
  f_plotname = "plots_liahovden" # filename for the pdf file
)
```

If the argument `f_plotname` is left empty (the default), the name of
the `slopes_df` object will be used (`flags_liahovden` in our case). The
pdf file will be saved in a folder named `f_quality_plots`.

> ℹ️ Handling lots of data?
>
> Automated chambers produce a lot of data, and visually inspecting all
> the fluxes might not be a reasonable option. In such cases, it is
> possible to first calculate the fluxes without plotting them
> (`flux_calc` takes the output of `flux_quality` as input) and target
> fluxes to visually inspect afterwards. Here are some suggestions on
> how to select which fluxes to inspect:
>
> - target specific campaigns or dates
> - random sampling of flux IDs, campaigns, or dates
> - target measurements based on other variables (wind speed for
>   example)
> - apply over conservative thresholds in `flux_quality` (therefore
>   assuming only false negative) and inspect flagged measurements only
> - do quality control statistics, targeting unrealistic changes in
>   fluxes over time or outliers
>
> Filtering the data directly before plotting is made convenient as
> `fluxible` follows the `tidyverse` grammar (Wickham *et al.*, 2019),
> as shown in the example below.
>
> ``` r
> flags_lia |> # the output of flux_quality
>   # apply here dplyr::filter on f_quality_flags, f_fluxid,
>   # sample(f_fluxid) for random sampling of fluxid, campaigns,
>   # dates, windspeed...
>   # flux_plot will plot only the measurements passing the filter
>   # and not the entire flags_lia df
>   flux_plot(
>     f_conc = conc,
>     f_datetime = datetime
>   )
> ```

Based on the quality flags and the plots, the user can decide to run
`flux_fitting` and/or `flux_quality` again with different parameters.

If a majority of fluxes show anomalies issues at the end of the
measurement, like flux 100 in the example, the user could decide to
prune the last 60 seconds of the measurements. Sometimes measurements
will pass the automated quality control but the user might have reasons
to still discard them (or the opposite). That is what the
`force_discard`, `force_ok`, `force_lm` and `force_zero` arguments are
for. In our example, for the measurement with fluxID 101, the
exponential model is not providing a good fit (resulting in the flux
being discarded) due to some noise at the start of the measurement and
it gets flagged to be discarded. The user could decide to replace that
flux by zero instead (that would need to be reported and defended). This
is achieved with `force_zero = 101`. Several fluxIDs can be provided to
the `force_` arguments by providing a vector:
`force_zero = c(100, 101)`.

> ℹ️ Redefining the focus window
>
> It might be sometime necessary to redefine the focus window (the
> portion of the flux used for model fitting) in case of consistent
> anomalies at one or both ends of the measurements. This is done with
> arguments `start_cut`, `end_cut` and `cut_direction` in
> `flux_fitting`. The `cut_direction` argument decides how the focus
> window is defined: `"none"` (default) defines the focus window at
> `start + start_cut` to `end - end_cut`, `"from_start"` makes it
> `start + start_cut` to `start + end_cut`; `"from_end"` makes it
> `end - start_cut` to `end - end_cut`. This accommodates if the initial
> measurements’ length are inconsistent but the user wants to cut all of
> them at the same length.
>
> Those parameters are applied homogeneously to the entire dataset and
> do not allow for flux specific focus window. In case subsets of the
> measurements require a different focus window, we recommend applying
> `flux_fitting` to specific subset separately and then rebinding the
> dataset. And if a detailed flux-by-flux cutting is needed, a
> `field_record` including an end column should be used in `flux_match`
> instead of a fixed measurement length.

The function `flux_fitting` is run again, with an end cut of 60 seconds:

``` r
fits_liahovden_60 <- conc_liahovden |>
  flux_fitting(
    conc,
    datetime,
    fit_type = "exp_zhao18",
    end_cut = 60 # we decided to cut the last 60 seconds of the measurements
  )
```

Then `flux_quality` again, possibly forcing a “zero” flag for fluxID
101:

``` r
flags_liahovden_60 <- fits_liahovden_60 |>
  flux_quality(
    conc
    # force_zero = 101 # to replace flux 101 with 0 instead of discarding
  )
#> 
#>  Total number of measurements: 138
#> 
#>  ok   127     92 %
#>  zero     8   6 %
#>  discard      3   2 %
#>  force_discard    0   0 %
#>  start_error      0   0 %
#>  no_data      0   0 %
#>  force_ok     0   0 %
#>  force_zero   0   0 %
#>  force_lm     0   0 %
#>  no_slope     0   0 %
```

And finally `flux_plot` again to check the output.

``` r
flags_liahovden_60 |>
  dplyr::filter(f_fluxid %in% c(54, 95, 100, 101)) |>
  flux_plot(
    conc,
    datetime,
    f_ylim_upper = 600,
    f_ylim_lower = 350,
    y_text_position = 450,
    facet_wrap_args = list(
      nrow = 2,
      ncol = 2,
      scales = "free"
    )
  )
```

![Output of \`flux_plot\` for fluxid 54, 95, 100 and 101, after quality
check. Concentration is in ppm in this
example.](fluxible_files/figure-html/fig-plot_exp_cut-1.png)

Output of `flux_plot` for fluxid 54, 95, 100 and 101, after quality
check. Concentration is in ppm in this example.

> ℹ️ The importance of reporting
>
> Because of `fluxible`‘s flexibility in choice of models, quality
> thresholds and focus window selection, it is crucial that users report
> the applied parameters when describing their method, for
> reproducibility purpose. In the example above, flux ID 95 changed
> quality flag after changing the focus window. Since the fit and its
> diagnosis are now done on fewer points, it can indeed change the
> quality flag. Note that all those parameters are functions’ arguments,
> making reporting as simple as sharing clean and documented code.

## Flux calculation

Now that we are satisfied with the fit, we can calculate fluxes with
`flux_calc`, which applies the following equation:

$$\text{flux} = \text{slope} \times \frac{P \times V}{R \times T \times A}$$

where

flux: the flux of gas at the surface of the plot (mmol m⁻² s⁻¹)

slope: slope estimate (ppm s⁻¹)

P: pressure (atm)

V: volume of the chamber and tubing (L)

R: gas constant (0.082057 L atm K⁻¹ mol⁻¹)

T: chamber air temperature (K)

A: area of chamber frame base (m²)

The calculation is using the slope, which can either be `f_slope`
(provided by `flux_fitting` and not quality checked) or `f_slope_corr`
which is the recommended slope after quality check with `flux_quality`.
Here the volume is defined as a constant for all the measurements but it
is also possible to provide the volume as a separate column
(`setup_volume`). The `cols_ave` arguments indicates which column(s),
i.e. the environmental data, should be averaged for each flux. When
setting the argument `cut = TRUE` (default), the same cut that was
applied in `flux_fitting` will be used. The `cols_sum` and `cols_med` do
the same for sum and median respectively. In the output, those columns
get appended with the suffixes `_ave`, `_sum` and `_med` respectively.
Here we recorded PAR and soil temperature in the same dataset and would
like their average for each measurement. The `cols_keep` arguments
indicates which columns should be kept. As `flux_calc` transforms the
dataframe from one row per datapoint of gas concentration to one row per
flux, the values in the columns specified in `cols_keep` have to be
constant within each measurement (if not, rows will be repeated to
accommodate for non constant values). Other columns can be nested in a
column called `nested_variables` with `cols_nest` (`cols_nest = "all"`
will nest all the columns present in the dataset, except those provided
to `cols_keep`).

The units of gas concentration, `conc_unit`, can be $mmol\ mol^{- 1}$,
$ppm$, $ppb$ or $ppt$. The units of the calculated flux is decided by
the user and should be in the form $amount\ surface^{- 1}\ time^{- 1}$.
Amount can be $mol$, $mmol$, $\mu mol$, $nmol$ or $pmol$; surface can be
$m^{2}$, $dm^{2}$ or $cm^{2}$; time can be $day$, $hour$, $minute$ or
$second$. Temperature in the input can be in Celsius, Kelvin or
Fahrenheit, and will be returned in the same unit in the output.

``` r
fluxes_liahovden_60 <- flux_calc(
  slopes_df = flags_liahovden_60,
  slope_col = f_slope_corr, # we use the slopes provided by flux_quality
  f_datetime = datetime,
  temp_air_col = temp_air,
  conc_unit = "ppm", # unit of gas concentration
  flux_unit = "mmol/m2/h", # unit of flux
  temp_air_unit = "celsius",
  setup_volume = 24.575, # in liters, can also be a variable
  atm_pressure = 1, # in atm, can also be a variable
  plot_area = 0.0625, # in m2, can also be a variable
  cols_keep = c("turfID", "type", "measurement_round"),
  cols_ave = c("temp_soil", "PAR")
)
```

    #> tibble [138 × 11] (S3: tbl_df/tbl/data.frame)
    #>  $ f_fluxid         : Factor w/ 138 levels "1","2","3","4",..: 1 2 3..
    #>  $ temp_soil_ave    : num [1:138] 6.96 7.01 6.83 6.83 2.5 ...
    #>  $ PAR_ave          : num [1:138] 24.242 1.05 28.809 0.403 48.062 ...
    #>  $ turfID           : chr [1:138] "4 AN1C 4" "4 AN1C 4" "27 AN3C 27"..
    #>  $ type             : chr [1:138] "NEE" "ER" "NEE" "ER" ...
    #>  $ measurement_round: num [1:138] 1 1 1 1 1 1 2 2 2 2 ...
    #>  $ f_slope_corr     : num [1:138] -0.2258 0.0718 -0.3718 0.2433 -0.2..
    #>  $ f_temp_air_ave   : num [1:138] 3.21 3.3 3.15 2.96 2.81 ...
    #>  $ datetime         : POSIXct[1:138], format: "2022-07-27 05:37:30" ..
    #>  $ f_flux           : num [1:138] -14.09 4.48 -23.22 15.2 -17.91 ...
    #>  $ f_model          : chr [1:138] "exp_zhao18" "exp_zhao18" "exp_zh"..

## Gross Primary Production calculation

CO₂ flux chambers and tents can be used to measure net ecosystem
exchange (NEE) and ecosystem respiration (ER) if the user manipulates
the light levels in the chamber. The difference between the two is the
gross primary production (GPP), which cannot be measured isolated from
ER but is often a variable of interest. The function `flux_diff`
calculates the difference between two types of fluxes as
$diff = type\_ a - type\_ b$ and returns a dataset in long format, with
type_a, type_b and diff as flux type. Any variables specified by the
user (`cols_keep` argument) will be filled with their values
corresponding to the type_a measurement. Other type of flux than type_a
and type_b, if present in the dataset (e.g. light response curves, soil
respiration) are kept. Each type_a and type_b measurements need to be
paired together for this calculation. The `id_cols` argument specifies
which columns should be used for pairing (e.g., date, campaign). The
`flux_diff` function can be used to calculate GPP in the case of
CO$_{2}$ fluxes, or transpiration with H$_{2}$O fluxes.

``` r
gpp_liahovden_60 <- flux_diff(
  fluxes_df = fluxes_liahovden_60,
  type_col = type, # the column specifying the type of measurement
  id_cols = c("measurement_round", "turfID"),
  cols_keep = c("temp_soil_ave", "PAR_ave", "datetime"), # or "none" or "all"
  type_a = "NEE", # we want the difference between NEE
  type_b = "ER", # and ER
  diff_name = "GPP" # the name of the calculated flux
)
```

Structure of the flux dataset including GPP:

    #> tibble [204 × 7] (S3: tbl_df/tbl/data.frame)
    #>  $ type             : chr [1:204] "ER" "GPP" "NEE" "ER" ...
    #>  $ f_flux           : num [1:204] 4.48 -18.57 -14.09 15.2 -38.42 ...
    #>  $ temp_soil_ave    : num [1:204] 7.01 6.96 6.96 6.83 6.83 ...
    #>  $ PAR_ave          : num [1:204] 1.05 24.242 24.242 0.403 28.809 ...
    #>  $ datetime         : POSIXct[1:204], format: "2022-07-27 05:42:00" ..
    #>  $ measurement_round: num [1:204] 1 1 1 1 1 1 1 1 1 2 ...
    #>  $ turfID           : chr [1:204] "4 AN1C 4" "4 AN1C 4" "4 AN1C 4" "..

The fluxes can then be transformed in units more suited for publishing,
for example $mg*m^{- 2}*h^{- 1}$:

``` r
gpp_liahovden_60 <- gpp_liahovden_60 |>
  dplyr::mutate(
    flux_mg = f_flux * 0.0440095
  )
```

    #> tibble [204 × 8] (S3: tbl_df/tbl/data.frame)
    #>  $ type             : chr [1:204] "ER" "GPP" "NEE" "ER" ...
    #>  $ f_flux           : num [1:204] 4.48 -18.57 -14.09 15.2 -38.42 ...
    #>  $ temp_soil_ave    : num [1:204] 7.01 6.96 6.96 6.83 6.83 ...
    #>  $ PAR_ave          : num [1:204] 1.05 24.242 24.242 0.403 28.809 ...
    #>  $ datetime         : POSIXct[1:204], format: "2022-07-27 05:42:00" ..
    #>  $ measurement_round: num [1:204] 1 1 1 1 1 1 1 1 1 2 ...
    #>  $ turfID           : chr [1:204] "4 AN1C 4" "4 AN1C 4" "4 AN1C 4" "..
    #>  $ flux_mg          : num [1:204] 0.197 -0.817 -0.62 0.669 -1.691 ...

#### References

Hutchinson, G.L. and Mosier, A.R. (1981), “[Improved Soil Cover Method
for Field Measurement of Nitrous Oxide
Fluxes](https://doi.org/10.2136/sssaj1981.03615995004500020017x)”, *Soil
Science Society of America Journal*, Vol. 45 No. 2, pp. 311–316.

Vandvik, V., Halbritter, A.H., Macias-Fauria, M., Maitner, B.S.,
Michaletz, S.T., Telford, R.J., Bison, N., *et al.* (2025), “[Plant
traits and associated ecological data from global change experiments and
climate gradients in
Norway](https://doi.org/10.1038/s41597-025-05509-4)”, *Scientific Data*,
Nature Publishing Group, Vol. 12 No. 1, p. 1477.

Wickham, H., Averick, M., Bryan, J., Chang, W., McGowan, L.D., François,
R., Grolemund, G., *et al.* (2019), “[Welcome to the
tidyverse](https://doi.org/10.21105/joss.01686)”, *Journal of Open
Source Software*, Vol. 4 No. 43, p. 1686.

Zhao, P., Hammerle, A., Zeeman, M. and Wohlfahrt, G. (2018), “[On the
calculation of daytime CO2 fluxes measured by automated closed
transparent chambers](https://doi.org/10.1016/j.agrformet.2018.08.022)”,
*Agricultural and Forest Meteorology*, Vol. 263, pp. 267–275.
