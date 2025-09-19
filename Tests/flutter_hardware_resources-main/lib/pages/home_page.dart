import 'package:flutter/material.dart';
import 'package:flutter_hardware_resources/pages/accelerometer_page.dart';
import 'package:flutter_hardware_resources/pages/audio_page.dart';
import 'package:flutter_hardware_resources/pages/bluetooth_page.dart';
import 'package:flutter_hardware_resources/pages/gps_page.dart';
import 'package:flutter_hardware_resources/pages/wifi_page.dart';
import 'package:flutter_hardware_resources/pages/motion_detector_page.dart';
import 'package:flutter_hardware_resources/pages/rotation_detector_page.dart';

import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos de Hardware'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dispositivos Móveis - Hardware',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore os recursos de hardware do seu dispositivo móvel',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildHardwareCard(
                    context,
                    'Bluetooth',
                    Icons.bluetooth,
                    Colors.blue,
                    'Conectividade sem fio de curta distância',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BluetoothPage(),
                      ),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'GPS',
                    Icons.location_on,
                    Colors.green,
                    'Sistema de posicionamento global',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GpsPage()),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'WiFi',
                    Icons.wifi,
                    Colors.orange,
                    'Conectividade de rede sem fio',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WifiPage()),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'Sensores',
                    Icons.sensors,
                    Colors.purple,
                    'Acelerômetro e Giroscópio (completo)',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccelerometerPage(),
                      ),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'Detector Movimento',
                    Icons.directions_run,
                    Colors.blue,
                    'Acelerômetro',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MotionDetectorPage(),
                      ),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'Detector Rotação',
                    Icons.rotate_right,
                    Colors.purple,
                    'Giroscópio',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RotationDetectorPage(),
                      ),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'Áudio',
                    Icons.mic,
                    Colors.teal,
                    'Gravação e reprodução de áudio',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AudioPage(),
                      ),
                    ),
                  ),
                  _buildHardwareCard(
                    context,
                    'Câmera',
                    Icons.camera_alt,
                    Colors.indigo,
                    'Captura de imagens e vídeos',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraPage(),
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
  }

  Widget _buildHardwareCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
