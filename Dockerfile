FROM alpine:3.6

MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

ADD entrypoint.sh /entrypoint.sh
ADD onstart.sh /onstart.sh
ADD onfinish.sh /onfinish.sh
RUN chmod +x /entrypoint.sh && \
    chmod +x /onstart.sh && \
    chmod +x /onfinish.sh

ONBUILD ADD command.sh /command.sh
ONBUILD RUN chmod +x /command.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
