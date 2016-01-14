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

# todo
#	add some kind of warning if no _main file is detected

#comma:=
#empty:=
#space:= $(empty) $(empty)
#aux_dir_log := $(subst $(space),$(comma),$(aux_dir_log))

main_file := $(wildcard *_main.tex)
main_file := $(subst .tex,,$(main_file))

aux_dir := ./auxdir

UNAME := $(shell uname)

# 3 compiles, 1 bib-compile
full:
ifeq ($(UNAME), CYGWIN_NT-5.1)
	make full_miktex
	copylog
endif

ifeq ($(UNAME), Linux)
	make full_texlive
	copylog
endif

ifeq ($(UNAME), Darwin)
	make full_texlive_mac
endif

full_miktex:
	echo "MikTeX (full)"
	make miktex_temp
	
	@for i in ./$(aux_dir)/$(main_file)[1-9]*.aux;\
  	do \
  		echo "Bilbliography of $$i";\
		bibtex $$i;\
  	done
	
	make miktex_temp
	make miktex_temp

full_texlive:
	echo "TeXLive on Linux (full)"
	make texlive_temp
	
	@for i in ./$(aux_dir)/$(main_file)[1-9]*.aux;\
  	do \
  		echo "Bilbliography of $$i";\
		bibtex $$i;\
  	done

	make texlive_temp
	make texlive_temp
	cp $(aux_dir)/$(main_file).pdf ./$(main_file).pdf

full_texlive_mac:
	echo "TeXLive on Mac (full)"
	make texlive_temp_mac
	
	@for i in ./$(main_file)[1-9]*.aux;\
  	do \
  		echo "Bilbliography of $$i";\
		bibtex $$i;\
  	done

	make texlive_temp_mac
	make texlive_temp_mac

# single compile with synctex
sync:
	echo "Temporary (single compile): with SyncTeX"
	
ifeq ($(UNAME), CYGWIN_NT-5.1)
	make miktex_temp_sync
	make copylog
endif

ifeq ($(UNAME), Linux)
	make texlive_temp_sync
endif

ifeq ($(UNAME), Darwin)
	make texlive_temp_mac_sync
endif

# single compile w/o synctex
temp:
	echo "Temporary (single compile): w/o SyncTeX"
	
ifeq ($(UNAME), CYGWIN_NT-5.1)
	make miktex_temp
	make copylog
endif
	
ifeq ($(UNAME), Linux)
	make texlive_temp
endif
	
ifeq ($(UNAME), Darwin)
	make texlive_temp_mac
endif

# The various single compiles (w, w/o sync) for different OS (edit mainly here)

# MikTeX on Windows
miktex_temp:
	echo "MikTeX: single compile, no SyncTeX"
	xelatex --interaction=nonstopmode -shell-escape --output-directory=$(aux_dir) $(main_file).tex

miktex_temp_sync:
	echo "MikTeX: single compile and SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape --aux-directory=$(aux_dir) --synctex=1 $(main_file).tex

# TeXLive on Linux
texlive_temp:
	echo "TeXLive on Linux: single compile, no SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape --output-directory=$(aux_dir) $(main_file).tex
	
	# fix lack of auxdir
	cp $(aux_dir)/$(main_file).pdf ./$(main_file).pdf

texlive_temp_sync:
	echo "TeXLive on Linux: single compile and SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape --output-directory=$(aux_dir) --synctex=1 $(main_file).tex
	
	# fix lack of auxdir
	cp $(aux_dir)/$(main_file).pdf ./$(main_file).pdf
	cp $(aux_dir)/$(main_file).synctex.gz ./$(main_file).synctex.gz

# TeXLive on Mac
texlive_temp_mac:
	echo "TeXLive on Mac: single compile, no SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape $(main_file).tex
	
	# fix lack of auxdir
	-tex_hide_aux.sh

texlive_temp_mac_sync:
	echo "TeXLive on Mac: single compile and SyncTeX"
	xelatex --interaction=nonstopmode --shell-escape --synctex=1 $(main_file).tex
	#echo "fixing lack of auxdir"
	#which tex_hide_aux.sh
	#pwd	
	
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
ifeq ($(UNAME), CYGWIN_NT-5.1)
	bibtex ./$(aux_dir)/$(main_file).aux
endif

ifeq ($(UNAME), Linux)
	bibtex ./$(main_file).aux
endif

ifeq ($(UNAME), Darwin)
	bibtex ./$(main_file).aux
endif

# create symbolic links to (shared) img directories
junctions:
	junctions.py -c

clean:
	rm -f *.aux *.blg *.log *.bbl *.lof *.tdo *.lot *.out *.toc *.synctex.gz
	rm -f -r ./auxdir/*
	rm -f ./tex/*.aux
	
