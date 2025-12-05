import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_sdk/map_sdk.dart';
import 'package:latlong2/latlong.dart';
import 'package:design_system/design_system.dart';

import '../../blocs/home/home_cubit.dart';
import '../../repositories/home_repository.dart';
import '../location_selection/location_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        create: (context) =>
            HomeCubit(context.read<HomeRepository>())
              ..loadHomeData(LatLng(40.7128, -74.0060)),
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _selectedVehicleIndex = 0;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(_isDarkMode),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          }
          if (state is HomeLoaded) {
            return _buildLoadedState(context, state);
          }
          if (state is HomeError) {
            return _buildErrorState(context, state);
          }
          return _buildErrorState(context, HomeError('Unknown error'));
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_taxi, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            'Finding rides near you...',
            style: AppTypography.bodyLarge(isDark: _isDarkMode),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.textSecondary(
                _isDarkMode,
              ).withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HomeError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: NeoCard(
          isDark: _isDarkMode,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Failed to load',
                style: AppTypography.h3(isDark: _isDarkMode),
              ),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(isDark: _isDarkMode),
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: 'Retry',
                icon: Icons.refresh,
                onPressed: () => context.read<HomeCubit>().loadHomeData(
                  LatLng(40.7128, -74.0060),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, HomeLoaded state) {
    return Stack(
      children: [
        // Map Layer
        Positioned.fill(
          child: OpenStreetMapAdapter(
            initialCenter: LatLng(40.7128, -74.0060),
            initialZoom: 14.0,
            onMapCreated: () {},
            markers: state.vehicles
                .map(
                  (v) => MapMarker(
                    id: v.id,
                    position: LatLng(v.lat, v.lng),
                    color: AppColors.primary,
                  ),
                )
                .toList(),
          ),
        ),

        // Dark mode toggle
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: GestureDetector(
            onTap: () => setState(() => _isDarkMode = !_isDarkMode),
            child: NeoCard(
              isDark: _isDarkMode,
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.zero,
              borderRadius: 12,
              child: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: AppColors.textPrimary(_isDarkMode),
              ),
            ),
          ),
        ),

        // Bottom Sheet with Content
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomContent(context, state),
        ),
      ],
    );
  }

  Widget _buildBottomContent(BuildContext context, HomeLoaded state) {
    return BottomSheetContainer(
      isDark: _isDarkMode,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          SearchInput(
            hintText: 'Where to?',
            isDark: _isDarkMode,
            prefixIcon: Icons.search,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationSelectionScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Saved Places Row
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  icon: Icons.home,
                  title: 'Home',
                  subtitle: 'Set location',
                  iconColor: AppColors.vehicleX,
                  isDark: _isDarkMode,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionCard(
                  icon: Icons.work,
                  title: 'Work',
                  subtitle: 'Set location',
                  iconColor: AppColors.vehicleXL,
                  isDark: _isDarkMode,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Promo Banner
          if (state.config.actionCards.isNotEmpty)
            PromoBanner(
              title:
                  state.config.actionCards.first.data['title']?.toString() ??
                  'Special Offer',
              subtitle:
                  state.config.actionCards.first.data['subtitle']?.toString() ??
                  'Limited time offer',
              code: 'SAVE20',
              isDark: _isDarkMode,
              onTap: () {},
            ),
          const SizedBox(height: 20),

          // Vehicle Types Section
          Text('Choose a ride', style: AppTypography.h4(isDark: _isDarkMode)),
          const SizedBox(height: 12),

          // Vehicle Type Carousel
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.config.vehicleTypes.length,
              itemBuilder: (context, index) {
                final vehicle = state.config.vehicleTypes[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < state.config.vehicleTypes.length - 1
                        ? 12
                        : 0,
                  ),
                  child: VehicleCardCompact(
                    name: vehicle.name,
                    price: '\$${vehicle.baseFare.toStringAsFixed(2)}',
                    eta: '${vehicle.etaMinutes} min',
                    icon: _getVehicleIcon(vehicle.id),
                    iconColor: _getVehicleColor(vehicle.id),
                    isSelected: _selectedVehicleIndex == index,
                    isDark: _isDarkMode,
                    onTap: () => setState(() => _selectedVehicleIndex = index),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text:
                  'Confirm ${state.config.vehicleTypes.isNotEmpty ? state.config.vehicleTypes[_selectedVehicleIndex].name : "Ride"}',
              icon: Icons.arrow_forward,
              onPressed: () {
                // Navigate to trip preview
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getVehicleIcon(String vehicleId) {
    switch (vehicleId.toLowerCase()) {
      case 'uber-x':
      case 'uberx':
        return Icons.directions_car;
      case 'uber-xl':
      case 'uberxl':
        return Icons.airport_shuttle;
      case 'comfort':
        return Icons.airline_seat_recline_extra;
      case 'black':
        return Icons.star;
      default:
        return Icons.directions_car;
    }
  }

  Color _getVehicleColor(String vehicleId) {
    switch (vehicleId.toLowerCase()) {
      case 'uber-x':
      case 'uberx':
        return AppColors.vehicleX;
      case 'uber-xl':
      case 'uberxl':
        return AppColors.vehicleXL;
      case 'comfort':
        return AppColors.vehicleComfort;
      case 'black':
        return AppColors.vehicleBlack;
      default:
        return AppColors.vehicleX;
    }
  }
}
