import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xservice_kit_platform_interface.dart';

/// An implementation of [XserviceKitPlatform] that uses method channels.
class MethodChannelXserviceKit extends XserviceKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xservice_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
