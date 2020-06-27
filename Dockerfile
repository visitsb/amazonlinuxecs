FROM amazonlinux:latest
LABEL maintainer="Shanti Naik <visitsb@gmail.com>"

USER root

COPY keep-alive.sh /usr/local/bin/
COPY sshd_config /tmp/
COPY sudoers /tmp/
COPY goss.yaml /goss.yaml

ENV GOSS_VERSION=v0.3.13
# Use yum whatprovides to identify which package is suitable for command you want to install
# yum whatprovides netstat
# https://stackoverflow.com/a/57073163
RUN /usr/bin/yum -y upgrade \
 && /usr/bin/yum -y update \
 && /usr/bin/yum install -y \
      amazon-efs-utils \
      which \
      sudo \
      util-linux \
      shadow-utils \
      procps-ng \
      file \
      openssh-server \
      openssh-client \
      net-tools \
      telnet \
 && /usr/bin/yum -y upgrade \
 && /usr/bin/yum -y update \
 && /usr/bin/yum -y clean all \
 && /usr/bin/rm -rf /var/cache/yum \
 && /usr/bin/curl --location --compressed https://github.com/aelsabbahy/goss/releases/download/$GOSS_VERSION/goss-linux-amd64 --output /usr/local/bin/goss \
 && /usr/sbin/useradd --user-group --groups wheel --uid 1000 ec2-user \
 && /bin/echo "root:" | /usr/sbin/chpasswd \
 && /bin/echo "ec2-user:ec2-user" | /usr/sbin/chpasswd \
 && /bin/cat /tmp/sshd_config >> /etc/ssh/sshd_config \
 && /bin/cat /tmp/sudoers >> /etc/sudoers \
 && /usr/bin/ssh-keygen -A \
 && /usr/bin/systemctl enable sshd \
 && /bin/chmod ugo+r /goss.yaml \
 && /bin/chmod ugo+rx /usr/local/bin/goss \
 && /bin/chmod ugo+rx /usr/local/bin/keep-alive.sh

EXPOSE 22/tcp

# http://0.0.0.0:8080/healthz
EXPOSE 8080/tcp
HEALTHCHECK --interval=5s --timeout=5s --start-period=5s --retries=3 CMD /usr/local/bin/goss -g /goss.yaml validate

STOPSIGNAL SIGTERM

# root password is empty
# User "ec2-user" is created with sudo rights (no password required to run sudo commands)
# Password is "ec2-user"
USER ec2-user
CMD ["keep-alive.sh"]
