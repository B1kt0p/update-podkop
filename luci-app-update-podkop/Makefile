include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI interface for update-podkop
LUCI_DEPENDS:=+update-podkop
LUCI_PKGARCH:=all
PKG_VERSION:=0.1
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0
PKG_MAINTAINER:=Buktop

include $(TOPDIR)/feeds/luci/luci.mk

# compile rule
$(eval $(call BuildPackage,luci-app-update-podkop))