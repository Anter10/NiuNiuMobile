LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

# LOCAL_MODULE := libGCloudVoice
# LOCAL_SRC_FILES := ../../../Classes/GCloudVoice/libs/Android/armeabi/libGCloudVoice.so
# include $(PREBUILT_SHARED_LIBRARY)

# ../../../Classes/CloudVoice.cpp\
# 		../../../Classes/lua_CloudVoice.cpp\
# 		../../../Classes/MessageNotify.cpp\
#../../../Classes/MessageNotify.cpp\

LOCAL_SRC_FILES := \
hellolua/main.cpp\
		../../../Classes/AppDelegate.cpp \
		../../../Classes/protobuf/pb.c\
		../../../Classes/protobuf/lfs.c\
		../../../Classes/UM_Share.cpp \
		../../../Classes/lua_UM_Share.cpp\
		../../../Classes/CloudVoice.cpp\
 		../../../Classes/lua_CloudVoice.cpp\
		../../../Classes/Cocos2dx/Android/CCUMSocialController.cpp\
		../../../Classes/Cocos2dx/Common/CCUMSocialSDK.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes
LOCAL_C_INCLUDES += $(LOCAL_PATH)../../../Classes/GCloudVoice/include
# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
# LOCAL_SHARED_LIBRARIES := libGCloudVoice
# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
LOCAL_ALLOW_UNDEFINED_SYMBOLS := true