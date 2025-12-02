include $(TOPDIR)/rules.mk

PKG_NAME:=update-podkop
PKG_VERSION:=0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=Buktop

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/update-podkop
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Update tool for Podkop
  DEPENDS:=+uci
endef

define Package/update-podkop/description
  Script for updating from a GitHub repo using parameters in /etc/config/update-podkop.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	# Ничего не компилируем, только копируем файлы
endef

define Package/update-podkop/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/update-podkop $(1)/etc/config/update-podkop

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/update-podkop.sh $(1)/usr/bin/update-podkop
endef

$(eval $(call BuildPackage,update-podkop))