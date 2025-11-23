import 'package:dio/dio.dart';
import '../core/constants.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: Constants.apiBaseUrl));

  Future<void> requestOTP(String phoneNumber) async {
    try {
      await _dio.post('/auth/request-otp', data: {'phoneNumber': phoneNumber});
    } catch (e) {
      throw Exception('Failed to request OTP');
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to verify OTP');
    }
  }
}
