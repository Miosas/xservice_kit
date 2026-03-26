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
import { MessageHandler, MessageValue, Service } from "..";

export class ServiceGateway {
  private static instance: ServiceGateway = new ServiceGateway();
  private mServices: Map<string, Service> = new Map();

  public static sharedInstance(): ServiceGateway {
    return ServiceGateway.instance;
  }

  private constructor() {
  }

  addService(service: Service): void {
    if (service) {
      this.mServices.set(service.serviceName(), service);
      service.start();
    }
  }

  registerHandler(handler: MessageHandler<MessageValue>): void {  
    let service: Service | undefined = this.mServices.get(handler.service());
    if (service) {
      service.registerHandler(handler);
    }
  }

  removeService(service: Service): void {
    if (service) {
      this.mServices.delete(service.serviceName());
      service.end();
    }
  }
}