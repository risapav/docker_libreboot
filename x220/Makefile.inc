## SPDX-License-Identifier: GPL-2.0-only

bootblock-y += variants/$(VARIANT_DIR)/gpio.c
romstage-y += variants/$(VARIANT_DIR)/gpio.c
romstage-y += variants/$(VARIANT_DIR)/romstage.c


ifeq ($(CONFIG_BOARD_LENOVO_X220_EDP),y)
ramstage-$(CONFIG_MAINBOARD_USE_LIBGFXINIT) += variants/x220_edp/gma-mainboard.ads
else
ramstage-$(CONFIG_MAINBOARD_USE_LIBGFXINIT) += gma-mainboard.ads
endif

bootblock-y += early_init.c
romstage-y += early_init.c
