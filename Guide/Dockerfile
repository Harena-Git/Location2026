############################################################
# Étape de build : WildFly 10 + JDK8 + Ant
############################################################
FROM eclipse-temurin:8-jdk AS build

ENV DEBIAN_FRONTEND=noninteractive \
    WILDFLY_VERSION=10.1.0.Final \
    WILDFLY_HOME=/opt/wildfly

# Installer dépendances (wget, unzip, ant)
RUN apt-get update \
 && apt-get install -y --no-install-recommends wget unzip ant \
 && rm -rf /var/lib/apt/lists/*

# Télécharger WildFly 10
RUN wget https://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.zip \
 && unzip wildfly-${WILDFLY_VERSION}.zip -d /opt/ \
 && mv /opt/wildfly-${WILDFLY_VERSION} ${WILDFLY_HOME} \
 && rm wildfly-${WILDFLY_VERSION}.zip

ENV PATH="${WILDFLY_HOME}/bin:${PATH}" \
    JBOSS_HOME=${WILDFLY_HOME}

WORKDIR /workspace

# Copier le projet (Ant script + sources)
COPY . /workspace

# Construire et déployer (exploded war) dans ${WILDFLY_HOME}/standalone/deployments
# Le build.xml doit avoir deploy.dir fixé à /opt/wildfly/standalone/deployments
RUN ant -f build.xml deploy

############################################################
# Étape finale (runtime) plus légère
############################################################
FROM eclipse-temurin:8-jre
ENV WILDFLY_HOME=/opt/wildfly \
    JBOSS_HOME=/opt/wildfly

# Copier WildFly déjà doté du déploiement depuis l'étape build
COPY --from=build /opt/wildfly /opt/wildfly

EXPOSE 8080 9990

# Outils pour healthcheck
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD curl -sf http://localhost:8080 || exit 1

RUN sed -i 's/<http-listener name="default" socket-binding="http"/<http-listener name="default" socket-binding="http" max-parameters="5000"/' /opt/wildfly/standalone/configuration/standalone.xml

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-Dundertow.max-parameters=5000"]