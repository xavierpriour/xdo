# xdo
A generic multi-stage command execution framework for application/system development/administration

`xdo` lets you easily run the same commands on different computers or with different parameters,
with a simple and consistent syntax.

- deploy to test? `xdo test deploy myApp:1.02`
- deploy to prod? `xdo prod deploy myApp:1.02`
- ssh into test server? `xdo test ssh`
- build on ci server? `xdo ci build myApp:1.02`

It is easy to extend, and does not have any dependency, beyond `bash`.

To install:

- clone this repo: `cd ~/projects && git clone git@github.com:xavierpriour/xdo.git`
- link `xdo` into your path: `sudo ln -s ~/projects/xdo/xdo /usr/local/bin` 
- add `XDO_HOME` to your init file (ex: `~/.zshrc`), pointing to this folder: `export XDO_HOME=$HOME/projects/xdo`
- also add `source $XDO_HOME/commands/_autocomplete.sh` to enable autocompletion
- test in $XDO_HOME: `xdo nostage noop`

TODO: example public project

## commands

All project command scripts should go into folder `./commands`.
Any file starting with an underscore will be ignored by the autocomplete.

If present, the file `./commands/_lib.sh` will be sourced before any command is run.
Use it to define common functions or variables
(don't forget to `export` them so they are accessible to the commands).

To get timestamps and start/stop logs, set XDO_LOG before calling.

## standard elements

Standard xdo commands and functions are geared toward docker images.
Look into the scripts themselves for a full list of the environment variables they need.

Utilities:

- ssh: logs into a server (needs SSH_USER and SSH_HOST)

Deployment:

1. `create`: sets up a new environment (by default, turns $SSH_HOST into a docker-machine named $DOM_NAME)
1. `provision`: initializes the recently-created machine (creating folders, copying files, etc.).
1. `build`: packages the system for deployment
1. `push`: uploads the package to your distribution mechanism (by default, a docker registry at $DOCKER_REGISTRY_ADDRESS)
1. `pull`: downloads the package from your distribution mechanism
1. `start`: launches your system (by default, does a docker-compose up)

(TODO)

## goals and design

Design goal was to make it extremely easy to execute commands on various environments and
not repeat yourself:

- environments and commands can be easily shared
- everything can be overridden where needed
- adding a new element is very easy and self-contained
- tool is joyful to use

At its heart, xdo simply:

- loads environment variables using some cascading priority rules
- provides smart autocompletion to the use
- finds which shell files to execute and runs them

### future

Here are some ideas, no commitment nor timeline:

- make it easier to share / reuse commands across projects
- package xdo in its own docker container, to remove dependency on bash

## why not xxx?

There is no shortage of awesome tools for building/deploying, from cli
(capistrano, shipit, fabric, deployer, my own grunt-stage,...)
to SaaS of all kinds.

Yet I still chose to develop `xdo`, basically for minimalism and freedom.
I wanted a tool I could use:

- with all my projects:
    - so not limited to one language
    - nor requiring a specific runner tool (like make, grunt, npm)
- for all my tasks:
    - not limited to some specific pre-defined DSL or tasks
    - "if it has a command line, I should be able to run it"
- locally as well as on any server (CI, deploy,...)
    - no SaaS
    - works offline
- without polluting my project with additional stuff
    - no need to add new packages to run my tasks,
    our build processes are complicated enough (Javascript fatigue anyone?)
    - and I'm not learning a new language just for deploying (looking at you, capistrano).
    Actually I gave up a little, you will need to be somehow comfortable with shell programming 
