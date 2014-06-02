FROM ubuntu:14.04
MAINTAINER Johannes 'fish' Ziemke <fish@freigeist.org> @discordianfish
EXPOSE 22

RUN apt-get -qy update && apt-get -qy install git openssh-server iptables ca-certificates runit
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
RUN mkdir /var/lib/docker && chmod a+x /usr/local/bin/docker

RUN groupadd docker
RUN useradd -m -G docker -d /git -s /usr/bin/git-shell git && passwd -d git
RUN useradd log
RUN mkdir /var/run/sshd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

ADD registry /etc/registry
ADD service /etc/service
RUN chown log:log /etc/service/sshd/log/main && chown log:log /etc/service/docker/log/main

ADD     authorized_keys.root  /root/.ssh/authorized_keys
# ADD doesn not honor USER, so we need to chown it. See #6119
ADD     authorized_keys  /git/.ssh/authorized_keys
RUN     chown git:git -R /git/.ssh/

USER    git
WORKDIR /git
RUN     git init --bare universe.git
ADD     pre-receive /git/universe.git/hooks/
VOLUME  /git/universe.git

USER root
ENTRYPOINT [ "/usr/sbin/runsvdir-start" ]
