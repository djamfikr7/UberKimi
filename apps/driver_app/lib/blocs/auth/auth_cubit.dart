import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthOTPSent extends AuthState {}
class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;
  AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(AuthInitial());

  Future<void> requestOTP(String phoneNumber) async {
    emit(AuthLoading());
    try {
      await _repository.requestOTP(phoneNumber);
      emit(AuthOTPSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOTP(String phoneNumber, String otp) async {
    emit(AuthLoading());
    try {
      final data = await _repository.verifyOTP(phoneNumber, otp);
      emit(AuthAuthenticated(data['user']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
