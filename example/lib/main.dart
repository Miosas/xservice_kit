import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:xservice_kit/xservice_kit.dart';
import 'package:xservice_kit_example/loader/service_loader.dart';
import 'package:xservice_kit_example/DemoService/service/demo_service.dart';

void main() {
  // 1. 首先初始化 Flutter 绑定
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 然后加载服务
  ServiceLoader.load();

  // 3. 运行应用
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // 4. 将服务调用移到 initState 中，确保在 Widget 初始化后执行
    _initializeServices();
  }

  // 初始化服务通信
  void _initializeServices() {
    print("测试：开始初始化服务通信");
    
    // 示例1：发送简单消息
    print("测试：示例1：发送简单消息到原生");
    DemoService.MessageToNative("这是来自Flutter的简单消息",(Exception e){
      print("测试：发送消息异常: ${e.toString()}");
      return false;
    }).then((bool value){
      if(value){
        print("测试：示例1：发送消息到原生成功");
      }else{
        print("测试：示例1：发送消息到原生失败");
      }
    });

    // 示例2：发送包含复杂数据的消息
    Future.delayed(Duration(seconds: 1), () {
      print("测试：示例2：发送包含复杂数据的消息到原生");
      DemoService.MessageToNative("这是包含复杂数据的消息|用户ID:123|操作:登录|时间:" + DateTime.now().toString(),(Exception e){
        print("测试：发送复杂消息异常: ${e.toString()}");
        return false;
      }).then((bool value){
        if(value){
          print("测试：示例2：发送复杂消息到原生成功");
        }else{
          print("测试：示例2：发送复杂消息到原生失败");
        }
      });
    });

    // 注册事件监听器
    print("测试：注册事件监听器，监听来自原生的广播事件");
    DemoService.service().addEventListner("test", (String event,Map<dynamic,dynamic> params){
      print("测试：收到来自原生的广播事件: $event, 参数: $params");
    });

    // 注册双向通信事件监听器
    print("测试：注册双向通信事件监听器");
    DemoService.service().addEventListner("native_response", (String event,Map<dynamic,dynamic> params){
      print("测试：收到原生响应事件: $event, 参数: $params");
      // 响应原生事件
      DemoService.MessageToNative("收到原生响应，正在处理...", (Exception e) {
        return false;
      }).then((bool value) {
        if (value) {
          print("测试：响应原生事件成功");
        }
      });
    });

    // 发送广播事件到原生
    Future.delayed(Duration(seconds: 2), () {
      print("测试：发送广播事件到原生");
      Map<String, dynamic> eventParams = {
        'flutter_time': DateTime.now().toString(),
        'flutter_version': '3.0.0',
        'message': '这是来自Flutter的广播消息'
      };
      DemoService.service().emitEvent("test", eventParams);
      print("测试：广播事件发送完成");
    });

    // 示例3：连续发送多条消息
    Future.delayed(Duration(seconds: 3), () {
      print("测试：示例3：连续发送多条消息到原生");
      _sendMessageWithDelay(1);
    });

    // 示例4：测试服务注册和管理
    Future.delayed(Duration(seconds: 4), () {
      print("测试：示例4：测试服务注册和管理");
      print("测试：服务名称: ${DemoService.service().serviceName()}");
      print("测试：服务注册状态: 已注册");
    });

    // 示例5：测试双向通信
    Future.delayed(Duration(seconds: 5), () {
      print("测试：示例5：测试双向通信");
      Map<String, dynamic> eventParams = {
        'trigger_native_response': true,
        'request_id': DateTime.now().millisecondsSinceEpoch
      };
      DemoService.service().emitEvent("flutter_event", eventParams);
      print("测试：发送双向通信触发事件");
    });
  }

  void _sendMessageWithDelay(int index) {
    if (index > 3) return;

    String message = "连续消息 $index：测试消息发送";
    print("测试：发送第$index条消息");

    DemoService.MessageToNative(message, (Exception e) {
      print("测试：发送消息异常: ${e.toString()}");
      return false;
    }).then((bool value) {
      if (value) {
        print("测试：连续消息${index}发送成功: $message");
      } else {
        print("测试：连续消息${index}发送失败: $message");
      }
      // 等待100ms后发送下一条消息
      Future.delayed(Duration(milliseconds: 100), () {
        _sendMessageWithDelay(index + 1);
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await XserviceKit.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app',textScaleFactor: 1.0),
        ),
        body: new Center(
          child: new Text('Running on: $_platformVersion\n',textScaleFactor: 1.0),
        ),
      ),
    );
  }
}