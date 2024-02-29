# fitting works with 0 second end cut

    Code
      flux_fitting_exp(co2_conc)
    Message <rlang_message>
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(datetime, temp_air, temp_soil, conc, PAR, turfID, type, start, end, fluxID, n_conc, ratio, flag, time, cut)`
    Warning <simpleWarning>
      
       fluxID 5 : slope was estimated on 205 points out of 210 seconds because data are missing
       fluxID 6 : slope was estimated on 206 points out of 210 seconds because data are missing
    Output
      # A tibble: 1,251 x 29
      # Groups:   fluxID [6]
         datetime            temp_air temp_soil  conc   PAR turfID       type 
         <dttm>                 <dbl>     <dbl> <dbl> <dbl> <fct>        <fct>
       1 2022-07-28 23:43:35    NA         NA    447. NA    156 AN2C 156 ER   
       2 2022-07-28 23:43:36     7.22      10.9  447.  1.68 156 AN2C 156 ER   
       3 2022-07-28 23:43:37    NA         NA    448. NA    156 AN2C 156 ER   
       4 2022-07-28 23:43:38    NA         NA    449. NA    156 AN2C 156 ER   
       5 2022-07-28 23:43:39    NA         NA    449. NA    156 AN2C 156 ER   
       6 2022-07-28 23:43:40    NA         NA    450. NA    156 AN2C 156 ER   
       7 2022-07-28 23:43:41    NA         NA    451. NA    156 AN2C 156 ER   
       8 2022-07-28 23:43:42    NA         NA    451. NA    156 AN2C 156 ER   
       9 2022-07-28 23:43:43    NA         NA    453. NA    156 AN2C 156 ER   
      10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
      # i 1,241 more rows
      # i 22 more variables: start <dttm>, end <dttm>, fluxID <fct>, n_conc <int>,
      #   ratio <dbl>, flag <chr>, time <dbl>, cut <fct>, Cm_est <dbl>, a_est <dbl>,
      #   b_est <dbl>, tz_est <dbl>, Cz <dbl>, time_diff <dbl>, Cm <dbl>, a <dbl>,
      #   b <dbl>, tz <dbl>, slope_tz <dbl>, fit <dbl>, fit_slope <dbl>,
      #   start_z <dttm>

# fitting works with 30 second end cut

    Code
      flux_fitting_exp(co2_conc, end_cut = 30)
    Message <rlang_message>
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(datetime, temp_air, temp_soil, conc, PAR, turfID, type, start, end, fluxID, n_conc, ratio, flag, time, cut)`
    Output
      # A tibble: 1,251 x 29
      # Groups:   fluxID [6]
         datetime            temp_air temp_soil  conc   PAR turfID       type 
         <dttm>                 <dbl>     <dbl> <dbl> <dbl> <fct>        <fct>
       1 2022-07-28 23:43:35    NA         NA    447. NA    156 AN2C 156 ER   
       2 2022-07-28 23:43:36     7.22      10.9  447.  1.68 156 AN2C 156 ER   
       3 2022-07-28 23:43:37    NA         NA    448. NA    156 AN2C 156 ER   
       4 2022-07-28 23:43:38    NA         NA    449. NA    156 AN2C 156 ER   
       5 2022-07-28 23:43:39    NA         NA    449. NA    156 AN2C 156 ER   
       6 2022-07-28 23:43:40    NA         NA    450. NA    156 AN2C 156 ER   
       7 2022-07-28 23:43:41    NA         NA    451. NA    156 AN2C 156 ER   
       8 2022-07-28 23:43:42    NA         NA    451. NA    156 AN2C 156 ER   
       9 2022-07-28 23:43:43    NA         NA    453. NA    156 AN2C 156 ER   
      10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
      # i 1,241 more rows
      # i 22 more variables: start <dttm>, end <dttm>, fluxID <fct>, n_conc <int>,
      #   ratio <dbl>, flag <chr>, time <dbl>, cut <fct>, Cm_est <dbl>, a_est <dbl>,
      #   b_est <dbl>, tz_est <dbl>, Cz <dbl>, time_diff <dbl>, Cm <dbl>, a <dbl>,
      #   b <dbl>, tz <dbl>, slope_tz <dbl>, fit <dbl>, fit_slope <dbl>,
      #   start_z <dttm>

# fitting works with 60 second end cut

    Code
      flux_fitting_exp(co2_conc, end_cut = 60)
    Message <rlang_message>
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(fluxID)`
      Joining with `by = join_by(datetime, temp_air, temp_soil, conc, PAR, turfID, type, start, end, fluxID, n_conc, ratio, flag, time, cut)`
    Output
      # A tibble: 1,251 x 29
      # Groups:   fluxID [6]
         datetime            temp_air temp_soil  conc   PAR turfID       type 
         <dttm>                 <dbl>     <dbl> <dbl> <dbl> <fct>        <fct>
       1 2022-07-28 23:43:35    NA         NA    447. NA    156 AN2C 156 ER   
       2 2022-07-28 23:43:36     7.22      10.9  447.  1.68 156 AN2C 156 ER   
       3 2022-07-28 23:43:37    NA         NA    448. NA    156 AN2C 156 ER   
       4 2022-07-28 23:43:38    NA         NA    449. NA    156 AN2C 156 ER   
       5 2022-07-28 23:43:39    NA         NA    449. NA    156 AN2C 156 ER   
       6 2022-07-28 23:43:40    NA         NA    450. NA    156 AN2C 156 ER   
       7 2022-07-28 23:43:41    NA         NA    451. NA    156 AN2C 156 ER   
       8 2022-07-28 23:43:42    NA         NA    451. NA    156 AN2C 156 ER   
       9 2022-07-28 23:43:43    NA         NA    453. NA    156 AN2C 156 ER   
      10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
      # i 1,241 more rows
      # i 22 more variables: start <dttm>, end <dttm>, fluxID <fct>, n_conc <int>,
      #   ratio <dbl>, flag <chr>, time <dbl>, cut <fct>, Cm_est <dbl>, a_est <dbl>,
      #   b_est <dbl>, tz_est <dbl>, Cz <dbl>, time_diff <dbl>, Cm <dbl>, a <dbl>,
      #   b <dbl>, tz <dbl>, slope_tz <dbl>, fit <dbl>, fit_slope <dbl>,
      #   start_z <dttm>
