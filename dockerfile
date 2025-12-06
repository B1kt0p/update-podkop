FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем свои пакеты
COPY update-podkop          /builder/package/update-podkop
COPY luci-app-update-podkop /builder/package/luci-app-update-podkop

WORKDIR /builder

# Обязательные шаги — без них пакеты не увидит система сборки
RUN ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    make defconfig && \
    make package/update-podkop/compile          V=sc -j$(nproc) && \
    make package/luci-app-update-podkop/compile V=sc -j$(nproc)

# Одна команда — копирует оба .ipk в /out
CMD find bin -name "*update-podkop*.ipk" -exec cp {} /out/ \; && \
    find bin -name "*luci-app-update-podkop*.ipk" -exec cp {} /out/ \;