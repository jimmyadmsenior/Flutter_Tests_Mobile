import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/bluetooth_controller.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  late BluetoothController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BluetoothController();
    _controller.addListener(_onControllerUpdate);
    _controller.initBluetooth();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _startScan() async {
    final error = await _controller.startScan();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _turnOnBluetooth() async {
    final error = await _controller.turnOnBluetooth();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
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
        title: const Text('Bluetooth'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
                      'Status do Bluetooth',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _controller.adapterState == BluetoothAdapterState.on
                              ? Icons.bluetooth
                              : Icons.bluetooth_disabled,
                          color:
                              _controller.adapterState ==
                                  BluetoothAdapterState.on
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(_controller.getAdapterStateText()),
                        const Spacer(),
                        ElevatedButton(
                          onPressed:
                              _controller.adapterState ==
                                  BluetoothAdapterState.off
                              ? _turnOnBluetooth
                              : null,
                          child: const Text('Ativar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Dispositivos Próximos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      _controller.adapterState == BluetoothAdapterState.on &&
                          !_controller.isScanning
                      ? _startScan
                      : null,
                  child: _controller.isScanning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _controller.adapterState != BluetoothAdapterState.on
                  ? const Center(
                      child: Text('Ative o Bluetooth para buscar dispositivos'),
                    )
                  : _controller.isScanning
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Buscando dispositivos...'),
                        ],
                      ),
                    )
                  : _controller.scanResults.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum dispositivo encontrado.\nToque em "Buscar" para procurar dispositivos.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _controller.scanResults.length,
                      itemBuilder: (context, index) {
                        final result = _controller.scanResults[index];
                        final device = result.device;
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              _controller.getDeviceIcon(device.platformName),
                            ),
                            title: Text(
                              device.platformName.isNotEmpty
                                  ? device.platformName
                                  : 'Dispositivo Desconhecido',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MAC: ${device.remoteId}'),
                                Text('RSSI: ${result.rssi} dBm'),
                              ],
                            ),
                            trailing: result.device.isConnected
                                ? const Icon(Icons.link, color: Colors.green)
                                : const Icon(
                                    Icons.link_off,
                                    color: Colors.grey,
                                  ),
                            onTap: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Conectando a ${device.platformName}...',
                                  ),
                                ),
                              );
                              final error = await _controller.connectToDevice(
                                device,
                              );
                              if (!context.mounted) return;
                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Conectado com sucesso!'),
                                  ),
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
