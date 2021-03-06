
<!-- README.md is generated from README.Rmd. Please edit that file -->
CDBNgenomics
============

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/Alice-MacQueen/CDBNgenomics.svg?branch=master)](https://travis-ci.org/Alice-MacQueen/CDBNgenomics) <!-- badges: end -->

The goal of CDBNgenomics is to allow for genome-wide association and other genomic work using genotype data for individuals from the Cooperative Dry Bean Nursery phenotypic dataset. It contains helper functions to visualize and analyze GAPIT GWAS results, to run mash analyses, and to visualize and analyze mash results using CDBN genotypic and phenotypic data. It also has the code necessary to replicate the analyses in the paper "Genetic Associations in Four Decades of Multi-Environment Trials Reveal Agronomic Trait Evolution in Common Bean".

Installation
------------

You can install the development version of CDBNgenomics from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Alice-MacQueen/CDBNgenomics")
```

### Installations for additional functionality

To use some of the optional functions in this package, you will need to install some additional packages, either from Bioconductor or from Github. The Bioconductor packages are needed to create dataframes containing annotation information.

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install(c("multtest", "GenomicFeatures", "GenomicRanges", 
                     "IRanges", "VariantAnnotation", "AnnotationDbi"))
```

mashr is needed **only** if you want to use the `mash_standard_run` function. It is not needed for any of the downstream plotting functions. *NB: mashr can only be installed on Linux or Mac operating systems. It cannot be installed on Windows systems.*

``` r
install.packages("devtools")
devtools::install_github("stephenslab/mashr@v0.2-11")
```

Some plotting functions also use the dots package, which allows you to specify more plotting arguments specific to each function.

``` r
devtools::install_github("lcolladotor/dots")
```

Obtaining the Genomic Information
=================================

The numerical genotype files, one for each chromosome, will also be downloaded when you install this R package. To use the numerical data in GAPIT, these files need to be unzipped from their .gz format and placed in a single directory. Currently, this data is in the package in the "data-raw/GAPIT\_Numerical\_format\_files" directory. Navigate to where you have installed the package and use the `gunzip` command on each file in this directory to unzip these files.

If you have trouble accessing this data, you can also download it from [The Texas Data Repository](https://doi.org/10.18738/T8/RTBTIR). This data will also need to be unzipped, as above, and placed in a single directory.

Using CDBNgenomics functions
----------------------------

Genome-Wide Association
-----------------------

``` r
library(CDBNgenomics)
## Example code to run GAPIT GWAS goes here
```

Annotations for Top Associations
--------------------------------

You can also use `gapit_table_topsnps` to create dataframes containing annotation information. To do this, first load the provided annotation information. Currently, this is version 2.1 of the annotation information for *Phaseolus vulgaris*.

If you have saved the gunzipped numerical files for GAPIT to your working directory, you would then run the following commands to load the annotation data:

``` r
library(AnnotationDbi)
library(VariantAnnotation)

txdb <- AnnotationDbi::loadDb(file = file.path("data-raw", "v2.1",
                                               "annotation", 
                                               "Pvulgaris_442_v2.1.gene.sqlite"))

anno_info <- read.table(file = file.path("data-raw", "v2.1", "annotation",
                                           "Pvulgaris_442_v2.1.annotation_info.txt"),
                          sep = "\t", fill = TRUE, header = TRUE)
Pv_kegg <- read.table(file = file.path("data-raw", "v2.1", "annotation",
                                         "commonbean_kegg.txt"),
                        sep = "\t", header = FALSE)
Pv_GO <- read.table(file = file.path("data-raw", "v2.1", "annotation",
                                       "commonbean_go.txt"),
                      sep = "\t", header = FALSE)
```

You can select a number of top SNPs to find annotation information for, a FDR threshold to find annotation information for, and any distance away from the associated SNP (in bp) for which to pull annotations. Here, we find genes in the 20kb and 100kb window surrounding the top 10 associations and all associations above a FDR of 10%.

``` r
anno_tables <- gapit_table_topsnps(df = gwas, n = 10, 
                                  FDRalpha = 0.1, rangevector = c(20000, 100000))
                                 
saveRDS(anno_tables, "Annotation_tables_example_gwas.rds")
```

This function will return a list of all of the tables you requested, named according to the criteria used to create the table. You can then save these tables individually as csv or any other type of file.

If the resultant tables are small, say, less than 2000 entries apiece, we favor saving these tables as individual sheets in an Excel file using the R package `XLConnect`.

``` r
library(XLConnect)

wb1 <- loadWorkbook(filename = "Annotation_tables_example_gwas.xlsx", 
                    create = TRUE)
for(j in seq_along(anno_tables)){
  createSheet(wb1, name = names(anno_tables)[j])
  writeWorksheet(wb1, anno_tables[[j]], sheet = names(anno_tables)[j])
  }
saveWorkbook(wb1)
```

Analysis of multiple phenotypes or planting locations
-----------------------------------------------------

To analyze whether effects of SNPs are similar or different for different phenotypes, the R package `mashr` can be used to conduct this kind of analysis, and downstream plotting functions in `CDBNgenomics` can be used to further visualize and interpret the results of this analysis.

After you run your GWAS using GAPIT, there are three steps to running a mash analysis. First, you must convert the GAPIT results to mashr input format. Second, you run the mash analysis. Third, you can visualize the mash results using `mashr` functions or using functions from `CDBNgenomics`.

### 1. Run the `gapit2mashr` function

Steps to do this are documented in the R package [gapit2mashr](https://github.com/Alice-MacQueen/gapit2mashr).

### 2. Run a standard mash analysis

Here, the input is the list object you obtained from `gapit2mashr()` in the previous step. Again, you can choose to save the output to a file in your path. You can optionally specify `numSNPs`, or if you are running this in a session where you don't have the output from `gapit2mashr()` in your environment, you can specify `numSNPs` equivalent to your `gapit2mashr()` run and this function will find the rds files it saved (on that path, with that number of SNPs) for you.

``` r
mash_output <- mash_standard_run(path = ".", list_input = mash_input, 
                                  numSNPs = numSNPs, saveoutput = TRUE)

# Or, if you are doing this in a new session and don't have mash_input 
#     in your workspace, you just need to enter the number of SNPs and this 
#     function will find a previously saved rds file with that numSNPs for you:
# mash_output <- mash_standard_run(path = ".", numSNPs = numSNPs,
#                                  saveoutput = TRUE)
```

### 3. Visualize mash output

You have a lot of options here, and some great ones (most importantly, `mash_plot_meta`) are already included in the `mashr` package.

However, this package adds a few additional options for viewing mash outputs.

#### 3a. Number of Significant SNPs per Number of Conditions

This plot can help answer questions like, "How many phenotypes do SNPs affect?"

``` r
nbycond <- mash_plot_sig_by_condition(m = mash_output)
nbycond$ggobject
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="70%" style="display: block; margin: auto;" />

#### 3b. Manhattan-esque plot ("Mashhattan")

This plot can help answer questions like, "What is the genomic distribution of SNPs with significant effects, and how many phenotypes do these SNPs affect?"

``` r
mashhattan <- mash_plot_manhattan_by_condition(m = mash_output)
#> Joining, by = "value"
mashhattan$ggmanobject
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="70%" style="display: block; margin: auto;" />

#### 3c. Pairwise sharing of similar effects

This plot can help answer questions like, "How many SNPs have similar effects between pairs of phenotypes?". As most analyses of pleiotropy typically only consider interactions between pairs of phenotypes, this plot is a useful extension of two-phenotype models.

If you saved the output of a `mash_standard_run()`, then you have saved two `get_pairwise_sharing()` outputs as rds objects already. All you need to do then is tell this function 1) the path to the RDS, for effectRDS; or 2) the correlation matrix you're using if it's an object in your environment, for corrmatrix.

``` r
pairwise_plot <- mash_plot_pairwise_sharing(effectRDS =                                      "data-raw/Pairwise_sharing_Strong_Effects_4000SNPs.rds",
                                            reorder = TRUE) 
#> Loading required namespace: dots
#> Scale for 'colour' is already present. Adding another scale for
#> 'colour', which will replace the existing scale.
pairwise_plot$gg_corr
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="70%" style="display: block; margin: auto;" />

#### 3d. Look at mash effect plots

This plot can help answer questions like, "What are the effects of a single SNP across multiple phenotypes?"

This will return ggplot objects for the effect plots for the `n`th significant SNP, ranked by the most significant local false sign rate. You can find the names of the top ten effects, for example, using `get_significant_results(m = mashoutput)[1:10]`.

Alternatively, if you have the row number of the SNP you want to plot (which you can find with `get_marker_df()`), you can put that in as `i`.

``` r
effects <- mash_plot_effects(m = mash_output, n = 1)
effects$ggobject +
    scale_x_discrete(labels = str_sub(as_vector(effects$effect_df$value), 
                                      start = 6)) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
#> Scale for 'x' is already present. Adding another scale for 'x', which
#> will replace the existing scale.
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="70%" style="display: block; margin: auto;" />
