FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Shanghai
ENV EMAIL=simon@tiertime.net

RUN sed -i "s@archive.ubuntu.com@repo.huaweicloud.com@g" /etc/apt/sources.list; \
    sed -i "s@security.ubuntu.com@repo.huaweicloud.com@g" /etc/apt/sources.list; \    
    apt update && apt upgrade; \    
    apt -y install tzdata locales apt-utils; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone;\
    locale-gen en_US.UTF-8;\
    echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale && \
    echo "LANGUAGE=\"en_US:en\"" >> /etc/default/locale && \
    echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale; \
    apt -y install python3 python3-venv libaugeas0;

RUN python3 -m venv /opt/certbot/; \
    /opt/certbot/bin/pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple; \
    /opt/certbot/bin/pip install certbot certbot-nginx -i https://pypi.tuna.tsinghua.edu.cn/simple; \
    ln -s /opt/certbot/bin/certbot /usr/bin/certbot -i https://pypi.tuna.tsinghua.edu.cn/simple; \
    /opt/certbot/bin/pip install certbot-dns-aliyun -i https://pypi.tuna.tsinghua.edu.cn/simple;

COPY obtain_cert.sh /opt/certbot/bin/obtain_cert
COPY renew_certs.sh /opt/certbot/bin/renew_certs

RUN chmod +x /opt/certbot/bin/obtain_cert; \
    ln -s /opt/certbot/bin/obtain_cert /usr/bin/obtain_cert; \
    chmod +x /opt/certbot/bin/renew_certs; \
    ln -s /opt/certbot/bin/renew_certs /usr/bin/renew_certs

ENTRYPOINT [ "bash" ]
