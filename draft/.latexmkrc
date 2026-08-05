# .latexmkrc configuration
$silent = 1;
$pdf_mode = 1;
$pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode %O %S';
$bibtex_use = 2;
push @generated_exts, 'bbl', 'run.xml', 'snm', 'nav', 'fls', 'fdb_latexmk';
$preview_mode = 1;
