# What is Habitat?
Habitat is an attempt to unify a users settings across 1 or n number of boxes so that they feel right at home on whatever box they work on. It also seeks to make moving between, and porting you specific settings to, differnt operating sysems easy.

# Overview
Habitat uses a cli interface called habitat to follow a five step proccess in setting up your environment.

## Step 1: Setup
* Source all file in the /lib folder to get a bunch of portable functions
* Add a directory to the path if it doesn't exist /deps/settings/bin
* unalias everything so that if you change your alias, the old one will be gone when you reset your settings
* remove everything in the /tmp directory
* Start a record of how long habitat takes to run
* export usefull variables into the users environment, like $OPERATING_SYSTEM
* alias habitat to source the habitat script for easy setting refresh

## Step 2: Dependancy Management
* Update Habitat if the user wants us to
* Update Extensions if the user wants us to
* Update User Settings if the user wants us to

## Step 3: Configuration
* Ask the user a few first time questions, and store things in /storage/habitat.cfg
	1. Where is you setting repo? (hit enter for default) (we will read user config for next answers if possible)
	2. Which Bash theme do you want?
	3. Do you want to install additional extensions? (can be in user setting repo, or done later)
	4. How do you want to update? (automatic, always_ask, never)
* Run extension setup/configuration

## Step 4: Deployment
* Source all settings files with a .sour extension into your environment
* Symlink all files with a .syml extension to your home directory
* Run extension deploy steps

## Step 5: Cleanup
* Tell the user about backups that exist
* Remove internal variables
* remove internal functions
* record how long habitat took to run

# Functions:

# Binaries:

# Variables:

# Options:

# Extending:
/storage/extensions/<name>

# TODO
* is it worth it to have some sort of daemon checking for setting updates, and auto running aura?
* Give all functions args
