#!/bin/sh
help() { printf "
*******
init.sh
*******
checks for a semver versioning tag in current git repo. if absent, initializes
it at 0.0.0. if present, doesn't do anything.

options:
\t-q --quiet          : suppresses debug prints
\t-h --help           : prints this text

usage/example:
\t./init.sh -q : runs this script in quiet mode

";
}

if [[ $* == *-h* ]] || [[ $* == *--help* ]]; then help; exit 1; fi;
if [[ $* == *-q* ]] || [[ $* == *--quiet* ]]; then exec 6>&1; exec > /dev/null; fi;

INITIAL_VERSION="0.0.0";
CURRENT_VERSION=$(./get-latest.sh);
if [[ $? = 1 ]]; then
  git tag ${INITIAL_VERSION};
  printf "
!: semver versioning not found from list of git tags...
\t> initialized repository versioning with 0.0.0.

";
else
  printf "
latest semver version ${CURRENT_VERSION} found in git tags...
skipping initialization.

";
fi;

exit 0;
