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
import { MessageContext, MessageHandler, MessageResult, MessageValue } from "../..";

export class FlutterMessageHandler implements MessageHandler<MessageValue> {
  private mContext: MessageContext = new Object;

  onMethodCall(name: string, args: Map<string, MessageValue>, result: MessageResult<MessageValue>): boolean {
    return false;
  }

  getContext(): MessageContext {
    return this.mContext;
  }

  setContext(obj: MessageContext): void {
    this.mContext = obj;
  }

  service(): string {
    return "root";
  }

  handleMessageNames(): Array<string> {
    let h: Array<string> = [];
    h.push("");
    return h;
  }
}