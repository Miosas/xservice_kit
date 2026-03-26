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
  MethodChannel,
  EventChannel,
  MethodCallHandler,
  StreamHandler,
  BinaryMessenger,
  MethodCall,
  MethodResult
} from '@ohos/flutter_ohos';

export class MessengerFacade {
  private messenger: BinaryMessenger | null = null;
  private static instance: MessengerFacade = new MessengerFacade();

  // Store current active channels
  private mMethodChannels: Map<string, MethodChannel> = new Map();
  private mEventChannels: Map<string, EventChannel> = new Map();

  // To store register and handlers when messengers not up
  private mPendingMethodHandlers: Map<string, MethodCallHandler> = new Map();
  private mPendingEventStreamHandlers: Map<string, StreamHandler> = new Map();
  private mPendingEventChannels: Map<string, string> = new Map();
  private mPendingMethodChannels: Map<string, string> = new Map();

  public static sharedInstance(): MessengerFacade {
    return MessengerFacade.instance;
  }

  private constructor() {
  }

  setMessenger(msger: BinaryMessenger | null): void {
    this.messenger = msger;
    if (this.messenger) {
      this.loadPendings();
    }
  }

  getMessenger(): BinaryMessenger | null {
    return this.messenger;
  }

  private loadPendings(): void {
    this.mPendingMethodChannels.forEach((value: string, mKey: string) => {
      let handler = this.mPendingMethodHandlers.get(mKey);
      this.registerMethodChannel(mKey);
      if (handler) {
        this.setMethodCallHandler(handler, mKey);
      }
    });

    this.mPendingEventChannels.forEach((value: string, mKey: string) => {
      let handler = this.mPendingEventStreamHandlers.get(mKey);
      this.registerEventChannel(mKey);
      if (handler) {
        this.setStreamHandler(handler, mKey);
      }
    });

    this.mPendingMethodChannels.clear();
    this.mPendingEventChannels.clear();
    this.mPendingEventStreamHandlers.clear();
    this.mPendingMethodHandlers.clear();
  }

  private methodChannelForName(name: string): MethodChannel | null {
    if (!name) {
      return null;
    }
    return this.mMethodChannels.get(name) || null;
  }

  private eventChannelForName(name: string): EventChannel | null {
    if (!name) {
      return null;
    }
    return this.mEventChannels.get(name) || null;
  }

  sendMessage(name: string, args: Object, channelName: string, result: MethodResult): void {
    if (!name) {
      return;
    }
    let mChannel: MethodChannel | undefined = this.mMethodChannels.get(channelName);
    if (mChannel) {
      mChannel.invokeMethod(name, args, result);
    } else {
      result.error('CHANNEL_NOT_FOUND', `Channel ${channelName} not found`, null);
    }
  }

  setMethodCallHandler(handler: MethodCallHandler | null, channelName: string): void {
    if (!handler && channelName) {
      this.mMethodChannels.delete(channelName);
      return;
    }

    if (!channelName) {
      return;
    }

    let mChannel: MethodChannel | undefined = this.mMethodChannels.get(channelName);
    if (mChannel && handler) {
      mChannel.setMethodCallHandler(handler);
    } else if (handler) {
      this.mPendingMethodHandlers.set(channelName, handler);
    }
  }

  setStreamHandler(handler: StreamHandler | null, channelName: string): void {
    if (!handler && channelName) {
      this.mEventChannels.delete(channelName);
      return;
    }

    if (!channelName) {
      return;
    }

    let eChannel: EventChannel | undefined = this.mEventChannels.get(channelName);
    if (eChannel && handler) {
      eChannel.setStreamHandler(handler);
    } else if (handler) {
      this.mPendingEventStreamHandlers.set(channelName, handler);
    }
  }

  registerMethodChannel(name: string): void {
    if (!name) {
      return;
    }

    if (!this.messenger) {
      this.mPendingMethodChannels.set(name, name);
    } else {
      let methodChannel: MethodChannel | undefined = this.mMethodChannels.get(name);
      if (!methodChannel) {
        methodChannel = this.createMethodChannel(this.messenger, name);
        this.mMethodChannels.set(name, methodChannel);
      }
    }
  }

  registerEventChannel(name: string): void {
    if (!this.messenger) {
      this.mPendingEventChannels.set(name, name);
    } else {
      let eventChannel: EventChannel | undefined = this.mEventChannels.get(name);
      if (!eventChannel) {
        eventChannel = this.createEventChannel(this.messenger, name);
        this.mEventChannels.set(name, eventChannel);
      }
    }
  }

  getAllMethodChannels(): Array<MethodChannel> {
    return Array.from(this.mMethodChannels.values());
  }

  getAllEventChannels(): Array<EventChannel> {
    return Array.from(this.mEventChannels.values());
  }

  private createMethodChannel(messenger: BinaryMessenger, name: string): MethodChannel {
    return new MethodChannel(messenger, name);
  }

  private createEventChannel(messenger: BinaryMessenger, name: string): EventChannel {
    return new EventChannel(messenger, name);
  }
}