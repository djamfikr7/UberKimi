import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3001/api/v1/auth'));

  Future<void> requestOTP(String phoneNumber) async {
    try {
      await _dio.post('/request-otp', data: {'phoneNumber': phoneNumber});
    } catch (e) {
      throw Exception('Failed to request OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await _dio.post('/verify-otp', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
        'role': 'driver', // Important: Driver Role
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
}
