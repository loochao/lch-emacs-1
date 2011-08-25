NAME1=loochao-tex-chs
SOURCE1=$(NAME).tex

NAME2=loochao-tex-chs2
SOURCE2=$(NAME).tex

pdf: $(SOURCE)
	xelatex  $(NAME1)
	pdflatex $(NAME2)

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
