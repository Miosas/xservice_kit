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
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { MessengerFacade } from ".";
import { deviceInfo } from '@kit.BasicServicesKit';

export default class XserviceKitPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "XserviceKitPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "xservice_kit");
    this.channel.setMethodCallHandler(this);

    // Connect to messenger.
    MessengerFacade.sharedInstance().setMessenger(binding.getBinaryMessenger());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
    }
  }

  async onMethodCall(call: MethodCall, result: MethodResult): Promise<void> {
    if (call.method === "getPlatformVersion") {
      result.success("HarmonyOS " + this.getHarmonyOSVersion());
    } else {
      result.notImplemented();
    }
  }

  private getHarmonyOSVersion(): string {
    try {
      return deviceInfo.distributionOSVersion
    } catch (error) {
      return "unknown";
    }
  }
}