TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UnlockerCC
UnlockerCC_BUNDLE_EXTENSION = bundle
UnlockerCC_FILES = UnlockerCC.m
UnlockerCC_CFLAGS = -fobjc-arc
UnlockerCC_PRIVATE_FRAMEWORKS = ControlCenterUIKit
UnlockerCC_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
