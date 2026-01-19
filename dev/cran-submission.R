# for update

usethis::use_version("patch") # (or ‘patch’ or ‘major’)
devtools::submit_cran()

usethis::use_github_links(overwrite = TRUE)
urlchecker::url_check()
devtools::build_readme()
devtools::check(remote = TRUE, manual = TRUE)

usethis::use_release_issue()

devtools::release()

devtools::spell_check()

devtools::check()
# check_rhub()
# This function is deprecated and defunct since rhub v2.
# Please see `?rhubv2` on transitioning to the new rhub functions.
# rhubv2 is not available on my version of R
rhub::rhub_setup()

# Notes:
# • The workflow file must be added to the default
#   branch of the GitHub repository.
# • GitHub actions must be enabled for the
#   repository. They are disabled for forked
#   repositories by default.

# Next steps:
# • Add the workflow file to git using `git add
#   <filename>`.
# • Commit it to git using `git commit`.
# • Push the commit to GitHub using `git push`.
# • Call `rhub::rhub_doctor()` to check that you
#   have set up R-hub correctly.
# • Call `rhub::rhub_check()` to check your
#   package.

rhub::rhub_doctor()

rhub::rhub_check()

devtools::check_win_devel()
devtools::check_win_oldrelease()
usethis::use_news_md()
usethis::use_cran_comments()
