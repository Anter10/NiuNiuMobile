-- 读取本地    静态数据管理类
local FileManager = class("FileManager")


-- 读取数据文件
-- @ filePath: 读取文件的路径名
-- @ return:   读取成功返回Json数据  失败返回false
function FileManager.readFile(filePath)
    local writePathFile = cc.FileUtils:getInstance():getWritablePath().."res/"..filePath
    local localPathFile = cc.FileUtils:getInstance():fullPathForFilename(filePath)
    local readPath      = nil
   
    -- 判断文件路径
    if cc.FileUtils:getInstance():isFileExist(writePathFile) then
       readPath         = writePathFile
    elseif cc.FileUtils:getInstance():isFileExist(localPathFile) then
       readPath         = localPathFile
    end
    
    -- 没有找到该文件 返回false  读取失败
    if not readPath then
       return false
    end 

    -- 存在文件 开始读取
    local  readData = cc.FileUtils:getInstance():getStringFromFile(readPath)
    if not readData or readData == "" then
       readData =  "[]"
    end
    readData        = json.decode(readData)
    return readData
end

function FileManager.isExistFile(fileName)
    if cc.FileUtils:getInstance():isFileExist(fileName) then
        return true
    end
    return false
end

--  写入本地文件 
--  @ filePath 写入文件名
--  @ strData  写入的数据
--  @ return   写入成功返回true  失败返回false
function FileManager.writePath(fileName, strData)
	local path1          =  cc.FileUtils:getInstance():getWritablePath().."res/"
    cc.FileUtils:getInstance():createDirectory(path1)
    local writeFilePath  =  cc.FileUtils:getInstance():getWritablePath().."res/"..fileName
    -- 开始写入数据
    local write = nil
    if type(strData) == "string" then
       write  = cc.FileUtils:getInstance():writeStringToFile(strData,writeFilePath)
    elseif type(strData) == "table" then
       write  = cc.FileUtils:getInstance():writeStringToFile(json.encode(strData),writeFilePath)
    end

    return write
end


return FileManager