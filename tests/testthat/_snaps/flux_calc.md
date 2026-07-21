# averaging works

    Code
      output
    Output
      # A tibble: 6 x 6
        f_fluxid f_temp_air_ave datetime            f_flux PAR_ave temp_soil_ave
        <fct>             <dbl> <dttm>               <dbl>   <dbl>         <dbl>
      1 1                  7.31 2022-07-28 23:43:35   95.6    1.95          10.8
      2 2                  7.38 2022-07-28 23:47:22   52.4    2.11          10.7
      3 3                  7.46 2022-07-28 23:52:10   18.6    2.04          10.7
      4 4                  7.77 2022-07-28 23:59:32   69.4    1.84          10.8
      5 5                  7.71 2022-07-29 00:03:10   89.9    1.66          10.6
      6 6                  7.75 2022-07-29 00:06:35   26.2    1.78          12.2

# keeping works

    Code
      dplyr::select(flux_calc(slopes0, f_slope, datetime, temp_air, conc_unit = "ppm",
        flux_unit = "mmol/m2/h", cols_keep = c("turfID", "type", "f_start"),
        setup_volume = 24.575, atm_pressure = 1, plot_area = 0.0625, cut = FALSE),
      f_fluxid, f_flux, turfID, type, f_start, f_slope)
    Message
      Averaging air temperature for each flux...
      Creating a df with the columns from 'cols_keep' argument...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 6
        f_fluxid f_flux turfID       type  f_start             f_slope
        <fct>     <dbl> <fct>        <fct> <dttm>                <dbl>
      1 1          95.6 156 AN2C 156 ER    2022-07-28 23:43:35   1.56 
      2 2          52.4 74 WN2C 155  NEE   2022-07-28 23:47:22   0.853
      3 3          18.6 74 WN2C 155  ER    2022-07-28 23:52:10   0.303
      4 4          69.4 109 AN3C 109 NEE   2022-07-28 23:59:32   1.13 
      5 5          89.9 109 AN3C 109 ER    2022-07-29 00:03:10   1.46 
      6 6          26.2 29 WN3C 106  NEE   2022-07-29 00:06:35   0.426

# keeping and averaging work together

    Code
      dplyr::select(flux_calc(slopes0, f_slope, datetime, temp_air, conc_unit = "ppm",
        flux_unit = "mmol/m2/h", cols_keep = c("turfID", "type", "f_start"),
        cols_ave = c("PAR", "temp_soil"), setup_volume = 24.575, atm_pressure = 1,
        plot_area = 0.0625, cut = FALSE), f_fluxid, f_flux, turfID, type, f_start,
      PAR_ave, temp_soil_ave)
    Message
      Averaging air temperature for each flux...
      Creating a df with the columns from 'cols_keep' argument...
      Creating a df with the columns from 'cols_ave' argument...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 7
        f_fluxid f_flux turfID       type  f_start             PAR_ave temp_soil_ave
        <fct>     <dbl> <fct>        <fct> <dttm>                <dbl>         <dbl>
      1 1          95.6 156 AN2C 156 ER    2022-07-28 23:43:35    1.95          10.8
      2 2          52.4 74 WN2C 155  NEE   2022-07-28 23:47:22    2.11          10.7
      3 3          18.6 74 WN2C 155  ER    2022-07-28 23:52:10    2.04          10.7
      4 4          69.4 109 AN3C 109 NEE   2022-07-28 23:59:32    1.84          10.8
      5 5          89.9 109 AN3C 109 ER    2022-07-29 00:03:10    1.66          10.6
      6 6          26.2 29 WN3C 106  NEE   2022-07-29 00:06:35    1.78          12.2

# nesting works

    Code
      output
    Output
      # A tibble: 1,251 x 7
      # Groups:   f_fluxid [6]
         f_fluxid datetime            f_flux PAR_ave temp_soil_ave  conc   PAR
         <fct>    <dttm>               <dbl>   <dbl>         <dbl> <dbl> <dbl>
       1 1        2022-07-28 23:43:35   6.94    1.95          10.8  447. NA   
       2 1        2022-07-28 23:43:35   6.94    1.95          10.8  447.  1.68
       3 1        2022-07-28 23:43:35   6.94    1.95          10.8  448. NA   
       4 1        2022-07-28 23:43:35   6.94    1.95          10.8  449. NA   
       5 1        2022-07-28 23:43:35   6.94    1.95          10.8  449. NA   
       6 1        2022-07-28 23:43:35   6.94    1.95          10.8  450. NA   
       7 1        2022-07-28 23:43:35   6.94    1.95          10.8  451. NA   
       8 1        2022-07-28 23:43:35   6.94    1.95          10.8  451. NA   
       9 1        2022-07-28 23:43:35   6.94    1.95          10.8  453. NA   
      10 1        2022-07-28 23:43:35   6.94    1.95          10.8  453. NA   
      # i 1,241 more rows

# nesting all works

    Code
      output
    Output
      # A tibble: 1,251 x 28
      # Groups:   f_fluxid [6]
         f_fluxid datetime            f_flux PAR_ave temp_soil_ave
         <fct>    <dttm>               <dbl>   <dbl>         <dbl>
       1 1        2022-07-28 23:43:35   6.94    1.95          10.8
       2 1        2022-07-28 23:43:35   6.94    1.95          10.8
       3 1        2022-07-28 23:43:35   6.94    1.95          10.8
       4 1        2022-07-28 23:43:35   6.94    1.95          10.8
       5 1        2022-07-28 23:43:35   6.94    1.95          10.8
       6 1        2022-07-28 23:43:35   6.94    1.95          10.8
       7 1        2022-07-28 23:43:35   6.94    1.95          10.8
       8 1        2022-07-28 23:43:35   6.94    1.95          10.8
       9 1        2022-07-28 23:43:35   6.94    1.95          10.8
      10 1        2022-07-28 23:43:35   6.94    1.95          10.8
      # i 1,241 more rows
      # i 23 more variables: nested_variables_datetime <dttm>,
      #   nested_variables_temp_air <dbl>, nested_variables_temp_soil <dbl>,
      #   nested_variables_conc <dbl>, nested_variables_PAR <dbl>,
      #   nested_variables_turfID <fct>, nested_variables_type <fct>,
      #   nested_variables_f_start <dttm>, nested_variables_f_end <dttm>,
      #   nested_variables_f_ratio <dbl>, nested_variables_f_flag_match <chr>, ...

# fahrenheit conversion works

    Code
      dplyr::select(flux_calc(slopes0_temp, f_slope, datetime, temp_fahr, conc_unit = "ppm",
        flux_unit = "mmol/m2/h", temp_air_unit = "fahrenheit", setup_volume = 24.575,
        atm_pressure = 1, plot_area = 0.0625, cut = FALSE), f_fluxid, f_temp_air_ave,
      datetime, f_flux)
    Message
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 4
        f_fluxid f_temp_air_ave datetime            f_flux
        <fct>             <dbl> <dttm>               <dbl>
      1 1                  45.2 2022-07-28 23:43:35   95.6
      2 2                  45.3 2022-07-28 23:47:22   52.4
      3 3                  45.4 2022-07-28 23:52:10   18.6
      4 4                  46.0 2022-07-28 23:59:32   69.4
      5 5                  45.9 2022-07-29 00:03:10   89.9
      6 6                  45.9 2022-07-29 00:06:35   26.2

# kelvin conversion works

    Code
      dplyr::select(flux_calc(slopes0_temp, f_slope, datetime, temp_kelvin,
        conc_unit = "ppm", flux_unit = "mmol/m2/h", temp_air_unit = "kelvin",
        setup_volume = 24.575, atm_pressure = 1, plot_area = 0.0625, cut = FALSE),
      f_fluxid, f_temp_air_ave, datetime, f_flux)
    Message
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 4
        f_fluxid f_temp_air_ave datetime            f_flux
        <fct>             <dbl> <dttm>               <dbl>
      1 1                  280. 2022-07-28 23:43:35   95.6
      2 2                  281. 2022-07-28 23:47:22   52.4
      3 3                  281. 2022-07-28 23:52:10   18.6
      4 4                  281. 2022-07-28 23:59:32   69.4
      5 5                  281. 2022-07-29 00:03:10   89.9
      6 6                  281. 2022-07-29 00:06:35   26.2

# calculating fluxes on dataset with cuts

    Code
      dplyr::select(flux_calc(slopes30_flag, f_slope_corr, datetime, temp_air,
        conc_unit = "ppm", flux_unit = "mmol/m2/h", keep_arg = "keep", setup_volume = 24.575,
        atm_pressure = 1, plot_area = 0.0625), f_fluxid, f_temp_air_ave, datetime,
      f_flux)
    Message
      Cutting data according to 'keep_arg'...
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 4
        f_fluxid f_temp_air_ave datetime            f_flux
        <fct>             <dbl> <dttm>               <dbl>
      1 1                  7.29 2022-07-28 23:43:35   47.7
      2 2                  7.37 2022-07-28 23:47:22   31.0
      3 3                  7.45 2022-07-28 23:52:10   20.7
      4 4                  7.77 2022-07-28 23:59:32   41.5
      5 5                  7.70 2022-07-29 00:03:10    0  
      6 6                  7.74 2022-07-29 00:06:35   26.1

# volume can be a variable instead of a constant

    Code
      dplyr::select(flux_calc(slopes0_vol, f_slope, datetime, temp_air, setup_volume = volume,
        conc_unit = "ppm", flux_unit = "mmol/m2/h", atm_pressure = 1, plot_area = 0.0625),
      f_fluxid, f_temp_air_ave, datetime, f_flux)
    Message
      Cutting data according to 'keep_arg'...
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 4
        f_fluxid f_temp_air_ave datetime            f_flux
        <fct>             <dbl> <dttm>               <dbl>
      1 1                  7.31 2022-07-28 23:43:35   70.4
      2 2                  7.38 2022-07-28 23:47:22   59.9
      3 3                  7.46 2022-07-28 23:52:10   15.2
      4 4                  7.77 2022-07-28 23:59:32   68.0
      5 5                  7.71 2022-07-29 00:03:10   14.9
      6 6                  7.75 2022-07-29 00:06:35   37.3

# pressure can be a variable instead of a constant

    Code
      dplyr::select(flux_calc(slopes0_vol, f_slope, datetime, temp_air, setup_volume = 24.575,
        conc_unit = "ppm", flux_unit = "mmol/m2/h", atm_pressure = f_pressure,
        plot_area = 0.0625), f_fluxid, f_temp_air_ave, datetime, f_flux)
    Message
      Cutting data according to 'keep_arg'...
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 4
        f_fluxid f_temp_air_ave datetime            f_flux
        <fct>             <dbl> <dttm>               <dbl>
      1 1                  7.31 2022-07-28 23:43:35   76.5
      2 2                  7.38 2022-07-28 23:47:22   52.4
      3 3                  7.46 2022-07-28 23:52:10   24.2
      4 4                  7.77 2022-07-28 23:59:32   76.3
      5 5                  7.71 2022-07-29 00:03:10   62.9
      6 6                  7.75 2022-07-29 00:06:35   31.4

# Fluxible workflow works from start to finish

    Code
      str(fluxes_test)
    Output
      tibble [6 x 6] (S3: tbl_df/tbl/data.frame)
       $ f_fluxid      : Factor w/ 6 levels "1","2","3","4",..: 1 2 3 4 5 6
       $ f_slope_corr  : num [1:6] 0.785 0.503 0.344 0.693 0 ...
       $ f_temp_air_ave: num [1:6] 7.28 7.37 7.45 7.77 7.69 ...
       $ datetime      : POSIXct[1:6], format: "2022-07-28 23:43:35" "2022-07-28 23:47:22" ...
       $ f_flux        : num [1:6] 48.3 30.9 21.1 42.5 0 ...
       $ f_model       : chr [1:6] "exp_zhao18" "exp_zhao18" "exp_zhao18" "exp_zhao18" ...

# Stupeflux works with slope_correction = FALSE

    Code
      stupeflux(raw_conc = co2_df_short, field_record = record_short, f_datetime = datetime,
        start_col = start, f_conc = conc, start_cut = 10, measurement_length = 180,
        fit_type = "exp_zhao18", temp_air_col = temp_air, conc_unit = "ppm",
        flux_unit = "mmol/m2/h", setup_volume = 24.575, atm_pressure = 1, plot_area = 0.0625,
        slope_correction = FALSE)
    Message
      Cutting measurements...
      Estimating starting parameters for optimization...
      Optimizing fitting parameters...
      Calculating fits and slopes...
      Done.
      
       Total number of measurements: 6
      
       ok 	 5 	 83 %
       zero 	 1 	 17 %
       discard 	 0 	 0 %
       force_discard 	 0 	 0 %
       start_error 	 0 	 0 %
       no_data 	 0 	 0 %
       force_ok 	 0 	 0 %
       force_zero 	 0 	 0 %
       force_lm 	 0 	 0 %
       no_slope 	 0 	 0 %
      Cutting data according to 'keep_arg'...
      Averaging air temperature for each flux...
      Calculating fluxes...
      Concentration was measured in ppm
      R constant set to 0.082057 L * atm * K^-1 * mol^-1
      Fluxes are in mmol/m2/h
    Output
      # A tibble: 6 x 7
        f_fluxid f_slope f_temp_air_ave f_atm_pressure_ave datetime            f_flux
        <fct>      <dbl>          <dbl>              <dbl> <dttm>               <dbl>
      1 1          0.785           7.28                  1 2022-07-28 23:43:35   48.3
      2 2          0.503           7.37                  1 2022-07-28 23:47:22   30.9
      3 3          0.344           7.45                  1 2022-07-28 23:52:10   21.1
      4 4          0.693           7.77                  1 2022-07-28 23:59:32   42.5
      5 5          1.20            7.69                  1 2022-07-29 00:03:10   74.0
      6 6          0.433           7.74                  1 2022-07-29 00:06:35   26.6
      # i 1 more variable: f_model <chr>

# Fluxible workflow works with kappamax

    Code
      fluxes_test
    Output
      # A tibble: 6 x 4
        f_model f_temp_air_ave datetime            f_flux
        <chr>            <dbl> <dttm>               <dbl>
      1 exp_hm            7.29 2022-07-28 23:43:35   44.7
      2 exp_hm            7.37 2022-07-28 23:47:22   25.7
      3 exp_hm            7.45 2022-07-28 23:52:10   23.0
      4 exp_hm            7.77 2022-07-28 23:59:32   44.5
      5 linear            7.70 2022-07-29 00:03:10    0  
      6 exp_hm            7.74 2022-07-29 00:06:35   24.8

# Working with two gases

    Code
      str(fluxes_twogases)
    Output
      tibble [12 x 7] (S3: tbl_df/tbl/data.frame)
       $ f_quality_flag: chr [1:12] "ok" "ok" "ok" "ok" ...
       $ f_fluxid      : Factor w/ 12 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
       $ f_temp_air_ave: num [1:12] 13.4 16.5 17.1 14.4 15 ...
       $ datetime      : POSIXct[1:12], format: "2024-06-18 10:04:37" "2024-06-18 11:12:52" ...
       $ flux_co2      : num [1:12] 0.08292 0.38505 0.43518 0.00108 0.06371 ...
       $ f_model       : chr [1:12] "exp_zhao18" "exp_zhao18" "exp_zhao18" "exp_zhao18" ...
       $ flux_ch4      : num [1:12] -0.04873 0.01165 0 -0.00649 0 ...
       - attr(*, "fit_type")= chr "exp_zhao18"

# sum and median works

    Code
      output
    Output
      # A tibble: 6 x 6
        f_fluxid f_temp_air_ave datetime            f_flux PAR_sum temp_soil_med
        <fct>             <dbl> <dttm>               <dbl>   <dbl>         <dbl>
      1 1                  7.31 2022-07-28 23:43:35   95.6    40.9          10.8
      2 2                  7.38 2022-07-28 23:47:22   52.4    44.2          10.7
      3 3                  7.46 2022-07-28 23:52:10   18.6    42.7          10.7
      4 4                  7.77 2022-07-28 23:59:32   69.4    38.6          10.8
      5 5                  7.71 2022-07-29 00:03:10   89.9    33.3          10.6
      6 6                  7.75 2022-07-29 00:06:35   26.2    37.4          12.2

# sum and average works on same variable

    Code
      output
    Output
      # A tibble: 6 x 6
        f_fluxid datetime            f_flux PAR_sum temp_soil_ave PAR_ave
        <fct>    <dttm>               <dbl>   <dbl>         <dbl>   <dbl>
      1 1        2022-07-28 23:43:35   95.6    40.9          10.8    1.95
      2 2        2022-07-28 23:47:22   52.4    44.2          10.7    2.11
      3 3        2022-07-28 23:52:10   18.6    42.7          10.7    2.04
      4 4        2022-07-28 23:59:32   69.4    38.6          10.8    1.84
      5 5        2022-07-29 00:03:10   89.9    33.3          10.6    1.66
      6 6        2022-07-29 00:06:35   26.2    37.4          12.2    1.78

# volumetric concentration works

    Code
      output_vol
    Output
      # A tibble: 6 x 6
        f_fluxid datetime            f_flux PAR_sum temp_soil_ave PAR_ave
        <fct>    <dttm>               <dbl>   <dbl>         <dbl>   <dbl>
      1 1        2022-07-28 23:43:35   66.3    40.9          10.8    1.95
      2 2        2022-07-28 23:47:22   48.0    44.2          10.7    2.11
      3 3        2022-07-28 23:52:10   16.3    42.7          10.7    2.04
      4 4        2022-07-28 23:59:32   59.4    38.6          10.8    1.84
      5 5        2022-07-29 00:03:10   59.3    33.3          10.6    1.66
      6 6        2022-07-29 00:06:35   21.4    37.4          12.2    1.78

