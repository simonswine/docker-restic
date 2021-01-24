FROM alpine:3.13

ENV RESTIC_VERSION=0.11.0

ADD restic-pub.pem /tmp/restic/restic-pub.pem

RUN cd /tmp/restic && \
    apk add --no-cache ca-certificates openssh-client && \
    apk add --no-cache --virtual .build curl gnupg && \
    curl -LO https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/SHA256SUMS && \
    curl -LO https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/SHA256SUMS.asc && \
    gpg --import restic-pub.pem && \
    gpg --verify SHA256SUMS.asc && \
    curl -LO https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2 && \
    cat SHA256SUMS | grep restic_${RESTIC_VERSION}_linux_amd64.bz2 | sha256sum -c && \
    bunzip2 restic_${RESTIC_VERSION}_linux_amd64.bz2 && \
    mv restic_${RESTIC_VERSION}_linux_amd64 /bin/restic && \
    chmod +x /bin/restic && \
    cd / && \
    rm -rf /tmp/restic && \
    apk del .build && \
    rm -rf /var/cache/apk/*

ADD run.sh /run.sh

ENTRYPOINT ["/bin/sh", "/run.sh"]
