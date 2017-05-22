#!/usr/bin/env python

# call Oberdiek's pdfcrop

import os

print('calling pdfcrop...')
for root, dirs, files in os.walk('./'):
    print(root)
    for fname in files:
        if fname.endswith('.pdf'):
            fname = os.path.join(root, fname)
            print(fname)
            os.system('pdfcrop ' +fname +' ' +fname)
