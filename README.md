# mf2sqn

mf2sqn is used to convert [OGMP masterfile](http://megasun.bch.umontreal.ca/ogmp/masterfile/intro.html) into [Sequin](http://www.ncbi.nlm.nih.gov/Sequin/) file in order to make [submission to the NCBI](https://submit.ncbi.nlm.nih.gov/).

This package is based on activities of  the [OGMP](http://megasun.bch.umontreal.ca/ogmp/) (i.e, priori to 2002), and
becomes open source as part of [MFannot](http://megasun.bch.umontreal.ca/RNAweasel/).

## Install

In order to run mf2sqn you need:

1. Install the [PirObject](https://github.com/prioux/PirObject) library.
2. Install all the necessary [PirModels](https://github.com/BFL-lab/PirModels).
3. Install [NCBI tbl2asn](http://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/) tool.
4. Copy `mf2sqn` in one of your executable directory (e.g: a directory list in $PATH).
5. Define the `MF2SQN_LIB` environment variable in order to point on the `lib` directory.
6. The `qualifs.pl` file should be in a directory accessible by your PERL5LIB search path. It can be a subdirectory of the user's home directory or more generally one of the directories specified by perl's @INC array. A way to check which directories your perl executable will search is to type "perl -V" and to have a look at the content of @INC. You can add directories to this list by setting your PERL5LIB environment variable (or simply PERLLIB in certain cases, be careful).

**Note**: At this point the installation of `mf2sqn` was only tested on Unix system (Ubuntu and CentOS).

## Usage

In order to get the help page of mf2sqn you need to type `mf2sqn -h` in your terminal.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) and [CONDUCT](CONDUCT.md) for details.

## Credits

- [All Contributors](https://github.com/BFL-lab/mf2sqn/graphs/contributors)

## License

GNU General Public License v3.0. Please see [License File](LICENSE.md) for more information.
