# list all directories under ./img
# to create the graphicspath for latex package graphicx
# use in latex preamble by: \input{./graphicspath}
#
# 2013.08.30 (BSD) Ioannis Filippidis

import os

print('Generating graphicspath for graphicx...')
print('I am at: ' +os.getcwd() )

s = '\graphicspath{%\n'
for root, dirs, files in os.walk('./img/', followlinks=True):
    print(root)
    print(dirs)
    print(files)
    for directory in dirs:
        path = os.path.join(root, directory)
        graphics_path_item = '{' +path +'/}%\n'
        print(graphics_path_item)
        s += graphics_path_item
s += '}\n'

print('dump...')
f = open('graphicspath.tex', 'w')
f.write(s)
f.close()
