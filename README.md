# Tram Data Merger

TDM is a short for Tram Data Merger, a simple script for merging .tgf data from a tram vehicle with data from information system.


## Setup

This script is written in Ruby and uses several gems, that are needed for execution. These gems are listed in `Gemfile`. Install these gems before using the script (sudo permissions might be needed):

```bash
# install bundler
gem install bundler

# use bundler to install gems in Gemfile
bundle install
```

## Usage

Several gem dependencies are required to be installed before usage, see [setup](#setup) before use.

To use the tool, data from information system are need in a specific format, that the helper script `is_splitter.rb` provides. Run the script in command line (providing you have ruby installed), like so:

```bash
ruby lib/is_splitter.rb exampleISFile1.csv
```
The script will generate separate split IS files for each vehicle in the `data/is/` folder. The `main.rb` script file can be than run in the command line, with `.tgf.txt` file paths in arguments, like so:

```bash
ruby lib/main.rb exampleFile1.tgf.txt foo/exampleFile2.tgf.txt
```

The program will merge `.tgf.txt` files from file paths in arguments with IS vehicle files, and write a merged `.csv` file, with the same name in the specified destination. 
