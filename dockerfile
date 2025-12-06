# Рабочий Dockerfile для itdoginfo/openwrt-sdk-ipk:24.10.3 (2025)
FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем свои пакеты в то место, куда их увидит OpenWrt после setup
COPY ./update-podkop          /builder/package/feeds/utilities/update-podkop
COPY ./luci-app-update-podkop /builder/package/feeds/luci/luci-app-update-podkop


# Делаем всё одним RUN, чтобы точно видеть где падает
RUN make defconfig && \
    make package/update-podkop/compile V=sc -j$(nproc) && \
    make package/luci-app-update-podkop/compile V=sc -j$(nproc)

# Копируем готовые ipk в /out одной командой (JSON-формат — без warning)
CMD ["/bin/sh", "-c", "find bin -name '*update-podkop*.ipk' -o -name '*luci-app-update-podkop*.ipk' -exec cp {} /out/ \\;"]