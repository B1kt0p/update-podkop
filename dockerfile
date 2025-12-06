FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем пакеты
COPY update-podkop          /builder/package/update-podkop
COPY luci-app-update-podkop /builder/package/luci-app-update-podkop

WORKDIR /builder

# Главное — ПЕРЕСОЗДАЁМ feeds.conf с нашим локальным feed'ом
RUN echo "src-link custom /builder/package" > feeds.conf && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    make defconfig && \
    make package/update-podkop/compile V=sc -j$(nproc) && \
    make package/luci-app-update-podkop/compile V=sc -j$(nproc)

# Одна команда без warning'ов
CMD ["/bin/sh", "-c", "find bin -name '*update-podkop*.ipk' -o -name '*luci-app-update-podkop*.ipk' -exec cp {} /out/ \\;"]