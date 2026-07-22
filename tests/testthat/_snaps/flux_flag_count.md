# quality flags count works

    Code
      flux_flag_count(slopes30lin_flag)
    Output
      # A tibble: 11 x 3
         f_quality_flag     n ratio
         <fct>          <int> <dbl>
       1 total              6 1    
       2 ok                 5 0.833
       3 zero               1 0.167
       4 discard            0 0    
       5 force_discard      0 0    
       6 start_error        0 0    
       7 no_data            0 0    
       8 force_ok           0 0    
       9 force_zero         0 0    
      10 force_lm           0 0    
      11 no_slope           0 0    

# quality flags count works after calculating fluxes

    Code
      flux_flag_count(fluxes)
    Output
      # A tibble: 11 x 3
         f_quality_flag     n ratio
         <fct>          <int> <dbl>
       1 total              6 1    
       2 ok                 5 0.833
       3 zero               1 0.167
       4 discard            0 0    
       5 force_discard      0 0    
       6 start_error        0 0    
       7 no_data            0 0    
       8 force_ok           0 0    
       9 force_zero         0 0    
      10 force_lm           0 0    
      11 no_slope           0 0    

