# *** Check for smaller bask image 
FROM maven:3.8-openjdk-8 AS base
WORKDIR /app
# Maven files
COPY ./project/src ./src
COPY ./project/LICENSE-GPLv3.txt ./
COPY ./project/pom.xml ./
# Maven run and create a target folder
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

# Script run file and Waitfor script
COPY ./entrypoint.sh ./
ADD https://raw.githubusercontent.com/eficode/wait-for/master/wait-for ./
RUN chmod +x ./wait-for
RUN chmod +x entrypoint.sh
#command: ["./wait-for", "db:3306", "--", "./entrypoint.sh"] 
# Runs the waitforit script, checks if the db container is up , starts the entry point script
ENTRYPOINT [ "./wait-for" , "db:3306" , "--" , "./entrypoint.sh" ]
#ENTRYPOINT [ "./entrypoint.sh" ]
