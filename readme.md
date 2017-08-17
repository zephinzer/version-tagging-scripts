# Version Tagging Scripts
This package provides scripts that helps with managing semver versioning systems using
git tagging.

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
to the HTTPS version of this repository.

# Inspiration
We needed a standardised way to add versioning to our packages. The primary way we
use it internally is in a GitLab environment.

# Contributing
Feel it's lacking something? Feel free to submit a Pull Request. Got it to work with
another CI software? Feel free to add to this readme's CI Software Integration Help
section.

Cheers!
