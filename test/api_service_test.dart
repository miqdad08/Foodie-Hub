import 'package:flutter_test/flutter_test.dart';
import 'package:foodie_hub/data/api/api_service.dart';
import 'package:foodie_hub/data/models/models.dart';
import 'package:foodie_hub/data/models/restaurant_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Check Api Service', () {
    test('Check get restaurant list', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response(
              '{"error":false,"message":"success","count":20,"restaurants":[]}',
              200));

      expect(await ApiService(client).getRestaurant(), isA<RestaurantModel>());
    });
  });
}
