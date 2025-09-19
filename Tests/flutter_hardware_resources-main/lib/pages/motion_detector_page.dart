import 'package:flutter/material.dart';
import '../controllers/motion_detector_controller.dart';
import 'dart:math';

class MotionDetectorPage extends StatefulWidget {
  const MotionDetectorPage({super.key});

  @override
  State<MotionDetectorPage> createState() => _MotionDetectorPageState();
}

class _MotionDetectorPageState extends State<MotionDetectorPage> {
  late MotionDetectorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MotionDetectorController();
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
        title: const Text('Detector de Movimento'),
        backgroundColor: Colors.blue,
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
                        'Controle do Acelerômetro',
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

              // Detector de Movimento
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _controller.isMoving
                                ? Icons.directions_run
                                : Icons.accessibility,
                            color: _controller.isMoving
                                ? Colors.red
                                : Colors.grey,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Detector de Movimento',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _controller.isMoving
                              ? Colors.red.withAlpha(1)
                              : Colors.grey.withAlpha(1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _controller.isMoving
                                ? Colors.red
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _controller.isMoving
                                  ? '🏃 MOVIMENTO DETECTADO!'
                                  : '🧍 Parado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _controller.isMoving
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Movimentos detectados: ${_controller.movementCount}',
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
                              value: _controller.movementThreshold,
                              min: 0.5,
                              max: 5.0,
                              divisions: 18,
                              label: _controller.movementThreshold
                                  .toStringAsFixed(1),
                              onChanged: _controller.setMovementThreshold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _controller.resetMovementCount,
                        child: const Text('Reset Contador'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),

              // Nível Digital
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _controller.isLevel
                                ? Icons.horizontal_rule
                                : Icons.architecture,
                            color: _controller.isLevel
                                ? Colors.green
                                : Colors.blue,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Nível Digital',
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
                            painter: LevelPainter(
                              _controller.tiltX,
                              _controller.tiltY,
                              _controller.isLevel,
                            ),
                            size: const Size(250, 250),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _controller.isLevel
                              ? Colors.green.withAlpha(1)
                              : Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _controller.isLevel
                                  ? '✅ NIVELADO'
                                  : '📐 Inclinado',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _controller.isLevel
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inclinação X: ${_controller.tiltX.toStringAsFixed(1)}°',
                            ),
                            Text(
                              'Inclinação Y: ${_controller.tiltY.toStringAsFixed(1)}°',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dados Brutos
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dados do Acelerômetro',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildSensorRow(
                        'X (Horizontal):',
                        _controller.x,
                        Colors.red,
                      ),
                      _buildSensorRow(
                        'Y (Vertical):',
                        _controller.y,
                        Colors.green,
                      ),
                      _buildSensorRow(
                        'Z (Profundidade):',
                        _controller.z,
                        Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Magnitude: ${_controller.magnitude.toStringAsFixed(2)} m/s²',
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
              value: (value + 10) / 20, // Normalizar para 0-1
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

class LevelPainter extends CustomPainter {
  final double tiltX, tiltY;
  final bool isLevel;

  LevelPainter(this.tiltX, this.tiltY, this.isLevel);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Desenhar círculo externo
    final outerPaint = Paint()
      ..color = Colors.grey.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerPaint);

    // Desenhar linhas de referência
    final linePaint = Paint()
      ..color = Colors.grey.withAlpha(25)
      ..color = Colors.grey.withAlpha(128)
      ..strokeWidth = 1;

    // Linha horizontal
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      linePaint,
    );

    // Linha vertical
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      linePaint,
    );

    // Calcular posição da bolha baseada na inclinação
    double bubbleX = center.dx + (tiltX * 3); // Amplificar movimento
    double bubbleY = center.dy + (tiltY * 3);

    // Limitar dentro do círculo
    double distance = sqrt(
      pow(bubbleX - center.dx, 2) + pow(bubbleY - center.dy, 2),
    );
    if (distance > radius - 15) {
      double angle = atan2(bubbleY - center.dy, bubbleX - center.dx);
      bubbleX = center.dx + cos(angle) * (radius - 15);
      bubbleY = center.dy + sin(angle) * (radius - 15);
    }

    // Desenhar bolha
    final bubblePaint = Paint()
      ..color = isLevel ? Colors.green : Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(bubbleX, bubbleY), 12, bubblePaint);

    // Desenhar círculo central (zona nivelada)
    final centerPaint = Paint()
      ..color = Colors.green.withAlpha(51)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, centerPaint);

    final centerBorderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 20, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
