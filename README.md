# TTtrpg
this is a hobby project dice rolling api, written in elixir

![Frontend Demo](assets/T_TTRPG_DEMO.gif)

## Installation
this is not ready for users or contributors, if your that interested you should fork and do your own thing (or maybe just start from scratch XD)

## Overview

```
.
├── assets
├── lib
│   ├── components
│   │   └── roll_string // this is where the structs live
│   ├── entities
│   └── systems
│       ├── dice_rolls // this is where the functions that manipulate objects of components live
│       └── server // this is where systems for handling web requests live 
├── phoenix_frontend // this is the pheonix frontend server, the api server and the web server are decoupled (because i want to do different frontends in the future)
│   ├── assets
│   │   ├── css
│   │   ├── js
│   │   └── vendor
│   ├── config
│   ├── lib
│   │   ├── phoenix_frontend
│   │   └── phoenix_frontend_web
│   │       ├── components
│   │       │   ├── layouts
│   │       │   └── live
│   │       └── controllers
│   │           ├── hello_html
│   │           └── page_html
│   ├── priv
│   │   ├── gettext
│   │   │   └── en
│   │   │       └── LC_MESSAGES
│   │   ├── repo
│   │   │   └── migrations
│   │   └── static
│   │       └── images
│   └── test
│       ├── phoenix_frontend_web
│       │   └── controllers
│       └── support
├── react_frontend // this is the react frontend server, the api server and the web server are decoupled (because i want to do different frontends in the future)
│   ├── app
│   │   └── actions
│   └── public
└── test
    ├── roller
    │   ├── protocals
    │   └── resolver
    └── systems
```

## Architecture
the api is being implemented as an event driven ecs style "game engine", I like ECS (entity, component, system) because i often find when I've implemented something poorly, and can't extend it, going back and using ECS allows me to do more complicated things with simpler feeling code.

for example a feature I want to implement in the future, is for users to be able to upload character sheets as .txt files, eg:
```
name: gandalf
str: 12, 1
con: 13, 1
dex: 14, 2
int: 18, 4
wis: 19, 4
cha: 15, 2
```

and have a character entity factory that can turn that into key value pairs that other systems can use in rolls. eg when your gandalf and you hit ``` 1d20 + wis + prof``` the roll system would be able to find ``` 1d20 + 4 + prof``` because gandalf has a wis, but not a prof.

this will be tricky to do, but I can see a path forward with an event driven ECS architecture. 
