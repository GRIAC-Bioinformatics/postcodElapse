# Development

## Dev environment

### Set-up

To develop postcodElapse you need [Rstudio](https://posit.co/downloads)
and the git large file storage [(LFS)](https://git-lfs.com/) installed,
check their instructions. In addition you need the install the
R-packages below.

``` r

install.packages(c("usethis", "pkgdown", "roxygen2")) #devtools

install.packages(c("dplyr", "terra","sf", "rlang")) #required by postcodElapse

install.packages(c("tidyverse", "tidyterra", "ggpubr")) #used in the docs
```

### Cloning

When you’re done install clone:
`https://github.com/GRIAC-Bioinformatics/postcodElapse`, you must enable
lfs for the repo and pull the large file. See shell commands below.

``` bash
git lfs install

git lfs pull
```

This will download ELAPSE.tif it’s 125mb, too large for a normal commit
but required by postcodElapse. If you wish to work on the development
version switch to the `dev` branch.

### Building

Again if you are implementing new features or fixing bugs please work on
the `dev` branch. To quickly install the package in the Rstudio ribbon
navigate: Build \> Load All, this quickly loads the package into your R
session. Or you can use the keybind: `Control + Shift + L`.

To build the package fully in the ribbon: Build \> Install package or
use the `Control + Shift + B` keybind, this also updates any changed
documentation.

If you are done developing and wish to build postcodElapse for release
on GitHub. Run Build \> Build Source Package, this will create an
archive (.tar.gz or .zip) in the parent directory of the repo. This file
is the built package, add this file to the new release. Don’t forget to
merge dev to main, and update the documentation.

## Documentation

### In package

In package documentation is what you read when you run ?postcodElapse.
It is made using roxygen from the comment blocks above the function
definitions in the postcodElapse. See their
[page](https://roxygen2.r-lib.org/) on usage.

### GitHub pages

GitHub pages is where you find this article in addition to the more
expanded guide style documentation. This is made using `pkgdown`.
Creating new articles or vignettes is done with `usethis`, by running in
the R console
[`usethis::use_article()`](https://usethis.r-lib.org/reference/use_vignette.html)
or
[`usethis::use_vignette()`](https://usethis.r-lib.org/reference/use_vignette.html).
For usage refer to the [pkgdown](https://pkgdown.r-lib.org/) and
[usethis](https://usethis.r-lib.org/) documentation.

Building the and viewing the site locally can be done by running
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html).
To publish the documentation on GitHub pages run
[`pkgdown::deploy_to_branch()`](https://pkgdown.r-lib.org/reference/deploy_to_branch.html)
and wait till GitHub fully deploys the page.
