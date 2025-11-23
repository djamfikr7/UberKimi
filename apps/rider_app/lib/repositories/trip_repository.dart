import 'package:dio/dio.dart';

class TripRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3003/api/v1'));

  Future<Map<String, dynamic>> getFareEstimates(Map<String, dynamic> pickup, Map<String, dynamic> dropoff) async {
    try {
      final response = await _dio.post('/trip/estimate', data: {
        'pickup': pickup,
        'dropoff': dropoff,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to get estimates: $e');
    }
  }

  Future<Map<String, dynamic>> requestTrip(String riderId, Map<String, dynamic> tripData) async {
    try {
      final response = await _dio.post('/trip/request', data: {
        'riderId': riderId,
        ...tripData,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to request trip: $e');
    }
  }
}
