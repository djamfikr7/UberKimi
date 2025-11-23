import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:map_sdk/map_sdk.dart';

class HomeRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3002/api/v1'));

  Future<Map<String, dynamic>> getHomeConfig(LatLng location) async {
    try {
      final response = await _dio.get('/rider/home-config', queryParameters: {
        'lat': location.latitude,
        'lng': location.longitude,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to load home config');
    }
  }

  Future<List<dynamic>> getNearbyVehicles(LatLng location) async {
    try {
      final response = await _dio.get('/vehicles/nearby', queryParameters: {
        'lat': location.latitude,
        'lng': location.longitude,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to load vehicles');
    }
  }
  Stream<List<dynamic>> getVehicleStream() {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:3002'),
    );
    return channel.stream.map((event) {
      final data = jsonDecode(event);
      if (data['type'] == 'vehicle_update') {
        return data['vehicles'] as List<dynamic>;
      }
      return [];
    });
  }
}
