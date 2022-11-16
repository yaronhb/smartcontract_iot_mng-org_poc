FROM    freeradius/freeradius-server:3.2.1

RUN     apt-get update
RUN     apt-get install -y git libssl-dev devscripts pkg-config libnl-3-dev libnl-genl-3-dev curl

RUN     apt-get install -y nano less

RUN     apt-get install -y jq
RUN     cd $(mktemp -d) &&\
        curl -L https://github.com/kellyjonbrazil/jc/releases/download/v1.22.1/jc_1.22.1-1_amd64.deb --output jc_amd64.deb &&\
        dpkg -i jc_amd64.deb &&\
        rm -r $(pwd) &&\
        cd -

COPY    freeradius-server-git/ /etc/freeradius-server-git
RUN     cd /etc/freeradius-server-git/scripts/ci/ &&\
        ./eapol_test-build.sh &&\
        cp ./eapol_test/eapol_test /usr/local/bin/

RUN     apt-get install -y redis

ARG     raddb="raddb"
RUN     ln -sf /bin/bash /bin/sh
COPY    "$raddb"/ /etc/raddb/

COPY    make_certs/ /etc/make_certs/

RUN     mkdir /tmp/radiusd && chown freerad /tmp/radiusd

ENTRYPOINT ["freeradius",  "-X"]
