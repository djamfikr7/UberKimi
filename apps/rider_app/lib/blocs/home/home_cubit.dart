import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_sdk/map_sdk.dart';
import '../../repositories/home_repository.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final Map<String, dynamic> config;
  final List<dynamic> vehicles;
  HomeLoaded({required this.config, required this.vehicles});
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  StreamSubscription? _vehicleSubscription;

  Future<void> loadHomeData(LatLng location) async {
    emit(HomeLoading());
    try {
      final config = await _repository.getHomeConfig(location);
      final vehicles = await _repository.getNearbyVehicles(location);
      emit(HomeLoaded(config: config, vehicles: vehicles));

      // Subscribe to real-time updates
      _vehicleSubscription?.cancel();
      _vehicleSubscription = _repository.getVehicleStream().listen((updatedVehicles) {
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(HomeLoaded(config: currentState.config, vehicles: updatedVehicles));
        }
      });
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _vehicleSubscription?.cancel();
    return super.close();
  }
}
