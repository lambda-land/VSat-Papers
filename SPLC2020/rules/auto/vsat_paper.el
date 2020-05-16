(TeX-add-style-hook
 "vsat_paper"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("acmart" "sigconf")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (TeX-run-style-hooks
    "latex2e"
    "Vsat_Impl_accumulation_rules"
    "Vsat_Impl_evaluation_rules"
    "Vsat_Impl_solve_choices"
    "acmart"
    "acmart10"
    "booktabs"
    "subcaption"
    "caption"
    "listings"
    "enumitem"
    "kantlipsum"
    "amsmath"
    "tikz"
    "xcolor"
    "paperCommands"
    "lambda"
    "cc"
    "mathpartir"
    "amsthm"
    "multirow"
    "array")
   (TeX-add-symbols
    '("FM" 1)
    '("Lx" 1)
    '("singleton" 1)
    '("mdl" 1)
    '("featMF" 1)
    "BibTeX"
    "unit"
    "fmf"
    "fmfT"
    "fmfF"
    "mdls"
    "SatVar"
    "SatModel"
    "Satfmf"
    "fls"
    "tru"
    "dimd"
    "LNot"
    "FMNot"
    "LOne"
    "FMOne"
    "LTwo"
    "FMTwo"
    "Fmitigate"
    "Fspectre"
    "Fnospec"
    "Flone"
    "Fpti")
   (LaTeX-add-labels
    "impl:accum"
    "impl:choice-eval"))
 :latex)

