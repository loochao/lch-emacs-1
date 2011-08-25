NAME=tex-beamer-pu
SOURCE=$(NAME).tex

pdf: $(SOURCE)
	pdflatex $(NAME)
	pdflatex $(NAME)

clean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.org" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

extraclean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.org" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;
