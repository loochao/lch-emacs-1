(TeX-add-style-hook "chaoo"
 (lambda ()
    (LaTeX-add-environments
     "outerlist"
     "lonelist"
     "innerlist")
    (TeX-add-symbols
     '("makeheading" 1)
     "blankline")
    (TeX-run-style-hooks
     "hyperref"
     "color"
     "lastpage"
     "fancyhdr"
     "paralist"
     "geometry"
     "includemp"
     "calc"
     "latex2e"
     "art10"
     "article"
     "10pt")))

