# xdo
A generic multi-stage command execution framework for application/system development/administration

`xdo` lets you easily run the same commands on different computers or with different parameters,
with a simple and consistent syntax.

- deploy to test? `xdo test deploy myApp:1.02`
- deploy to prod? `xdo prod deploy myApp:1.02`
- ssh into test? `xdo test ssh`
- build on ci server? `xdo ci build myApp:1.02`

It is easy to extend, and does not have any dependency, beyond `bash`.

To install:

- clone this repo
- link `xdo` into your path: `sudo ln -s ./xdo /usr/local/bin` 
- add `XDO_PATH` to your `~/.profile` pointing to this folder
- test: `xdo nostage noop`

TODO: example public project

## standard elements

Standard xdo commands and functions are geared toward docker images.

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
