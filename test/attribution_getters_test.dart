import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackier_sdk_flutter/trackierfluttersdk.dart';
import 'package:trackier_sdk_flutter/trackierconfig.dart';
import 'package:trackier_sdk_flutter/trackierevent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Missing Coverage Tests', () {
    const MethodChannel channel = MethodChannel('trackierfluttersdk');
    List<MethodCall> methodCalls = [];

    setUp(() {
      methodCalls.clear();
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        methodCalls.add(methodCall);
        
        switch (methodCall.method) {
          case 'getAdSet':
            return 'test-ad-set';
          case 'getAdSetID':
            return 'test-ad-set-id';
          case 'getP2':
            return 'test-p2';
          case 'getP3':
            return 'test-p3';
          case 'getP4':
            return 'test-p4';
          case 'getP5':
            return 'test-p5';
          case 'getClickId':
            return 'test-click-id';
          case 'getDlv':
            return 'test-dlv';
          case 'getPid':
            return 'test-pid';
          case 'getIsRetargeting':
            return 'false';
          case 'createDynamicLink':
            return 'https://test.dynamic.link/abc123';
          default:
            return 'mock-response';
        }
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      methodCalls.clear();
    });

    test('getAdSet returns correct ad set', () async {
      final result = await Trackierfluttersdk.getAdSet();
      expect(result, 'test-ad-set');
      expect(methodCalls[0].method, 'getAdSet');
    });

    test('getAdSetID returns correct ad set ID', () async {
      final result = await Trackierfluttersdk.getAdSetID();
      expect(result, 'test-ad-set-id');
      expect(methodCalls[0].method, 'getAdSetID');
    });

    test('getP2 returns correct P2 value', () async {
      final result = await Trackierfluttersdk.getP2();
      expect(result, 'test-p2');
      expect(methodCalls[0].method, 'getP2');
    });

    test('getP3 returns correct P3 value', () async {
      final result = await Trackierfluttersdk.getP3();
      expect(result, 'test-p3');
      expect(methodCalls[0].method, 'getP3');
    });

    test('getP4 returns correct P4 value', () async {
      final result = await Trackierfluttersdk.getP4();
      expect(result, 'test-p4');
      expect(methodCalls[0].method, 'getP4');
    });

    test('getP5 returns correct P5 value', () async {
      final result = await Trackierfluttersdk.getP5();
      expect(result, 'test-p5');
      expect(methodCalls[0].method, 'getP5');
    });

    test('getClickId returns correct click ID', () async {
      final result = await Trackierfluttersdk.getClickId();
      expect(result, 'test-click-id');
      expect(methodCalls[0].method, 'getClickId');
    });

    test('getDlv returns correct DLV value', () async {
      final result = await Trackierfluttersdk.getDlv();
      expect(result, 'test-dlv');
      expect(methodCalls[0].method, 'getDlv');
    });

    test('getPid returns correct PID value', () async {
      final result = await Trackierfluttersdk.getPid();
      expect(result, 'test-pid');
      expect(methodCalls[0].method, 'getPid');
    });

    test('getIsRetargeting returns correct retargeting status', () async {
      final result = await Trackierfluttersdk.getIsRetargeting();
      expect(result, 'false');
      expect(methodCalls[0].method, 'getIsRetargeting');
    });

    test('createDynamicLink with all optional parameters', () async {
      final dynamicLink = await Trackierfluttersdk.createDynamicLink(
        templateId: 'template-456',
        link: 'https://example2.com',
        domainUriPrefix: 'https://trackier2.link',
        deepLinkValue: 'deep-link-value-2',
        androidRedirect: 'https://play.google.com/store/apps/details?id=com.example2',
        iosRedirect: 'https://apps.apple.com/app/example2/id987654321',
        desktopRedirect: 'https://example2.com/desktop',
        sdkParameters: {'sdk_test': 'test_value', 'version': '1.0'},
        attributionParameters: {'source': 'test', 'medium': 'test_medium'},
        socialMeta: {
          'title': 'Test App 2',
          'description': 'Test Description 2',
          'image': 'https://example.com/image.png'
        },
      );
      
      expect(dynamicLink, 'https://test.dynamic.link/abc123');
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'createDynamicLink');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['templateId'], 'template-456');
      expect(args['link'], 'https://example2.com');
      expect(args['domainUriPrefix'], 'https://trackier2.link');
      expect(args['deepLinkValue'], 'deep-link-value-2');
      expect(args['androidRedirect'], 'https://play.google.com/store/apps/details?id=com.example2');
      expect(args['iosRedirect'], 'https://apps.apple.com/app/example2/id987654321');
      expect(args['desktopRedirect'], 'https://example2.com/desktop');
      
      final sdkParams = Map<String, String>.from(args['sdkParameters'] as Map);
      expect(sdkParams['sdk_test'], 'test_value');
      expect(sdkParams['version'], '1.0');
      
      final attrParams = Map<String, String>.from(args['attributionParameters'] as Map);
      expect(attrParams['source'], 'test');
      expect(attrParams['medium'], 'test_medium');
      
      final socialMeta = Map<String, String>.from(args['socialMeta'] as Map);
      expect(socialMeta['title'], 'Test App 2');
      expect(socialMeta['description'], 'Test Description 2');
      expect(socialMeta['image'], 'https://example.com/image.png');
    });
  });

  group('TrackerSDKConfig Callback Tests', () {
    test('deferred deeplink callback initialization', () {
      String? receivedUri;
      bool callbackCalled = false;

      final config = TrackerSDKConfig('callback-test-token', 'test-env');
      config.deferredDeeplinkCallback = (String? uri) {
        receivedUri = uri;
        callbackCalled = true;
      };

      // Verify callback is set
      expect(config.deferredDeeplinkCallback, isNotNull);
      
      // Test the callback
      config.deferredDeeplinkCallback!('test://callback');
      expect(callbackCalled, true);
      expect(receivedUri, 'test://callback');
    });

    test('callback handles null URI', () {
      String? receivedUri = 'initial';
      bool callbackCalled = false;

      final config = TrackerSDKConfig('null-test-token', 'test-env');
      config.deferredDeeplinkCallback = (String? uri) {
        receivedUri = uri;
        callbackCalled = true;
      };

      config.deferredDeeplinkCallback!(null);
      expect(callbackCalled, true);
      expect(receivedUri, null);
    });
  });

  group('TrackierEvent Edge Cases', () {
    test('event with all predefined constants', () {
      final constants = [
        TrackierEvent.LEVEL_ACHIEVED,
        TrackierEvent.ADD_TO_CART,
        TrackierEvent.ADD_TO_WISHLIST,
        TrackierEvent.COMPLETE_REGISTRATION,
        TrackierEvent.TUTORIAL_COMPLETION,
        TrackierEvent.PURCHASE,
        TrackierEvent.SUBSCRIBE,
        TrackierEvent.START_TRIAL,
        TrackierEvent.ACHIEVEMENT_UNLOCKED,
        TrackierEvent.CONTENT_VIEW,
        TrackierEvent.TRAVEL_BOOKING,
        TrackierEvent.SHARE,
        TrackierEvent.INVITE,
        TrackierEvent.LOGIN,
        TrackierEvent.UPDATE,
      ];

      for (final constant in constants) {
        final event = TrackierEvent(constant);
        expect(event.eventId, constant);
        expect(event.toMap['eventId'], constant);
      }
    });

    test('event setEventValue with string value', () {
      final event = TrackierEvent('string-test');
      event.setEventValue('string_key', 'test_value');
      
      final eventMap = event.toMap;
      final evMap = Map<String, Object>.from(eventMap['ev'] as Map);
      expect(evMap.containsKey('string_key'), true);
      expect(evMap['string_key'], 'test_value');
    });

    test('event with maximum parameter values', () {
      final event = TrackierEvent('max-params-test');
      
      // Set all 10 parameters
      event.param1 = 'P1';
      event.param2 = 'P2';
      event.param3 = 'P3';
      event.param4 = 'P4';
      event.param5 = 'P5';
      event.param6 = 'P6';
      event.param7 = 'P7';
      event.param8 = 'P8';
      event.param9 = 'P9';
      event.param10 = 'P10';
      
      // Set multiple custom values
      for (int i = 1; i <= 20; i++) {
        event.setEventValue('custom_$i', 'value_$i');
      }
      
      final eventMap = event.toMap;
      
      // Verify all standard params
      for (int i = 1; i <= 10; i++) {
        expect(eventMap['param$i'], 'P$i');
      }
      
      // Verify all custom params
      final evMap = eventMap['ev'] as Map<String, Object>;
      for (int i = 1; i <= 20; i++) {
        expect(evMap['custom_$i'], 'value_$i');
      }
      expect(evMap.length, 20);
    });
  });
}