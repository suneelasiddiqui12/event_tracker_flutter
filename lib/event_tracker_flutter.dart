import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


class EventTrackerFlutter {
  
  @visibleForTesting
  static const MethodChannel channel = MethodChannel('event_tracker_flutter');
  static Future<void> initialize({
    required String eventKey,
    bool debug = false,
  }) async {
    await channel.invokeMethod('initialize', {
      'eventKey': eventKey,
      'debug': debug,
    });
  }

static Future<void> identify({
  required String contactNumber,
  Map<String, dynamic> traits = const {},
}) async {
  await channel.invokeMethod('identify', {
    'contactNumber': contactNumber,
    'traits': traits,
  });
}

static Future<void> page(
  String pageName, {
  Map<String, dynamic> properties = const {},
}) async {
  await channel.invokeMethod('page', {
    'pageName': pageName,
    'properties': properties,
  });
}

static Future<void> identifyAnonymous({
  required String sessionId,
  Map<String, dynamic> traits = const {},
}) async {
  await channel.invokeMethod('identifyAnonymous', {
    'sessionId': sessionId,
    'traits': traits,
  });
}

static Future<void> flush() async {
  await channel.invokeMethod('flush');
}

static Future<void> track({
  required String eventName,
  Map<String, dynamic> properties = const {},
}) async {
  await channel.invokeMethod('track', {
    'eventName': eventName,
    'properties': properties,
  });
}
}
