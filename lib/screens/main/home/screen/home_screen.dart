import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initializeMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Map View
          _buildMapView(),

          // Top Status Bar
          _buildTopStatusBar(),

          // App Header with Duty Toggle
          _buildAppHeader(),

          // Map Controls
          _buildMapControls(),

          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Ensure we always have a camera position
        final cameraPosition =
            homeProvider.initialCameraPosition ??
            const CameraPosition(
              target: LatLng(17.3850, 78.4867), // Hyderabad default
              zoom: 12.0,
            );

        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GoogleMap(
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  homeProvider.onMapCreated(controller);
                  print('✅ GoogleMap created successfully');
                  print(
                    '✅ Camera position: ${cameraPosition.target.latitude}, ${cameraPosition.target.longitude}',
                  );
                  print('✅ Zoom level: ${cameraPosition.zoom}');
                },
                markers: homeProvider.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // We'll use custom button
                zoomControlsEnabled: false, // We'll use custom controls
                mapType: MapType.normal,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onTap: (LatLng position) {
                  print(
                    'Map tapped at: ${position.latitude}, ${position.longitude}',
                  );
                },
                onCameraMove: (CameraPosition position) {
                  // Map is interactive, so it's working
                },
                onCameraIdle: () {
                  print('✅ Map camera idle - map is fully loaded');
                },
              ),
            ),
            // Show loading overlay if still loading
            if (homeProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
            // Show error message if there's an error
            if (homeProvider.errorMessage != null)
              Positioned(
                top: 100,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    homeProvider.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTopStatusBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 30,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Row(
              children: [
                const Text(
                  '2:49',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chat, color: Colors.green[400], size: 16),
                const SizedBox(width: 4),
                Icon(Icons.network_cell, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Icon(Icons.warning, color: Colors.orange, size: 16),
              ],
            ),

            // Right side
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Icon(Icons.wifi, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Icon(
                  Icons.signal_cellular_4_bar,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.battery_full, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Truck Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Colors.yellow,
                    size: 24,
                  ),
                ),

                const Spacer(),

                // Duty Toggle
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        homeProvider.isOnDuty ? 'On Duty' : 'Off Duty',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          await homeProvider.toggleDutyStatus();

                          // Show feedback based on result
                          if (homeProvider.errorMessage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  homeProvider.isOnDuty
                                      ? 'You are now On Duty'
                                      : 'You are now Off Duty',
                                ),
                                backgroundColor: homeProvider.isOnDuty
                                    ? Colors.green
                                    : Colors.red,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  homeProvider.errorMessage ??
                                      'Failed to update duty status',
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: homeProvider.isOnDuty
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          // Center Location Button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.my_location, color: Colors.black),
              onPressed: () {
                context.read<HomeProvider>().centerMapOnLocation();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.person, 'Profile'),
            _buildNavItem(1, Icons.grid_view, 'Account'),
            _buildNavItem(2, Icons.group_add, 'Referral'),
            _buildNavItem(3, Icons.more_horiz, 'More'),
            _buildNavItem(4, Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        if (index == 4) {
          // Logout
          _handleLogout();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.yellow : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.yellow : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to login screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
