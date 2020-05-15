## Repository for Vsat submission to SPLC 2020


### Layout
- data for plots in the paper are in `data` directory
- statistics scripts in the `statistics` directory
  - we also provide Rmarkdown files to provide a walkthrough of the analysis
- Complete inference rules available in `rules.pdf` file
- We provide `*.nix` files in the `nix` directory, which pin the development
  environment used in the benchmarks and analysis to specific commits of
  `nixpkgs`. This allows researchers to create a development environment
  identical to the one used in this paper for both the `vsat` tool and for the
  statistics scripts, in a `nix-shell`; Use `nix-shell shell.nix` for the
  Haskell environment, and `nix-shell R.nix` for the `R` environment


### The Vsat tool
You can find version of Vsat for this paper [here](https://github.com/doyougnu/VSat).

#### Benchmarking
Run a benchmark using stack + gauge,e.g., `stack bench vsat:auto --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv`

Add a `csvraw` argument to get the bootstrapped averages _and_ the raw measurements from gauge:
`stack bench vsat:auto --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv --csvraw raw-output.csv`


The available benchmarks are listed benchmark targets in `package.yaml` in the vsat Haskell project:
  - run the automotive dataset
    - `stack bench vsat:auto --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the financial dataset: `stack bench vsat:fin --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the core/dead on auto: `stack bench vsat:auto-dead-core --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the core/dead on fin: `stack bench vsat:fin-dead-core --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run variational model diagnostics on fin: `stack bench vsat:fin-diag --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run variational model diagnostics on auto: `stack bench vsat:auto-diag --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`

To retrieve the counts of sat vs unsat models you can count the disjuncted
clauses in the resulting variational model. The papers cited in the paper come
from a branch which only counted the outputs of the solver. This branch is
called `SatUnsatCounting` in the vsat project github cited above.

#### Processing data
We make available a julia script called `parseRaw.jl` to process the `csv` files
from the benchmarking. You'll have to edit the input and output of it by hand.
If you run it on data generated with `csvraw` you'll need to change `:Name` to
`:name` or vice versa. We do not provide a `.nix` file for the julia script
because at the time of this writing Julia has not solidified their packaging
process enough for `nix` to reproduce it in a pure, functional way. If needed,
the `csv`s can be parsed in `R` or your language of choice.
