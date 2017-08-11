# XeTeX makefile by Ioannis Filippidis (BSD) 2010 - 2013
#
# help
#	There are 3 options in this file:
#		1) full (3 compiles, 1 bib, no sync)
#		2) sync (1 compile, sync)
#		3) temp (1 compile, no sync)
#
#	Editing makes sense mostly towards the end, where
#	the single-compile commands are
#	(these are called by everything else)
#
# usage
#	make full, or
#	make sync, or
#	make temp
#
# tip
#	in TeXstudio configure:
#		F1 = make sync
#		F2 = make paperbib
#		F5 = make full
#		F12 = make junctions


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

# single compile with synctex
sync:
	echo "Temporary (single compile): with SyncTeX"

ifeq ($(UNAME), Linux)
	make texlive_temp_sync
endif

ifeq ($(UNAME), Darwin)
	make texlive_temp_mac_sync
endif

texlive_temp_sync:
	echo "TeXLive on Linux: single compile and SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex

texlive_temp_mac_sync:
	echo "TeXLive on Mac: single compile and SyncTeX"
	time xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex

	@printf "\n\n"
	-@tex_hide_aux.sh > /dev/null

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

paperbib:

ifeq ($(UNAME), Linux)
	bibtex ./$(main_file).aux
endif

ifeq ($(UNAME), Darwin)
	bibtex ./$(main_file).aux
endif

clean:
	-rm -f *.aux *.blg *.log *.bbl *.lof *.tdo *.lot *.out *.toc *.synctex.gz
	-rm -f -r ./auxdir/*
	-rm -f ./tex/*.aux
	# some PDF files may be sources, so not `*.pdf`
	-rm -f ./img/*.pdf_tex
