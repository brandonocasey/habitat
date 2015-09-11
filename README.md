# Beta Release
Everything has passed smoke testing, their are a few existing plugins that work.

Things to Note before using this:
* There is still a lot to do and a lot that can change in the plugin api
* The code is somewhat stable at this point and I am fixing issues as they come up
* Some of the unit tests fail due to recent changes, they will be fixed

# TODO
* Finish/Update unit tests
	* verify error lines in unit tests
	* verify that the environment has not changed when running the script
	* redirect to variables for unit tests. using > or | if possible
	* better tests for one_time_question
* Implement something to auto run unit tests on git
* abstract the varaibles passed to plugin authors
* dont force write/read to be passed the config file
* versioning plugins
* verify portability to other shells
* better config file
* more hooks for plugins
* change plugins to modules, allow modules to have other modules , more habitat calls
* faster git pulling to check for update



# Future Features
* use one_time_question to ask about updates
	* auto
	* warn with diff
	* warn no diff
	* manual
* Ask the user about backup preferences
* Add a function so that plugin authors can easily backup files
* Add more debug output
* habitat_add_plugin -> habitat_add_plugins
* habitat_rm_plugin -> habitat_rm_plugins
* Better return codes for some functions
* Documentation on the potential methods plugin authors have avialable



# Maybe Someday
* better/consistant function comments
* get the return value in habitat_call_function
* check the return code of unset in unset functions and remove errors?
* Anything better than a config file?

# What is Habitat?
habitat provides a framework for keeping your settings in order, through the use of plugins, without doing a lot of the grunt work yourself. (unless you want to!)

# How to use it
1. git clone this repo to your home directory
2. cd into that directory
3. run . habitat

# What does it do?
With no arguments passed habitat will source and run all plugins that you have installed. This is why a lot of people will run habitat in there bash_profile everytime they login. to have everything set up for them automatically. It also automatically cleans up after itself so you don't have any internal functions laying around in your environment. habitat can also:

* Add plugins based upon github (habitat add author/name)
* Removing plugins (habitat rm author/name)
* Checking for and updating plugins
* Manage a config file so you can replicate your environment without duplicating other github repositories
* Update itself if there is a need
* give you help or parse args using a plugin if the plugin supports it (habitat author/repo help)


# Why use it?
Personally I found myself writing around the setbacks in configurating my shell environment. Eventually I ended up with 10 solutions all of which were differnt and specific to a certain binary or set of binaries. Needless to say there were bugs and a lot of wasted effort. I wanted a modular way to configure certain applications in such a way that I did not have to code around it. So I came up with habitat. It codes around the setbacks for you so you can use all X solutions and still understand everything that is going on. As well as having everyone of those solutions tested.

# Writing a plugin
> Note Habitat can stub all this out for you using habitat stub author/plugin
plugins contain two functions one is called run and the other is called options. Both are prefixed with habitat_author_repo_name replacing / or - with underscore. Examples:

```BASH
function habitat_author_repo_name_options()
function habitat_author_repo_name_run()
```

Also the first argument to each of these functions is always their folder. ex: ~/.habitat/plugins/author/repo

## run
This function is run everytime habita is sourced with no arguments. It should do whatever the plugin wants to set up the users environment.

## options
This function is used to interact with a plugin directly or to get help with using a plugin. It can be called like:

```BASH
habitat author/repo "arg1" "arg2"
```

# HELP

| ARG             | Info
|-----------------|---------------------------------------------
| add             | add (a) plugin(s). use with save write a config change
| rm              | remove (a) plugin(s). use with save to write a config change
| save            | doesn't do anything by itself, just saves add/rm to config
| stub            | stub a plugin in the plugins dir ex: stub author/plugin_name
| help            | show this help menu or plugin help. ex: help author/plugin_name
| debug           | show debug statements to stdout
| update          | go through a plugin update progress
| update-self     | check/update the habitat cli
| ls              | show a list of installed plugins
| install         | install plugins based upon config file
