# *** Check for smaller bask image 
FROM maven:3.8-openjdk-8 AS base
WORKDIR /app
# Maven files
COPY ./project/src ./src
COPY ./project/LICENSE-GPLv3.txt ./
COPY ./project/pom.xml ./

RUN mvn verify


FROM openjdk:8-jre-alpine
WORKDIR /app
# *** CHANGE LATER -- copy only jar file into a created target file
COPY --from=base app/target/ ./target
# ENV variable for db 
ENV DB_DIALECT MYSQL
ENV DB_URL jdbc:mysql://db:3306/lavagna?autoReconnect=true&useSSL=false 
ENV DB_USER root
ENV DB_PASS root
ENV SPRING_PROFILE dev

COPY ./entrypoint.sh ./
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
