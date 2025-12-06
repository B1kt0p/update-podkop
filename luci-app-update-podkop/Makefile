include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI interface for update-podkop
LUCI_PKGARCH:=all
PKG_LICENSE:=GPL-3.0

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-update-podkop/install
  $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
  $(INSTALL_DATA) ./luasrc/controller/update_podkop.lua $(1)/usr/lib/lua/luci/controller/update_podkop.lua
endef

$(eval $(call BuildPackage,luci-app-update-podkop))