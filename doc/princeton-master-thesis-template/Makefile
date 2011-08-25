
NAME=lch-pums-thesis
SOURCE=$(NAME).tex $(NAME).bib

#HELP FIXME
#hThe main target of this Makefile:
#h
#h	help:		instructions for each option.
#h	all:		dvi pdf clean, after make all, dvi and pdf will be generated
#h			but other dummy files will be cleaned.
#h	dvi:		dvi and necessary dummy files will be generated.
#h	pdf:		pdf and related dummy files will be generated.
#h	clean:		All the dummy files will be cleaned (dvi and pdf are targets, not dummy!)
#h	cleanall:	All the files except sources will be cleaned (dummy, dvi, and pdf)

#help:;	sed -n 's/^#h//p' < $(MAKEF)

all: dvi pdf clean

test:
	echo test

dvi: $(SOURCE)
	latex $(NAME)
	bibtex $(NAME)
	latex $(NAME)

pdf: $(SOURCE)
	pdflatex $(NAME)
	bibtex $(NAME)
	pdflatex $(NAME)

clean:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

cleanall:
	find -E . \( -name "*.aux" \
	          -o -name "$(NAME).*" \
                   ! -name "*.tex" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

#tar:
#	find . \( -name "*" ! -name $(NAME).tar.gz \) -exec tar -cvzf $(NAME)_`date +"%Y-%m-%d"`.tar.gz {} \;






