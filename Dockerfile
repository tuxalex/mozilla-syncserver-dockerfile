# VERSION 0.1
# DESCRIPTION:    mozilla syncserver conatiner
# TO_BUILD:       docker build -rm -t syncserver .
# TO_RUN:         docker run --name=fsync -d -v /home/fsync_config/:/home/syncserver/ -v /var/log/fsync/:/var/log/syncserver -p 5000:5000 -ti tuxcloud.fr/fsync

FROM ubuntu-debootstrap:14.04
MAINTAINER Alexan Andrieux "alexan.andrieux@gmail.com" 
#BASE ON Arthur Caranta "arthur+code.mozillasyncdocker@caranta.com"


RUN apt-get -y update
RUN apt-get install -y git build-essential python-virtualenv python2.7-dev

RUN git clone https://github.com/mozilla-services/syncserver.git 
RUN cd syncserver && make build
RUN mkdir /home/syncserver/ 
RUN mkdir /var/log/syncserver/
RUN touch /var/log/syncserver/sync-error.log
#&& cp /syncserver/syncserver.ini /home/syncserver/config.ini
#RUN echo "sqluri = sqlite:////home/syncserver/syncserver.db" >>/home/syncserver/config.ini
#RUN echo "allow_new_users = true" >>/home/syncserver/config.ini
RUN perl -p -i -e "s#paste ./syncserver.ini#paste /home/syncserver/config.ini#g" /syncserver/Makefile

ADD config.ini /home/syncserver/config.ini

VOLUME ["/home/syncserver/"]
VOLUME ["/var/log/syncserver"]
EXPOSE 5000

CMD cd syncserver && make serve
