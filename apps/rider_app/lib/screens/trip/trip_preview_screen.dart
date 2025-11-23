import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/trip/trip_cubit.dart';
import '../../repositories/trip_repository.dart';

class TripPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> pickup;
  final Map<String, dynamic> dropoff;

  const TripPreviewScreen({
    Key? key,
    required this.pickup,
    required this.dropoff,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit(TripRepository())..getEstimates(pickup, dropoff),
      child: BlocConsumer<TripCubit, TripState>(
        listener: (context, state) {
          if (state is TripSearching) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Looking for drivers...'),
                  ],
                ),
              ),
            );
          } else if (state is TripDriverAssigned) {
            Navigator.of(context).pop(); // Close searching dialog
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              builder: (_) => Container(
                padding: const EdgeInsets.all(16),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Driver Found!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 10),
                    Text('Driver: ${state.driver['name']}', style: const TextStyle(fontSize: 18)),
                    Text('Vehicle: ${state.driver['vehicle']} (${state.driver['plate']})'),
                    Text('Rating: ${state.driver['rating']} ⭐'),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is TripError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Choose a Ride'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Column(
              children: [
                // Placeholder Map
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: const Center(child: Text('Route Map Placeholder')),
                  ),
                ),
                // Estimates List
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is TripLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TripEstimatesLoaded) {
                        final estimates = state.data['estimates'] as List;
                        return ListView.builder(
                          itemCount: estimates.length,
                          itemBuilder: (context, index) {
                            final est = estimates[index];
                            return ListTile(
                              leading: Image.asset(est['image'], width: 50, errorBuilder: (_,__,___) => const Icon(Icons.directions_car)),
                              title: Text(est['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${est['eta']} min away'),
                              trailing: Text('\$${est['price']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected ${est['name']}')));
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Confirm Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<TripCubit>().requestTrip(
                          'rider_123', // Mock Rider ID
                          {
                            'pickup': pickup,
                            'dropoff': dropoff,
                            'serviceId': 'uber_x',
                            'fare': 15.50, // Mock fare
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirm UberX', style: TextStyle(fontSize: 18, color: Colors.white)),
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
