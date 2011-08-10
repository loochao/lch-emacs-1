NAME=loochao-emacs-cheat-sheet
SOURCE=$(NAME).tex

pdf: $(SOURCE)
	pdflatex $(NAME)

clean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

extraclean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;
