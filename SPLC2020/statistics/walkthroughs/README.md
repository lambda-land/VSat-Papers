## Walkthroughs for the analysis in R

Please find each walkthrough `pdf` describing the analysis already compiled for
your convenience. If you would like to setup the same development environment to
tinker with the analysis scripts or data you'll need to construct a `nix-shell`.
We have written the `nix` files for you, the workflow is:

```
$ nix-shell ../../nix/R.nix ## load the pinned R environment
## Now in the right environment, build the pdf via rmarkdown
[nix-shell:~/Research/VSat-Papers/SPLC2020/statistics/walkthroughs]$ R -e "library(rmarkdown); render(\"rq1_rq3.Rmd\", output_format = \"pdf_document\")"
## or run the script as a batch process
[nix-shell:~/Research/VSat-Papers/SPLC2020/statistics/walkthroughs]$ Rscript ../scripts/sigTest.R
## or open an R interpreter, then load with source("...file...of..interest")
[nix-shell:~/Research/VSat-Papers/SPLC2020/statistics/walkthroughs]$ R
```
