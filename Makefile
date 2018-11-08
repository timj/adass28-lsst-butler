# Example makefile to help you compile your ADASS proceedings
# but you really should read the ManuscriptInstructions.pdf
#
# Version 27-oct-2018   Peter Teuben
#
# See also:  http://www.adass.org/instructions/ADASS2018.tar
#            http://adass2018.umd.edu/ADASS2018.tar
#
# P = paper_id,   your proceedings contribution code
# V = version,    your version # (1,2,..) since you can only upload unique files

                    # put your paper_id here (with dash, not dot)
                    # or find your template on http://www.astro.umd.edu/~teuben/adass/papers/
P = P13-7
                    # for testing; comment this line for your production version
# P = ADASS_template
                    # keep incrementing this after each upload of your $(P)
V = 2

#  variables for authors (comment out the ones you don't need)
# FIGS = P1-2_f1.eps   P1-2_f2.eps
FIGS = P13-7_f1.eps
# FIGS = example.eps

#  variables for editors (don't modify, for export, not authors)
YEAR   = 2018
TMPDIR = ADASS$(YEAR)_author_template
FILES  = AdassChecks.py AdassConfig.py AdassIndex.py ADASS_template.tex \
	 asp2014.bst asp2014.sty copyrightform.pdf example.bib example.eps \
	 Index.py manual2010.pdf ManuscriptInstructions.pdf PaperCheck.py \
	 README subjectKeywords.txt TexScanner.py \
	 adass2018.bib Makefile

#  probably don't change these either
TAR_FILE  = $(P)_v$(V).tar.gz
ZIP_FILE  = $(P)_v$(V).zip
FILES4TAR = $(P).tex $(P).bib $(FIGS)

all:	$(P).pdf tar

export:
	rm -rf $(TMPDIR)
	mkdir $(TMPDIR)
	cp -a $(FILES) $(TMPDIR)
	echo Created on `date` by `whoami`  > $(TMPDIR)/VERSION
	-git remote -v                     >> $(TMPDIR)/VERSION
	-git branch                        >> $(TMPDIR)/VERSION
	tar cf ADASS$(YEAR).tar $(TMPDIR)

# these targets are for most common unix systems, but YMMV. Modify if you need
# let the editors know you have a better way for the next 2019 ADASS team
# e.g.    latex ADASS_template; dvipdfm ADASS_template

$(P).pdf:  $(P).dvi $(FIGS)
	dvipdf $(P)

$(P).bib:                                  # bootstrap if you don't have one
	touch $(P).bib

$(P).dvi:  $(P).tex $(P).bib
	latex $(P)
	bibtex $(P)
	latex $(P)
	latex $(P)

pdf:
	pdflatex $(P)
	bibtex $(P)
	pdflatex $(P)
	pdflatex $(P)

clean:
	rm -f $(P).dvi $(P).bbl $(P).pdf

tar:
	tar zcf $(TAR_FILE) $(FILES4TAR)
	@echo Submit to ftp://ftp.astro.umd.edu/incoming/adass
	@echo e.g.   ncftpput ftp.astro.umd.edu  incoming/adass $(TAR_FILE)

zip:
	zip $(ZIP_FILE) $(FILES4TAR)
	@echo Submit to ftp://ftp.astro.umd.edu/incoming/adass
	@echo e.g.   ncftpput ftp.astro.umd.edu  incoming/adass $(ZIP_FILE)
