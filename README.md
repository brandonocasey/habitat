# WARNING!
So far this is a just a proof of concept, when everything is up and working this warning will be removed. Right now the design is being hashed out, feel free to create tickets or submit more portable binaries/code, but I would not use this in the wild just yet.

# What is Habitat?
Habitat is an attempt to unify a users settings across 1 or n number of boxes so that they feel right at home on whatever box they work on. It also seeks to make moving between, and porting you specific settings to, different operating sysems easy.

It does this by providing a framework for setting up your shell by using a settings repos, as well as habitat dependancies.

# Overview
The habitat cli interface follows a three step proccess in setting up your environment.

## Step 1: Prep/Dependancy management
* add /lib/bin to the path
* setup habitat file structure variables
* unalias everything so alias renames are forgotten every run, meaning we don't have to worry about old ones lingering
* setup helpful variables like operating system
* Start a record of how long habitat takes to run
* alias habitat to source the habitat script for easy setting refresh
* Ask questions about installs (first time)
    1. Setting repo link, or example, or new
    2. Do you want updates, y or n
    3. if yes to above how? auto, ask, auto silent
* Update/Install Habitat if the user wants us to
* Update/Install Extensions if the user wants us to
* Update/Install User Settings Repo if the user wants us to


## Step 2: Extensions
### A: Setup
* Run extension setup
* Should setup variables that the extension will need
* ask the user first time questions, which should be stored in the users settings repo under a config file

### B: Deploy
* Run extension deploy
* Deploy whatever this extension is setup to deploy from the users settings folder

### C: Cleanup (optional)
* Run extension cleanup function, to cleanup non standard variables/functions and files that were created

## Step 3: Cleanup
* Tell the user about backups that exist
* Remove internal variables
* remove internal functions
* record how long habitat took to run
* remove everything in the /storage/tmp directory

# How do extensions work?
Extensions are a big part of every step in the life cycle of a program

# Binaries:

# Variables:

# Options:
* --install   - Install an additional extension via a github user/repo pair
* --add       - alias for install
* --save      - Used in conjunction with --install to save that extension to your environment
* --remove    - remove an extension, deleting its folder, entries in the user extension.cfg, and ask the user if they wish to keep config files
* --uninstall - alias for remove
* --help      - view help on using the cli

# Planned Extensions
* Vim
    * Vim Plugins
* Binaries
* Bash Completion
* .sour
* .syml
* themes

# Extending:
see Extending.md

# TODO
* Give all binaires argument parsing
* Give all binaries a help
* check command return codes
* export colors
* mimic Perl functions, or use perl?
