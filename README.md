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

# Binaries
## Return Codes
| Code | Meaning  |
|------|----------|
| 0    | Success  |
| 1    | Failure  |
| 2    | Error    |

## Descriptions
* ask.sh - Ask the user a question and pass all possible answers, enter/control +c default to the first answer
* command.sh - Check if a command is executable in the shell and run an async command
* config.sh - remove, insert, and update config entires
* data.sh - symlink, move, copy, and download data with backup support, also finds and gets the full path of a file
* regex.sh - return 0 on regex match, and regex replace a string
* repo.sh - download, update, and get the status of a version control repo
* string.sh - Split and Join a string on a deliminator, can even join unique

# Variables
| Name                | Value                        | Description                                                |
|---------------------|------------------------------|------------------------------------------------------------|
| habitat_base        | $HOME/.habitat               | Base path for everything                                   |
| habitat_cli         | $habitat_base/turtle         | The Location of the CLI                                    |
| habitat_storage     | $habitat_base/storage        | The location of all habitat storage                        |
| habitat_bin         | $habitat_base/bin            | The Location of all binaries                               |
| habitat_extensions  | $habitat_base/extensions     | The Location of extensions                                 |
| habitat_setting     | $habitat_base/settings       | The Location of your settings                              |
| habitat_tmp         | $habitat_storage/tmp         | Storage of temporary files                                 |
| habitat_backup      | $habitat_stoarge/backup      | Storage of file backups                                    |
| habitat_logs        | $habitat_storage/logs        | Storage of all the logs                                    |
| habitat_log_file    | $habitat_logs/turtle.log     | The main log file                                          |
| CUSTOM_LOG_FILE     | $habitat_log_file            | The main log file, so we don't have to pass it to binaries |
| habitat_config_file | $habitat_settings/turtle.cfg | The habitat config file                                    |

# Config
* update_type - how to update extensions and settings
* extensions  - extensions to install
* log_level   - Valid levels are:
    * 0 - None
    * 1 - Errors
    * 2 - Info
    * 3 - Debug
    * 4 - Devel
    * 5 - Eveything to STDOUT



# Options:
if no options are passed then habitat will configure the environment
source ./habitat <options>


| Option           | Description                                                              |
|------------------|--------------------------------------------------------------------------|
| settings         | Install setting from an existing repo, or use new/example                |
| install          | Install an additional extension via a github user/repo pair              |
| remove           | remove an extension, deleting its folder                                 |
| save             | pass this with remove/install to remove/add to the user extension config |
| uninstall        | alias for remove                                                         |
| add              | alias for install                                                        |
| stub             | stub an extension in the extensions folder                               |
| help             | show this help                                                           |
| debug            | Show debug output in the log                                             |
| verbose          | Show verbose output in the log                                           |

# Planned Extensions
* Vim
    * Vim Plugins
* Binaries
* Bash Completion
* themes

# Extending:
see Extending.md

# RoadMap
The Roadmap from Alpha to Release

## Alpha -> Beta
The current roadmap from Alpha to Beta

### General
* Give all binaires argument parsing
* Give all binaries a help
* check command return codes
* async output all lines to log
* log_async and regular async
* Multiple settings repos?
* How does one extension use another?
* Can we make the bin folder, optionaly source friendly?
* turtle.cfg - Required for this extension to work
* Export Some habitat directory for user usage
* store extensions in a user dir ex: extensions/brandonocasey/{habitat-things,habitat-lols}


### ~~Milestone 1 - Documentation/Base~~
* ~~Create the Documentation for extending and the readme~~
* ~~Add several portable binaries~~
* ~~Add a stubbed habitat cli~~

### ~~Milestone 2 - Extensions~~
* ~~Habitat should be able to manage an extension, through the CLI~~
    * ~~install~~
    * ~~save~~
    * ~~uninstall~~
* ~~Extensions should be cleaned up automatically~~
* ~~Extensions should be run successfully~~
* ~~create an extension to test with~~

### Milestone 3 - User Settings
* ~~Give the CLI the ability to do the following for settings~~
    * ~~update~~
    * ~~change~~
    * ~~new~~
    * ~~example~~
* ~~Solidify the extension API~~
* ~~make sure nothing uninteded goes to the users environment~~
* Find a good way to make a dependancy tree
* ~~determine what other variables would be usefull to the user~~ ~~Remove this~~

### Milestone 4 - General TODO
* Go over the items in general TODO and add to roadmap
* add comments to rough code
* Fix tab/spacing issues
* ~~Add colors to the output~~ ~~No Need~~

## Beta -> Release
The current roadmap for Beta to release

### Milestone 1 - Unit test
* Unit test habitat and the portable binaries
* Use those unit tests on multiple enviornments/shells to make everything more robust

### Milestone 2 - Comments
* Comment everything using a standard
* create a website using that comment standard

### Milestone 3 - General TODO
* go over the general TODO section and fix things
* Finish off the documentation
* make all the extensions that have been talked about

### Milestone 4 - Website
* Develop a website to register extensions with
* implement cli searching for extensions
* switch extensions over from repository urls only to repository urls or project names from the website
