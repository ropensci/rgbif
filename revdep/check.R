library("devtools")

res <- revdep_check(threads = 4)
revdep_check_save_summary()
revdep_check_print_problems()
revdep_email(date = "June 9", only_problems = FALSE, draft = FALSE)

pkgs <- list(
  list(your_package = "downscale", your_version = "1.2-1", email = "charliem2003@gmail.com"),
  list(your_package = "plotKML", your_version = "0.5-6", email = "tom.hengl@isric.org"),
  list(your_package = "speciesgeocodeR", your_version = "1.0-4", email = "alexander.zizka@bioenv.gu.se")
)

str <- paste0(readLines("revdep/email.md"), collapse = "\n")
lapply(pkgs, function(x)
  whisker::whisker.render(str, data = x)
)
