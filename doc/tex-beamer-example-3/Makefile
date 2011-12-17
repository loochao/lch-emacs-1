NAME=main
HEAD=slide handout article
SLIDE=slide
ARTICLE=article
HANDOUT=handout
SOURCE=$(NAME).tex
ALLSOURCE=$(HEAD) $(NAME)

all: slide article handout clean

slide: $(SOURCE)
	@pdflatex $(SLIDE)
	@pdflatex $(SLIDE)

article: $(SOURCE)
	@pdflatex $(ARTICLE)
	@pdflatex $(ARTICLE)

handout: $(SOURCE)
	@pdflatex $(HANDOUT)
	@pdflatex $(HANDOUT)

test:
	echo "slide.* article.* handout.* main.*"

clean: slideclean articleclean handoutclean
slideclean:
	@find -E . \( -name "*.aux" \
		-o -name "slide.*"\
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.org" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

articleclean:
	@find -E . \( -name "*.aux" \
		-o -name "article.*"\
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.org" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;

handoutclean:
	@find -E . \( -name "*.aux" \
		-o -name "handout.*"\
                   ! -name "*.pdf" \
                   ! -name "*.dvi" \
                   ! -name "*.tex" \
                   ! -name "*.sty" \
                   ! -name "*.org" \
                   ! -name "*.cls" \
                   ! -name "*.bib" \) \
            -exec rm -rf {} \;
