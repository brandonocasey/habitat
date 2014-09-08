# Overview
* habitat_name_of_extension/extension.habit
* habitat_name_of_extension/requires.cfg
* extension.habit will be sourced into the environment
* extension.habit has functions defined like this:
* extension_name_prep
* extension_name_setup
* extension_name_deploy
* extension_name_clean
* anything with extension_name in the front will be cleaned up (functions/vars) for the user
* anything else will have to be cleaned up manually, * This means try to use local variables or extension name prefixed variavles so they get auto cleaned up.

# best practices
* Log everything using the log, log_header, and log_result binaries
* Hook into functionality that already exists, such as symlink and source

# Prep
* Declare variables that you will need later

# Configure
* Ask the user questions and configure the environment based off answers (usually first time only, and from then on stored in a config file)

# Deploy
* Deploy the configured enviornment

# Clean
* Cleanup any and all files/functions the user wont want/need 
