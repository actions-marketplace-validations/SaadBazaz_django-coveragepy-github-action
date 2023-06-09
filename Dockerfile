FROM python:3.8.1-slim

LABEL "com.github.actions.name"="Django Coverage Action for Python"
LABEL "com.github.actions.description"="Python Django Coverage GitHub Action"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="black"


# # /var/lib
# # manual mysql fixes
# RUN set -eux; \
#  	groupadd -r mysql --gid=999; \
# # https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
#  	useradd -r -g mysql --uid=999 --home-dir=/var/lib/mysqld --shell=/bin/bash mysql; \
# # also create the postgres user's home directory with appropriate permissions
# # see https://github.com/docker-library/postgres/issues/274
#  	mkdir -p /var/lib/mysqld; \
#  	chown -R mysql:mysql /var/lib/mysqld; \
# 	mkdir -p /var/run/mysqld; \
# 	chown -R mysql:mysql /var/run/mysqld
# RUN mkdir -p /var/lib/mysqld && chown -R mysql:mysql /var/lib/mysqld && chmod 2777 /var/lib/mysqld && mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 2777 /var/run/mysqld

# # /var/run
# # manual mysql fixes



# # Configure Access to Home Directories
# # https://mariadb.com/kb/en/systemd/#configuring-access-to-home-directories
# RUN mkdir /etc/systemd/system/mariadb.service.d
# RUN tee /etc/systemd/system/mariadb.service.d/dontprotecthome.conf <<EOF \
# [Service]\
# \
# ProtectHome=false \
# EOF
# # RUN apt-get install --reinstall systemd
# # RUN systemctl daemon-reload



RUN apt-get update \
&& apt-get install -y --no-install-recommends git gcc libc-dev python3-dev build-essential libpq-dev mariadb-client libmariadbclient-dev \
&& apt-get purge -y --auto-remove \
&& rm -rf /var/lib/apt/lists/*


RUN pip install --upgrade pip virtualenv

# setup postgresql database and user.
# We don't expose the port, but allow all incomming connections
# USER mysql
# configure the user for later. the service will be started in the entrypoint
# RUN find /var/lib/mysql/mysql -exec touch -c -a {} + && service mysql start && mysqladmin -u root create mydb
USER root


COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
