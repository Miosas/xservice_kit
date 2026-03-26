/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { MessageResult, MessageValue, ServiceEventListner, XConverter } from 'xservice_kit';
import { DemoService } from '../DemoService/service/DemoService';
import { ServiceLoader } from '../loader/ServiceLoader';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    ServiceLoader.load();

    GeneratedPluginRegistrant.registerWith(flutterEngine);

    this.setupEventListeners();

    setTimeout(() => {
      this.test();
    }, 2000);
  }

  private test() {
    console.log('Send Native message sent to flutter');
    DemoService.MessageToFlutter(new MyMessageResult(),'This a message from native to flutter')
    DemoService.getService().emitEvent('test',new Map)
    
    // 示例：发送带参数的事件
    setTimeout(() => {
      this.sendEventWithParams();
    }, 3000);
    
    // 示例：测试长时间运行的任务
    setTimeout(() => {
      this.testLongRunningTask();
    }, 4000);
  }

  private sendEventWithParams() {
    console.log('测试：发送带参数的事件到Flutter');
    let params = new Map<string, Object>();
    params.set('native_time', Date.now().toString());
    params.set('native_version', '1.0.0');
    params.set('message', '这是来自OHOS的带参数事件');
    DemoService.getService().emitEvent('test', params);
  }

  private testLongRunningTask() {
    console.log('测试：开始长时间运行的任务');
    // 模拟长时间运行的任务
    setTimeout(() => {
      console.log('测试：长时间任务完成');
      let params = new Map<string, Object>();
      params.set('task_status', 'completed');
      params.set('task_duration', '2000ms');
      DemoService.getService().emitEvent('long_task_complete', params);
    }, 2000);
  }

  private setupEventListeners() {
    DemoService.getService().addEventListner('test', new MyEventListener());
    // 添加双向通信事件监听器
    DemoService.getService().addEventListner('flutter_event', new FlutterEventListener());
    // 添加长时间任务事件监听器
    DemoService.getService().addEventListner('long_task_complete', new LongTaskEventListener());
  };
}

class MyEventListener implements ServiceEventListner {
  onEvent(name: string, params: Map<string, Object>): void {
    switch (name){
      case 'test':
        console.log('测试：原生收到广播消息',name)
        console.log('测试：flutter_version:',JSON.stringify(params.get('flutter_version')))
        console.log('测试：message:',JSON.stringify(params.get('message')))
    }
  }
}

class FlutterEventListener implements ServiceEventListner {
  onEvent(name: string, params: Map<string, Object>): void {
    console.log('测试：收到Flutter事件:', name);
    console.log('测试：事件参数:', JSON.stringify(XConverter.mapToRecord(params)));
    
    // 响应Flutter事件，实现双向通信
    setTimeout(() => {
      this.sendResponseToFlutter(params);
    }, 1000);
  }
  
  private sendResponseToFlutter(params: Map<string, Object>): void {
    console.log('测试：发送响应到Flutter');
    let responseParams = new Map<string, Object>();
    responseParams.set('response_time', Date.now().toString());
    responseParams.set('request_id', params.get('request_id') || 'unknown');
    responseParams.set('message', '这是OHOS对Flutter事件的响应');
    
    DemoService.getService().emitEvent('native_response', responseParams);
  }
}

class LongTaskEventListener implements ServiceEventListner {
  onEvent(name: string, params: Map<string, Object>): void {
    console.log('测试：收到长时间任务完成事件:', name);
    console.log('测试：任务状态:', JSON.stringify(params.get('task_status')));
    console.log('测试：任务持续时间:', JSON.stringify(params.get('task_duration')));
  }
}

class MyMessageResult implements MessageResult {
  success(var1: MessageValue): void {
    console.log('Native message sent to flutter success!')
  }

  error(var1: string, var2: string, var3: Object): void {
    console.log('Send Native message to flutter error')
  }

  notImplemented(): void {
    console.log('Send Native message to flutter not implemented')
  }
}