/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2017 Chukong Technologies Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.util.Log;
import android.widget.Toast;

import com.tencent.gcloud.voice.GCloudVoiceEngine;
import com.tencent.gcloud.voice.IGCloudVoiceNotify;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;
import com.umeng.social.CCUMSocialController;
import com.umeng.socialize.Config;
import com.umeng.socialize.UMShareAPI;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxHelper;

import java.util.Timer;
import java.util.TimerTask;

//锁屏问题处理

public class AppActivity extends Cocos2dxActivity {

    private Activity mActivity = null;
    private static AppActivity context;

    //控制锁屏的私有变量
    private PowerManager.WakeLock mWakeLock;

    static {
        System.loadLibrary("GCloudVoice");
    }

    public static IWXAPI api;


    public void onReq(BaseReq req) {
        System.out.println("=======pay=:" + 1);
    }


    public void onResp(BaseResp resp) {
        System.out.println("=======pay=:" + 2);

        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            if(resp.errCode == 0){

            }
            else{

            }

            //		AlertDialog.Builder builder = new AlertDialog.Builder(this);
            //		builder.setTitle(R.string.app_tip);
            //		builder.setMessage(getString(R.string.pay_result_callback_msg, resp.errStr +";code=" + String.valueOf(resp.errCode)));
            //		builder.show();
        }
        finish();
    }
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mActivity = this;
        context=this;

        UMShareAPI.get(this);
        CCUMSocialController.initSocialSDK(mActivity, "com.umeng.social");
        //        UmengTool.checkWx(this);
        Config.shareType = "cocos2dx";
        api = WXAPIFactory.createWXAPI(this, "wx705a56832e439340",false);
        api.registerApp("wx705a56832e439340");
        GCloudVoiceEngine.getInstance().init(getApplicationContext(), this);
//        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("globals","当前的信息是什么意思");
        //锁屏问题
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        mWakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK,"MyLock");
        mWakeLock.acquire();
        //自起callback
        Intent intent = getIntent();
        String scheme = intent.getScheme();
        String dataString = intent.getDataString();
        Uri uri = intent.getData();
        System.out.println("scheme:" + scheme);
        if (uri != null) {
            //完整的url信息
            String url = uri.toString();
            Log.e(String.format("url22222222222222: %s", uri),"a");
            Cocos2dxHelper.setStringForKey("Share_RoomID", url);
//            //scheme部分
//            String schemes = uri.getScheme();
//            //host部分
//            String host = uri.getHost();
//            //port部分
//            int port = uri.getPort();
//            //访问路径
//            String path = uri.getPath();
//            //编码路径
//            String path1 = uri.getEncodedPath();
//            //query部分
//            String queryString = uri.getQuery();
            //获取参数值
            String systemInfo = uri.getQueryParameter("system");
//String id=uri.getQueryParameter("id");　
//　　　　　　　System.out.println("host:" + host);
//　　　　　　　System.out.println("dataString:" + dataString);
//　　　　　　  System.out.println("id:" + id);
//　　　　　　　System.out.println("path:" + path);
//　　　　　　　System.out.println("path1:" + path1);
//　　　　　　　System.out.println("queryString:" + queryString);
        }

    }

    public void onPause()
    {
        super.onPause();
        if(mWakeLock != null)
        {
            mWakeLock.release();
            mWakeLock = null;
        }
    }
    @Override
    public void onResume()
    {
        super.onResume();
        if(mWakeLock == null)
        {
            PowerManager pm = (PowerManager)getSystemService(Context.POWER_SERVICE);
            mWakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK, "XYTEST");
            mWakeLock.acquire();
        }
    }
    @Override
    protected void onDestroy()
    {
        super.onDestroy();
        if(mWakeLock != null)
        {
            mWakeLock.release();
            mWakeLock = null;
        }
    }

    public static boolean hasWX(){
         return api.isWXAppInstalled();

    }



    // 获得打开网络链接
    public static boolean isNetworkConnected() {
        if (context != null) {
            // 获取手机所有连接管理对象(包括对wi-fi,net等连接的管理)
            ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            // 获取NetworkInfo对象
            NetworkInfo networkInfo = manager.getActiveNetworkInfo();
            //判断NetworkInfo对象是否为空
            if (networkInfo != null)
                return networkInfo.isAvailable();
        }
        return false;
    }



    public static void payByWC(String appid, String partnerid, String prepayid, String noncestr, String timestamp,String ppackage, String sign){
        try{
            PayReq req = new PayReq();
            //req.appId = "wxf8b4f85f3a794e77";  // ≤‚ ‘”√appId
            req.appId			= appid;
            req.partnerId		= partnerid;
            req.prepayId		= prepayid;
            req.nonceStr		= noncestr;
            req.timeStamp		= timestamp;
            req.packageValue	= ppackage;
            req.sign			= sign;
//            req.extData			= "章鱼互动"; // optional

            boolean zf = api.sendReq(req);
            Toast.makeText(context,appid+ " path = " + partnerid, Toast.LENGTH_LONG).show();
        }catch(Exception e){

        }

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        // 授权回调
        CCUMSocialController.onActivityResult(requestCode, resultCode, data);

        super.onActivityResult(requestCode, resultCode, data);
    }




    private static GCloudVoiceEngine engine = null;
    private static String _recordingPath;
    private static String _downloadPath;
    private static String _fileID;

    //语音消息jni-------------————
    public static void  Init_Voice(String open_id,String recordingPath,String downloadPath) {
        Log.i("CZ", "Init_Voice is:" + recordingPath+open_id+downloadPath);

        engine = GCloudVoiceEngine.getInstance();
        engine.SetAppInfo("1227051357", "cdf839a4167c23a5cbfea3d752392242", open_id);
        engine.Init();
        engine.SetMode(1);

        engine.ApplyMessageKey(60000);

        Notify notify = new  Notify();
        engine.SetNotify(notify);

        _recordingPath = recordingPath;
        _downloadPath = downloadPath;

        //timer to poll
        TimerTask task = new TimerTask() {
            public void run() {
                Message message = new Message();
                message.what = 1;
                handler.sendMessage(message);
            }
        };

        Timer timer = new Timer(true);
        timer.schedule(task, 500, 500);

    }

    public static void StartRecording()
    {
        int ret;
        ret = engine.StartRecording(_recordingPath);
    }

    public static void StopRecording()
    {
        int ret;
        ret = engine.StopRecording();
        if (ret!=0){
            return ;
        }
        engine.UploadRecordedFile(_recordingPath, 60000);
    }
    public static void DownloadRecordedFile(String fileId)
    {
        int ret;
        ret = engine.DownloadRecordedFile(fileId, _downloadPath, 5000);
    }

    public static int PlayRecordedFile()
    {
        int ret;
        ret = engine.PlayRecordedFile(_downloadPath);
        return  ret;

    }
    final static  Handler handler = new Handler() {
        public void handleMessage(Message msg) {
            String TAG = "[API]";
            switch (msg.what) {
                case 1:
                    engine.Poll();
                    break;
            }
            super.handleMessage(msg);
        }
    };



    static class  Notify implements IGCloudVoiceNotify {
        /*
        String TAG = "[cz]";
        @Override
        public void onJoinRoomComplete(int code) {
            // TODO Auto-generated method stub
            Log.i(TAG, "onJoinRoomComplete:" + code);
            _logTV.setText( "onJoinRoomComplete with "+ code);
        }*/
        public final String tag = "GCloudVoiceNotify";

        @Override
        public void OnJoinRoom(int i, String s, int i1) {

        }

        @Override
        public void OnStatusUpdate(int status, String roomName, int memberID) {

        }

        @Override
        public void OnQuitRoom(int i, String s) {

        }

        @Override
        public void OnMemberVoice(int[] ints, int i) {

        }

        @Override
        public void OnUploadFile(int code, String filePath, String fileID) {
            Log.i(tag, "OnUploadFile CallBack code=" + code + " filePath:" + filePath + " fileID:" + fileID);
            if (code == 11) {
                Cocos2dxHelper.setStringForKey("OnUploadFile", "1");
                Cocos2dxHelper.setStringForKey("fileId", fileID);
            }
        }

        @Override
        public void OnDownloadFile(int code, String filePath, String fileID) {
            //下载完成之后自动播放
            Log.i(tag, "OnDownloadFile CallBack code=" + code + " filePath:" + filePath + " fileID:" + fileID);

            if (code == 13) {
                Cocos2dxHelper.setStringForKey("OnDownloadFile", "1");
                int ret;
                ret = engine.PlayRecordedFile(_downloadPath);
                if (ret!=0)
                {
                    Cocos2dxHelper.setStringForKey("OnPlayRecordedFile", "1");
                }
            }
        }

        @Override
        public void OnPlayRecordedFile(int code, String filePath) {
            Cocos2dxHelper.setStringForKey("OnPlayRecordedFile", "1");
        }

        @Override
        public void OnApplyMessageKey(int code) {
            //创建秘钥成功或失败
            Log.i(tag, "OnApplyMessageKey CallBack code=" + code);
        }

        @Override
        public void OnSpeechToText(int i, String s, String s1) {

        }

        @Override
        public void OnRecording(char[] chars, int i) {

        }

        @Override
        public void OnStreamSpeechToText(int i, int i1, String s) {

        }


    }

    public static Object getJavaActivity() {
        return context;
    }

}
