package fleamarket.taobao.com.xservicekit;

import fleamarket.taobao.com.xservicekit.message.MessengerFacade;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** XserviceKitPlugin */
public class XserviceKitPlugin implements MethodCallHandler, FlutterPlugin {
  private MethodChannel channel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "xservice_kit");
    channel.setMethodCallHandler(new XserviceKitPlugin());

    //Connect to messenger.
    MessengerFacade.sharedInstance().setMessenger(registrar.messenger());

  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xservice_kit");
    channel.setMethodCallHandler(this);

    //Connect to messenger.
    MessengerFacade.sharedInstance().setMessenger(flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }
}
