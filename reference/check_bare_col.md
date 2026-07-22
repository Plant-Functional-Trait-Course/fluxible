# Check that a column argument was supplied as a bare name

This helper is internal to the package. It accepts a quosure (from
[`rlang::enquo()`](https://rlang.r-lib.org/reference/enquo.html)) and a
parameter name and aborts with a clear message when the user provided a
string literal or another unsuitable value instead of a bare (unquoted)
column name.

## Usage

``` r
check_bare_col(arg_quo, arg_name)
```

## Arguments

- arg_quo:

  A quosure (created with `enquo(arg)`).

- arg_name:

  Character name of the argument (for error messages).
