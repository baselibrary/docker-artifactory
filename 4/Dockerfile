FROM baselibrary/java:8
MAINTAINER ShawnMa <qsma@thoughtworks.com>

## Version
ENV ARTIFACTORY_MAJOR   4
ENV ARTIFACTORY_VERSION 4.6.0

## Repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D7639232 &&\
  echo "deb https://jfrog.bintray.com/artifactory-pro-debs trusty main" > /etc/apt/sources.list.d/artifactory.list

## Packages
RUN \
  apt-get update &&\
  apt-get install -y jfrog-artifactory-pro=$ARTIFACTORY_VERSION &&\
  rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/artifactory"]

CMD ["artifactory"]
