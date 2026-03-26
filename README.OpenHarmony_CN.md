<p align="center">
  <h1 align="center"> <code>xservice_kit</code> </h1>
</p>



本项目基于[xservice_kit](https://pub.dev/packages/xservice_kit) 开发。

## 简介
xservice_kit 是一个 Flutter 插件，用于帮助实现 Flutter 与原生平台之间的消息通信。它提供了一套服务注册、方法调用和事件分发的机制，支持 Android、iOS 和 HarmonyOS 平台。

## 1. 安装与使用

### 1.1 安装方式

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

#### pubspec.yaml

```yaml
...

dependencies:
  xservice_kit:
    git:
      url: https://github.com/Miosas/xservice_kit.git

...
```

执行命令

```bash
flutter pub get
```

### 1.2 安装命令行工具

```bash
npm install -g xservice-arkts
```

### 1.3 编写配置文件放置到 ServicesYaml（可自定义）文件夹

编写配置示例[ServicesYaml](example/CodeGen/ServicesYaml/DemoService.yml)

### 1.4 用命令行生成代码

例如：

```bash
xservice-arkts -o out -p fleamarket.taobao.com.xservicekitexample -a -t yaml ServicesYaml
```

生成代码基本结构：
```plain
otu
├─arkts
│  ├─DemoService
│  │  ├─handlers
│  │  │      DemoService_MessageToNative.ets
│  │  │      
│  │  └─service
│  │          DemoService.ets
│  │          DemoServiceRegister.ets
│  │
│  └─loader
│          ServiceLoader.ets
│
├─dart
│  ├─DemoService
│  │  ├─handlers
│  │  │      demo_service_message_to_flutter.dart
│  │  │
│  │  └─service
│  │          demo_service.dart
│  │          demo_service_register.dart
│  │
│  └─loader
│          service_loader.dart
│
├─java
│  ├─DemoService
│  │  ├─handlers
│  │  │      DemoService_MessageToNative.java
│  │  │
│  │  └─service
│  │          DemoService.java
│  │          DemoServiceRegister.java
│  │
│  └─loader
│          ServiceLoader.java
│
└─oc
    └─DemoService
        ├─handlers
        │      DemoService_MessageToNative.h
        │      DemoService_MessageToNative.mm
        │
        └─service
                Service_DemoService.h
                Service_DemoService.mm
```

### 1.5 移动代码到项目中

移动路径参照：

- [java](example/android/app/src/main/java/fleamarket/taobao/com/xservicekitexample)

- [oc](example/ios/Runner/XService)

- [dart](example/lib)

- [arkts](example/ohos/entry/src/main/ets)

将生成代码移动到项目，然后在程序的开始调用Serviceloader

### 1.6 使用案例

使用案例详见 [example](example/lib/main.dart)

## 2. 约束与限制

### 2.1 兼容性

在以下版本中已测试通过

1. Flutter: 3.22.1-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.1.251; ROM: 6.0.0.115 SP16;
2. Flutter: 3.27.5-ohos-1.0.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.1.251; ROM: 6.0.0.115 SP16;



## 3. API

 > [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该属性；no 则表示不支持；partially 表示部分支持。

### 核心接口 (Dart):

| Name | Description | Type | Input | Output | ohos Support |
|---|---|---|---|---|---|
| ServiceTemplate | 服务模板类 | class | serviceName: String | - | yes |
| ServiceTemplate.serviceName() | 获取服务名称 | function | 无 | String | yes |
| ServiceTemplate.invokeMethod() | 调用方法 | function | method: String, [arguments: dynamic, onException: onInvocationException?] | Future<dynamic> | yes |
| ServiceTemplate.regiserHandler() | 注册处理器 | function | handler: ServiceCallHandler | void | yes |
| ServiceTemplate.emitEvent() | 发送事件 | function | event: String, params: Map<dynamic,dynamic> | void | yes |
| ServiceTemplate.addEventListner() | 添加事件监听器 | function | event: String, listner: ServiceEventListner | ServiceEventListnerRemoveCallback | yes |
| ServiceTemplate.methodChannel() | 获取方法通道 | function | 无 | MethodChannel | yes |
| ServiceTemplate.eventChannel() | 获取事件通道 | function | 无 | EventChannel | yes |
| ServiceGateway | 服务网关类 | class | - | - | yes |
| ServiceGateway.sharedInstance() | 获取单例实例 | function | 无 | ServiceGateway | yes |
| ServiceGateway.registerService() | 注册服务 | function | service: ServiceTemplate | void | yes |
| ServiceGateway.registerHandler() | 注册处理器 | function | handler: ServiceCallHandler | void | yes |
| ServiceCallHandler | 服务调用处理器抽象类 | abstract class | - | - | yes |
| ServiceCallHandler.name() | 获取处理器名称 | function | 无 | String | yes |
| ServiceCallHandler.service() | 获取服务名称 | function | 无 | String | yes |
| ServiceCallHandler.onMethodCall() | 处理方法调用 | function | call: MethodCall | Future<dynamic> | yes |

### DemoService API (Dart):

| Name | Description | Type | Input | Output | ohos Support |
|---|---|---|---|---|---|
| DemoService.service() | 获取ServiceTemplate实例 | function | 无 | ServiceTemplate | yes |
| DemoService.regsiter() | 注册服务 | function | 无 | void | yes |
| DemoService.MessageToNative() | 向原生发送消息 | function | message: String, [onException: onInvocationException?] | Future<bool> | yes |
| DemoServiceMessageToFlutter.regsiter() | 注册消息处理器 | function | 无 | void | yes |
| DemoServiceMessageToFlutter.onCall() | 处理来自Flutter的消息 | function | message: String | Future<Map> | yes |

### DemoService API (ArkTS):

| Name | Description | Type | Input | Output | ohos Support |
| ---- | ----------- | ---- | ----- | ------ | ------------ |
| DemoService.getService() | 获取ServiceTemplate实例 | function | 无 | ServiceTemplate | yes |
| DemoService.register() | 注册服务 | function | 无 | void | yes |
| DemoService.MessageToFlutter() | 向Flutter发送消息 | function | result: MessageResult<MessageValue>, message: string | void | yes |
| DemoService_MessageToNative.register() | 注册消息处理器 | function | 无 | void | yes |
| DemoService_MessageToNative.onCall() | 处理来自Flutter的消息 | function | result: MessageResult<MessageValue>, message: string | boolean | yes |
| DemoService_MessageToNative.onMethodCall() | 处理方法调用 | function | name: string, args: Map<string,MessageValue>, result: MessageResult<MessageValue> | boolean | yes |
| DemoService_MessageToNative.handleMessageNames() | 获取处理的消息名称 | function | 无 | Array<string> | yes |
| DemoService_MessageToNative.getContext() | 获取上下文 | function | 无 | Object | yes |
| DemoService_MessageToNative.setContext() | 设置上下文 | function | obj: Object | void | yes |
| DemoService_MessageToNative.service() | 获取服务名称 | function | 无 | string | yes |

## 4. 遗留问题

无

## 5. 其他

无

## 6. 目录结构

```
|---- xservice_kit
|     |---- android   # android适配代码
|     |---- example   # 多平台的完整示例应用
|           |----lib  # 示例代码
|           |----ohos # 鸿蒙工程
|     |---- ios       # ios适配代码
|     |---- lib       # 核心代码实现
|     |---- ohos      # 鸿蒙适配代码
|     |---- test      # 单元测试文件
|     |---- CHANGELOG.md       # 更新日志
|     |---- README.OpenSource  # 开源说明
|     |---- README.md          # 英文说明文档
|     |---- README_zh.md       # 中文说明文档
|     |---- README.OpenHarmony_CN.md # HarmonyOS 中文说明文档
|     |---- pubspec.yaml       # 配置文件
```

## 7. 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://github.com/Miosas/xservice_kit/issues) ，当然，也非常欢迎发 [PR](https://github.com/Miosas/xservice_kit/pulls) 共建。

## 8. 开源协议

本项目基于 [License](LICENSE)，请自由地享受和参与开源。
