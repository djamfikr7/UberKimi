import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class DriverRepository {
  WebSocketChannel? _channel;
  
  Stream<dynamic> get messages => _channel?.stream ?? const Stream.empty();

  void connect(String driverId) {
    // Connect to Trip Service WebSocket
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3003'));
    
    // Register as Driver
    _channel?.sink.add(jsonEncode({
      'type': 'register_driver',
      'driverId': driverId,
    }));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void acceptTrip(String tripId, String driverId) {
    _channel?.sink.add(jsonEncode({
      'type': 'accept_trip',
      'tripId': tripId,
      'driverId': driverId,
    }));
  }
}
