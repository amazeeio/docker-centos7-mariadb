FROM amazeeio/centos:7
MAINTAINER amazee.io

ENV MARIADB_VERSION=10.1

RUN { \
      echo '[mariadb]'; \
      echo 'name = MariaDB'; \
      echo "baseurl = http://yum.mariadb.org/$MARIADB_VERSION/centos7-amd64"; \
      echo 'gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'; \
      echo 'gpgcheck=1'; \
    } > /etc/yum.repos.d/mariadb.repo

COPY server.cnf /etc/my.cnf.d/server.cnf
COPY docker-entrypoint /usr/local/bin/docker-entrypoint

RUN yum install -y epel-release && \
    yum install -y pwgen MariaDB-server MariaDB-client && \
    yum clean all && \
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    fix-permissions /var/lib/mysql && \
    fix-permissions /var/run/mysqld && \
    fix-permissions /var/log/ && \
    fix-permissions /etc/my.cnf.d/

ENV MYSQL_RANDOM_ROOT_PASSWORD=true \
    MYSQL_DATABASE=amazeeio \
    MYSQL_USER=amazeeio \
    MYSQL_PASSWORD=amazeeio

VOLUME /var/lib/mysql
ENTRYPOINT ["docker-entrypoint"]
CMD ["mysqld"]