FROM ubuntu:latest

ENV APP_TITLE='Virtual Machine Manager'

# Background color
ENV BG_GRADIENT="#111, #222"

ENV BROADWAY_DISPLAY=':5'

# Passed to nginx
ENV CORNER_IMAGE_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'
ENV FAVICON_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'

ENV GDK_BACKEND='broadway'
ENV GTK_THEME='Adwaita:dark'
ENV HOSTS="[]"

RUN apt-get update && apt-get install -y \
    at-spi2-core \
    dbus-x11 \
    gettext-base \
    gir1.2-spiceclientgtk-3.0 \
    libglib2.0-bin \
    libgtk-4-1 \
    libgtk-4-bin \
    nginx \
    papirus-icon-theme \
    ssh \
    tmux \
    virt-manager \
    wget && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate -O /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)"
RUN chmod +x /usr/bin/ttyd

RUN mkdir -p /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

COPY startapp.sh /usr/local/bin/startapp
COPY start.sh  /usr/local/bin/start
RUN chmod +x /usr/local/bin/start /usr/local/bin/startapp

COPY nginx.tmpl /etc/nginx/nginx.tmpl
COPY terminal-outline.svg /www/data/images/terminal-outline.svg

CMD ["/usr/local/bin/startapp"]