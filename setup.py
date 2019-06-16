#!/usr/bin/env python3
from distutils.core import setup

setup(
        name = 'hdcb',
#       packages = ['hdcb'],
        version = '0.0.0',
        description = 'HexDump Coloring Book',
#       url = 'https://github.com/v3l0c1r4pt0r/hdcb',
        author = 'v3l0c1r4pt0r',
        author_email = 'kamil@re-ws.pl',
        classifiers = [
            'Programming Language :: Python',
            'Programming Language :: Python :: 3',
            'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
            'Development Status :: 1 - Planning',
            'Intended Audience :: Developers',
            'Topic :: Scientific/Engineering :: Information Analysis',
            'Topic :: Utilities',
            ],
        long_description = '''HDCB is an utility to color hexadecimal dumps of
binary files. It defines its own pseudo-language as an extension to Python to
make defining new formats as easy as possible.

Currently the Python port is in design phase. Older version, based on bash is
available as a legacy version.
''',
)
