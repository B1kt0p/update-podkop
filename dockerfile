# Лучше использовать официальный образ и указать свою цель
FROM openwrt/sdk:aarch64_cortex-a53-24.10.3
# Или если itdoginfo тебе очень нравится и работает — можно оставить:
# FROM itdoginfo/openwrt-sdk-ipk:24.10.3

ARG VERSION=0.1
ENV VERSION=v${VERSION}

# Копируем свой пакет в стандартное место
COPY update-podkop /builder/package/update-podkop

WORKDIR /builder

# Только defconfig + сборка нужного пакета
RUN make defconfig && \
    make package/update-podkop/compile V=s -j$(($(nproc) + 1))

CMD find bin -name "*update-podkop*.ipk" -exec cp {} /out/ \;