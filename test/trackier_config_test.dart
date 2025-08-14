import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackier_sdk_flutter/trackierconfig.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TrackerSDKConfig Tests', () {
    test('constructor sets basic properties correctly', () {
      final config = TrackerSDKConfig('test-app-token', 'production');
      
      expect(config.appToken, 'test-app-token');
      expect(config.envirnoment, 'production');
      expect(config.secretId, '');
      expect(config.secretKey, '');
      expect(config.manualMode, false);
      expect(config.disableOrganic, false);
      expect(config.region, TrackierRegion.NONE);
      expect(config.attributionParams, isEmpty);
    });

    test('setAppSecret sets secret values correctly', () {
      final config = TrackerSDKConfig('test-token', 'dev');
      config.setAppSecret('secret-123', 'key-456');
      
      expect(config.secretId, 'secret-123');
      expect(config.secretKey, 'key-456');
    });

    test('setManualMode sets manual mode correctly', () {
      final config = TrackerSDKConfig('test-token', 'dev');
      config.setManualMode(true);
      
      expect(config.manualMode, true);
      
      config.setManualMode(false);
      expect(config.manualMode, false);
    });

    test('disableOrganicTracking sets organic tracking correctly', () {
      final config = TrackerSDKConfig('test-token', 'dev');
      config.disableOrganicTracking(true);
      
      expect(config.disableOrganic, true);
      
      config.disableOrganicTracking(false);
      expect(config.disableOrganic, false);
    });

    test('setRegion sets region correctly', () {
      final config = TrackerSDKConfig('test-token', 'dev');
      
      config.setRegion(TrackierRegion.IN);
      expect(config.region, TrackierRegion.IN);
      
      config.setRegion(TrackierRegion.GLOBAL);
      expect(config.region, TrackierRegion.GLOBAL);
      
      config.setRegion(TrackierRegion.NONE);
      expect(config.region, TrackierRegion.NONE);
    });

    test('setAttributionParams sets and clears params correctly', () {
      final config = TrackerSDKConfig('test-token', 'dev');
      final params1 = {'param1': 'value1', 'param2': 'value2'};
      final params2 = {'param3': 'value3'};
      
      config.setAttributionParams(params1);
      expect(config.attributionParams, params1);
      expect(config.attributionParams.length, 2);
      
      // Setting new params should clear old ones
      config.setAttributionParams(params2);
      expect(config.attributionParams, params2);
      expect(config.attributionParams.length, 1);
      expect(config.attributionParams.containsKey('param1'), false);
      expect(config.attributionParams.containsKey('param3'), true);
    });

    test('toMap returns correct configuration map', () {
      final config = TrackerSDKConfig('app-token-123', 'staging');
      config.setAppSecret('secret-456', 'key-789');
      config.setManualMode(true);
      config.disableOrganicTracking(false);
      config.setRegion(TrackierRegion.GLOBAL);
      config.setAttributionParams({'custom_param': 'custom_value'});
      
      final configMap = config.toMap;
      
      expect(configMap['appToken'], 'app-token-123');
      expect(configMap['environment'], 'staging');
      expect(configMap['secretId'], 'secret-456');
      expect(configMap['secretKey'], 'key-789');
      expect(configMap['setManualMode'], true);
      expect(configMap['disableOrganicTracking'], false);
      expect(configMap['region'], 'global');
      expect(configMap['attributionParams']['custom_param'], 'custom_value');
      expect(configMap['deeplinkCallback'], 'deferred-deeplink');
    });

    test('toMap handles different regions correctly', () {
      final config = TrackerSDKConfig('token', 'env');
      
      config.setRegion(TrackierRegion.NONE);
      expect(config.toMap['region'], 'none');
      
      config.setRegion(TrackierRegion.IN);
      expect(config.toMap['region'], 'in');
      
      config.setRegion(TrackierRegion.GLOBAL);
      expect(config.toMap['region'], 'global');
    });

    test('toMap with empty attribution params', () {
      final config = TrackerSDKConfig('token', 'env');
      final configMap = config.toMap;
      
      expect(configMap['attributionParams'], isEmpty);
    });

    test('deferred deeplink callback can be set', () {
      final config = TrackerSDKConfig('token', 'env');
      String? receivedUri;
      
      config.deferredDeeplinkCallback = (String? uri) {
        receivedUri = uri;
      };
      
      expect(config.deferredDeeplinkCallback, isNotNull);
      
      // Test the callback
      config.deferredDeeplinkCallback!('test://deeplink');
      expect(receivedUri, 'test://deeplink');
    });
  });

  group('TrackierRegion Enum Tests', () {
    test('enum values are correct', () {
      expect(TrackierRegion.NONE.name, 'NONE');
      expect(TrackierRegion.IN.name, 'IN');
      expect(TrackierRegion.GLOBAL.name, 'GLOBAL');
    });

    test('enum comparison works correctly', () {
      expect(TrackierRegion.NONE == TrackierRegion.NONE, true);
      expect(TrackierRegion.IN == TrackierRegion.GLOBAL, false);
    });
  });
}