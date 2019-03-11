FROM python:2.7

# add a user for the app on alpine
#     https://github.com/gliderlabs/docker-alpine/issues/38#issuecomment-377520103
# Packages according to README.md:
# - https://www.itzgeek.com/how-tos/linux/debian/how-to-install-memcached-on-debian-9.html
# - https://www.cairographics.org/download/
RUN mkdir /badgr && \
#    adduser -D -h /badgr badgr && \ # alpine
    useradd -m -d /badgr badgr && \
    chown -R badgr /badgr && \
    apt-get update && \
    apt-get -y install libcairo2-dev mysql-client

# TODO: 
# - https://docs.docker.com/samples/library/rabbitmq/
# - https://docs.docker.com/samples/library/memcached/

WORKDIR /badgr

ADD requirements.txt .
RUN pip install -r requirements.txt
ENV PATH="$PATH:/badgr/.local/bin"

ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["migrate", "runserver"]
ADD . .

#RUN chown -R badgr /badgr
RUN cp docker/settings_local.py apps/mainsite/settings_local.py

#USER badgr



