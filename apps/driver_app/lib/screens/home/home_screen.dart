import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_sdk/open_street_map_adapter.dart';
import 'package:latlong2/latlong.dart';
import '../../blocs/driver/driver_cubit.dart';
import '../../repositories/driver_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DriverCubit(context.read<DriverRepository>()),
      child: BlocConsumer<DriverCubit, DriverState>(
        listener: (context, state) {
          if (state is DriverTripRequest) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('New Trip Request!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fare: \$${state.trip['fare']}'),
                    Text('Distance: 5.2 km'), // Mock
                    const SizedBox(height: 10),
                    const Text('Pickup: 123 Main St'),
                    const Text('Dropoff: 456 Elm St'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.read<DriverCubit>().declineTrip();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Decline'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DriverCubit>().acceptTrip(state.trip['id']);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip Accepted!')));
                    },
                    child: const Text('Accept'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          final isOnline = state is DriverOnline || state is DriverTripRequest;
          return Scaffold(
            appBar: AppBar(
              title: Text(isOnline ? 'Online' : 'Offline'),
              backgroundColor: isOnline ? Colors.green : Colors.grey,
            ),
            body: Column(
              children: [
                Expanded(
                  child: OpenStreetMapAdapter(
                    initialCenter: const LatLng(37.7749, -122.4194), // Mock SF
                    onMapCreated: () {
                      // TODO: Handle driver location updates
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isOnline) {
                        context.read<DriverCubit>().goOffline();
                      } else {
                        context.read<DriverCubit>().goOnline('driver_123');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOnline ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text(
                      isOnline ? 'GO OFFLINE' : 'GO ONLINE',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
