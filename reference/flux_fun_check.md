# checking that arguments and columns are in the correct class

checking that arguments and columns are in the correct class

## Usage

``` r
flux_fun_check(args, fn, msg, name_df = NA)
```

## Arguments

- args:

  list of arguments or dataframe to check

- fn:

  list of functions used to check (`is.numeric`, `is.character`, ...)

- msg:

  list of messages to return in case of failed check

- name_df:

  in case args is a df with selected columns to check origdf is the
  original df to take the name from for a more obvious error message

## Author

Adam Klimes
