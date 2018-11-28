# Coefficients 2 JSON

## ⚠️ Disclaimer ⚠️
This tool was created for a very specific purpose. However, I doubtfully hope
that someone else may find a use of this code. It will need changes but could be
made into a tool that can parse any given file that contains a table of data.
Minor changes would allow parsing of CSV files.

## What is it?
This script will take in a file that contains a table of data and convert it
into a JSON file in a specific format.

## Why was this made?
This was made in order to generate
[this JSON file](https://github.com/bristol-sca/ELMO2/blob/master/coeffs.json)
from
[this TXT file.](https://github.com/bristol-sca/ELMO/blob/master/coeffs.txt)

## Usage
Simply run this command, replacing coeffs.txt with your text file.
```
ruby src/parser.rb coeffs.txt
```

## License
This program is released under [license AGPLv3+.](https://www.gnu.org/licenses/agpl.html)
