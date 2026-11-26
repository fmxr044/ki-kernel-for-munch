## Ki-Kernel - munch (sm8250 / kona) only
## 净化后仅保留 munch 机型与 kona 平台基础设备树

ifeq ($(CONFIG_ARCH_KONA),y)
dtb-y += kona.dtb \
         kona-v2.dtb \
         kona-v2.1.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
dtbo-$(CONFIG_MACH_XIAOMI_MUNCH) += munch-sm8250-overlay.dtbo
munch-sm8250-overlay.dtbo-base := kona.dtb kona-v2.dtb kona-v2.1.dtb
endif
