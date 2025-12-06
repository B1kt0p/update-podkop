# Рабочий Dockerfile для itdoginfo/openwrt-sdk-ipk:24.10.3 (2025)
FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем свои пакеты в то место, куда их увидит OpenWrt после setup
COPY update-podkop          /openwrt/package/update-podkop
COPY luci-app-update-podkop /openwrt/package/luci-app-update-podkop

# Переходим в корень SDK (именно туда распаковывает setup.sh)
WORKDIR /openwrt

# Делаем всё одним RUN, чтобы точно видеть где падает
RUN ./setup.sh && \
    echo "src-link custom /openwrt/package" >> feeds.conf && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    make defconfig && \
    make package/update-podkop/compile          V=sc -j$(nproc) && \
    make package/luci-app-update-podkop/compile V=sc -j$(nproc)

# Копируем готовые ipk в /out одной командой (JSON-формат — без warning)
CMD ["/bin/sh", "-c", "find bin -name '*update-podkop*.ipk' -o -name '*luci-app-update-podkop*.ipk' -exec cp {} /out/ \\;"]