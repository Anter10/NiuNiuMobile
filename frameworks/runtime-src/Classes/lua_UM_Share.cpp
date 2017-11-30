#include "scripting/lua-bindings/auto/lua_UM_Share.hpp"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS) && !defined(CC_TARGET_OS_TVOS)
#include "UM_Share.hpp"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_UM_Share_UM_Share_getlogin(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_getlogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_getlogin'", nullptr);
            return 0;
        }
        cobj->getlogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:getlogin",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_getlogin'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_boardcustomShare(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_boardcustomShare'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:boardcustomShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_boardcustomShare'", nullptr);
            return 0;
        }
        cobj->boardcustomShare(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:boardcustomShare",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_boardcustomShare'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_initWithShare(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_initWithShare'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:initWithShare");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UM_Share:initWithShare");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "UM_Share:initWithShare");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "UM_Share:initWithShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_initWithShare'", nullptr);
            return 0;
        }
        bool ret = cobj->initWithShare(arg0, arg1, arg2, arg3);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:initWithShare",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_initWithShare'.",&tolua_err);
#endif

    return 0;
}
int lua_UM_Share_UM_Share_shareWithAll(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_shareWithAll'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:shareWithAll");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UM_Share:shareWithAll");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "UM_Share:shareWithAll");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "UM_Share:shareWithAll");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_shareWithAll'", nullptr);
            return 0;
        }
        cobj->shareWithAll(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:shareWithAll",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_shareWithAll'.",&tolua_err);
#endif

    return 0;
}
//int lua_UM_Share_UM_Share_add_WebView(lua_State* tolua_S)
//{
//    int argc = 0;
//    UM_Share* cobj = nullptr;
//    bool ok  = true;
//
//#if COCOS2D_DEBUG >= 1
//    tolua_Error tolua_err;
//#endif
//
//
//#if COCOS2D_DEBUG >= 1
//    if (!tolua_isusertype(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
//#endif
//
//    cobj = (UM_Share*)tolua_tousertype(tolua_S,1,0);
//
//#if COCOS2D_DEBUG >= 1
//    if (!cobj) 
//    {
//        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UM_Share_UM_Share_add_WebView'", nullptr);
//        return 0;
//    }
//#endif
//
//    argc = lua_gettop(tolua_S)-1;
//    if (argc == 3) 
//    {
//        std::string arg0;
//        cocos2d::Size arg1;
//        cocos2d::Point arg2;
//
//        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:add_WebView");
//
//        ok &= luaval_to_size(tolua_S, 3, &arg1, "UM_Share:add_WebView");
//
//        ok &= luaval_to_point(tolua_S, 4, &arg2, "UM_Share:add_WebView");
//        if(!ok)
//        {
//            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_add_WebView'", nullptr);
//            return 0;
//        }
////        cobj->add_WebView(arg0, arg1, arg2);
//        lua_settop(tolua_S, 1);
//        return 1;
//    }
//    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:add_WebView",argc, 3);
//    return 0;
//
//#if COCOS2D_DEBUG >= 1
//    tolua_lerror:
//    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_add_WebView'.",&tolua_err);
//#endif
//
//    return 0;
//}
int lua_UM_Share_UM_Share_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_create'", nullptr);
            return 0;
        }
        UM_Share* ret = UM_Share::create();
        object_to_luaval<UM_Share>(tolua_S, "UM_Share",(UM_Share*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UM_Share:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_create'.",&tolua_err);
#endif
    return 0;
}
int lua_UM_Share_UM_Share_createWithShare(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "UM_Share:createWithShare");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "UM_Share:createWithShare");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "UM_Share:createWithShare");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "UM_Share:createWithShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_createWithShare'", nullptr);
            return 0;
        }
        UM_Share* ret = UM_Share::createWithShare(arg0, arg1, arg2, arg3);
        object_to_luaval<UM_Share>(tolua_S, "UM_Share",(UM_Share*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UM_Share:createWithShare",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_createWithShare'.",&tolua_err);
#endif
    return 0;
}
//int lua_UM_Share_UM_Share_getInternetConnectionStatus(lua_State* tolua_S)
//{
//    int argc = 0;
//    bool ok  = true;
//
//#if COCOS2D_DEBUG >= 1
//    tolua_Error tolua_err;
//#endif
//
//#if COCOS2D_DEBUG >= 1
//    if (!tolua_isusertable(tolua_S,1,"UM_Share",0,&tolua_err)) goto tolua_lerror;
//#endif
//
//    argc = lua_gettop(tolua_S) - 1;
//
//    if (argc == 0)
//    {
//        if(!ok)
//        {
//            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_getInternetConnectionStatus'", nullptr);
//            return 0;
//        }
//        int ret = UM_Share::getInternetConnectionStatus();
//        tolua_pushnumber(tolua_S,(lua_Number)ret);
//        return 1;
//    }
//    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UM_Share:getInternetConnectionStatus",argc, 0);
//    return 0;
//#if COCOS2D_DEBUG >= 1
//    tolua_lerror:
//    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_getInternetConnectionStatus'.",&tolua_err);
//#endif
//    return 0;
//}
int lua_UM_Share_UM_Share_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UM_Share* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UM_Share_UM_Share_constructor'", nullptr);
            return 0;
        }
        cobj = new UM_Share();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UM_Share");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UM_Share:UM_Share",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_UM_Share_UM_Share_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_UM_Share_UM_Share_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UM_Share)");
    return 0;
}

int lua_register_UM_Share_UM_Share(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UM_Share");
    tolua_cclass(tolua_S,"UM_Share","UM_Share","cc.Layer",nullptr);

    tolua_beginmodule(tolua_S,"UM_Share");
        tolua_function(tolua_S,"new",lua_UM_Share_UM_Share_constructor);
        tolua_function(tolua_S,"getlogin",lua_UM_Share_UM_Share_getlogin);
        tolua_function(tolua_S,"boardcustomShare",lua_UM_Share_UM_Share_boardcustomShare);
        tolua_function(tolua_S,"initWithShare",lua_UM_Share_UM_Share_initWithShare);
        tolua_function(tolua_S,"shareWithAll",lua_UM_Share_UM_Share_shareWithAll);
//        tolua_function(tolua_S,"add_WebView",lua_UM_Share_UM_Share_add_WebView);
        tolua_function(tolua_S,"create", lua_UM_Share_UM_Share_create);
        tolua_function(tolua_S,"createWithShare", lua_UM_Share_UM_Share_createWithShare);
//        tolua_function(tolua_S,"getInternetConnectionStatus", lua_UM_Share_UM_Share_getInternetConnectionStatus);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UM_Share).name();
    g_luaType[typeName] = "UM_Share";
    g_typeCast["UM_Share"] = "UM_Share";
    return 1;
}
TOLUA_API int register_all_UM_Share(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_UM_Share_UM_Share(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

#endif
