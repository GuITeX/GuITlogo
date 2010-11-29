PACKAGE = guit
EXAMPLE = guittest

FILE = README $(addsuffix .dtx,$(PACKAGE)) $(addsuffix .ins,$(PACKAGE)) \
	$(addsuffix .pdf,$(PACKAGE)) $(addsuffix .pdf,$(EXAMPLE))

DIRECTORY = GuITlogo

.PHONY: all clean clobber distro

all: $(addsuffix .sty,$(PACKAGE)) $(addsuffix .pdf,$(PACKAGE)) \
	$(addsuffix .tex,$(EXAMPLE)) $(addsuffix .pdf,$(EXAMPLE))

%.sty: %.dtx
	tex $*.ins

$(addsuffix .pdf,$(PACKAGE)): %.pdf: %.dtx %.sty
	pdflatex $<
	pdflatex $<
	makeindex -s gind.ist $*
	makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<

%.tex: $(addsuffix .dtx,$(PACKAGE))
	tex $(addsuffix .ins,$(PACKAGE))

$(addsuffix .pdf, $(EXAMPLE)): %.pdf: %.tex $(addsuffix .sty,$(PACKAGE))
	pdflatex $<
	pdflatex $<

clean:
	rm -fv *~ *.aux *.glo *.gls *.idx *.ilg *.ind *.log *.out *.toc

clobber: clean
	rm -fv *.cfg *.sty *.tex *.zip

distro: $(addsuffix .zip,$(DIRECTORY))

$(addsuffix .zip,$(DIRECTORY)): %.zip: $(FILE)
	rm -rf $* $@
	mkdir $*
	cp -a $^ $*
	zip -9v $@ $*/*
	rm -rf $*
