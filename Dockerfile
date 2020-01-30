FROM debian:10.2
COPY bluditsetup.sh /build.sh
RUN chmod u+x /build.sh
RUN /build.sh
EXPOSE 80
#ENTRYPOINT tail -f /dev/null
CMD ["apachectl", "-D", "FOREGROUND"]
