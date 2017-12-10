
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1920,
    height =1080,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "EXACT_FIT"}
            
            -- return {autoscale = "FIXED_WIDTH"}
            
        end
    end
}



VERSION="1.0"--当前版本号
-- SHOW_ALL


require("app.model.Server.Server")--请求文件
require("app.model.Server.ServerWebSocket")
require("app.model.NotificationCenter")--消息文件
require("app.model.LocalData.LocalData")--数据文件
require("app.model.Util")
require "app.model.MessageConfig"
--  音效
G_SOUND={
    --  比牌 女
    niu_0_w="sound/effect/Bcard/female/niu_0_w.mp3",  --  没牛
    niu_1_w="sound/effect/Bcard/female/niu_1_w.mp3",  --  牛1
    niu_2_w="sound/effect/Bcard/female/niu_2_w.mp3",  --  牛2
    niu_3_w="sound/effect/Bcard/female/niu_3_w.mp3",  --  牛3
    niu_4_w="sound/effect/Bcard/female/niu_4_w.mp3",  --  牛4
    niu_5_w="sound/effect/Bcard/female/niu_5_w.mp3",  --  牛5
    niu_6_w="sound/effect/Bcard/female/niu_6_w.mp3",  --  牛6
    niu_7_w="sound/effect/Bcard/female/niu_7_w.mp3",  --  牛7
    niu_8_w="sound/effect/Bcard/female/niu_8_w.mp3",  --  牛8
    niu_9_w="sound/effect/Bcard/female/niu_9_w.mp3",  --  牛9
    niu_10_w="sound/effect/Bcard/female/niu_niu_w.mp3",    --  牛牛
    niu_12_w="sound/effect/Bcard/female/niu_sizha_w.mp3",  --  4炸
    niu_11_w="sound/effect/Bcard/female/niu_wuhua_w.mp3",  --  5花牛
    niu_13_w="sound/effect/Bcard/female/niu_5_s_w.mp3",--  牛5小

    --  比牌 男
    niu_0_m="sound/effect/Bcard/men/niu_0_m.mp3",  --  没牛
    niu_1_m="sound/effect/Bcard/men/niu_1_m.mp3",  -- 牌女 牛1
    niu_2_m="sound/effect/Bcard/men/niu_2_m.mp3",  --  牛2
    niu_3_m="sound/effect/Bcard/men/niu_3_m.mp3",  --  牛3
    niu_4_m="sound/effect/Bcard/men/niu_4_m.mp3",  --  牛4
    niu_5_s_m="sound/effect/Bcard/men/niu_5_s_m.mp3",--  牛5小
    niu_5_m="sound/effect/Bcard/men/niu_5_m.mp3",  --  牛5
    niu_6_m="sound/effect/Bcard/men/niu_6_m.mp3",  --  牛6
    niu_7_m="sound/effect/Bcard/men/niu_7_m.mp3",  --  牛7
    niu_8_m="sound/effect/Bcard/men/niu_8_m.mp3",  --  牛8
    niu_9_m="sound/effect/Bcard/men/niu_9_m.mp3",  --  牛9
    niu_niu_m="sound/effect/Bcard/men/niu_niu_m.mp3",    --  牛牛
    niu_sizha_m="sound/effect/Bcard/men/niu_sizha_m.mp3",  --  4炸
    niu_wuhua_m="sound/effect/Bcard/men/niu_wuhua_m.mp3",  --  5花牛

    --  游戏开始
    gamestart="sound/effect/began/gamestart.mp3", 

    --  按钮点击
    Audio_Button_Click="sound/effect/button/Audio_Button_Click.mp3",  

    --  倒计时
    game_timeto="sound/effect/countdown/game_timeto.mp3", 

    --  发牌
    fapai="sound/effect/Fcard/fapai.mp3",  --  备份1 
    select_card="sound/effect/Fcard/select_card.mp3",  --  备份2 
    send_poker="sound/effect/Fcard/send_poker.mp3",  -- 备份3

    --  胜负
    sound_lose="sound/effect/outcome/sound_lose.mp3",  --负
    sound_win="sound/effect/outcome/sound_win.mp3",  --  胜

    --  庄家提示
    banker="sound/effect/prompt/banker.mp3",

    --  抢庄
    GET_BANKER="sound/effect/Robzhuang/GET_BANKER.mp3",
    buqiang_0="sound/effect/Robzhuang/buqiang_0.mp3",--  女  不抢庄
    buqiang_1="sound/effect/Robzhuang/buqiang_1.mp3",  --  男不抢庄
    qiangzhuang0_0="sound/effect/Robzhuang/qiangzhuang0_0.mp3",  --  女抢庄
    qiangzhuang0_1="sound/effect/Robzhuang/qiangzhuang0_1.mp3",  --  男抢庄

    --坐庄
    zuozhuang1_0="sound/effect/Setzhuang/zuozhuang1_0.mp3",  --  女坐庄
    zuozhuang1_1="sound/effect/Setzhuang/zuozhuang1_1.mp3",  --  男坐庄

    --  下注结算
    nan_xiazhuend_0="sound/effect/settlement/nan_xiazhuend_0.mp3",  -- 备份1
    nan_xiazhuend_1="sound/effect/settlement/nan_xiazhuend_1.mp3", --  备份2

    --  聊天语音  男
    man_1="sound/effect/voicechat/man_1.mp3",
    man_2="sound/effect/voicechat/man_2.mp3",
    man_3="sound/effect/voicechat/man_3.mp3",
    man_4="sound/effect/voicechat/man_4.mp3",
    man_5="sound/effect/voicechat/man_5.mp3",
    man_6="sound/effect/voicechat/man_6.mp3",
    man_7="sound/effect/voicechat/man_7.mp3",
    man_8="sound/effect/voicechat/man_8.mp3",
    man_9="sound/effect/voicechat/man_9.mp3",
    man_10="sound/effect/voicechat/man_10.mp3",

    -- 聊天语音  女
    woman_1="sound/effect/voicechat/woman_1.mp3",
    woman_2="sound/effect/voicechat/woman_2.mp3",
    woman_3="sound/effect/voicechat/woman_3.mp3",
    woman_4="sound/effect/voicechat/woman_4.mp3",
    woman_5="sound/effect/voicechat/woman_5.mp3",
    woman_6="sound/effect/voicechat/woman_6.mp3",
    woman_7="sound/effect/voicechat/woman_7.mp3",
    woman_8="sound/effect/voicechat/woman_8.mp3",
    woman_9="sound/effect/voicechat/woman_9.mp3",
    woman_10="sound/effect/voicechat/woman_10.mp3",

    --  倒计时
    game_timeto="sound/effect/voicechat/game_timeto.mp3",

    -- 准备
    ready_0="sound/effect/prepare/ready_0.mp3",--女
    ready_1="sound/effect/prepare/ready_1.mp3", --  男



}
--  背景音乐
G_MUSIC={
    
    bg_music0="sound/background/roombg/bg_music0.mp3",    --  背景音乐1
    bkmusic2="sound/background/roombg/bkmusic2.mp3", --  背景音乐2
    game_bg_music="sound/background/roombg/game_bg_music.mp3",--  背景音乐2
    hall_bg_voice="sound/background/roombg/hall_bg_voice.mp3",  --  大厅背景1
    hall="sound/background/roombg/hall.mp3",--  大厅背景2
    room="sound/background/roombg/room.mp3", --  房间


}