import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xservice_kit/xservice_kit_method_channel.dart';

void main() {
  MethodChannelXserviceKit platform = MethodChannelXserviceKit();
  const MethodChannel channel = MethodChannel('xservice_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
