import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackier_sdk_flutter/trackierfluttersdk.dart';
import 'package:trackier_sdk_flutter/trackierconfig.dart';
import 'package:trackier_sdk_flutter/trackierevent.dart';

void main() {
  const MethodChannel channel = MethodChannel('trackierfluttersdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  // Store method calls for verification
  List<MethodCall> methodCalls = [];
  
  setUp(() {
    methodCalls.clear();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      methodCalls.add(methodCall);
      
      // Return mock responses based on method
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '1.6.73';
        case 'getTrackierId':
          return 'test-tracker-id-12345';
        case 'getAd':
          return 'test-ad';
        case 'getAdID':
          return 'test-ad-id';
        case 'getAdSet':
          return 'test-ad-set';
        case 'getAdSetID':
          return 'test-ad-set-id';
        case 'getCampaign':
          return 'test-campaign';
        case 'getCampaignID':
          return 'test-campaign-id';
        case 'getP1':
          return 'test-p1';
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
        case 'resolveDeeplinkUrl':
          return {'success': true, 'data': {'param1': 'value1'}};
        default:
          return null;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    methodCalls.clear();
  });

  group('Trackier SDK Basic Tests', () {
    test('getPlatformVersion returns correct version', () async {
      final version = await Trackierfluttersdk.platformVersion;
      expect(version, '1.6.73');
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'getPlatformVersion');
    });

    test('getTrackierId returns tracker ID', () async {
      final trackerId = await Trackierfluttersdk.getTrackierId();
      expect(trackerId, 'test-tracker-id-12345');
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'getTrackierId');
    });
  });

  group('SDK Initialization Tests', () {
    test('initializeSDK calls with correct parameters', () {
      final config = TrackerSDKConfig('test-app-token', 'development');
      config.setAppSecret('secret-id', 'secret-key');
      config.setManualMode(true);
      config.disableOrganicTracking(false);
      config.setRegion(TrackierRegion.IN);
      
      Trackierfluttersdk.initializeSDK(config);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'initializeSDK');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['appToken'], 'test-app-token');
      expect(args['environment'], 'development');
      expect(args['secretId'], 'secret-id');
      expect(args['secretKey'], 'secret-key');
      expect(args['setManualMode'], true);
      expect(args['disableOrganicTracking'], false);
      expect(args['region'], 'in');
    });
  });

  group('Event Tracking Tests', () {
    test('trackerEvent calls with correct event data', () {
      final event = TrackierEvent('test-event-id');
      event.orderId = 'order-123';
      event.revenue = 99.99;
      event.currency = 'USD';
      event.couponCode = 'SAVE10';
      event.discount = 10.0;
      event.param1 = 'custom-param1';
      event.setEventValue('custom_key', 'custom_value');
      
      Trackierfluttersdk.trackerEvent(event);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'trackierEvent');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['eventId'], 'test-event-id');
      expect(args['orderId'], 'order-123');
      expect(args['revenue'], 99.99);
      expect(args['currency'], 'USD');
      expect(args['couponCode'], 'SAVE10');
      expect(args['discount'], 10.0);
      expect(args['param1'], 'custom-param1');
      expect(args['ev']['custom_key'], 'custom_value');
    });

    test('trackEvent calls with predefined event constants', () {
      final event = TrackierEvent(TrackierEvent.PURCHASE);
      event.revenue = 49.99;
      event.currency = 'EUR';
      
      Trackierfluttersdk.trackEvent(event);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'trackierEvent');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['eventId'], TrackierEvent.PURCHASE);
      expect(args['revenue'], 49.99);
      expect(args['currency'], 'EUR');
    });
  });

  group('User Data Tests', () {
    test('setUserId calls with correct user ID', () {
      Trackierfluttersdk.setUserId('user-12345');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setUserId');
      expect(methodCalls[0].arguments, 'user-12345');
    });

    test('setUserEmail calls with correct email', () {
      Trackierfluttersdk.setUserEmail('test@example.com');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setUserEmail');
      expect(methodCalls[0].arguments, 'test@example.com');
    });

    test('setUserPhone calls with correct phone', () {
      Trackierfluttersdk.setUserPhone('+1234567890');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setUserPhone');
      expect(methodCalls[0].arguments, '+1234567890');
    });

    test('setUserName calls with correct name', () {
      Trackierfluttersdk.setUserName('John Doe');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setUserName');
      expect(methodCalls[0].arguments, 'John Doe');
    });

    test('setDOB calls with correct date of birth', () {
      Trackierfluttersdk.setDOB('1990-01-01');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setDOB');
      expect(methodCalls[0].arguments, '1990-01-01');
    });

    test('setGender calls with correct gender enum', () {
      Trackierfluttersdk.setGender(Gender.Male);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setGender');
      expect(methodCalls[0].arguments, 'Gender.Male');
    });

    test('setUserAdditonalDetail calls with correct additional details', () {
      final additionalDetails = {'age': 30, 'city': 'New York'};
      Trackierfluttersdk.setUserAdditonalDetail(additionalDetails);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setUserAdditonalDetail');
      expect(methodCalls[0].arguments, additionalDetails);
    });
  });

  group('Attribution Tests', () {
    test('setPreinstallAttribution calls with correct parameters', () {
      Trackierfluttersdk.setPreinstallAttribution('test-pid', 'test-campaign', 'campaign-123');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setPreinstallAttribution');
      
      final args = Map<String, String>.from(methodCalls[0].arguments as Map);
      expect(args['pid'], 'test-pid');
      expect(args['campaign'], 'test-campaign');
      expect(args['campaignId'], 'campaign-123');
    });

    test('updatePostbackConversion calls with correct conversion value', () {
      Trackierfluttersdk.updatePostbackConversion(1);
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'updatePostbackConversion');
      expect(methodCalls[0].arguments, 1);
    });

    test('updateAppleAdsToken calls with correct token', () {
      Trackierfluttersdk.updateAppleAdsToken('apple-ads-token-123');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'updateAppleAdsToken');
      expect(methodCalls[0].arguments, 'apple-ads-token-123');
    });
  });

  group('Attribution Getter Tests', () {
    test('getAd returns correct ad value', () async {
      final result = await Trackierfluttersdk.getAd();
      expect(result, 'test-ad');
      expect(methodCalls[0].method, 'getAd');
    });

    test('getAdID returns correct ad ID', () async {
      final result = await Trackierfluttersdk.getAdID();
      expect(result, 'test-ad-id');
      expect(methodCalls[0].method, 'getAdID');
    });

    test('getCampaign returns correct campaign', () async {
      final result = await Trackierfluttersdk.getCampaign();
      expect(result, 'test-campaign');
      expect(methodCalls[0].method, 'getCampaign');
    });

    test('getCampaignID returns correct campaign ID', () async {
      final result = await Trackierfluttersdk.getCampaignID();
      expect(result, 'test-campaign-id');
      expect(methodCalls[0].method, 'getCampaignID');
    });

    test('getP1 returns correct P1 value', () async {
      final result = await Trackierfluttersdk.getP1();
      expect(result, 'test-p1');
      expect(methodCalls[0].method, 'getP1');
    });
  });

  group('Dynamic Link Tests', () {
    test('createDynamicLink calls with required parameters', () async {
      final dynamicLink = await Trackierfluttersdk.createDynamicLink(
        templateId: 'template-123',
        link: 'https://example.com',
        domainUriPrefix: 'https://trackier.link',
        deepLinkValue: 'deep-link-value',
      );
      
      expect(dynamicLink, 'https://test.dynamic.link/abc123');
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'createDynamicLink');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['templateId'], 'template-123');
      expect(args['link'], 'https://example.com');
      expect(args['domainUriPrefix'], 'https://trackier.link');
      expect(args['deepLinkValue'], 'deep-link-value');
    });

    test('resolveDeeplinkUrl returns correct data', () async {
      final result = await Trackierfluttersdk.resolveDeeplinkUrl('https://trackier58.u9ilnk.me/d/32GAmKTxxY');
      
      expect(result['success'], true);
      expect(result['data']['param1'], 'value1');
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'resolveDeeplinkUrl');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['url'], 'https://test.link/abc123');
    });
  });

  group('Utility Method Tests', () {
    test('setLocalRefTrack calls with correct parameters', () {
      Trackierfluttersdk.setLocalRefTrack(true, '|');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setLocalRefTrack');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['boolValue'], true);
      expect(args['delimeter'], '|');
    });

    test('parseDeeplink calls with correct URI', () {
      Trackierfluttersdk.parseDeeplink('https://example.com/deeplink?param=value');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'parseDeeplink');
      expect(methodCalls[0].arguments, 'https://example.com/deeplink?param=value');
    });

    test('fireInstall calls correctly', () {
      Trackierfluttersdk.fireInstall();
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'fireInstall');
      expect(methodCalls[0].arguments, null);
    });

    test('setIMEI calls with correct IMEI values', () {
      Trackierfluttersdk.setIMEI('imei1-123456789', 'imei2-987654321');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setIMEI');
      
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['imei1'], 'imei1-123456789');
      expect(args['imei2'], 'imei2-987654321');
    });

    test('setMacAddress calls with correct MAC address', () {
      Trackierfluttersdk.setMacAddress('00:1B:44:11:3A:B7');
      
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'setMacAddress');
      expect(methodCalls[0].arguments, '00:1B:44:11:3A:B7');
    });
  });
}