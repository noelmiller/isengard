ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-bazzite}"
ARG IMAGE_TAG="${IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE_NAME}:${IMAGE_TAG} AS isengard

COPY system_files /
COPY scripts /scripts

RUN /scripts/preconfigure.sh && \
    /scripts/install_packages.sh && \
    /scripts/configure_kde.sh && \
    /scripts/enable_services.sh && \
    /scripts/just.sh && \
    /scripts/cleanup.sh && \
    ostree container commit
