# LaTeX convenience scripts

- `Makefile`: compile, make bib, sync on unix, max, windows, for help see [`makefile.md`](makefile.md)
- `graphicspath.py`: auto-populate `graphicx` paths by traversing directories under `./img`
- `tex_hide_aux.sh`: turn auxiliary `tex`-generated files to hidden ones, useful on `*nix` systems where `TexLive` doesn't support any equivalent to the `MikTeX` option `--aux-directory`
- `pdfcrop.py`: call [`pdfcrop`](http://www.ctan.org/pkg/pdfcrop) over a directory tree
- `ieeeconf_custom.tex`: some personal `IEEEtrans` small cfgs.
