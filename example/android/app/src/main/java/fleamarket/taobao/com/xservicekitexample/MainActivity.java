package fleamarket.taobao.com.xservicekitexample;

import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import fleamarket.taobao.com.xservicekit.handler.MessageResult;
import fleamarket.taobao.com.xservicekit.service.ServiceEventListner;
import fleamarket.taobao.com.xservicekitexample.DemoService.service.DemoService;
import fleamarket.taobao.com.xservicekitexample.loader.ServiceLoader;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    // 加载服务
    ServiceLoader.load();

    // 注册插件
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    // 设置事件监听器
    setupEventListeners();

    // 延迟执行测试
    final Handler handler = new Handler();
    handler.postDelayed(new Runnable() {
      @Override
      public void run() {
        test();
      }
    }, 2000);
  }

  private void test() {
    System.out.println("Send Native message sent to flutter");

    // Send message to flutter
    DemoService.MessageToFlutter(new MessageResult<Map>() {
      @Override
      public void success(Map var1) {
        System.out.println("Native message sent to flutter success!");
      }

      @Override
      public void error(String var1, String var2, Object var3) {
        System.out.println("Send Native message to flutter error");
      }

      @Override
      public void notImplemented() {
        System.out.println("Send Native message to flutter not implemented");
      }
    }, "This a message from native to flutter");

    DemoService.getService().emitEvent("test", new HashMap());
    
    // 示例：发送带参数的事件
    final Handler handler1 = new Handler();
    handler1.postDelayed(new Runnable() {
      @Override
      public void run() {
        sendEventWithParams();
      }
    }, 3000);
    
    // 示例：测试长时间运行的任务
    final Handler handler2 = new Handler();
    handler2.postDelayed(new Runnable() {
      @Override
      public void run() {
        testLongRunningTask();
      }
    }, 4000);
  }

  private void sendEventWithParams() {
    Log.d("android", "测试：发送带参数的事件到Flutter");
    Map<String, Object> params = new HashMap<>();
    params.put("native_time", String.valueOf(System.currentTimeMillis()));
    params.put("native_version", "1.0.0");
    params.put("message", "这是来自Android的带参数事件");
    DemoService.getService().emitEvent("test", params);
  }

  private void testLongRunningTask() {
    Log.d("android", "测试：开始长时间运行的任务");
    // 模拟长时间运行的任务
    final Handler handler = new Handler();
    handler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Log.d("android", "测试：长时间任务完成");
        Map<String, Object> params = new HashMap<>();
        params.put("task_status", "completed");
        params.put("task_duration", "2000ms");
        DemoService.getService().emitEvent("long_task_complete", params);
      }
    }, 2000);
  }

  private void setupEventListeners() {
    DemoService.getService().addEventListner("test", new ServiceEventListner() {
      @Override
      public void onEvent(String name, Map params) {
        switch (name){
          case "test":
            Log.d("android", "测试：原生收到广播消息:"+name);
            Log.d("android", "测试：flutter_version::"+params.get("flutter_version"));
            Log.d("android", "测试：message:"+params.get("message"));
        }
        System.out.println("Did recieve broadcast even from flutter");
      }
    });
    
    // 添加双向通信事件监听器
    DemoService.getService().addEventListner("flutter_event", new ServiceEventListner() {
      @Override
      public void onEvent(String name, Map params) {
        Log.d("android", "测试：收到Flutter事件:" + name);
        Log.d("android", "测试：事件参数:" + params.toString());
        
        // 响应Flutter事件，实现双向通信
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
          @Override
          public void run() {
            sendResponseToFlutter(params);
          }
        }, 1000);
      }
    });
    
    // 添加长时间任务事件监听器
    DemoService.getService().addEventListner("long_task_complete", new ServiceEventListner() {
      @Override
      public void onEvent(String name, Map params) {
        Log.d("android", "测试：收到长时间任务完成事件:" + name);
        Log.d("android", "测试：任务状态:" + params.get("task_status"));
        Log.d("android", "测试：任务持续时间:" + params.get("task_duration"));
      }
    });
  }
  
  private void sendResponseToFlutter(Map params) {
    Log.d("android", "测试：发送响应到Flutter");
    Map<String, Object> responseParams = new HashMap<>();
    responseParams.put("response_time", String.valueOf(System.currentTimeMillis()));
    responseParams.put("request_id", params.get("request_id") != null ? params.get("request_id") : "unknown");
    responseParams.put("message", "这是Android对Flutter事件的响应");
    
    DemoService.getService().emitEvent("native_response", responseParams);
  }
}