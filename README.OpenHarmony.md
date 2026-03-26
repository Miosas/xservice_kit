<p align="center">
  <h1 align="center"> <code>xservice_kit</code> </h1>
</p>



This project is developed based on [xservice_kit](https://pub.dev/packages/xservice_kit).

## Introduction
xservice_kit is a Flutter plugin that helps implement message communication between Flutter and native platforms. It provides a set of mechanisms for service registration, method invocation, and event distribution, supporting Android, iOS, and HarmonyOS platforms.

## 1. Installation and Usage

### 1.1 Installation Method

Go to the project directory and add the following dependency to pubspec.yaml:

#### pubspec.yaml

```yaml
...

dependencies:
  xservice_kit:
    git:
      url: https://github.com/Miosas/xservice_kit.git

...
```

Execute the command

```bash
flutter pub get
```

### 1.2 Install Command Line Tool

```bash
npm install -g xservice-arkts
```

### 1.3 Write configuration files and place them in the ServicesYaml (customizable) folder

Write configuration example [ServicesYaml](example/CodeGen/ServicesYaml/DemoService.yml)

### 1.4 Generate code with command line

For example:

```bash
xservice-arkts -o out -p fleamarket.taobao.com.xservicekitexample -a -t yaml ServicesYaml
```

Generated code basic structure:
```plain
out
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

### 1.5 Move code to project

Reference paths for moving:

- [java](example/android/app/src/main/java/fleamarket/taobao/com/xservicekitexample)

- [oc](example/ios/Runner/XService)

- [dart](example/lib)

- [arkts](example/ohos/entry/src/main/ets)

Move the generated code to the project, then call Serviceloader at the beginning of the program

### 1.6 Usage Cases

See [example](example/lib/main.dart) for usage cases

## 2. Constraints and Limitations

### 2.1 Compatibility

Tested and passed in the following versions:

1. Flutter: 3.22.1-ohos-1.0.6; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.1.251; ROM: 6.0.0.115 SP16;
2. Flutter: 3.27.5-ohos-1.0.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.1.251; ROM: 6.0.0.115 SP16;

## 3. API

 > [!TIP] "ohos Support" column with "yes" means the attribute is supported on ohos platform; "no" means not supported; "partially" means partially supported.

### Core Interfaces (Dart):

| Name | Description | Type | Input | Output | ohos Support |
|---|---|---|---|---|---|
| ServiceTemplate | Service template class | class | serviceName: String | - | yes |
| ServiceTemplate.serviceName() | Get service name | function | None | String | yes |
| ServiceTemplate.invokeMethod() | Call method | function | method: String, [arguments: dynamic, onException: onInvocationException?] | Future<dynamic> | yes |
| ServiceTemplate.regiserHandler() | Register handler | function | handler: ServiceCallHandler | void | yes |
| ServiceTemplate.emitEvent() | Send event | function | event: String, params: Map<dynamic,dynamic> | void | yes |
| ServiceTemplate.addEventListner() | Add event listener | function | event: String, listner: ServiceEventListner | ServiceEventListnerRemoveCallback | yes |
| ServiceTemplate.methodChannel() | Get method channel | function | None | MethodChannel | yes |
| ServiceTemplate.eventChannel() | Get event channel | function | None | EventChannel | yes |
| ServiceGateway | Service gateway class | class | - | - | yes |
| ServiceGateway.sharedInstance() | Get singleton instance | function | None | ServiceGateway | yes |
| ServiceGateway.registerService() | Register service | function | service: ServiceTemplate | void | yes |
| ServiceGateway.registerHandler() | Register handler | function | handler: ServiceCallHandler | void | yes |
| ServiceCallHandler | Service call handler abstract class | abstract class | - | - | yes |
| ServiceCallHandler.name() | Get handler name | function | None | String | yes |
| ServiceCallHandler.service() | Get service name | function | None | String | yes |
| ServiceCallHandler.onMethodCall() | Handle method call | function | call: MethodCall | Future<dynamic> | yes |

### DemoService API (Dart):

| Name | Description | Type | Input | Output | ohos Support |
|---|---|---|---|---|---|
| DemoService.service() | Get ServiceTemplate instance | function | None | ServiceTemplate | yes |
| DemoService.regsiter() | Register service | function | None | void | yes |
| DemoService.MessageToNative() | Send message to native | function | message: String, [onException: onInvocationException?] | Future<bool> | yes |
| DemoServiceMessageToFlutter.regsiter() | Register message handler | function | None | void | yes |
| DemoServiceMessageToFlutter.onCall() | Handle message from Flutter | function | message: String | Future<Map> | yes |

### DemoService API (ArkTS):

| Name | Description | Type | Input | Output | ohos Support |
| ---- | ----------- | ---- | ----- | ------ | ------------ |
| DemoService.getService() | Get ServiceTemplate instance | function | None | ServiceTemplate | yes |
| DemoService.register() | Register service | function | None | void | yes |
| DemoService.MessageToFlutter() | Send message to Flutter | function | result: MessageResult<MessageValue>, message: string | void | yes |
| DemoService_MessageToNative.register() | Register message handler | function | None | void | yes |
| DemoService_MessageToNative.onCall() | Handle message from Flutter | function | result: MessageResult<MessageValue>, message: string | boolean | yes |
| DemoService_MessageToNative.onMethodCall() | Handle method call | function | name: string, args: Map<string,MessageValue>, result: MessageResult<MessageValue> | boolean | yes |
| DemoService_MessageToNative.handleMessageNames() | Get handled message names | function | None | Array<string> | yes |
| DemoService_MessageToNative.getContext() | Get context | function | None | Object | yes |
| DemoService_MessageToNative.setContext() | Set context | function | obj: Object | void | yes |
| DemoService_MessageToNative.service() | Get service name | function | None | string | yes |

## 4. Known Issues

None

## 5. Other

None

## 6. Directory Structure

```
|---- xservice_kit
|     |---- android   # android adaptation code
|     |---- example   # multi-platform complete sample application
|           |----lib  # sample code
|           |----ohos # HarmonyOS project
|     |---- ios       # ios adaptation code
|     |---- lib       # core code implementation
|     |---- ohos      # HarmonyOS adaptation code
|     |---- test      # unit test files
|     |---- CHANGELOG.md       # update log
|     |---- README.OpenSource  # open source description
|     |---- README.md          # English description document
|     |---- README_zh.md       # Chinese description document
|     |---- README.OpenHarmony.md # HarmonyOS English description document
|     |---- README.OpenHarmony_CN.md # HarmonyOS Chinese description document
|     |---- pubspec.yaml       # configuration file
```

## 7. Contribute Code

You can submit [Issue](https://github.com/Miosas/xservice_kit/issues) if you find any problems during use, and of course, you are very welcome to send [PR](https://github.com/Miosas/xservice_kit/pulls) to build together.

## 8. Open Source License

This project is based on [License](LICENSE), please enjoy and participate in open source freely.