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

