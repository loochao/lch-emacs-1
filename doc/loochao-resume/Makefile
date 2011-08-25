NAME=loochao-resume
SOURCE=$(NAME).tex
DATE=$(shell date +%y%m%d)
pdf: $(SOURCE)
	pdflatex $(NAME)
	pdflatex $(NAME)
	mv $(NAME).pdf $(NAME)-$(DATE).pdf

clean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

extraclean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;
