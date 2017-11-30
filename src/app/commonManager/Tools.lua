Tools = {}


-- 所有渠道
Tools.allchannel = {
    "c1001", --掌间牛牛
    "c1002", --和和牛牛
    "c1003"
}

-- 当前渠道
Tools.currentchannelid = "c1002"

-- 当前是否是测试 1正式  2测试
Tools.isceshi = 1

-- 是否已经断网
Tools.hasnet = true
-- 渠道 和 Android版控制
Tools.channelandioscompany = true

-- 渠道号
Tools.channels = {
    c1001={
        id   = "c1001",
        name = "掌间牛牛",
        channel = "zhangjian",
        gamename = "zhangjianniuniu",
        updatename = "niuniu",
        sharecodeurl = "http://wx.sharkpoker.cn/index.php/Home/ShopReturn/getHhQrcode?account_id=",
        logo = "res/niuniu_denglu/n_logo.png"
    },

    c1002={
        id   = "c1002",
        name = "和和牛牛",
        channel = "hehe",
        gamename = "heheniuniu",
        updatename = "heheniuniu",
        sharecodeurl = "http://wx.sharkpoker.cn/index.php/Home/ShopReturn/getHhQrcode?account_id=",
        logo = "res/niuniu_denglu/n_logo1.png"
    }
}


Tools.Channel = function()
     return Tools.channels[Tools.currentchannelid]
end


-- 是否是打企业包
Tools.iscompanyipa = true

function Tools.setSpriteGray(sp)
    local vertShaderByteArray = "\n" ..
            "attribute vec4 a_position; \n" ..
            "attribute vec2 a_texCoord; \n" ..
            "attribute vec4 a_color; \n" ..
            "#ifdef GL_ES  \n" ..
            "varying lowp vec4 v_fragmentColor;\n" ..
            "varying mediump vec2 v_texCoord;\n" ..
            "#else                      \n" ..
            "varying vec4 v_fragmentColor; \n" ..
            "varying vec2 v_texCoord;  \n" ..
            "#endif    \n" ..
            "void main() \n" ..
            "{\n" ..
            "gl_Position = CC_PMatrix * a_position; \n" ..
            "v_fragmentColor = a_color;\n" ..
            "v_texCoord = a_texCoord;\n" ..
            "}"

    local flagShaderByteArray = "#ifdef GL_ES \n" ..
            "precision mediump float; \n" ..
            "#endif \n" ..
            "varying vec4 v_fragmentColor; \n" ..
            "varying vec2 v_texCoord; \n" ..
            "void main(void) \n" ..
            "{ \n" ..
            "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
            "gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b); \n" ..
            "gl_FragColor.w = c.w; \n" ..
            "}"
    local glProgram = cc.GLProgram:createWithByteArrays(vertShaderByteArray, flagShaderByteArray)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
    glProgram:link()
    glProgram:updateUniforms()
    sp:setGLProgram(glProgram)
end


function Tools.showError(msg, time, fontsize)
	local msgNode = cc.CSLoader:createNode("res/csb/ShowErrorMsg.csb")
    ccui.Helper:doLayout(msgNode)
    msgNode:setPosition(display.cx, display.cy)
    msgNode:getChildByName("error"):setText(msg)
    fontsize = fontsize or 40
    msgNode:getChildByName("error"):setFontSize(fontsize)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():getRunningScene():addChild(msgNode,999960000000)
        
        -- 关闭
        local function removeCall()
           msgNode:removeFromParent()
           msgNode = nil
        end
        time = time or 1
        local call = cc.CallFunc:create(removeCall)
        local move = cc.MoveBy:create(time, cc.p(0, 120))

        local seq  = cc.Sequence:create(move, call)

        msgNode:runAction(seq)
    end
end


