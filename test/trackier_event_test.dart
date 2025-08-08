import 'package:flutter_test/flutter_test.dart';
import 'package:trackier_sdk_flutter/trackierevent.dart';

void main() {
  group('TrackierEvent Tests', () {
    test('constructor sets event ID correctly', () {
      final event = TrackierEvent('test-event-id');
      expect(event.eventId, 'test-event-id');
    });

    test('constructor with predefined event constants', () {
      final purchaseEvent = TrackierEvent(TrackierEvent.PURCHASE);
      expect(purchaseEvent.eventId, 'Q4YsqBKnzZ');
      
      final loginEvent = TrackierEvent(TrackierEvent.LOGIN);
      expect(loginEvent.eventId, 'o91gt1Q0PK');
      
      final addToCartEvent = TrackierEvent(TrackierEvent.ADD_TO_CART);
      expect(addToCartEvent.eventId, 'Fy4uC1_FlN');
    });

    test('all predefined event constants have correct values', () {
      expect(TrackierEvent.LEVEL_ACHIEVED, '1CFfUn3xEY');
      expect(TrackierEvent.ADD_TO_CART, 'Fy4uC1_FlN');
      expect(TrackierEvent.ADD_TO_WISHLIST, 'AOisVC76YG');
      expect(TrackierEvent.COMPLETE_REGISTRATION, 'mEqP4aD8dU');
      expect(TrackierEvent.TUTORIAL_COMPLETION, '99VEGvXjN7');
      expect(TrackierEvent.PURCHASE, 'Q4YsqBKnzZ');
      expect(TrackierEvent.SUBSCRIBE, 'B4N_In4cIP');
      expect(TrackierEvent.START_TRIAL, 'jYHcuyxWUW');
      expect(TrackierEvent.ACHIEVEMENT_UNLOCKED, 'xTPvxWuNqm');
      expect(TrackierEvent.CONTENT_VIEW, 'Jwzois1ays');
      expect(TrackierEvent.TRAVEL_BOOKING, 'yP1-ipVtHV');
      expect(TrackierEvent.SHARE, 'dxZXGG1qqL');
      expect(TrackierEvent.INVITE, '7lnE3OclNT');
      expect(TrackierEvent.LOGIN, 'o91gt1Q0PK');
      expect(TrackierEvent.UPDATE, 'sEQWVHGThl');
    });

    test('default property values are correct', () {
      final event = TrackierEvent('test-event');
      
      expect(event.orderId, '');
      expect(event.couponCode, '');
      expect(event.discount, 0.0);
      expect(event.revenue, 0.0);
      expect(event.currency, '');
      expect(event.param1, '');
      expect(event.param2, '');
      expect(event.param3, '');
      expect(event.param4, '');
      expect(event.param5, '');
      expect(event.param6, '');
      expect(event.param7, '');
      expect(event.param8, '');
      expect(event.param9, '');
      expect(event.param10, '');
      expect(event.evMap, isEmpty);
    });

    test('event properties can be set correctly', () {
      final event = TrackierEvent('test-event');
      
      event.orderId = 'order-12345';
      event.couponCode = 'SAVE20';
      event.discount = 15.5;
      event.revenue = 99.99;
      event.currency = 'USD';
      event.param1 = 'custom-param-1';
      event.param2 = 'custom-param-2';
      event.param3 = 'custom-param-3';
      event.param4 = 'custom-param-4';
      event.param5 = 'custom-param-5';
      event.param6 = 'custom-param-6';
      event.param7 = 'custom-param-7';
      event.param8 = 'custom-param-8';
      event.param9 = 'custom-param-9';
      event.param10 = 'custom-param-10';
      
      expect(event.orderId, 'order-12345');
      expect(event.couponCode, 'SAVE20');
      expect(event.discount, 15.5);
      expect(event.revenue, 99.99);
      expect(event.currency, 'USD');
      expect(event.param1, 'custom-param-1');
      expect(event.param2, 'custom-param-2');
      expect(event.param3, 'custom-param-3');
      expect(event.param4, 'custom-param-4');
      expect(event.param5, 'custom-param-5');
      expect(event.param6, 'custom-param-6');
      expect(event.param7, 'custom-param-7');
      expect(event.param8, 'custom-param-8');
      expect(event.param9, 'custom-param-9');
      expect(event.param10, 'custom-param-10');
    });

    test('setEventValue adds custom key-value pairs', () {
      final event = TrackierEvent('test-event');
      
      event.setEventValue('user_id', 'user-123');
      event.setEventValue('category', 'electronics');
      event.setEventValue('product_count', 3);
      event.setEventValue('is_premium', true);
      event.setEventValue('price', 199.99);
      
      expect(event.evMap['user_id'], 'user-123');
      expect(event.evMap['category'], 'electronics');
      expect(event.evMap['product_count'], 3);
      expect(event.evMap['is_premium'], true);
      expect(event.evMap['price'], 199.99);
      expect(event.evMap.length, 5);
    });

    test('setEventValue can override existing values', () {
      final event = TrackierEvent('test-event');
      
      event.setEventValue('key1', 'value1');
      expect(event.evMap['key1'], 'value1');
      
      event.setEventValue('key1', 'new-value');
      expect(event.evMap['key1'], 'new-value');
      expect(event.evMap.length, 1);
    });

    test('toMap returns correct event map with all properties', () {
      final event = TrackierEvent('purchase-event');
      event.orderId = 'order-456';
      event.couponCode = 'DISCOUNT10';
      event.discount = 5.0;
      event.revenue = 49.99;
      event.currency = 'EUR';
      event.param1 = 'p1';
      event.param2 = 'p2';
      event.param3 = 'p3';
      event.param4 = 'p4';
      event.param5 = 'p5';
      event.param6 = 'p6';
      event.param7 = 'p7';
      event.param8 = 'p8';
      event.param9 = 'p9';
      event.param10 = 'p10';
      event.setEventValue('custom_key', 'custom_value');
      
      final eventMap = event.toMap;
      
      expect(eventMap['eventId'], 'purchase-event');
      expect(eventMap['orderId'], 'order-456');
      expect(eventMap['couponCode'], 'DISCOUNT10');
      expect(eventMap['discount'], 5.0);
      expect(eventMap['revenue'], 49.99);
      expect(eventMap['currency'], 'EUR');
      expect(eventMap['param1'], 'p1');
      expect(eventMap['param2'], 'p2');
      expect(eventMap['param3'], 'p3');
      expect(eventMap['param4'], 'p4');
      expect(eventMap['param5'], 'p5');
      expect(eventMap['param6'], 'p6');
      expect(eventMap['param7'], 'p7');
      expect(eventMap['param8'], 'p8');
      expect(eventMap['param9'], 'p9');
      expect(eventMap['param10'], 'p10');
      final evMap = eventMap['ev'] as Map<String, Object>;
      expect(evMap['custom_key'], 'custom_value');
    });

    test('toMap returns correct map with minimal data', () {
      final event = TrackierEvent('minimal-event');
      final eventMap = event.toMap;
      
      expect(eventMap['eventId'], 'minimal-event');
      expect(eventMap['orderId'], '');
      expect(eventMap['couponCode'], '');
      expect(eventMap['discount'], 0.0);
      expect(eventMap['revenue'], 0.0);
      expect(eventMap['currency'], '');
      expect(eventMap['param1'], '');
      expect(eventMap['param2'], '');
      expect(eventMap['param3'], '');
      expect(eventMap['param4'], '');
      expect(eventMap['param5'], '');
      expect(eventMap['param6'], '');
      expect(eventMap['param7'], '');
      expect(eventMap['param8'], '');
      expect(eventMap['param9'], '');
      expect(eventMap['param10'], '');
      expect(eventMap['ev'], isEmpty);
    });

    test('toMap includes only set custom event values', () {
      final event = TrackierEvent('custom-event');
      event.setEventValue('only_key', 'only_value');
      
      final eventMap = event.toMap;
      final evMap = eventMap['ev'] as Map<String, Object>;
      expect(evMap['only_key'], 'only_value');
      expect(evMap.length, 1);
    });

    test('multiple events are independent', () {
      final event1 = TrackierEvent('event1');
      final event2 = TrackierEvent('event2');
      
      event1.revenue = 100.0;
      event1.setEventValue('key1', 'value1');
      
      event2.revenue = 200.0;
      event2.setEventValue('key2', 'value2');
      
      expect(event1.revenue, 100.0);
      expect(event2.revenue, 200.0);
      expect(event1.evMap['key1'], 'value1');
      expect(event2.evMap['key2'], 'value2');
      expect(event1.evMap.containsKey('key2'), false);
      expect(event2.evMap.containsKey('key1'), false);
    });

    test('event with complex custom data types', () {
      final event = TrackierEvent('complex-event');
      
      event.setEventValue('string_value', 'test string');
      event.setEventValue('int_value', 42);
      event.setEventValue('double_value', 3.14159);
      event.setEventValue('bool_value', true);
      event.setEventValue('list_value', [1, 2, 3]);
      event.setEventValue('map_value', {'nested': 'data'});
      
      final eventMap = event.toMap;
      final customMap = eventMap['ev'] as Map<String, Object>;
      
      expect(customMap['string_value'], 'test string');
      expect(customMap['int_value'], 42);
      expect(customMap['double_value'], 3.14159);
      expect(customMap['bool_value'], true);
      expect(customMap['list_value'], [1, 2, 3]);
      expect(customMap['map_value'], {'nested': 'data'});
    });
  });
}