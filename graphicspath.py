#!/usr/bin/python
description = """
list all directories under given directory
to create the graphicspath for latex package graphicx
use in latex preamble by: \input{./graphicspath}

2013 - 2014 (BSD) Ioannis Filippidis
"""
import logging
logger = logging.getLogger(__name__)

import os
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description=description)
    
    parser.add_argument('-d', '--directory', default='./img/',
                        help='list directory tree under this directory.')
    parser.add_argument('-o', '--output-filename', default='graphicspath.tex',
                        help='name of tex file where tree is dumped')
    
    args = parser.parse_args()
    
    return args

def dump_dir_tree(path, texfile):
    logger.info('Generating \graphicspath for graphicx...')
    logger.debug('I am at: ' + os.getcwd() )
    
    s = '\graphicspath{%\n'
    for root, dirs, files in os.walk(path, followlinks=True):
        logger.debug(root)
        logger.debug(dirs)
        logger.debug(files)
        
        for directory in dirs:
            path = os.path.join(root, directory)
            
            # path with whitespace ? -> skip
            if path.find(' ') != -1:
                logger.warning('Path with whitespace found: ' + path)
                continue
            
            graphics_path_item = '{' + path + '/}%\n'
            logger.debug(graphics_path_item)
            
            s += graphics_path_item
    s += '}%\n'
    
    logger.info('dumping to "' + texfile + '" the tree:\n' + s)
    f = open(texfile, 'w')
    f.write(s)
    f.close()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    args = parse_args()
    print(args)
    dump_dir_tree(args.directory, args.output_filename)
