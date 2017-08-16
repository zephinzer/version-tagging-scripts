#!/bin/sh
if [[ $1 = "" ]]; then
  printf "ERROR: Target environment NOT FOUND (specify it as an argument)\n";
  printf "eg. [./should-update-to.sh dev] for the dev environment\n"
  printf "\nExiting with status code 1.\n"
  exit 1;
fi

LATEST=$(./get-latest.sh);
DEPLOYED=$(./get-latest.sh $1);

if [[ $LATEST = "" ]] || [[ $DEPLOYED = "" ]]; then
  if [[ $LATEST = "" ]]; then
    printf "ERROR: Version tags (x.y.z) NOT FOUND.\n";
  fi;
  if [[ $DEPLOYED = "" ]]; then
    printf "ERROR: Deployed version tags (x.y.z-$1) NOT FOUND.\n";
  fi;
  printf "\nExiting with status code 1.\n"
  exit 1;
else
  LATEST_DEPLOYED=$(printf "${DEPLOYED}" | cut -d- -f1);
  printf "LATEST:                $LATEST\n";
  printf "LATEST_DEPLOYED:       $LATEST_DEPLOYED\n";
  if [[ $LATEST = $LATEST_DEPLOYED ]]; then
    printf "No changes need to be made.\n"
    printf "\nExiting with status code 0.\n"
    exit 1;
  fi;
fi;

COMPARE="${LATEST}\n${LATEST_DEPLOYED}\n";
NEXT_VERSION=$(printf ${COMPARE} | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -n 1);

if [[ $NEXT_VERSION = $LATEST ]]; then
  printf "UPDATING TO:           ${NEXT_VERSION}\n"
  UPDATED_FULL_VERSION=$(printf "${NEXT_VERSION}" | cut -d- -f1);
  UPDATED_MAJOR_VERSION=$(printf "${UPDATED_FULL_VERSION}" | cut -d. -f1);
  UPDATED_MINOR_VERSION=$(printf "${UPDATED_FULL_VERSION}" | cut -d. -f2);
  UPDATED_PATCH_VERSION=$(printf "${UPDATED_FULL_VERSION}" | cut -d. -f3);
  printf "UPDATED_FULL_VERSION:  ${UPDATED_FULL_VERSION}\n"
  printf "UPDATED_MAJOR_VERSION: ${UPDATED_MAJOR_VERSION}\n"
  printf "UPDATED_MINOR_VERSION: ${UPDATED_MINOR_VERSION}\n"
  printf "UPDATED_PATCH_VERSION: ${UPDATED_PATCH_VERSION}\n"
fi;