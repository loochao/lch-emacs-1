NAME=tex-article
SOURCE=$(NAME).tex

all: pdf clean

pdf: $(SOURCE)
	pdflatex $<
	pdflatex $<

clean:
	@find -E . \( -name "*.aux" \
	           -o -name "tex-book.*" \
	           -o -name "tex-article.*" \
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
