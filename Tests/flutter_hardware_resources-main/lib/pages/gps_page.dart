import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/gps_controller.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({super.key});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  late GpsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GpsController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS / Localização'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Localização Atual',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _controller.isLoading ? null : _controller.getCurrentLocation,
                          icon: _controller.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.location_on),
                          label: const Text('Obter Localização'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _controller.statusMessage,
                        style: TextStyle(
                          color: _controller.currentPosition != null
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_controller.currentPosition != null) ...[
                // Mapa
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mapa da Localização',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FlutterMap(
                              mapController: _controller.mapController,
                              options: MapOptions(
                                initialCenter: LatLng(
                                  _controller.currentPosition!.latitude,
                                  _controller.currentPosition!.longitude,
                                ),
                                initialZoom: 16.0,
                                minZoom: 3.0,
                                maxZoom: 18.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.flutter_hardware_resources',
                                ),
                                MarkerLayer(markers: _controller.markers),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Informações de Endereço e CEP
                if (_controller.address != null || _controller.postalCode != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Endereço e CEP',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          if (_controller.address != null)
                            _buildInfoRow('Endereço:', _controller.address!),
                          if (_controller.postalCode != null)
                            _buildInfoRow('CEP:', _controller.postalCode!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Detalhes técnicos da localização
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes Técnicos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Latitude:',
                          '${_controller.currentPosition!.latitude.toStringAsFixed(6)}°',
                        ),
                        _buildInfoRow(
                          'Longitude:',
                          '${_controller.currentPosition!.longitude.toStringAsFixed(6)}°',
                        ),
                        _buildInfoRow(
                          'Altitude:',
                          '${_controller.currentPosition!.altitude.toStringAsFixed(2)} m',
                        ),
                        _buildInfoRow(
                          'Precisão:',
                          '${_controller.currentPosition!.accuracy.toStringAsFixed(2)} m',
                        ),
                        _buildInfoRow(
                          'Velocidade:',
                          '${_controller.currentPosition!.speed.toStringAsFixed(2)} m/s',
                        ),
                        _buildInfoRow(
                          'Direção:',
                          '${_controller.currentPosition!.heading.toStringAsFixed(2)}°',
                        ),
                        _buildInfoRow(
                          'Timestamp:',
                          DateTime.fromMillisecondsSinceEpoch(
                            _controller.currentPosition!.timestamp.millisecondsSinceEpoch,
                          ).toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
