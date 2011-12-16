EMACS=/Applications/Documents/Emacs.app/Contents/MacOS/Emacs

BATCH=${EMACS} -q -batch -no-site-file

ELC=${BATCH} -f batch-byte-compile

BATCHED=${BATCH} -eval

test:
	$(BATCH) '(setq enable-local-variables :all)' \
          General_Exam.org \
          -f org-export-as-latex \
          -f save-buffers-kill-emacs

NAME=111209_GroupMeeting
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
