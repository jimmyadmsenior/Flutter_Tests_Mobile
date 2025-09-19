import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../controllers/wifi_controller.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  late WifiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WifiController();
    _controller.addListener(_onControllerUpdate);
    _controller.initialize();
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

  Color _getStatusColor() {
    switch (_controller.connectionStatus) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return Colors.green;
      case ConnectivityResult.bluetooth:
        return Colors.blue;
      case ConnectivityResult.none:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    switch (_controller.connectionStatus) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.ethernet:
        return Icons.settings_ethernet;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.none:
        return Icons.signal_wifi_off;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi / Conectividade'),
        backgroundColor: const Color.fromARGB(255, 234, 230, 224),
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
                        'Status da Conexão',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            _getStatusIcon(),
                            color: _getStatusColor(),
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _controller.getConnectionStatusText(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(),
                                  ),
                                ),
                                if (_controller.connectionStatus ==
                                    ConnectivityResult.wifi) ...[
                                  const SizedBox(height: 4),
                                  Text(_controller.wifiName),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _controller.isChecking ? null : _controller.checkConnectivity,
                          icon: _controller.isChecking
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh),
                          label: const Text('Atualizar Status'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações da Rede',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Tipo de Conexão:',
                        _controller.getConnectionStatusText(),
                      ),
                      if (_controller.connectionStatus == ConnectivityResult.wifi) ...[
                        _buildInfoRow('Nome da Rede:', _controller.wifiName),
                        _buildInfoRow('Endereço IP:', _controller.wifiIP),
                        _buildInfoRow('BSSID:', _controller.wifiBSSID),
                        _buildInfoRow('Gateway:', _controller.wifiGateway),
                        _buildInfoRow('Subnet:', _controller.wifiSubnet),
                        _buildInfoRow(
                          'Força do Sinal:',
                          '${_controller.signalStrength} dBm',
                        ),
                        _buildInfoRow('Tipo de Segurança:', _controller.securityType),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conceitos Importantes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• WiFi: Tecnologia de rede sem fio baseada no padrão IEEE 802.11\n'
                        '• RSSI/dBm: Força do sinal WiFi (-30 dBm = excelente, -70 dBm = fraco)\n'
                        '• BSSID: Identificador único do ponto de acesso WiFi\n'
                        '• WPA/WPA2/WPA3: Protocolos de segurança WiFi\n'
                        '• Gateway: Endereço IP do roteador da rede\n'
                        '• Subnet: Máscara de sub-rede da conexão',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
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
            width: 120,
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
