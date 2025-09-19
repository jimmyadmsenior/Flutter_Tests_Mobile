import 'package:flutter/material.dart';
import '../controllers/rotation_detector_controller.dart';
import 'dart:math';

class RotationDetectorPage extends StatefulWidget {
  const RotationDetectorPage({super.key});

  @override
  State<RotationDetectorPage> createState() => _RotationDetectorPageState();
}

class _RotationDetectorPageState extends State<RotationDetectorPage> {
  late RotationDetectorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RotationDetectorController();
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
        title: const Text('Detector de Rotação'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Controle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Controle do Giroscópio',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _controller.isMonitoring
                              ? _controller.stopMonitoring
                              : _controller.startMonitoring,
                          icon: Icon(
                            _controller.isMonitoring
                                ? Icons.stop
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            _controller.isMonitoring
                                ? 'Parar Monitoramento'
                                : 'Iniciar Monitoramento',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.isMonitoring
                                ? Colors.red
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Detector de Rotação
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _controller.isRotating
                                ? Icons.rotate_right
                                : Icons.crop_rotate,
                            color: _controller.isRotating
                                ? Colors.orange
                                : Colors.grey,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Detector de Rotação',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _controller.isRotating
                              ? Colors.orange.withAlpha(1)
                              : Colors.grey.withAlpha(1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _controller.isRotating
                                ? Colors.orange
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _controller.isRotating
                                  ? '🔄 ROTACIONANDO!'
                                  : '⏸️ Parado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _controller.isRotating
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Direção: ${_controller.rotationDirection}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Rotações detectadas: ${_controller.rotationCount}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Sensibilidade: '),
                          Expanded(
                            child: Slider(
                              value: _controller.rotationThreshold,
                              min: 0.1,
                              max: 2.0,
                              divisions: 19,
                              label: _controller.rotationThreshold
                                  .toStringAsFixed(1),
                              onChanged: _controller.setRotationThreshold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _controller.resetRotationCount,
                        child: const Text('Reset Contador'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Orientação 3D
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.threed_rotation,
                            color: Colors.blue,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Orientação 3D',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: CustomPaint(
                            painter: OrientationPainter(
                              _controller.pitch,
                              _controller.roll,
                              _controller.yaw,
                            ),
                            size: const Size(250, 250),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Pitch (X): ${_controller.pitch.toStringAsFixed(1)}°',
                            ),
                            Text(
                              'Roll (Y): ${_controller.roll.toStringAsFixed(1)}°',
                            ),
                            Text(
                              'Yaw (Z): ${_controller.yaw.toStringAsFixed(1)}°',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          onPressed: _controller.resetOrientation,
                          child: const Text('Reset Orientação'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),

              // Dados Brutos
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dados do Giroscópio',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildSensorRow(
                        'X (Pitch):',
                        _controller.gyroX,
                        Colors.red,
                      ),
                      _buildSensorRow(
                        'Y (Roll):',
                        _controller.gyroY,
                        Colors.green,
                      ),
                      _buildSensorRow(
                        'Z (Yaw):',
                        _controller.gyroZ,
                        Colors.blue,
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

  Widget _buildSensorRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (value + 5) / 10, // Normalizar para 0-1
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              value.toStringAsFixed(2),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class OrientationPainter extends CustomPainter {
  final double pitch, roll, yaw;

  OrientationPainter(this.pitch, this.roll, this.yaw);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Desenhar círculo base
    final basePaint = Paint()
      ..color = Colors.grey.withAlpha(3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, basePaint);

    // Desenhar linhas de referência
    final linePaint = Paint()
      ..color = Colors.grey.withAlpha(5)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      linePaint,
    );

    // Desenhar representação 3D simplificada
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Aplicar rotações (simplificado)
    canvas.rotate(yaw * pi / 180);

    // Desenhar "dispositivo"
    final devicePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Retângulo representando o dispositivo
    final deviceRect = Rect.fromCenter(
      center: Offset.zero,
      width: 60,
      height: 100,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(deviceRect, const Radius.circular(8)),
      devicePaint,
    );

    // Indicador de orientação (topo do dispositivo)
    final topPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, -40), 8, topPaint);

    canvas.restore();

    // Desenhar indicadores de ângulo
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Pitch
    textPainter.text = TextSpan(
      text: 'P: ${pitch.toStringAsFixed(0)}°',
      style: const TextStyle(color: Colors.red, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));

    // Roll
    textPainter.text = TextSpan(
      text: 'R: ${roll.toStringAsFixed(0)}°',
      style: const TextStyle(color: Colors.green, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 25));

    // Yaw
    textPainter.text = TextSpan(
      text: 'Y: ${yaw.toStringAsFixed(0)}°',
      style: const TextStyle(color: Colors.blue, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 40));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withAlpha(3)
      ..strokeWidth = 1;

    // Desenhar grade
    for (int i = 0; i <= 4; i++) {
      double x = (size.width / 4) * i;
      double y = (size.height / 4) * i;

      // Linhas verticais
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      // Linhas horizontais
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
