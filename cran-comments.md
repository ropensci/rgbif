R CMD CHECK passed on my local OS X install on R 3.1.2 and R development 
version, Ubuntu running on Travis-CI, and Win builder.

This submission is in response to the request from Brian Ripley about
fixing problems with examples wrapped in \donttest. I have moved all
examples to be wrapped in \dontrun because all call web APIs.

Note that CRAN checks may fail on Mavericks because there appears to be
no Mavericks binaries available for two dependencies: rgdal and rgeos.

Thanks! Scott Chamberlain
