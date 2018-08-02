FROM centos
RUN yum -y update && \
    yum -y group install "Development Tools" && \
    yum -y install epel-release && \
    yum -y install python34 zlib-devel readline-devel \
    yum clean all

RUN curl -LO https://bitbucket.org/mhulden/foma/downloads/foma-0.9.18.tar.gz
RUN tar xzf foma-0.9.18.tar.gz
WORKDIR foma-0.9.18
RUN make && make install
WORKDIR ..

RUN curl -LO https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.1.1.tar.gz
RUN tar xzf libvoikko-4.1.1.tar.gz
WORKDIR libvoikko-4.1.1
RUN ./configure -disable-hfst --enable-static --disable-shared && \
    make && make install
WORKDIR ..

RUN curl -LO https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.2.tar.gz
RUN tar xzf voikko-fi-2.2.tar.gz
WORKDIR voikko-fi-2.2
RUN make vvfst && make vvfst-install DESTDIR=/usr/share/voikko

VOLUME /out
CMD cp /usr/local/bin/voikkospell /out && \
    cp -R /usr/share/voikko /out/dictionary
