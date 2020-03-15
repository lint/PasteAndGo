ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PasteAndGo
PasteAndGo_FILES = Tweak.xm
PasteAndGo_CFLAGS = -fobjc-arc
PasteAndGo_PRIVATE_FRAMEWORKS = BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
