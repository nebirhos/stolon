FROM fedora:24

RUN dnf -y install postgresql-server postgresql hostname

RUN dnf clean all

RUN useradd -ms /bin/bash stolon

COPY run.sh bin/stolon-keeper bin/stolon-sentinel bin/stolon-proxy /usr/local/bin/

EXPOSE 5431 5432 6431

ENTRYPOINT ["/usr/local/bin/run.sh"]
