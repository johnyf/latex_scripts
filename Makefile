# Typesetting documents
#
# There are 3 main recipes in this file:
#
#   1. full (3 compiles, 1 bib, last build with SyncTeX)
#   2. sync (1 compile, SyncTeX)
#
# Copyright 2010-2017 by Ioannis Filippidis
# All rights reserved. Licensed under BSD.

#comma:=
#empty:=
#space:= $(empty) $(empty)
#aux_dir_log := $(subst $(space),$(comma),$(aux_dir_log))

main_file := $(wildcard *_main.tex)
main_file := $(subst .tex,,$(main_file))
ifeq ("$(main_file)","")
$(warning !!!!!!!!)
$(warning No LaTeX file that ends with "_main.tex")
$(warning !!!!!!!!)
endif

aux_dir := ./auxdir

UNAME := $(shell uname)

# 3 compiles, 1 bib-compile
full:

ifeq ($(UNAME), Linux)
	make full_texlive
	copylog
endif

ifeq ($(UNAME), Darwin)
	make full_texlive_mac
endif

full_texlive:
	echo "TeXLive on Linux (full)"
	xelatex --interaction=nonstopmode --shell-escape $(main_file).tex

	@for i in ./$(aux_dir)/$(main_file)[1-9]*.aux;\
  	do \
  		echo "Bilbliography of $$i";\
		bibtex $$i;\
  	done

	xelatex --interaction=nonstopmode --shell-escape $(main_file).tex
	xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex
	cp $(aux_dir)/$(main_file).pdf ./$(main_file).pdf

full_texlive_mac:
	echo "TeXLive on Mac (full)"
	xelatex --interaction=nonstopmode --shell-escape $(main_file).tex

	@for i in ./$(main_file)[1-9]*.aux;\
  	do \
  		echo "Bilbliography of $$i";\
		bibtex $$i;\
  	done

	xelatex --interaction=nonstopmode --shell-escape $(main_file).tex
	xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex
	# fix lack of auxdir
	-tex_hide_aux.sh

sync:
	echo "Compile once using SyncTeX"

ifeq ($(UNAME), Linux)
	openout_any=a \
	xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex
endif

ifeq ($(UNAME), Darwin)
	openout_any=a \
	time xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex
	@printf "\n\n"
	-@tex_hide_aux.sh > /dev/null
endif


# pytex: all of it
pytex:
	make temp
	make pythontex
	make temp

# pythontex: experimental
pythontex:
	-pythontex2.py $(main_file).tex

# other, secondary stuff
copylog:
	cp $(aux_dir)/$(main_file).log ./$(main_file).log

bib:
	bibtex ./$(main_file).aux

biblatex:
	biber $(main_file)


clean:
	-rm -f *.aux *.blg *.log *.bcf *.bbl *.lof *.tdo *.lot *.out *.toc *.synctex.gz
	-rm -f -r ./auxdir/*
	-rm -f ./tex/*.aux
	# some PDF files may be sources, so not `*.pdf`
	-rm -f ./img/*.pdf_tex

clean_cache:
	-rm -f .tla2tex/*.tla .tla2tex/*.tex
