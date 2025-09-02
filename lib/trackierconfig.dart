import 'package:flutter/services.dart';

typedef void DeferredDeeplinkCallback(String? uri);

class TrackerSDKConfig {
  String appToken = "";
  String envirnoment = "";
  String secretId = "";
  String secretKey = "";
  bool manualMode = false;
  bool disableOrganic = false;
  String androidId = "";
  String facebookId = "";
  TrackierRegion region = TrackierRegion.NONE;

  Map<String, dynamic> attributionParams = {};

  DeferredDeeplinkCallback? deferredDeeplinkCallback;

  static const MethodChannel _channel = const MethodChannel('trackierfluttersdk');
  static const String _deferredDeeplinkCallbackName = 'deferred-deeplink';

  TrackerSDKConfig(String appToken, String envirnoment) {
    this.appToken = appToken;
    this.envirnoment = envirnoment;
    _initCallbackHandlers();
  }

  void setAppSecret(String secretId, String secretKey) {
    this.secretId = secretId;
    this.secretKey = secretKey;
  }
  
  void setManualMode(bool value) {
    this.manualMode = value;
  }

  void disableOrganicTracking(bool value) {
    this.disableOrganic = value;
  }

  void setAndroidId(String value) {
    this.androidId = value;
  }

  void setFacebookAppId(String value) {
    this.facebookId = value;
  }

  void setAttributionParams(Map<String, dynamic> params) {
    attributionParams.clear();
    attributionParams.addAll(params);
  }

  void _initCallbackHandlers() {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case _deferredDeeplinkCallbackName:
            if (deferredDeeplinkCallback != null) {
              String? uri = call.arguments['uri'];
              deferredDeeplinkCallback!(uri);
            }
            break;
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void setRegion(TrackierRegion region) {
    this.region = region;
  }

  Map<String, dynamic> get toMap {
    Map<String, dynamic> configMap = {
      'appToken': appToken,
      'environment': envirnoment,
      'secretId': secretId,
      'secretKey': secretKey,
      'deeplinkCallback': _deferredDeeplinkCallbackName,
      'setManualMode': manualMode,
      'disableOrganicTracking': disableOrganic,
      'attributionParams': attributionParams,
      'setAndroidId' : androidId,
      'setFacebookAppId' : facebookId,
      'region': region.name.toLowerCase()
    };

    return configMap;
  }
}

enum TrackierRegion {
  NONE,
  IN,
  GLOBAL,
}