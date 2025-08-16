# syntax=docker/dockerfile:1

FROM openjdk:11-jdk-buster

LABEL version="1.12.0"
LABEL homepage.group=Minecraft
LABEL homepage.name="Enigmatica 6 1.12.0"
LABEL homepage.icon="https://media.forgecdn.net/avatars/287/328/637307875703147764.jpeg"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://Enigmatica6:25565
RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

ENV MOTD " Server"

CMD ["/launch.sh"]