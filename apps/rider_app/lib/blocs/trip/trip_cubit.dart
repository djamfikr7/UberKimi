import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/trip_repository.dart';

abstract class TripState {}

class TripInitial extends TripState {}
class TripLoading extends TripState {}
class TripEstimatesLoaded extends TripState {
  final Map<String, dynamic> data;
  TripEstimatesLoaded(this.data);
}
class TripSearching extends TripState {
  final String tripId;
  TripSearching(this.tripId);
}
class TripDriverAssigned extends TripState {
  final Map<String, dynamic> driver;
  TripDriverAssigned(this.driver);
}
class TripError extends TripState {
  final String message;
  TripError(this.message);
}

class TripCubit extends Cubit<TripState> {
  final TripRepository _repository;

  TripCubit(this._repository) : super(TripInitial());

  Future<void> getEstimates(Map<String, dynamic> pickup, Map<String, dynamic> dropoff) async {
    emit(TripLoading());
    try {
      final data = await _repository.getFareEstimates(pickup, dropoff);
      emit(TripEstimatesLoaded(data));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }

  Future<void> requestTrip(String riderId, Map<String, dynamic> tripData) async {
    emit(TripLoading());
    try {
      final response = await _repository.requestTrip(riderId, tripData);
      emit(TripSearching(response['tripId']));
      
      // SIMULATION:
      await Future.delayed(const Duration(seconds: 5));
      emit(TripDriverAssigned({
        'name': 'John Doe',
        'rating': 4.9,
        'vehicle': 'Toyota Camry',
        'plate': 'ABC-1234'
      }));
    } catch (e) {
      emit(TripError(e.toString()));
    }
  }
}
