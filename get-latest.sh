#!/bin/sh
help () { printf "
*************
get-latest.sh
*************
retrieves the latest git tag that resembles a semver versioning (x.y.z) where x is
the major version, y is the minor version and z is the patch version. exits with code
1 if no version is found, exists with code 0 if version is found.

options:
\t-h --help           : prints this text

usage:
\t./get-latest.sh <dash_suffix> [...options]
\t\t<dash_suffix> : String

examples:
\t./get-latest.sh dev
\t\tgets the latest version suffixed with '-dev'
\t\tif there exists git tags 1.0.0-dev and 1.0.1-dev, this will return 1.0.1-dev
";
}

if [[ $* == *-h* ]] || [[ $* == *--help* ]]; then help; exit 1; fi;

VERSION_SELECTOR="^[0-9]+\.[0-9]+\.[0-9]+"
[[ "$1" != "" ]] && VERSION_SELECTOR="${VERSION_SELECTOR}\-${1}";
VERSION=$(git tag -l | egrep "${VERSION_SELECTOR}$" | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -n 1);
[[ $VERSION = "" ]] && exit 1;
printf "$VERSION\n";
exit 0;
