# Overview
A general overview of creating and developing an extension

> extension_name will be the name of your extension without habitat_ on the front

## Requirements
* Prefix your extension with habitat_
* use only lowercase letters lowercase and underscores in your extension name
* Include an extension.habit file at the root of your project which has the required functions
* any extension that you require must go in requirements.cfg in the root folder

# Best Practices
* Log everything using the log, log_sub_header, and log_result binaries
* try to use portable binaires when possible to retain compatabilty with all environments
* Anything with extension_name in the front will be cleaned up (functions/vars) for you, use it
* Make sure use local in your functions if you dont want to cleanup a ton of variables at the end

# Required Functions
## extension_name_setup
* Declare variables that you will need later
* Ask the user questions and configure the environment based off answers (usually first time only, and from then on stored in a config file)
* add any binary paths to the $PATH variable ()

## extension_name_deploy
* Deploy the configured enviornment

# Optional Function
## extension_name_cleanup
* Cleanup any and all files/functions the user wont want/need
* remove things from the PATH that the user wont need
