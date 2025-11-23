import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TripRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3003/api/v1/trip'));
  WebSocketChannel? _channel;

  Future<Map<String, dynamic>> getFareEstimates(Map<String, dynamic> pickup, Map<String, dynamic> dropoff) async {
    try {
      final response = await _dio.post('/estimate', data: {'pickup': pickup, 'dropoff': dropoff});
      return response.data;
    } catch (e) {
      throw Exception('Failed to get estimates: $e');
    }
  }

  Future<Map<String, dynamic>> requestTrip(String riderId, Map<String, dynamic> tripData) async {
    try {
      final response = await _dio.post('/request', data: {
        'riderId': riderId,
        ...tripData
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to request trip: $e');
    }
  }

  Stream<dynamic> connectToTripUpdates(String tripId) {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3003'));
    _channel?.sink.add(jsonEncode({
      'type': 'subscribe_trip',
      'tripId': tripId,
    }));
    return _channel?.stream ?? const Stream.empty();
  }
}
