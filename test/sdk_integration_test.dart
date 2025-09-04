import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackier_sdk_flutter/trackierfluttersdk.dart';
import 'package:trackier_sdk_flutter/trackierconfig.dart';
import 'package:trackier_sdk_flutter/trackierevent.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Trackier SDK Integration Tests', () {
    const MethodChannel channel = MethodChannel('trackierfluttersdk');
    List<MethodCall> methodCalls = [];

    setUp(() {
      methodCalls.clear();
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        methodCalls.add(methodCall);
        
        switch (methodCall.method) {
          case 'resolveDeeplinkUrl':
            // Simulate error handling
            if (methodCall.arguments['url'] == 'invalid-url') {
              throw PlatformException(code: 'INVALID_URL', message: 'Invalid URL provided');
            }
            return {'success': true, 'data': {'param1': 'value1'}};
          default:
            return 'mock-response';
        }
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      methodCalls.clear();
    });

    test('complete SDK workflow - initialization and event tracking', () {
      // Initialize SDK
      final config = TrackerSDKConfig('app-token-123', 'production');
      config.setAppSecret('secret-id', 'secret-key');
      config.setRegion(TrackierRegion.GLOBAL);
      Trackierfluttersdk.initializeSDK(config);

      // Set user data
      Trackierfluttersdk.setUserId('user-456');
      Trackierfluttersdk.setUserEmail('user@example.com');
      Trackierfluttersdk.setUserName('John Doe');

      // Track an event
      final event = TrackierEvent(TrackierEvent.PURCHASE);
      event.revenue = 99.99;
      event.currency = 'USD';
      event.orderId = 'order-789';
      event.setEventValue('category', 'electronics');
      Trackierfluttersdk.trackEvent(event);

      // Verify all calls were made
      expect(methodCalls.length, 5);
      expect(methodCalls[0].method, 'initializeSDK');
      expect(methodCalls[1].method, 'setUserId');
      expect(methodCalls[2].method, 'setUserEmail');
      expect(methodCalls[3].method, 'setUserName');
      expect(methodCalls[4].method, 'trackierEvent');

      // Verify initialization config
      final initArgs = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(initArgs['appToken'], 'app-token-123');
      expect(initArgs['environment'], 'production');
      expect(initArgs['region'], 'global');

      // Verify event data
      final eventArgs = Map<String, dynamic>.from(methodCalls[4].arguments as Map);
      expect(eventArgs['eventId'], TrackierEvent.PURCHASE);
      expect(eventArgs['revenue'], 99.99);
      expect(eventArgs['currency'], 'USD');
      expect(eventArgs['orderId'], 'order-789');
      final evMap = Map<String, Object>.from(eventArgs['ev'] as Map);
      expect(evMap['category'], 'electronics');
    });

    test('error handling in resolveDeeplinkUrl', () async {
      final result = await Trackierfluttersdk.resolveDeeplinkUrl('invalid-url');
      expect(result, isEmpty); // The SDK catches exceptions and returns empty map
      expect(methodCalls.length, 1);
      expect(methodCalls[0].method, 'resolveDeeplinkUrl');
    });

    test('multiple events with different data types', () {
      final events = [
        TrackierEvent(TrackierEvent.LOGIN),
        TrackierEvent(TrackierEvent.ADD_TO_CART),
        TrackierEvent(TrackierEvent.PURCHASE),
      ];

      events[0].setEventValue('login_method', 'google');
      events[1].setEventValue('item_count', 3);
      events[1].setEventValue('total_value', 149.99);
      events[2].setEventValue('payment_method', 'credit_card');
      events[2].setEventValue('is_repeat_customer', true);

      for (final event in events) {
        Trackierfluttersdk.trackEvent(event);
      }

      expect(methodCalls.length, 3);
      
      // Verify first event (LOGIN)
      final loginArgs = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(loginArgs['eventId'], TrackierEvent.LOGIN);
      final loginEvMap = Map<String, Object>.from(loginArgs['ev'] as Map);
      expect(loginEvMap['login_method'], 'google');

      // Verify second event (ADD_TO_CART)
      final cartArgs = Map<String, dynamic>.from(methodCalls[1].arguments as Map);
      expect(cartArgs['eventId'], TrackierEvent.ADD_TO_CART);
      final cartEvMap = Map<String, Object>.from(cartArgs['ev'] as Map);
      expect(cartEvMap['item_count'], 3);
      expect(cartEvMap['total_value'], 149.99);

      // Verify third event (PURCHASE)
      final purchaseArgs = Map<String, dynamic>.from(methodCalls[2].arguments as Map);
      expect(purchaseArgs['eventId'], TrackierEvent.PURCHASE);
      final purchaseEvMap = Map<String, Object>.from(purchaseArgs['ev'] as Map);
      expect(purchaseEvMap['payment_method'], 'credit_card');
      expect(purchaseEvMap['is_repeat_customer'], true);
    });

    test('attribution configuration with all parameters', () {
      final config = TrackerSDKConfig('comprehensive-token', 'staging');
      config.setAppSecret('comprehensive-secret', 'comprehensive-key');
      config.setManualMode(true);
      config.disableOrganicTracking(true);
      config.setRegion(TrackierRegion.IN);
      config.setAttributionParams({
        'utm_source': 'facebook',
        'utm_medium': 'cpc',
        'utm_campaign': 'summer_sale',
        'custom_param': 'custom_value'
      });

      Trackierfluttersdk.initializeSDK(config);

      expect(methodCalls.length, 1);
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      
      expect(args['appToken'], 'comprehensive-token');
      expect(args['environment'], 'staging');
      expect(args['secretId'], 'comprehensive-secret');
      expect(args['secretKey'], 'comprehensive-key');
      expect(args['setManualMode'], true);
      expect(args['disableOrganicTracking'], true);
      expect(args['region'], 'in');
      
      final attributionParams = Map<String, dynamic>.from(args['attributionParams'] as Map);
      expect(attributionParams['utm_source'], 'facebook');
      expect(attributionParams['utm_medium'], 'cpc');
      expect(attributionParams['utm_campaign'], 'summer_sale');
      expect(attributionParams['custom_param'], 'custom_value');
    });

    test('gender enum string conversion', () {
      Trackierfluttersdk.setGender(Gender.Male);
      Trackierfluttersdk.setGender(Gender.Female);
      Trackierfluttersdk.setGender(Gender.Others);

      expect(methodCalls.length, 3);
      expect(methodCalls[0].arguments, 'Gender.Male');
      expect(methodCalls[1].arguments, 'Gender.Female');
      expect(methodCalls[2].arguments, 'Gender.Others');
    });

    test('device identification methods', () {
      Trackierfluttersdk.setIMEI('imei1-test', 'imei2-test');
      Trackierfluttersdk.setMacAddress('AA:BB:CC:DD:EE:FF');

      expect(methodCalls.length, 2);
      
      final imeiArgs = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(imeiArgs['imei1'], 'imei1-test');
      expect(imeiArgs['imei2'], 'imei2-test');
      
      expect(methodCalls[1].arguments, 'AA:BB:CC:DD:EE:FF');
    });

    test('comprehensive event with all standard parameters', () {
      final event = TrackierEvent('comprehensive-event');
      event.orderId = 'ORDER-2023-12345';
      event.couponCode = 'HOLIDAY50';
      event.discount = 25.00;
      event.revenue = 199.99;
      event.currency = 'EUR';
      event.param1 = 'Electronics';
      event.param2 = 'Smartphone';
      event.param3 = 'Samsung';
      event.param4 = 'Galaxy S23';
      event.param5 = 'Black';
      event.param6 = '128GB';
      event.param7 = 'Unlocked';
      event.param8 = 'New';
      event.param9 = 'Premium';
      event.param10 = 'Bundle';
      
      event.setEventValue('user_segment', 'premium');
      event.setEventValue('promotion_id', 'PROMO2023');
      event.setEventValue('referrer', 'organic_search');

      Trackierfluttersdk.trackEvent(event);

      expect(methodCalls.length, 1);
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      
      expect(args['eventId'], 'comprehensive-event');
      expect(args['orderId'], 'ORDER-2023-12345');
      expect(args['couponCode'], 'HOLIDAY50');
      expect(args['discount'], 25.00);
      expect(args['revenue'], 199.99);
      expect(args['currency'], 'EUR');
      expect(args['param1'], 'Electronics');
      expect(args['param2'], 'Smartphone');
      expect(args['param3'], 'Samsung');
      expect(args['param4'], 'Galaxy S23');
      expect(args['param5'], 'Black');
      expect(args['param6'], '128GB');
      expect(args['param7'], 'Unlocked');
      expect(args['param8'], 'New');
      expect(args['param9'], 'Premium');
      expect(args['param10'], 'Bundle');
      
      final evMap = Map<String, Object>.from(args['ev'] as Map);
      expect(evMap['user_segment'], 'premium');
      expect(evMap['promotion_id'], 'PROMO2023');
      expect(evMap['referrer'], 'organic_search');
    });
  });

  group('Edge Cases and Boundary Tests', () {
    const MethodChannel channel = MethodChannel('trackierfluttersdk');
    List<MethodCall> methodCalls = [];

    setUp(() {
      methodCalls.clear();
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        methodCalls.add(methodCall);
        return 'mock-response';
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      methodCalls.clear();
    });

    test('empty and null string handling', () {
      Trackierfluttersdk.setUserId('');
      Trackierfluttersdk.setUserEmail('');
      Trackierfluttersdk.setUserName('');

      expect(methodCalls.length, 3);
      expect(methodCalls[0].arguments, '');
      expect(methodCalls[1].arguments, '');
      expect(methodCalls[2].arguments, '');
    });

    test('zero and negative values in events', () {
      final event = TrackierEvent('edge-case-event');
      event.revenue = 0.0;
      event.discount = -5.0; // Negative discount (unusual but possible)
      
      Trackierfluttersdk.trackEvent(event);

      expect(methodCalls.length, 1);
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['revenue'], 0.0);
      expect(args['discount'], -5.0);
    });

    test('very large numbers in events', () {
      final event = TrackierEvent('large-numbers-event');
      event.revenue = 999999999.99;
      event.setEventValue('large_int', 9223372036854775807); // Max int64
      event.setEventValue('large_double', 1.7976931348623157e308); // Near max double
      
      Trackierfluttersdk.trackEvent(event);

      expect(methodCalls.length, 1);
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['revenue'], 999999999.99);
      
      final evMap = Map<String, Object>.from(args['ev'] as Map);
      expect(evMap['large_int'], 9223372036854775807);
      expect(evMap['large_double'], 1.7976931348623157e308);
    });

    test('special characters in strings', () {
      final event = TrackierEvent('special-chars-test');
      event.orderId = 'ORDER-2023-éñüñ';
      event.couponCode = 'SAVE20PERCENT';
      event.setEventValue('unicode_text', 'hello-world');
      event.setEventValue('special_chars', '!@#\$%^&*()');
      
      Trackierfluttersdk.trackEvent(event);

      expect(methodCalls.length, 1);
      final args = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      expect(args['eventId'], 'special-chars-test');
      expect(args['orderId'], 'ORDER-2023-éñüñ');
      expect(args['couponCode'], 'SAVE20PERCENT');
      
      final evMap = Map<String, Object>.from(args['ev'] as Map);
      expect(evMap['unicode_text'], 'hello-world');
      expect(evMap['special_chars'], '!@#\$%^&*()');
    });

    test('mixed region configurations', () {
      final configs = [
        TrackerSDKConfig('token1', 'env1')..setRegion(TrackierRegion.NONE),
        TrackerSDKConfig('token2', 'env2')..setRegion(TrackierRegion.IN),
        TrackerSDKConfig('token3', 'env3')..setRegion(TrackierRegion.GLOBAL),
      ];

      for (final config in configs) {
        Trackierfluttersdk.initializeSDK(config);
      }

      expect(methodCalls.length, 3);
      
      final args1 = Map<String, dynamic>.from(methodCalls[0].arguments as Map);
      final args2 = Map<String, dynamic>.from(methodCalls[1].arguments as Map);
      final args3 = Map<String, dynamic>.from(methodCalls[2].arguments as Map);
      
      expect(args1['region'], 'none');
      expect(args2['region'], 'in');
      expect(args3['region'], 'global');
    });
  });
}