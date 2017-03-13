# LaTeX Makefile Guide
There are 3 options, organized as follows:

1. `full_compile` (compile; bib; compile; compile)
	- 	- full_miktex
			- miktex_temp (1)
			- bibtex
			- miktex_temp (1)
			- miktex_temp (1)
		- copylog
	-	- full_texlive
			- texlive_temp (2)
			- bibtex
			-texlive_temp (2)
			- texlive_temp (2)
		- copylog
	- 	- full_texlive_mac
			- texlive_temp_mac (3)
			- bibtex
			- texlive_temp_mac (3)
			- texlive_temp_mac (3)
		(no copying needed)

2. `sync` (compile; sync)
	-	- miktex_temp_sync (4)
		- copylog
	- texlive_temp_sync (5)
	- texlive_temp_mac_sync (6)

3. `temp` (compile)
	-	- miktex_temp (1)
		- copylog

	- texlive_tmp (2)
	- texlive_temp_mac (3)

The individual calls are:

   `temp`

1. miktex_temp (windows)
2. texlive_temp (linux)
3. texlive_temp_mac (mac)

	`temp_sync`

4. miktex_temp_sync (windows)
5. texlive_temp_sync (linux)
6. texlive_temp_mac_sync (mac)

From the above:

1. windows (1 and 4) use `auxdir` (`--aux-directory`)
2. linux (2 and 5) use `-output-directory`
3. mac (3 and 6) use `chflags` (to make auxiliary files hidden in file viewer)
