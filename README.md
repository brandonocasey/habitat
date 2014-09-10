# WARNING!
So far this is a just a proof of concept, when everything is up and working this warning will be removed. Right now the design is being hashed out, feel free to create tickets or submit more portable binaries/code, but I would not use this in the wild just yet.

# What is Habitat?
Habitat is an attempt to unify a users settings across 1 or n number of boxes so that they feel right at home on whatever box they work on. It also seeks to make moving between, and porting you specific settings to, different operating sysems easy.

It does this by providing a framework for setting up your shell by using a settings repos, as well as habitat dependancies.

# Overview
The habitat cli is called turtle and it follows a four step proccess in setting up your environment, (if no args are passed)

## Step 1: Prep/Grab Args
* add /lib/bin to the path
* setup habitat file structure variables
* unalias everything so alias renames are forgotten every run, meaning we don't have to worry about old ones lingering
* Start a record of how long habitat takes to run
* Grab the args from the user
* setup helpful variables like operating system
* alias habitat to source the habitat script for easy setting refresh

## Step 2: Dependancy management
* Ask questions about installs (first time)
    1. Setting repo link, or example, or new
    2. Do you want updates, y or n
    3. if yes to above how? auto, ask, inform, nevermind
* Update/Install Habitat Framework if the user wants us to
* Update/Install Extensions if the user wants us to
* Update/Install User Settings Repo if the user wants us to


## Step 3: Extensions
### A: Setup
* Run extension setup
* Should setup variables that the extension will need
* ask the user first time questions, which should be stored in the users settings repo under a config file

### B: Deploy
* Run extension deploy
* Deploy whatever this extension is setup to deploy from the users settings folder

### C: Cleanup (optional)
* Run extension cleanup function, to cleanup non standard variables/functions and files that were created

## Step 4: Cleanup
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
if no options are passed then habitat will configure the environment
source ./habitat <options>


| Option           | Description                                                              |
|------------------|--------------------------------------------------------------------------|
| example-settings | Use the example settings repo as a base                                  |
| new-settings     | Create a new local settings repo                                         |
| settings         | Install setting from an existing repo                                    |
| install          | Install an additional extension via a github user/repo pair              |
| remove           | remove an extension, deleting its folder                                 |
| save             | pass this with remove/install to remove/add to the user extension config |
| uninstall        | alias for remove                                                         |
| add              | alias for install                                                        |
| help             | show this help                                                           |

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
## General
* Give all binaires argument parsing
* Give all binaries a help
* check command return codes
* export colors
* mimic Perl functions, or use perl?
* async output all lines to log
* Multiple settings repos?

## Alpha -> Beta
### Milestone 1 - Documentation/Base
* ~~Create the Documentation for extending and the readme~~
* ~~Add several portable binaries~~
* ~~Add a stubbed habitat cli~~
* determine what variables would be usefull to the user

### Milestone 2 - User Settings
* ~~Have the ability to manage users settings from a repo (svn, git, etc)~~
    * ~~update~~
    * install
    * uninstall
    * ~~new~~
    * ~~example~~
* ~~Solidify the extension API~~
* make sure nothing uninteded goes to the users environment

### Milestone 3 - Extensions
* Habitat should be able to manage an extension (same steps as user repo)
* Extensions should be cleaned up automatically
* Extensions should be run successfully
* determine if anything else would be helpful for the user to have
* create an extension to test with


## Beta -> Release
### Milestone 1 - Unit test
* Unit test habitat and the portable binaries
* Use those unit tests on multiple enviornments/shells to make everything more robust

### Milestone 2 - Comments
* Comment everything using a standard
* create a website using that comment standard

### Milestone 3 - Website
* Develop a website to register extensions with
* implement cli searching for extensions
* switch extensions over from repository urls only to repository urls or project names from the website
