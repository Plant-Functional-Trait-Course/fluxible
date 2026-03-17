#to create the tests
usethis::use_testthat()
usethis::use_test("flux_fitting_quadratic")

#to add used packages in the description
usethis::use_package("tibble")
usethis::use_dev_package("licoread")

# to make the webpage
usethis::use_pkgdown()
pkgdown::build_site()
usethis::use_pkgdown_github_pages()

usethis::use_vignette("two-gases")
devtools::build_vignettes()

usethis::use_readme_rmd()
devtools::build_readme()
usethis::use_package_doc()

#to detect unused arguments
args()

devtools::load_all()

# do not use, it is a mess
# autoimport::autoimport()

devtools::document()
devtools::test(filter = "flux_plot")
devtools::test()
devtools::run_examples()
devtools::check()

devtools::check(manual = TRUE)

# making the code better
# styler::style_pkg()
lintr::lint_package()


# adding check action
usethis::use_github_action(name = "check-standard", badge = TRUE)

# deprecating stuff
usethis::use_lifecycle()

# add code coverage badge
# rcompendium::add_github_actions_codecov()
# rcompendium::add_codecov_badge()
# this is actually a paid service

# add logo
usethis::use_logo("logos/fluxible-logo7.png", geometry = "240x278", retina = TRUE)

usethis::use_coverage(type = c("codecov"))
usethis::use_github_action("test-coverage")

# adding CRAN version badge
rcompendium::add_cran_badge()

# lifecycle badge
rcompendium::add_lifecycle_badge(lifecycle = "stable", quiet = FALSE)

# setting up revdep (one time thing)
usethis::use_revdep()

# checking if the new release is breaking other packages
revdepcheck::revdep_check(num_workers = 4)

# to render perf report, preview does not work
quarto::quarto_render("perf_report.qmd")
quarto::quarto_render("download_logs.qmd")
