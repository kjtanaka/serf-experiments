Chef recipe and Test Kitchen for my Serf experiments
----------------------------------------------------

This recipe installs [Serf](http://www.serfdom.io/) with the 
following directory tree.

```
/etc/init.d/serf       --->  startup script
/opt/serf/             --->  app dir
├── etc                --->  config dir
│   └── serf.json      --->  config file
├── libexec            --->  scripts dir
│   ├── join.sh        --->  script for member-join event
│   └── leave.sh       --->  script for member-leave event
├── sbin               --->  sbin dir
│   └── serf           --->  serf
└── var                --->  var
    └── log            --->  log dir
        └── serf.log   --->  log file
```

Take a look at ``/opt/serf/libexec/join.sh`` and ``/opt/serf/libexec/leave.sh``. 
What it does is to update ``/etc/hosts`` when member-join and member-leave event happen.

For more information is [here](http://kjtanaka.github.io/posts/2013/12/serf-experiment.html).
