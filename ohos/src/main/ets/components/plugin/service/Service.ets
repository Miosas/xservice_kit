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
import { EventSink, MessageHandler, MessageValue, ServiceEventListner } from "..";

export interface Service {
  serviceName(): string;
  methodChannelName(): string;
  eventChannelName(): string;
  didRecieveEventSink(eventSink: EventSink, args: Object): void;
  didCancelEvenStream(args: Object): void;

  emitEventAnonymous(obj: Record<string, MessageValue>): void;  

  emitEvent(even: string, obj: Map<string, MessageValue>): void;
  addEventListner(event: string, listner: ServiceEventListner): void;
  removeEventListner(event: string, listner: ServiceEventListner): void;
  invoke(name: string, args: Object, chanelName: string, result: Object): void;
  registerHandler(handler: MessageHandler<MessageValue>): void;
  start(): void;
  end(): void;
}