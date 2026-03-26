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
import {
  EventSink,
  FlutterMessage,
  FlutterMessageDispatcher,
  FlutterMessageHost,
  MessageContext,
  MessageDispatcher,
  MessageHandler,
  MessageObject,
  MessageResult,
  MessageValue,
  MessengerFacade,
  Service,
  ServiceEventListner
} from "..";

import {
  MethodCall,
  MethodResult as FlutterMethodResult,
  StreamHandler,
  EventSink as FlutterEventSink
} from '@ohos/flutter_ohos';

// Define MessageResult implementation class - Adapt Flutter MethodResult
class TemplateMessageResult implements MessageResult<MessageValue> {
  private result: FlutterMethodResult;

  constructor(result: FlutterMethodResult) {
    this.result = result;
  }

  success(var1: MessageValue): void {
    this.result.success(var1);
  }

  error(var1: string, var2: string, var3: Object): void {
    this.result.error(var1, var2, var3);
  }

  notImplemented(): void {
    this.result.notImplemented();
  }
}

// Adapt Flutter MethodCallHandler
class MethodCallHandlerImpl {
  private template: ServiceTemplate;

  constructor(template: ServiceTemplate) {
    this.template = template;
  }

  onMethodCall(call: MethodCall, result: FlutterMethodResult): void {
    let host: FlutterMessageHost = new FlutterMessageHost(this.template.methodChannelName());

    // Fix key difference: Directly use original method name and parameters, consistent with Android
    let msg: FlutterMessage = new FlutterMessage(call.method, call.args, host);
    this.template.getDispatcher().dispatch(msg, new TemplateMessageResult(result));
  }
}

// Adapt Flutter StreamHandler
class StreamHandlerImpl implements StreamHandler {
  private template: ServiceTemplate;

  constructor(template: ServiceTemplate) {
    this.template = template;
  }

  onListen(args: Object, eventSink: FlutterEventSink): void {
    class EventSinkAdapter implements EventSink {
      private flutterSink: FlutterEventSink;

      constructor(flutterSink: FlutterEventSink) {
        this.flutterSink = flutterSink;
      }

      success(var1: Object): void {
        this.flutterSink.success(var1);
      }

      error(var1: string, var2: string, var3: Object): void {
        this.flutterSink.error(var1, var2, var3);
      }

      endOfStream(): void {
        this.flutterSink.endOfStream();
      }
    }

    let sink: EventSink = new EventSinkAdapter(eventSink);
    this.template.didRecieveEventSink(sink, args);
  }

  onCancel(args: Object): void {
    this.template.didCancelEvenStream(args);
  }
}

// Adapt Flutter MethodResult
class MethodResultImpl implements FlutterMethodResult {
  success: (result: Object) => void;
  error: (errorCode: string, errorMessage: string, errorDetails: Object) => void;
  notImplemented: () => void;

  constructor(
    success: (result: Object) => void,
    error: (errorCode: string, errorMessage: string, errorDetails: Object) => void,
    notImplemented: () => void
  ) {
    this.success = success;
    this.error = error;
    this.notImplemented = notImplemented;
  }
}

// Define event message class
class EventMessage {
  event: string;
  params?: Map<string, MessageValue>;

  constructor(event: string, params?: Map<string, MessageValue>) {
    this.event = event;
    this.params = params;
  }
}

export class ServiceTemplate implements Service, MessageHandler<MessageValue> {
  private eventSink: EventSink | null = null;
  private args: Object | null = null;
  private mDispatcher: MessageDispatcher;
  private mName: string = '';
  private mEventListners: Map<string, Array<ServiceEventListner>> = new Map();

  constructor(name: string) {
    this.mName = name;
    this.mDispatcher = new FlutterMessageDispatcher();

    // Set context to current ServiceTemplate instance
    this.mDispatcher.setContext(this);

    this.registerHandler(this);
  }

  serviceName(): string {
    return this.mName;
  }

  methodChannelName(): string {
    return this.mName + "_method_channel";
  }

  eventChannelName(): string {
    return this.mName + "_event_channel";
  }

  didRecieveEventSink(eventSink: EventSink, args: Object): void {
    this.eventSink = eventSink;
    this.args = args;
  }

  didCancelEvenStream(args: Object): void {
    this.args = null;
    this.eventSink = null;
  }

  invoke(name: string, args: Object, chanelName: string, result: FlutterMethodResult): void {
    MessengerFacade.sharedInstance().sendMessage(name, args, chanelName, result);
  }

  registerHandler(handler: MessageHandler<MessageValue>): void {
    handler.setContext(this)
    this.mDispatcher.registerHandler(handler);
  }

  getDispatcher(): MessageDispatcher {
    return this.mDispatcher;
  }

  start(): void {
    MessengerFacade.sharedInstance().registerMethodChannel(this.methodChannelName());
    MessengerFacade.sharedInstance().registerEventChannel(this.eventChannelName());

    let methodHandler = new MethodCallHandlerImpl(this);
    MessengerFacade.sharedInstance().setMethodCallHandler(methodHandler, this.methodChannelName());

    let streamHandler = new StreamHandlerImpl(this);
    MessengerFacade.sharedInstance().setStreamHandler(streamHandler, this.eventChannelName());
  }

  end(): void {
    MessengerFacade.sharedInstance().setMethodCallHandler(null, this.methodChannelName());
    MessengerFacade.sharedInstance().setStreamHandler(null, this.eventChannelName());
  }

  emitEventAnonymous(obj: Record<string, MessageValue>): void {
    if (this.eventSink) {
      this.eventSink.success(this.checkType(obj));
    }
  }

  private checkType(param: Record<string, MessageValue>): Record<string, MessageValue> {
    const supporedType: Map<string, boolean> = new Map();
    supporedType.set("string", true);
    supporedType.set("number", true);
    supporedType.set("boolean", true);

    let result: Record<string, MessageValue> = {};
    let keys = Object.keys(param);

    for (let i = 0; i < keys.length; i++) {
      let key = keys[i];
      let value = param[key];

      if (key === null || value === null) {
        continue;
      }

      const typeName: string = typeof value;
      if (supporedType.get(typeName)) {
        result[key] = value;
      }
    }

    return result;
  }

  // MessageHandler implementation - Adapt new message structure
  onMethodCall(name: string, args: Map<string, MessageValue>, result: MessageResult<MessageValue>): boolean {
    // Handle event message
    if (name === '__event__') {
      let event = args.get('event') as string;
      let params = args.get('params') as MessageObject;
      this.onEvent(event, params);
      return true;
    }

    // Other method calls can add processing logic here
    return false;
  }

  getContext(): Object {
    return this;
  }

  setContext(obj: Object): void {
    // Do nothing
  }

  handleMessageNames(): Array<string> {
    let list: Array<string> = [];
    list.push("__event__");
    return list;
  }

  service(): string {
    return this.serviceName();
  }

  private onEvent(event: string, params: MessageObject): void {
    if (!event) {
      return;
    }

    let listners: Array<ServiceEventListner> | undefined = this.mEventListners.get(event);
    if (listners) {
      for (let i = 0; i < listners.length; i++) {
        let l = listners[i];
        l.onEvent(event, params as Map<string, Object>);
      }
    }
  }

  emitEvent(even: string, obj: Map<string, MessageValue>): void {
    if (!even) {
      return;
    }

    let msg = new EventMessage(even, obj);

    let resultHandler = new MethodResultImpl(
      (o: Object) => {
        // Success callback
      },
      (errorCode: string, errorMessage: string, errorDetails: Object) => {
        // Error callback
      },
      () => {
        // Not implemented callback
      }
    );

    this.invoke("__event__", msg, this.methodChannelName(), resultHandler);
  }

  addEventListner(event: string, listner: ServiceEventListner): void {
    if (!event || !listner) {
      return;
    }

    let listners: Array<ServiceEventListner> | undefined = this.mEventListners.get(event);
    if (!listners) {
      listners = [];
      this.mEventListners.set(event, listners);
    }

    listners.push(listner);
  }

  removeEventListner(event: string, listner: ServiceEventListner): void {
    if (!event || !listner) {
      return;
    }

    let listners: Array<ServiceEventListner> | undefined = this.mEventListners.get(event);
    if (listners) {
      const index = listners.indexOf(listner);
      if (index > -1) {
        listners.splice(index, 1);
      }
    }
  }
}