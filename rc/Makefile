prefix=
EMACS=/Applications/Documents/Emacs.app/Contents/MacOS/Emacs

BATCH=${EMACS} -q -batch -no-site-file

ELC=${BATCH} -f batch-byte-compile

BATCHED=${BATCH} -eval

test:
	$(BATCH) --eval "(goto-char (point-min))" \
		--eval '(insert "test")' \
		lch-outline.el
