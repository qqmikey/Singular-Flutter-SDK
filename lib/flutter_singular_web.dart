import 'dart:js' as js;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterSingularWeb {
  /// Constructs a FlutterSingularWeb
  FlutterSingularWeb();

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'singular-api',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterSingularWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'start':
        Map<Object?, Object?> args = call.arguments as Map<Object?, Object?>;
        final String apiKey = args['apiKey'] as String;
        final String secretKey = args['secretKey'] as String;
        var config = js.JsObject(js.context['SingularConfig'], [
          apiKey,
          secretKey,
          js.context['singularProductId'],
        ]);
        js.context['singularSdk'].callMethod('init', [config]);
        break;
      case 'event':
        Map<Object?, Object?> args = call.arguments as Map<Object?, Object?>;
        final String eventName = args['eventName'] as String;
        js.context['singularSdk'].callMethod('event', [eventName]);
        break;
      case 'eventWithArgs':
        Map<Object?, Object?> args = call.arguments as Map<Object?, Object?>;
        final String eventName = args['eventName'] as String;
        final Map<Object?, Object?> eventArgs = args['args'] as Map<Object?, Object?>;
        js.context['singularSdk'].callMethod('event', [eventName, eventArgs]);
        break;
      case 'customRevenue':
        Map<Object?, Object?> args = call.arguments as Map<Object?, Object?>;
        final String eventName = args['eventName'] as String;
        final String currency = args['currency'] as String;
        final double amount = args['amount'] as double;
        js.context['singularSdk'].callMethod('revenue', [eventName, currency, amount]);
        break;
      case 'setWrapperNameAndVersion':
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'singular_flutter for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}