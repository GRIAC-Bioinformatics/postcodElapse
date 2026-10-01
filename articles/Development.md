# Development

## Dev environment

### Set-up

To develop postcodElapse you need Rstudio and the git large file storage
[(LFS)](https://git-lfs.com/) plugin installed. Check their instructions
or use your package manager of choice. In addition you need the install
following R-packages:
`usethis, pkgdown, roxygen, dplyr, terra, sf, rlang`. Most are
dependences for postcodElapse usethis, pkgdown & roxygen are for
development.

### Cloning the repo

When you’re done install clone the
[repo](https://github.com/GRIAC-Bioinformatics/postcodElapse), you must
enable lfs for the repo and pull the large file. See shell commands
below.

``` bash
git lfs install

git lfs pull
```

This will download ELAPSE.tif it’s 125mb, too large for a normal commit
but necessary for postcodElapse. If you wish to work on the development
version switch to the `dev` branch.

### Building

Again if you are implementing new features or fixing bugs please work on
the `dev` branch. To quickly install the package in the Rstudio ribbon
navigate: Build \> Load All, this quickly loads the package into your R
session. Or you can use the keybind: `Control + Shift + L`.

This does not build the documentation to do that build the package:
Build \> Install package or `Control + Shift + B`.

If you are done developing and wish to build postcodElapse for release
on GitHub. Run Build \> Build Source Package, this will create an
archive (.tar.gz or .zip) in the parent directory of the repo. This file
is the built package, add this file to the new release.

## Creating documentation

### In package

In package documentation is what you read when you run ?postcodElapse.
It is made using roxygen from the comment blocks above the function
definitions in the package. See their
[page](https://roxygen2.r-lib.org/) on how to use.

### GitHub pages

GitHub pages is where you found this article in addition to the more
expanded guide style documentation. This is made using `pkgdown`.
Creating new articles or vignettes is done with `usethis`, by running in
the R console
[`usethis::use_article`](https://usethis.r-lib.org/reference/use_vignette.html)
or
[`usethis::use_vignette`](https://usethis.r-lib.org/reference/use_vignette.html).

Building the site locally can be done by running
[`pkgdown::build_site`](https://pkgdown.r-lib.org/reference/build_site.html).
To publish the documentation first push your changes to the repo. Then
run `pkdown::deploy_to_branch()`, and wait for github to deploy the
page. You can check it’s status in the
[deploments](https://github.com/GRIAC-Bioinformatics/postcodElapse/deployments).
