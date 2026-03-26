package fleamarket.taobao.com.xservicekitexample.DemoService.handlers;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import fleamarket.taobao.com.xservicekit.handler.MessageHandler;
import fleamarket.taobao.com.xservicekit.handler.MessageResult;
import fleamarket.taobao.com.xservicekit.service.ServiceGateway;

public class DemoService_MessageToNative implements MessageHandler<Boolean>{
    private Object mContext = null;
    private boolean onCall(MessageResult<Boolean> result,String message){
        //Add your handler code here.
        Log.d("android", "测试：收到来自Flutter的消息: " + message);
        Log.d("android", "测试：处理消息中...");
        // 模拟处理过程
        try {
            Thread.sleep(100); // 模拟处理时间
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Log.d("android", "测试：消息处理完成");
        // 调用 result.success() 通知 Flutter 端操作成功
        if (result != null) {
            result.success(true);
        }
        return true;
    }
    
    //==================Do not edit code blow!==============
    @Override
    public boolean onMethodCall(String name, Map args, MessageResult<Boolean> result) {
        this.onCall(result,(String)args.get("message"));



        Object a = getContext();


        return true;
    }
    @Override
    public List<String> handleMessageNames() {
        List<String> h = new ArrayList<>();
        h.add("MessageToNative");
        return h;
    }
    @Override
    public Object getContext() {
        return mContext;
    }
    
    @Override
    public void setContext(Object obj) {
        mContext = obj;
    }
    @Override
    public String service() {
        return "DemoService";
    }
    public static void register(){
        ServiceGateway.sharedInstance().registerHandler(new DemoService_MessageToNative());
    }
}
