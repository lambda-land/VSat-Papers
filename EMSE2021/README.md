## Repository for Vsat submission to EMSE 2021


### Repository Layout
- data for plots in the paper are in `data` directory
- variational models for the void, dead and core analyses are in `data` directory as `json` files
- Complete [inference rules](https://github.com/lambda-land/VSat-Papers/blob/master/SPLC2020/rules/rules.pdf) available in `rules.pdf` file in the `rules` directory
- We provide several files in the spirit of [reproducible
  research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research),
  such that other researchers can not only reproduce our analysis but reproduce
  _the exact environment_ of our analysis. This is done in several ways:
    - the `*.nix` files in the `nix` directory, pin the development environment
      used in the benchmarks and analysis to specific commits of `nixpkgs` which
      are dated for the time of publication. This allows researchers to create a
      development environment identical to the one used in this paper for both
      the `vsat` tool and for the statistics scripts, in a `nix-shell`; Use `>
      nix-shell shell.nix` for the Haskell environment, and `> nix-shell R.nix`
      for the `R` environment
    - We provide the source code R scripts used in our evaluation in the
      `statistics/scripts` directory
    - We provide RMarkdown files and the resulting `pdf` files to walk other
      researchers through the analysis. Compiling to a pdf not only archives the
      analysis but also the code used for the analysis
    - The vsat tool can be built using either `cabal`, `stack` or `nix`. All
      three allow a reproduction of the tool down to the library and compiler
      version. We provide the `vsat.cabal` file, `package.yaml, and stack.yaml`
      and `nix/release.nix` such that the tool can be rebuilt. We recommend
      `stack` for most cases


### The Vsat tool
You can find version of Vsat for this paper
[here](https://github.com/doyougnu/VSat). To run the tool:
1. Clone the repository, i.e., `git clone https://github.com/doyougnu/VSat`
2. If you are using `nix` un-comment the following in `stack.yaml`:
   ```
   # ## uncomment the following lines to tell stack you are in a nix environment
   # nix:
   #   enable: true
   #   pure: true
   #   # packages: [ z3, pkgconfig, zlib, abc-verifier, cvc4, yices, boolector, haskellPackages.hoogle haskellPackages.hasktags]
   #   packages: [ z3, pkgconfig, zlib ]
   ```
   if not then do not change `stack.yaml`
3. You'll need to install `haskell`, `stack` and `cabal` to run the tool, if you
   are using `nix` these derivations will be built for you with a nix-shell.
   Please see the repository from 1, with instructions for your OS.
4. Ensure you have the needed dependencies installed by running: `stack
   --version` (stack), `ghc -v` (haskell), `cabal --help` (cabal)
5. Ensure you have `z3` installed by running `z3 -h`, `vsat` requires `z3`
   version 4.8.7 or greater.
6. Ensure you can build `vsat` from source by running:
   `stack build`
7. If 6, did not result in an error then you should be able to run any command
   in the next section without issue


#### Benchmarking
Run a benchmark using stack + gauge,e.g., `stack bench vsat:auto
--benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv`
If you are not using `nix` or `nixOs` you'll need to change the `nix` option in
`stack.yaml` and set `enable: false`

Add a `csvraw` argument to get the bootstrapped averages _and_ the raw
measurements from gauge: `stack bench vsat:auto --benchmark-arguments='+RTS -qg
-A64m -AL128m -n8m -RTS --csv output-file.csv --csvraw raw-output.csv`


The available benchmarks are listed benchmark targets in `package.yaml` in the vsat Haskell project:
  - run the automotive dataset
    - `stack bench vsat:auto --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the financial dataset
    - `stack bench vsat:fin --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the core/dead on auto
    - `stack bench vsat:auto-dead-core --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the core/dead on fin
    - `stack bench vsat:fin-dead-core --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run variational model diagnostics on fin:
    - `stack bench vsat:fin-diag --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run variational model diagnostics on auto:
    - `stack bench vsat:auto-diag --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`

To retrieve the counts of sat vs unsat models you can count the disjuncted
clauses in the resulting variational model. The numbers cited in the paper come
from a branch which altered the benchmark source code to count the outputs of
the solver. This branch is called `SatUnsatCounting` in the vsat project github
cited above.

#### Processing data
We make available a julia script called `parseRaw.jl` to process the `csv` files
from the benchmarking. You'll have to edit the input and output of it by hand.
If you run it on data generated with `csvraw` you'll need to change `:Name` to
`:name` or vice versa. We do not provide a `.nix` file for the julia script
because at the time of this writing Julia has not solidified their packaging
process enough for `nix` to reproduce it in a pure, functional way. If needed,
the `csv`s can be parsed in `R` or your language of choice.
