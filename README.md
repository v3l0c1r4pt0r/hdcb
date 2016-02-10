# hdcb
HexDumpColoringBook - binary file analysis helper

Overview
---

HDCB is a program that is meant to ease analysis of unknown binary files on
Linux (or any other) platform. It provides custom markup language based on bash
(and built on top of bash interpreter, so it is possible to use standard bash
syntax) to describe the format of a file. It allows to define variable of any
length that could be used later more than one time. There is a possibility to
use defined variable in array. HDCB allows to get value of any used variable and
use it later in example as length of an array.

HDCB outputs processed file in hexdump format (hexdump's -C flag). It is then
coloured according to input description script to make file analysis easier.
Colors are picked automatically - one background-foreground pair for every
defined variable. There is also a possibility to define custom color pair when
defining a variable.

![sdc-output](https://github.com/v3l0c1r4pt0r/hdcb/blob/master/doc/sdc.png?raw=true "Analyzed SDC file")

Installation
---

Program can be built by issuing standard
```bash
./configure
make
sudo make install
```
sequence. It is necessary to install the program into system as main hdcb script
shall be placed in directory added to `$PATH` variable to work properly and
library scripts need to have valid paths hardcoded. Default install path is
`/usr/local/`, but it can be changed to anything else like in example
`$HOME/bin` as long as `$HOME/bin/bin/` can be found within `$PATH`.

Command description
---

* `define` - defines variable

  Usage: ```define "varname" length [background] [foreground];```

  Where:

  - `varname` is a name by which variable would be referenced later
  - `length` defines length of the single variable element
  - `background` is optional number of background color used to highlight the
    variable (available colors are presented
[here](http://misc.flogisoft.com/bash/tip_colors_and_formatting#background1))
  - `foreground` is optional number of foreground color used to highlight the
    variable (available colors are presented
[here](http://misc.flogisoft.com/bash/tip_colors_and_formatting#foreground_text1))

* `use` - uses defined variable

  Usage: ```use "varname" [dup] [shellvar];```

  Where:

  - `varname` is a varname defined with `define` command
  - `dup` creates array of this number of variable items
  - `shellvar` allows getting value of the variable used and saving it into
    given shell variable

    shellvar naming has special naming rules

    - Variables ending with `_l` will be read as little-endian
    - Variables ending with `_b` will be read as big-endian

* `squeeze` - squeezes repeating lines

  Usage: ```squeeze;```

  This command instructs hdcb to let hexdump sqeeze lines with repeating bytes.
  It is useful when analyzing huge files since it will in some cases havily
  reduce output size.

Control shell variables
---

* `cursor` can be used to advance next variable beginning, in example to mark
  next 4 bytes as reserved, you could type `let cursor+=4;`.

Example script
---

```bash
define "length" 4;
define "string" 1;

use "length" len_l;
use "string" $len_l;
```

This script defines two variables. First is a length field stored on four bytes.
Second is a one byte character. At the beginning of the file being analysed
there are four bytes of length. When using this variable its value is stored in
`len_l` shell variable. Its value is treated as little-endian. Then string is
defined and `len_l` variable is used as array size. Result of such script would
be as below.

![basic_example](https://github.com/v3l0c1r4pt0r/hdcb/blob/master/doc/example.png?raw=true "String HDCB output")
