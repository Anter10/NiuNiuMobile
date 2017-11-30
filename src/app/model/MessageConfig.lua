
 --[[生成messageType---zj]]--
 --  房间是否存在
N_room_STATE ={}
N_room_STATE[1]="房间号不存在"
N_room_STATE[2]="玩家有房间"
N_room_STATE[3]="钻石不足"
N_room_STATE[4]="游戏正在进行中,请等待下局加入"
N_room_STATE[5]="房间人数已满"

--  配牛信息
N_NIU_STATE ={}
N_NIU_STATE[0]="没牛"
N_NIU_STATE[1]="牛一"
N_NIU_STATE[2]="牛二"
N_NIU_STATE[3]="牛三"
N_NIU_STATE[4]="牛四"
N_NIU_STATE[5]="牛五"
N_NIU_STATE[6]="牛六"
N_NIU_STATE[7]="牛七"
N_NIU_STATE[8]="牛八"
N_NIU_STATE[9]="牛九"
N_NIU_STATE[10]="牛牛"
N_NIU_STATE[11]="五花牛"
N_NIU_STATE[12]="炸弹牛"
N_NIU_STATE[13]="五小牛"
------房间规则信息
PARMS_A={
  "10局  ",
  "20局  "
}

PARMS_B={
  "轮流坐庄\n",
  "翻四张抢庄\n",
  "经典抢庄\n",
}
PARMS_C={
  "一分场  ",
  "五分场  ",
  "十分场  ",
}

PARMS_D={
  "牛牛×3 牛九×2 ",
  "牛牛×4 牛九×3 "
}

PARMS_E={
  "有特殊牛\n",
  "无特殊牛\n"
}

PARMS_F={}
PARMS_F[1]="超时托管\n"
PARMS_F[2]="不托管\n"





N_USER_STATE =--用户状态，针对自己
{
  N_USER_STATE_WAIT = 0, --//玩家等待状态 可以点击准备或者开始;
  N_USER_STATE_READY=1,   --//玩家准备完毕，等待抢庄;
  N_USER_STATE_ZHUANG=2,  --//玩家抢庄完毕，等待下注;
  N_USER_STATE_BET=3,     --//玩家下注完毕，等待配牛;
  N_USER_STATE_OPEN=4,    --//玩家配牛完毕，等待结算;
  N_USER_STATE_WAIT_JION = 5,    
  N_USER_STATE_END=6,

};


N_DESK_STATE=--房间状态,广播所有玩家
{
  N_DESK_STATE_WAIT = 0,--等待准备或开始
  N_DESK_STATE_READY=1,--准备完成
  N_DESK_STATE_START=2,--发牌
  N_DESK_STATE_ZHUANG=3,--抢庄 
  N_DESK_STATE_BET=4,--下注
  N_DESK_STATE_OPEN=5,--所有亮牌
  N_DESK_STATE_END=6,---
}



Message_config = {}

Message_config.TYPES = {
	--一定要保证sc 是cs+1, 每个模块的notify从后往前放
    -- common 序号[0-99]
    -- hall client 消息区间 序号[1000 --5000]
    MSG_C_CLIENT_TICK = 1001,--client发来的Tick心跳消息号;
    MSG_C_2_S_LOGIN_REQ = 1002,--客户端发给服务器gate;
    MSG_S_2_C_LOGIN_RES = 1003,--gate服务器返回结果;

    MSG_C_2_L_LOGIN_REQ = 1004,--客户端发给登录服务器login;
    MSG_L_2_C_LOGIN_RES = 1005,--登录服务器返回结果login;

    MSG_S_2_C_USER_INFO = 1006,--服务器发送玩家信息到client;

    MSG_C_2_S_CREATE_ROOM_REQ = 1007,--client 申请创建房间;
    MSG_S_2_C_CREATE_ROOM_RES = 1008,--client 申请创建房间结果返回;

    MSG_C_2_S_JOIN_ROOM_REQ = 1009,--client 申请进入房间;
    MSG_S_2_C_JION_ROOM_RES = 1010,--client 申请进入房间结果返回;

    MSG_S_2_C_ROOM_USER_INFO = 1011,--服务器广播房间内玩家信息到client;

    MSG_C_2_S_ROOM_USER_ACTION_REQ = 1012,--玩家操作申请;
    
    MSG_S_2_C_ROOM_USER_ACTION_RES = 1013,--//玩家操作申请结果返回;

    MSG_S_2_C_ROOM_USER_ACTION_INFO = 1014,--//服务器广播房间内玩家操作信息到client;

    MSG_S_2_C_ROOM_USER_CARD_INFO = 1015,--//服务器广播房间内玩家card信息到client;

    MSG_S_2_C_ROOM_RESULT_INFO = 1016,--//服务器广播房间本局结算界面;

    MSG_S_2_C_ROOM_USER_TALK_MSG = 1017,--//服务器广播房间本局结算界面;

    MSG_S_2_C_ROOM_DIS_BAND = 1021,--//解散牌局通知;

    MSG_S_2_C_ROOM_ALL_SCORE = 1022,--//解散牌局通知;

    MSG_S_2_C_SHARE_INFO = 1024,--//微信分享内容;

    MSG_S_2_C_MONEWY_MAG = 1025,--//微信分享内容;

    MSG_S_2_C_ZHANJI = 1019,--//战绩

    MSG_S_2_C_ZHANJI_MAG = 1020,--//战绩;

    REQUEST_PLAYERS_ROOMS = 1027, -- 请求玩家房间信息
    
    RESPONSE_PLAYERS_ROOMS = 1028, -- 解析玩家房间信息
     
}




 --[[生成messageType---zj]]--
Message_config.NAMES = {}

Message_config.NAMES[Message_config.TYPES.MSG_C_CLIENT_TICK] = "ClientTickMsg"
Message_config.NAMES[Message_config.TYPES.MSG_C_2_L_LOGIN_REQ] = "UserLoginMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_L_2_C_LOGIN_RES] = "UserLoginMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_C_2_S_LOGIN_REQ] = "ClientLoginMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_LOGIN_RES] = "ClientLoginMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_C_2_S_CREATE_ROOM_REQ] = "UserCreateRoomMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_CREATE_ROOM_RES] = "UserCreateRoomMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_JION_ROOM_RES] = "UserJoinRoomMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_C_2_S_JOIN_ROOM_REQ] = "UserJoinRoomMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_USER_INFO] = "NotifyRoomUserMsg"
Message_config.NAMES[Message_config.TYPES.MSG_C_2_S_ROOM_USER_ACTION_REQ] = "UserActionMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_USER_ACTION_INFO] = "NotifyRoomUserActionMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_USER_CARD_INFO] = "NotifyRoomUserCardMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_RESULT_INFO] = "NotifyRoomResultMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_USER_ACTION_RES] = "UserActionMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_DIS_BAND] = "NotifyRoomDisbandMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_USER_TALK_MSG] = "UserTalkMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ROOM_ALL_SCORE] = "NotifyRoomAllScoreMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_SHARE_INFO] = "ShareInfoMsgRes"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_MONEWY_MAG] = "NotifyMoneyMsg"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ZHANJI] = "HistoryResultMsgReq"
Message_config.NAMES[Message_config.TYPES.MSG_S_2_C_ZHANJI_MAG] = "HistoryResultMsgRes"
Message_config.NAMES[Message_config.TYPES.REQUEST_PLAYERS_ROOMS] = "UserSelectRoomsMsgReq"
Message_config.NAMES[Message_config.TYPES.RESPONSE_PLAYERS_ROOMS] = "UserSelectRoomsMsgRes"

N_CARD_COLOR_TYPE={
  N_CARD_COLOR_TYPE_NULL = 0,
  N_CARD_COLOR_TYPE_SQUAL =1,--//方块;
  N_CARD_COLOR_TYPE_FLOOR=2,--//梅花;
  N_CARD_COLOR_TYPE_RED=3,--//红桃;
  N_CARD_COLOR_TYPE_BLACK=4,--//黑桃;
  N_CARD_COLOR_TYPE_MASK=5,--//暗牌;
  N_CARD_COLOR_TYPE_END=6,
};

N_CARD_NUMBER_TYPE={
  N_CARD_NUMBER_TYPE_BULL = 0,
  N_CARD_NUMBER_TYPE_A=1,--
  N_CARD_NUMBER_TYPE_2=2,--
  N_CARD_NUMBER_TYPE_3=3,--
  N_CARD_NUMBER_TYPE_4=4,--
  N_CARD_NUMBER_TYPE_5=5,--
  N_CARD_NUMBER_TYPE_6=6,--
  N_CARD_NUMBER_TYPE_7=7,--
  N_CARD_NUMBER_TYPE_8=8,--
  N_CARD_NUMBER_TYPE_9=9,--
  N_CARD_NUMBER_TYPE_10=10,--
  N_CARD_NUMBER_TYPE_J=11,
  N_CARD_NUMBER_TYPE_Q=12,
  N_CARD_NUMBER_TYPE_K=13,
  N_CARD_NUMBER_TYPE_SJ=14,--//小王;
  N_CARD_NUMBER_TYPE_BJ=15,--//大王;
  N_CARD_NUMBER_TYPE_MASK=16,-- //暗牌;
  NN_CARD_NUMBER_TYPE_END=17,
  
};

