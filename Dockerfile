FROM gsasha/ffmpeg
MAINTAINER Sasha <gsasha@gmail.com>
LABEL Description="Grabber of stills from a wifi camera."

ADD grab_frame.sh /scripts/grab_frame.sh
RUN mkdir -p /stills
VOLUME /stills

ENV CameraName XXX
ENV CameraIP 10.10.10.12
ENV CameraUsername user
ENV CameraPassword passwd

RUN echo "* * * * * /usr/bin/nohup /scripts/grab_frame.sh" > /etc/crontabs/root
CMD '/usr/sbin/crond' '-f'


