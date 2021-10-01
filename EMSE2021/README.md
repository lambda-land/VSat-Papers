## Repository for Vsat submission to EMSE 2021


### Repository Layout
- data for plots in the paper are in `munged_data` directory
- variational models for the void, dead and core analyses are in `munged_data` directory as `json` files
- We provide several files in the spirit of [reproducible
  research](https://en.wikipedia.org/wiki/Reproducibility#Reproducible_research),
  such that other researchers can not only reproduce our analysis but reproduce
  _the exact environment_ of our analysis. This is done in several ways:
    - the `*.nix` files in the `nix` directory, pin the development environment
      used in the benchmarks and analysis to specific commits of `nixpkgs` which
      are dated for the time of publication. This allows researchers to create a
      development environment identical to the one used in this paper for both
      the `vsat` tool and for the statistics scripts, in a `nix-shell`; Use `>
      nix-shell R.nix` for the `R` environment. To reproduce the haskell
      environment we rely on the `stack` built tool
    - We provide the source code R scripts used in our evaluation in the
      `statisticsScripts` directory. The scripts are heavily commented.
    - The vsat tool can be built using either `cabal`, `stack`. Both allow a
      reproduction of the tool down to the library and compiler version. We
      provide the `vsat.cabal` file, `package.yaml, and stack.yaml`. We
      recommend `stack` for most cases because it pins the package set to a
      specific package set, whereas `cabal` uses the package set present on the
      user's computer.


### The Vsat tool
You can find the version of Vsat for this paper
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
3. You'll need to install `haskell`, `stack` and `cabal` to run the tool.
   Please see the repository from 1, with instructions for your OS.
4. Ensure you have the needed dependencies installed by running: `stack
   --version` (stack), `ghc -v` (haskell), `cabal --help` (cabal)
5. Ensure you have `z3` installed by running `z3 -h`, `vsat` requires `z3`
   version 4.8.7 or greater. If you using a different base solver than ensure
   you have it on your `$PATH` just like `z3` in the previous example.
6. Ensure you can build `vsat` from source by running:
   `stack build`
7. If 6, did not result in an error then you should be able to run any command
   in the next section without issue


#### Benchmarking
Run a benchmark using stack + gauge,e.g., `stack bench vsat:auto
--benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv`

Add a `csvraw` argument to get the bootstrapped averages _and_ the raw
measurements from gauge: `stack bench vsat:auto --benchmark-arguments='+RTS -qg
-A64m -AL128m -n8m -RTS --csv output-file.csv --csvraw raw-output.csv`


The available benchmarks are listed benchmark targets in `package.yaml` in the vsat Haskell project:
  - run the automotive dataset
    - `stack bench vsat:auto --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`
  - run the financial dataset
    - `stack bench vsat:fin --benchmark-arguments='+RTS -qg -A64m -AL128m -n8m -RTS --csv output-file.csv'`

You can inspect the source code for each benchmark in the
`bench/AutoBench/Main.hs` and `bench/Financial/Main.hs` files. Configurations
for the benchmarks are in `bench/Core.hs`. These benchmarks will a _long_ time
to finish as they are setup to run the analysis for several base solvers. Please
comment out specific items in `defaultMainWith ...` in the `AutoBench/Main.hs`
and `Financial/Main.hs` files if you do not want this to occur.

To retrieve the counts of sat vs unsat models you can count the disjuncted
clauses in the resulting variational model. The numbers cited in the paper come
from a branch which altered the benchmark source code to count the outputs of
the solver. This branch is called `SatUnsatCounting` in the vsat project github
cited above.

#### Processing data
We make available a julia script called `parseRaw.jl` to process the `csv` files
from the benchmarking. You'll have to edit it by hand for your needs. If you run
it on data generated with `csvraw` you'll need to change `:Name` to `:name` or
vice versa. We do not provide a `.nix` file for the julia script because at the
time of this writing Julia has not solidified their packaging process enough for
`nix` to reproduce it in a pure, functional way. If needed, the `csv`s can be
parsed in `R` or `awk` or some other language of your choice.
