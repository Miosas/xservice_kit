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
import { Message, MessageDispatcher, MessageHandler, MessageResult, MessageValue } from "../..";

export class FlutterMessageDispatcher implements MessageDispatcher {
  private _handlers: Map<string, MessageHandler<MessageValue>> = new Map();
  private mContext: Object = new Object;

  dispatch(msg: Message, result: MessageResult<MessageValue>): void {
    if (msg && result) {
      let handler: MessageHandler<MessageValue> | undefined = this._handlers.get(msg.name());
      if (handler) {
        handler.onMethodCall(msg.name(), msg.arguments(), result);
      }
    }
  }

  registerHandler(handler: MessageHandler<MessageValue>): void {
    if (!handler) {
      return;
    }

    handler.setContext(this.getContext());

    let messages: Array<string> = handler.handleMessageNames();
    for (let name of messages) {
      if (!this._handlers.has(name)) {
        this._handlers.set(name, handler);
      } else {
        console.error("Register multiple handlers for same key result in undefined error!");
      }
    }
  }

  removeHandler(handler: MessageHandler<MessageValue>): void {
    if (handler) {
      let messages: Array<string> = handler.handleMessageNames();
      for (let name of messages) {
        this._handlers.delete(name);
      }
    }
  }

  removeAll(): void {
    this._handlers.clear();
  }

  getContext(): Object {
    return this.mContext;
  }

  setContext(obj: Object): void {
    this.mContext = obj;
  }
}