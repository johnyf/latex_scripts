#! /bin/bash

# hide latex auxiliary files' mess (uses chflags)
#
# Copyright 2013 by Ioannis Filippidis
# All rights reserved. Licensed under BSD.

echo "Hiding aux files...";
for i in *.{out,log,aux,toc,bbl,blg,synctex.gz,nav,snm,vrb};
do
	echo ${i}
	if [ -f "${i}" ];
	then
		chflags -f hidden $i;
	else
		echo "Files of this type do not exist.";
	fi
done

for i in ./tex/*.aux
do
	echo ${i}
	if [ -f "${i}" ];
	then
		chflags -f hidden $i;
	else
		echo "There don't exist .aux files in ./tex";
	fi
done
