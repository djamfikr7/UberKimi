import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_sdk/map_sdk.dart';
import 'package:latlong2/latlong.dart';
import '../../blocs/home/home_cubit.dart';
import '../../repositories/home_repository.dart';
import '../trip/trip_preview_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        create: (context) => HomeCubit(context.read<HomeRepository>())
          ..loadHomeData(LatLng(40.7128, -74.0060)),
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoaded) {
            return Stack(
              children: [
                // Map Layer
                OpenStreetMapAdapter(
                  initialCenter: LatLng(40.7128, -74.0060),
                  initialZoom: 14.0,
                  onMapCreated: () {},
                  markers: (state.vehicles).map((v) => MapMarker(
                    id: v['id'],
                    position: LatLng(v['lat'], v['lng']),
                    rotation: (v['heading'] as num).toDouble(),
                  )).toList(),
                ),
                
                // Action Cards Layer (Server-Driven)
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: (state.config['actionCards'] as List).map<Widget>((card) {
                      if (card['type'] == 'safety_banner') {
                        return Card(
                          color: Colors.blue.shade50,
                          child: ListTile(
                            leading: Icon(Icons.shield, color: Colors.blue),
                            title: Text(card['data']['title']),
                            subtitle: Text(card['data']['subtitle']),
                          ),
                        );
                      }
                      if (card['type'] == 'promo_banner') {
                        return Card(
                          color: Colors.green.shade50,
                          child: ListTile(
                            leading: Icon(Icons.local_offer, color: Colors.green),
                            title: Text(card['data']['discount']),
                            subtitle: Text('Code: ${card['data']['code']}'),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }).toList(),
                  ),
                ),

                // Vehicle Carousel Layer
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (state.config['vehicleTypes'] as List).length,
                    itemBuilder: (context, index) {
                      final vehicle = state.config['vehicleTypes'][index];
                      return Container(
                        width: 120,
                        margin: EdgeInsets.only(right: 10),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car, size: 40),
                              SizedBox(height: 8),
                              Text(vehicle['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('\$${vehicle['baseFare']}'),
                              Text('${vehicle['etaMinutes']} min'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Where to? Search Bar
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      print('Where to clicked!');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TripPreviewScreen(
                            pickup: {'lat': 37.7749, 'lng': -122.4194}, // Mock SF
                            dropoff: {'lat': 37.8044, 'lng': -122.2711}, // Mock Oakland
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const [
                            Icon(Icons.search),
                            SizedBox(width: 10),
                            Text('Where to?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
