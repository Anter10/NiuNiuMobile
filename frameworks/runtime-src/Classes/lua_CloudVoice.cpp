#include "scripting/lua-bindings/auto/lua_CloudVoice.hpp"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS) && !defined(CC_TARGET_OS_TVOS)
#include "CloudVoice.hpp"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_CloudVoice_CloudVoice_PlayRecordedFile(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_PlayRecordedFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_PlayRecordedFile'", nullptr);
            return 0;
        }
        cobj->PlayRecordedFile();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:PlayRecordedFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_PlayRecordedFile'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_Refresh_ForKey(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_Refresh_ForKey'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_Refresh_ForKey'", nullptr);
            return 0;
        }
        cobj->Refresh_ForKey();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:Refresh_ForKey",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_Refresh_ForKey'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_Init_Voice(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_Init_Voice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CloudVoice:Init_Voice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_Init_Voice'", nullptr);
            return 0;
        }
        cobj->Init_Voice(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:Init_Voice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_Init_Voice'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_onEnter(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_onEnter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_onEnter'", nullptr);
            return 0;
        }
        cobj->onEnter();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:onEnter",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_onEnter'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_StopPlayFile(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_StopPlayFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_StopPlayFile'", nullptr);
            return 0;
        }
        cobj->StopPlayFile();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:StopPlayFile",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_StopPlayFile'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_StopRecording(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_StopRecording'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_StopRecording'", nullptr);
            return 0;
        }
        cobj->StopRecording();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:StopRecording",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_StopRecording'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_update(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_update'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "CloudVoice:update");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_update'", nullptr);
            return 0;
        }
        cobj->update(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:update",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_update'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_setFileID(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_setFileID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CloudVoice:setFileID");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_setFileID'", nullptr);
            return 0;
        }
        cobj->setFileID(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:setFileID",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_setFileID'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_init(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_init'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_StartRecording(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_StartRecording'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_StartRecording'", nullptr);
            return 0;
        }
        cobj->StartRecording();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:StartRecording",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_StartRecording'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_DownloadRecordedFile(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CloudVoice*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_CloudVoice_CloudVoice_DownloadRecordedFile'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CloudVoice:DownloadRecordedFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_DownloadRecordedFile'", nullptr);
            return 0;
        }
        cobj->DownloadRecordedFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:DownloadRecordedFile",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_DownloadRecordedFile'.",&tolua_err);
#endif

    return 0;
}
int lua_CloudVoice_CloudVoice_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CloudVoice",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_create'", nullptr);
            return 0;
        }
        CloudVoice* ret = CloudVoice::create();
        object_to_luaval<CloudVoice>(tolua_S, "CloudVoice",(CloudVoice*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CloudVoice:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_create'.",&tolua_err);
#endif
    return 0;
}
int lua_CloudVoice_CloudVoice_constructor(lua_State* tolua_S)
{
    int argc = 0;
    CloudVoice* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CloudVoice_CloudVoice_constructor'", nullptr);
            return 0;
        }
        cobj = new CloudVoice();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"CloudVoice");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CloudVoice:CloudVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_CloudVoice_CloudVoice_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_CloudVoice_CloudVoice_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CloudVoice)");
    return 0;
}

int lua_register_CloudVoice_CloudVoice(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CloudVoice");
    tolua_cclass(tolua_S,"CloudVoice","CloudVoice","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"CloudVoice");
        tolua_function(tolua_S,"new",lua_CloudVoice_CloudVoice_constructor);
        tolua_function(tolua_S,"PlayRecordedFile",lua_CloudVoice_CloudVoice_PlayRecordedFile);
        tolua_function(tolua_S,"Refresh_ForKey",lua_CloudVoice_CloudVoice_Refresh_ForKey);
        tolua_function(tolua_S,"Init_Voice",lua_CloudVoice_CloudVoice_Init_Voice);
        tolua_function(tolua_S,"onEnter",lua_CloudVoice_CloudVoice_onEnter);
        tolua_function(tolua_S,"StopPlayFile",lua_CloudVoice_CloudVoice_StopPlayFile);
        tolua_function(tolua_S,"StopRecording",lua_CloudVoice_CloudVoice_StopRecording);
        tolua_function(tolua_S,"update",lua_CloudVoice_CloudVoice_update);
        tolua_function(tolua_S,"setFileID",lua_CloudVoice_CloudVoice_setFileID);
        tolua_function(tolua_S,"init",lua_CloudVoice_CloudVoice_init);
        tolua_function(tolua_S,"StartRecording",lua_CloudVoice_CloudVoice_StartRecording);
        tolua_function(tolua_S,"DownloadRecordedFile",lua_CloudVoice_CloudVoice_DownloadRecordedFile);
        tolua_function(tolua_S,"create", lua_CloudVoice_CloudVoice_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CloudVoice).name();
    g_luaType[typeName] = "CloudVoice";
    g_typeCast["CloudVoice"] = "CloudVoice";
    return 1;
}
TOLUA_API int register_all_CloudVoice(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_CloudVoice_CloudVoice(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

#endif
