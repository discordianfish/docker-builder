# Docker config build pipeline
The docker build pipeline is used to build new or take existing images,
configure them as far as possible and push them to a registry.

- There is one repository containing one directory per image.
- Images get named `registry`/`directory`:`tag`
- tag is the branch name or `latest` for branch master

For debugging, `authorized_keys.root` gets copied to /root/.ssh/authorized_keys
to be used for ssh into the container as root.


## Getting started

    echo my-registry:5000 > registry
    cat ~/.ssh/id_rsa.pub > authorized_keys
    cat ~/.ssh/id_rsa.pub > authorized_keys.root
    docker build -t builder .
    docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup -p 2222:22 docker-build
    git remote add foo ssh://git@127.0.0.1:2222/git/universe.git
    mkdir image/ & vim image/Dockerfile # do your stuff
    git commit ...
    git push # this will build and push


## Caveats

This image includes a pre-receive hook to do the buildings etc. Since
the hooks are part of the git repo and that repo is a volume, it's not
possible to uprade the pre-receive hook by just starting a new image.
