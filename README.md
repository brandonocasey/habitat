# WARNING!
So far this is a just a proof of concept, when everything is up and working this warning will be removed. Right now the design is being hashed out, feel free to create tickets or submit ideas, but I would not use this in the wild just yet.


# TODO
* write unit tests
	* verify debug/error lines in unit tests
	* verify that the environment has not changed when running the script
	* redirect to variables for unit tests. using > or | if possible
	* better tests for one_time_question
* habitat_version


# Would Like
* verify config function
* better function comments
* get the return value in habitat_call_function
* check the return code of unset in unset functions and sqwelch errors?
* plugin specific config settings
* warn about updates
	* habitat_update_self
	* habitat_update_plugins
* habitat_install
* habitat_ls
* support quotes variables in config?
* namespace and eval plugins automatically?
* ignore everything but functions in plugin
* habitat_add_plugin -> habitat_add_plugins
* habitat_rm_plugin -> habitat_rm_plugins

# Need a better idea
* seperate plugin and git repos
	* stuff git repos somewhere



# What is Habitat?
habitat provides a framework for keeping your settings in order, through the use of plugins, without doing a lot of the grunt work yourself. (unless you want to!)

# How to use it
1. Check this repo out
2. Add some plugins with 'habitat add'
3. Add you dotfiles to the dotfiles directory
4. run '. habitat' and watch the magic happen

# What does it do?
habitat itself only manages and runs plugins when you login to a shell (although you can turn this off by default). This includes:

* Adding plugins from github
* Removing plugins
* Checking for plugin updates and telling you what the code changes are (so nothing weird happends to your environment)
* Run the plugins and sets up your environment
* Unsets and removes anything prefixed with 'habitat', basically things used to setup but that are not needed outside of that
* Manage a config file to keep configuration and information on plugins you have installed


# Why use it?
Personally I found myself writing around the setbacks in configurating my shell environment. Eventually I ended up with 10 solutions all of which were differnt and specific to a certain binary or set of binaries. Needless to say there were bugs and a lot of wasted effort. I wanted a modular way to configure certain applications in such a way that I did not have to code around it. So I came up with habitat. It codes around the setbacks in shell for you so you can configure things modularly without too much hassle.

# Writing a plugin
This may change as habitat is developed, but for now this is how it works

plugins contain four main functions. every function is named like this. where Author is the plugin author, repo is the plugin name or git repo. and where name is the actual name of the function:

> function habitat_author_repo_name()


All of this functions can be stubbed out by using the 'habitat stub' method
## setup
This function is used to setup variables that could possibly be used by other plugins, but mainly to setup and configure things for the plugin that it is running in. arguments that need to be passed to this will be pushed to thsi function.

## run
This function is used to setup the users dotfiles in the way that they need to be setup.

## usage
This function is used to get help with the plugin, if the plugin requires arguments they will be used here

## versioning
This function is used to report the current version. It may be phased out if I can get a better idea then this.

# Using the CLI
|ARG     |   Info
|--------|---------------------------------------------
| add    |   add (a) plugin(s). use --save write a config change
| rm     |   remove (a) plugin(s). use --save to write a config change
| stub   |   stub a plugin in /home/blondebeard/Projects/.habitat/plugins. ex: stub author/plugin_name
| help   |   show this help menu or plugin help. ex: help author/plugin_name
