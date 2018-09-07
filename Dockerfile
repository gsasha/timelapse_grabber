FROM gsasha/ffmpeg
MAINTAINER Sasha <gsasha@gmail.com>
LABEL Description="Grabber of stills from a wifi camera."

RUN apk --no-cache add curl
ADD grab_frame.sh /scripts/grab_frame.sh
#RUN mkdir -p /stills
VOLUME /stills

ENV CAMERA_NAME caminion
ENV CAMERA_ADDR 10.10.10.12:10554
ENV PUSHGATEWAY_ADDR 10.10.10.17:9091
ENV CAMERA_USER user
ENV CAMERA_PASSWORD passwd

RUN echo "* * * * * /usr/bin/nohup /scripts/grab_frame.sh" > /etc/crontabs/root
CMD '/usr/sbin/crond' '-f'


