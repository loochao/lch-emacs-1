Hunspell spell checker, morphological analyzer and stemmer

Windows binary distribution

Common usage (in Windows command window)
----------------------------------------

hunspell -d en_US

(Type words and press enter, the "*", "+" and "-" output mean accepted words,
"&" and "#" mean rejected words. Exit: press Ctrl-z and enter in an empty line.)

Encoding problems on Windows
----------------------------

Use input and output redirection to solve encoding problems
of the Windows platform:

Edit your input.txt with the requested character encoding (it's the
same encoding as the encoding of the Hunspell dictionary), and run

hunspell -d dic < input.txt > output.txt

notepad output.txt

Spell checking is faster listing only
the bad words with the option -l:

hunspell -l -d dic < input.txt > badwords.txt

Files
-----

hunspell.exe    Hunspell spell checker
hzip.exe        dictionary compressor
hunzip.exe      dictionary decompressor
manual1.pdf     manual page (hunspell)
manual4.pdf     manual page (hunspell dictionary format)
en_US.aff,dic   American English dictionary (see README_en_US.txt)

Source distribution: http://hunspell.sourceforge.net

Myspell & Hunspell dictionaries:
http://wiki.services.openoffice.org/wiki/Dictionaries

Copyright (C) 2002-2008 László Németh. License: MPL/GPL/LGPL.

Based on OpenOffice.org's Myspell library.
Myspell's copyright (C) Kevin Hendricks, 2001-2002, License: BSD.

This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE,
to the extent permitted by law.

László Németh
<nemeth AT OpenOffice DOT org>
