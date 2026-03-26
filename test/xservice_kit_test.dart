import 'package:flutter_test/flutter_test.dart';
import 'package:xservice_kit/xservice_kit.dart';
import 'package:xservice_kit/xservice_kit_platform_interface.dart';
import 'package:xservice_kit/xservice_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockXserviceKitPlatform
    with MockPlatformInterfaceMixin
    implements XserviceKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final XserviceKitPlatform initialPlatform = XserviceKitPlatform.instance;

  test('$MethodChannelXserviceKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelXserviceKit>());
  });

  test('getPlatformVersion', () async {
    XserviceKit xserviceKitPlugin = XserviceKit();
    MockXserviceKitPlatform fakePlatform = MockXserviceKitPlatform();
    XserviceKitPlatform.instance = fakePlatform;

    expect(await xserviceKitPlugin.getPlatformVersion(), '42');
  });
}
