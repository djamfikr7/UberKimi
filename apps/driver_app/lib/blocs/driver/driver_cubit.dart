import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/driver_repository.dart';

abstract class DriverState {}

class DriverOffline extends DriverState {}
class DriverOnline extends DriverState {}
class DriverTripRequest extends DriverState {
  final Map<String, dynamic> trip;
  DriverTripRequest(this.trip);
}

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository _repository;

  DriverCubit(this._repository) : super(DriverOffline());

  void goOnline(String driverId) {
    _repository.connect(driverId);
    emit(DriverOnline());
    
    // Listen for messages
    _repository.messages.listen((message) {
      try {
        final data = jsonDecode(message);
        if (data['type'] == 'trip_request') {
          emit(DriverTripRequest(data['trip']));
        }
      } catch (e) {
        print('Error parsing WS message: $e');
      }
    });
  }

  void goOffline() {
    _repository.disconnect();
    emit(DriverOffline());
  }

  void acceptTrip(String tripId) {
    _repository.acceptTrip(tripId, 'driver_123'); // Mock driver ID
    emit(DriverOnline()); // Return to online/map view
  }
  
  void declineTrip() {
    emit(DriverOnline());
  }
}
