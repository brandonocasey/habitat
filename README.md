# What is Habitat?
Habitat is an attempt to unify a users settings across 1 or n number of boxes so that they feel right at home on whatever box they work on. It also seeks to make moving between, and porting you specific settings to, different operating sysems easy.

It does this by providing a framework for setting up your shell by using a settings repos, as well as habitat dependancies.

# Overview
Habitat uses a cli interface called habitat to follow a five step proccess in setting up your environment.

## Step 1: Setup/Dependancy management
* add /lib/bin to the path
* setup habitat file structure variables
* Ask questions about installs (first time)
    1. Setting repo link, or example, or new
    2. Do you want updates, y or n
    3. if yes to above how? auto, ask, auto silent
* Update/Install Habitat if the user wants us to
* Update/Install Extensions if the user wants us to
* Update/Install User Settings Repo if the user wants us to


## Step 2: Prep
* setup helpful variables like operating system
* unalias  everything so alias renames are forgotten every run, meaning we don't have to worry about old ones lingering
* Start a record of how long habitat takes to run
* alias habitat to source the habitat script for easy setting refresh
* Run Extension Prep

## Step 3: Configuration
* Run extension setup/configuration

## Step 4: Deployment
* Run extension deploy steps

## Step 5: Cleanup
* Tell the user about backups that exist
* Remove internal variables
* remove internal functions
* record how long habitat took to run
* remove everything in the /storage/tmp directory

# How do extensions work?
Extensions are a big part of every step in the life cycle of a program


# Functions:


# Binaries:

# Variables:

# Options:

# Extensions
* Vim
    * Vim Plugins
* Binaries
* Bash Completion
* .sour
* .syml

# Extending:
/storage/extensions/<name>

# TODO
* is it worth it to have some sort of daemon checking for setting updates, and auto running aura?
* Give all functions args
* Give all functions help
* Should themes be .sour?
* Should functions be .sour?
* check command return codes
* export colors
* mimic Perl functions
* change functions to binaries
* add_to_string replace pathadd
