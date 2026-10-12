# Development

## Dev environment

### Set-up

To develop postcodElapse, Rstudio with the git large file storage (LFS)
installed is required. [Instructions can be found
here](https://git-lfs.com/). In addition, the following R packages are
required:

``` r

install.packages(c("usethis", "pkgdown", "roxygen2")) #devtools

install.packages(c("dplyr", "terra","sf", "rlang")) #required by postcodElapse

install.packages(c("tidyverse", "tidyterra", "ggpubr")) #used in the docs
```

### Cloning

After installing all the dependencies, clone:
<https://github.com/GRIAC-Bioinformatics/postcodElapse>. Make sure to
enable git LFS for the repo and pull the large file, see shell commands
below.

``` bash
git lfs install

git lfs pull
```

This will download the 125MB ELAPSE.tif. Although it is too large for a
normal commit, it is required by postcodElapse. If preferred, you can
switch to the dev branch.

### GeoPackages

Finally create a directory named: `data` in the parent directory of the
postcodElapse repo. Download and place into the data dir both supported
GeoPackages links below:

1.  [BAG (Basisregistratie Adressen en
    Gebouwencontains)](https://service.pdok.nl/lv/bag/atom/bag.xml) for
    every building in the Netherlands the location and postal code.
    Package size 8GB

2.  [PC6
    (Postcode6)](https://service.pdok.nl/cbs/postcode6/atom/postcode6_volledige_postcode.xml)
    provides the geographic area for every Dutch postal code. Package
    size 0.5GB

These are used in the documentation. When setup correct everything
should match the the directory tree below:

    ./development
    ├── data
    │   ├── bag-light.gpkg
    │   └── cbs_pc6_2024.gpkg
    └── postcodElapse
        ├── data-raw
        │   └── sample_postcodes.R
        ├── DESCRIPTION
        ├── inst
        │   ├── ELAPSE.tif
        │   └── extdata
        │       ├── postcode1000.rds
        │       └── postcode100.rds
        ├── LICENSE.md
        ├── man
        │   ├── coord_zoomFeature.Rd
        │   ├── formatPostcode.Rd
        │   ├── geom_rectFeature.Rd
        │   ├── loadElapse.Rd
        │   ├── pollutionFromBag.Rd
        │   ├── pollutionFromPc6.Rd
        │   └── postcodElapse.Rd
        ├── NAMESPACE
        ├── _pkgdown.yml
        ├── postcodElapse.Rproj
        ├── R
        │   ├── extraction.R
        │   ├── helpers.R
        │   └── plotting.R
        ├── README.md
        └── vignettes
            ├── articles
            │   ├── Development.Rmd
            │   └── Spacial-plotting.Rmd
            ├── postcodElapse.Rmd
            └── postcodElapse.Rmd.orig

    10 directories, 26 files

### Building

When implementing new features or fixing bugs, make sure to work on the
dev branch. To quickly install the package in the Rstudio ribbon,
navigate to: *Build \> Load All*. This will quickly load the package
into the current R session. Alternatively, use the keybind:
`Control + Shift + L`.

Again if you are implementing new features or fixing bugs please work on
the `dev` branch. To quickly install the package in the Rstudio ribbon
navigate: Build \> Load All, this quickly loads the package into your R
session. Or you can use the keybind: `Control + Shift + L`.

To fully build the package in the ribbon: *Build \> Install package* or
use the `Control + Shift + B` keybind. , This will also update any
changed documentation.

After finishing developing, to build postcodElapse for release on
GitHub, use: *Run Build \> Build Source Package*. This will build
package as an archive (.tar.gz or .zip) in the parent directory of the
repo. Add this file as new release to GitHub. Don’t forget to merge dev
to main and update the documentation.

## Documentation

### In package

The package documentation is used for ?postcodElapse in R. It is created
with roxygen from the comment blocks above the function definitions in
the postcodElapse. See their [page](https://roxygen2.r-lib.org/) for
user information.

### GitHub pages

More expanded guide style documentation can be found on the GitHub
pages. This is created using *pkgdown*. Creating new articles or
vignettes can be done with *usethis*, running in the R console
[`usethis::use_article()`](https://usethis.r-lib.org/reference/use_vignette.html)
or
[`usethis::use_vignette()`](https://usethis.r-lib.org/reference/use_vignette.html).
User information can be found in the
[pkgdown](https://pkgdown.r-lib.org/) and
[usethis](https://usethis.r-lib.org/) documentation.

Local building and viewing can be done by running
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html).
To publish the documentation on GitHub pages, run
[`pkgdown::deploy_to_branch()`](https://pkgdown.r-lib.org/reference/deploy_to_branch.html)
and wait until GitHub fully deploys the page.
