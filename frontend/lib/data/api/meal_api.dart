import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'api_client.dart';

@lazySingleton
class MealApi {
  final ApiClient _apiClient;

  MealApi(this._apiClient);

  Future<Response> getMyMeals() {
    return _apiClient.get('/meals/my');
  }

  Future<Response> createMeal(Map<String, dynamic> data) {
    return _apiClient.post('/meals', data: data);
  }

  Future<Response> deleteMeal(String id) {
    return _apiClient.delete('/meals/$id');
  }

  Future<Response> getOverview(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return _apiClient.get(
      '/meals/overview',
      queryParameters: {'date': dateStr},
    );
  }

  Future<Response> getAllMeals() {
    return _apiClient.get('/meals/all');
  }
}
