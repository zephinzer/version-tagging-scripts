# Version Tagging Scripts

[![Build Status](https://travis-ci.org/zephinzer/version-tagging-scripts.svg?branch=master)](https://travis-ci.org/zephinzer/version-tagging-scripts)

This package provides scripts that helps with managing semver versioning systems using
git tagging.

Semver versioning is:
```
 X . Y . Z
 |   |   |-> patch version (bug fixes)
 |   |-> minor version (backward-compatible changes/additions)
 |-> major version (backward-compatibility breaking changes)
```

Read more on semver at: [http://semver.org/](http://semver.org/)



# Recommended Installation



Use this as a `git` submodule. Install it by running the following in the root of your
project:

```
git submodule add https://github.com/zephinzer/version-tagging-scripts <./path/to/put/it/in>
```



# Usage



By default, all scripts will print the debug output. They also come with a `-q` or
`--quiet` flag that can silence the debug output which you should use once you've tested
them out.

Details of all scripts can also be found via the `-h` or `--help` script.

> **IMPORTANT** Call the scripts using `./script` instead of `bash ./script`, this allows
the script to find itself relative to where you're calling it from and things will **fail**
should you not do so. The necessary hashbangs have been added and they are labelled with
`#!/bin/sh`. 


## `./iterate`


The `./iterate` script should be enough for most continuous integration pipelines.

Run it anywhere in your pipeline that you need to up the version number.

To up the `patch` version, use:

```bash
./path/you/put/it/iterate -q -i
```

To up the `minor` version, use:

```bash
./path/you/put/it/iterate minor -q -i
```

To up the `major` version, use:

```bash
./path/you/put/it/iterate major -q -i
```

## `./get-branch`


This script outputs the current branch you are on.


## `./get-latest`


This script outputs the latest version you are on.


## `./get-next`


This script outputs the next version you should be migrating to.


## `./init`


This script checks for the presence of a `git` tag that resembles `x.y.z` where
`x` is the major version, `y` is the minor version, and `z` is the patch version.
Should it fail to find such a git tag, it will initialize by adding a global
`0.0.0` tag to your repository.



# CI Software Integration Help



## GitLab


Install it in your dev machine with:

```bash
git submodule add https://github.com/zephinzer/version-tagging-scripts <./path/you/wanna/add/submodule/to>
```

A new file `.gitmodules` should appear. Verify that it looks like

```
[submodule './path/you/added/submodule/to']
  path = ./path/you/added/submodule/to
  url = https://github.com/zephinzer/version-tagging-scripts
```

We use this script with GitLab by installing this repository as a `git` submodule.
In a `build` phase in your `scripts` property, add the following:

```yaml
...
  stage: build
...
  artifacts:
    path:
      - ./path/you/added/submodule/to
...
  scripts:
    - git submodule deinit -f .
    - git submodule init
    - git submodule update --init
    - git submodule sync
    - ...
...
```

Note that using the `ssh://` version for this repo when adding the submodule **WILL NOT WORK**
and will corrupt whichever runner it runs on.

Incase you corrupt a runner, you'll need to access the directory containing your 
project builds and manually run `deinit` and change the `.gitmodules` file to direct it
to the HTTPS version of this repository. Main symptom of a corrupt runner will be during
the fetch/clone phase of a job, you'll see some lines that look like:

```
Fetching changes...
fatal: [../]+.git/modules/[./path/you/added/submodule/to] is not a git repository
```

Or something to that effect. No tests have been run, `before_script` has not run either.



# Play With It



The `./utils` directory contains some tools to get you started on how this works.


## Setup Branches


Run the following to set up a traditional CI pipeline consisting of
`dev`, `ci`, `qa`, `uat`, `staging` and `production` branches/environments:

```bash
#> ./utils/branch_setup
```

You should find yourself on the `_dev` branch. They will be prefixed with an underscore
incase you forget that they are just test example environments.


## Setup Pipeline


Run the following to add commits to the relevant branches:

```bash
#> ./utils/pipeline_setup
```

This will add commits to the environments that simulate an actual pipeline with
`_production` having only 1 commit and `_dev` having all 6 commits (1 for each
environment/branch).


## Play With It


Run `./iterate -q -i` on the `_dev` branch (which you should be on). This will initialize
the versioning in _dev. Check out the versions available with:

```bash
#> git tag -l --merged
```

There should be `0.0.0` and `0.0.1`. Great.

Now checkout the `_ci` branch and check the branch for tags with:

```bash
#> git tag -l --merged
```

There should be no tags. Now do a rebase from the `_dev` branch into your `_ci` branch:

```bash
#> git rebase _dev
```

Run the tag checking command again:

```bash
#> git tag -l --merged
```

You should now see `0.0.0` and `0.0.1` because the tags associated with the `HEAD`
commit in the `_dev` branch should have been played to `_ci` and `_ci` now has the
commits from `_dev`. Verify this yourself with `git log -n 1`. Both should match.


## Enough Games


Run the following to revert all test/example branches:

```bash
#> ./utils/branch_teardown
```



# Inspiration



We needed a standardised way to add versioning to our packages. The primary way we use it internally is in a GitLab environment.



# Testing



We use Docker to test the code so that we can check if certain expected features are available.

Run the tests using:

```
#> ./test
```



# Supported Versions



## Git

- Git 1.8.5


# Contributing



Feel it's lacking something? Feel free to submit a Pull Request. Got it to work with
another CI software? Feel free to add to this readme's CI Software Integration Help
section.

Cheers!
