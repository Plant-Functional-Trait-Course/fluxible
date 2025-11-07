# Using an already existing end column to slice measurements

Provides the `f_end` column for `flux_match`

## Usage

``` r
flux_match_col(field_record, start_col, end_col, name_field_record)
```

## Arguments

- field_record:

  dataframe recording which measurement happened when. Has to contain at
  least a column containing the start of each measurement, and any other
  column identifying the measurements.

- start_col:

  start column in field_record (`ymd_hms` format)

- end_col:

  end column in field_record (`ymd_hms` format)

- name_field_record:

  name of the df (for error message)
