import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'xservice_kit_method_channel.dart';

abstract class XserviceKitPlatform extends PlatformInterface {
  /// Constructs a XserviceKitPlatform.
  XserviceKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static XserviceKitPlatform _instance = MethodChannelXserviceKit();

  /// The default instance of [XserviceKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelXserviceKit].
  static XserviceKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XserviceKitPlatform] when
  /// they register themselves.
  static set instance(XserviceKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
