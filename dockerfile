FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем свои пакеты в место, куда setup.sh распакует SDK
COPY update-podkop          /builder/package/update-podkop
COPY luci-app-update-podkop /builder/package/luci-app-update-podkop

WORKDIR /builder

# КРИТИЧЕСКИ ВАЖНО — setup.sh готовит среду (скачивает SDK, создаёт feeds.conf, dl/)
RUN [ ! -d ./scripts ] && ./setup.sh && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    # Добавляем кастомный feed для твоих пакетов (если package/ не в стандартном месте)
    echo "src-link custom /builder/package" >> feeds.conf && \
    ./scripts/feeds update custom && \
    ./scripts/feeds install -a && \
    make defconfig && \
    make package/update-podkop/compile          V=sc -j$(nproc) && \
    make package/luci-app-update-podkop/compile V=sc -j$(nproc)

# Одна строка CMD в JSON-формате (без warning'ов)
CMD ["/bin/sh", "-c", "find bin -name '*update-podkop*.ipk' -o -name '*luci-app-update-podkop*.ipk' -exec cp {} /out/ \\;"]